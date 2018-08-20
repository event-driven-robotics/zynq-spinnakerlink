#include <asm/io.h>
#include <asm/uaccess.h>
#include <linux/cdev.h>
#include <linux/delay.h>
#include <linux/device.h>
#include <linux/dma-mapping.h>
#include <linux/fs.h>
#include <linux/interrupt.h>
#include <linux/ioctl.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/of_platform.h>
#include <linux/semaphore.h>
#include <linux/slab.h>
#include <linux/string.h>
#include <linux/types.h>
#include <linux/wait.h>

#include "iit-spinn2neu-ioctl.h"


#define BURST_UNIT         2
#define BURST_SAMPLE_SIZE  4
#define DATA_STORAGE_U32   2048

#define DRIVER_NAME        "iit-spinn2neu"
#define DTS_COMPATIBLE     "iit.it,Spinn2Neu-core-1.0"
#define SP2NEU_CLASS_NAME  "spinn2neu_dev"
#define SP2NEU_CTL_DEVNAME "spinn2neu"

//#define MSK_CONF_ENAB_IP     0x00000001
#define MSK_CONF_ENAB_DMA    0x00000002
#define MSK_CONF_ENAB_INT    0x00000004
//#define MSK_CONF_ENAB_LB     0x00000008
#define MSK_CONF_FLUSH_FIFO  0x00000010
//#define MSK_CONF_PWDWN       0x00000100
//#define MSK_CONF_CHIPTYPE    0x00010000
#define MSK_CONF_REM_LB     0x01000000
#define MSK_CONF_LOC_LB     0x02000000
#define MSK_CONF_LOCFAR_LB  0x04000000

#define MSK_INT_RXFIFOEMPTY     0x00000001
#define MSK_INT_RXFIFOALMEMPTY  0x00000002
#define MSK_INT_RXFIFOFULL      0x00000004
#define MSK_INT_TXFIFOEMPTY     0x00000008
#define MSK_INT_TXFIFOALMFULL   0x00000010
#define MSK_INT_TXFIFOFULL      0x00000020
//#define MSK_INT_BIASFINISHED    0x00000040
#define MSK_INT_TSTAMPWRAPPED   0x00000080
#define MSK_INT_RXBUFFERREADY   0x00000100
#define MSK_INT_RXFIFONOTEMPTY  0x00000200
#define MSK_INT_TXDUMPMODE      0x00001000
#define MSK_INT_RXPARITYERR     0x00002000
#define MSK_INT_RXMODEMERR      0x00004000

#define MAX_BURST      2048
#define MAX_CH_COUNT   2
#define MAX_CHANNELS   (MAX_CH_COUNT * MAX_DEV_COUNT) + 1
#define MAX_DEV_COUNT  2
#define MSG_PREFIX     "IIT-Spinn2Neu: "

#if 0
// Chip type
#define MN256   0
#define IFSLWTA 1
#endif

#define REG_CTRL         0x00
#define REG_RXBU         0x08
#define REG_TIBU         0x0C
#define REG_TXBU         0x10
#define REG_DMAI         0x14
#define REG_RAWI         0x18
#define REG_IRQI         0x1C
#define REG_MSKI         0x20
//#define REG_BTIM         0x24
#define REG_WRAP         0x28
//#define REG_PRSC         0x2C
//#define REG_ONTH         0x30
//#define REG_SETTLING     0x34
//#define REG_TIMESTAMP    0x38
#define REG_ID           0x5C


#define set_register_bits(reg, v, mask) do {                                    \
	int __ms = 0;							                                    \
	typeof(mask) __mask = (mask);			                                    \
    while(__mask > 0 && ! (__mask & 0x1)) {                                     \
        __mask = __mask >> 1;                                                   \
        __ms++;                                                                 \
    }                                                                           \
    iowrite32((ioread32(reg) & ~(mask)) | (((v) << __ms) & (mask)), (reg));     \
} while (0)

#define get_register_bits(reg, res, mask) do {              \
    unsigned int __rmask = (mask);                          \
    typeof(*(reg)) __reg = ioread32(reg);                   \
                                                            \
    while(__rmask > 0 && ! (__rmask & 0x1)) {               \
        __rmask = __rmask >> 1;                             \
        __reg = __reg >> 1;                                 \
    }                                                       \
                                                            \
    res = __reg & __rmask;                                  \
} while (0)

#define SHOWTIMESTAMPWRAPPING 0
static int tswrapp = SHOWTIMESTAMPWRAPPING;
module_param(tswrapp, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP);
MODULE_PARM_DESC(tswrapp, "Time stamp wrapping (1=> show ts, 0[default]=>dont show ts) ");

MODULE_LICENSE("GPL");
MODULE_AUTHOR("gaetano.derobertis@iit.it");
MODULE_DESCRIPTION("SpinnLink to Neuelab driver module");

#define SAMPLE_ON_PROBE 1

struct dev_support;

static int          dev_probe (struct platform_device *devp);
static int          dev_remove (struct platform_device *devp);
static int          register_chardev (struct platform_device *devp);
static irqreturn_t  irq_handler (int irq, void *arg);
static void         sp2neu_init (struct platform_device *devp);

static int          chardev_open (struct inode *i, struct file *f);
static int          chardev_close (struct inode *i, struct file *f);
static ssize_t      chardev_read (struct file *f, char *buf, size_t len, loff_t *off);
static ssize_t      chardev_write (struct file *f, const char __user *buf, size_t len, loff_t *off);

static long         sp2neu_ioctl (struct file *filp, unsigned int cmd, unsigned long param);

//static long         set_threshold (struct file *filep, unsigned int threshold);
static long         read_version (struct file *filep, unsigned int * version);
static long         get_timestamp (struct file *filep, unsigned int * timestampwrap);
static long         clear_timestamp (void);
static long         set_remote_loopback (bool value);
static long         set_local_loopback (bool value);
static long         set_locfar_loopback (bool value);
//static long         read_timestamper (struct file *filep, unsigned int * timestamp);


struct dev_support {
	int                major, minor;
	struct cdev        chdev;
	dev_t              devt;
	void               *base_addr;
	size_t             mem_size;
	resource_size_t    pm_start;          //phisical memory start

//	resource_size_t    reset_reg_ph;      //phisical memory start of reset register
//	void               *reset_reg_virt;

	dma_addr_t         phys_dma_mem;
	void               *virt_dma_mem;

	unsigned int       irq;
	unsigned int       wraptimes;

    unsigned int       data_read[DATA_STORAGE_U32];
    unsigned int       data_write[DATA_STORAGE_U32];

	wait_queue_head_t  wait;
	int                open_count;
	bool               read_ok[2];
	bool               burst_err;
	bool               buf_switch;
	int                buf_offset;
	struct semaphore   buf_sem[2];

	bool               ovflw[2];
	bool               fifo_full;
};

static struct class          *sp2neu_class;
static struct dev_support    d_support;

static struct file_operations sp2neu_fops = {
	.open           = chardev_open,
	.owner          = THIS_MODULE,
	.read           = chardev_read,
	.release        = chardev_close,
	.unlocked_ioctl = sp2neu_ioctl,
	.write          = chardev_write,
};

static const struct of_device_id match_table[] = {
	{ .compatible = DTS_COMPATIBLE, } ,
	{}
};

static struct platform_driver iit_sp2neu_driver = {
	.driver = {
		.name           = DRIVER_NAME,
		.owner          = THIS_MODULE,
		.of_match_table = match_table
	},
	.probe  = dev_probe,
	.remove = dev_remove
};



module_platform_driver(iit_sp2neu_driver);


static void read_generic_reg(u32 *par, void __iomem *reg_addr)
{
    *par=ioread32(reg_addr);
}


static void write_generic_reg(u32 par, void __iomem *reg_addr)
{
	iowrite32(par,reg_addr);
}


#if 0
static void keep_out_from_reset(void)
{
    unsigned int tmp32;

	printk(KERN_DEBUG MSG_PREFIX "Resetting device..\n");
    tmp32 = ioread32(d_support.reset_reg_virt);
	iowrite32(tmp32 & 0xFFFFFFFD, d_support.reset_reg_virt);
    tmp32 = ioread32(d_support.reset_reg_virt);
	iowrite32(tmp32 | (~0xFFFFFFFD), d_support.reset_reg_virt);
	printk(KERN_DEBUG MSG_PREFIX "Device reset done\n");
}
#endif


static int dev_probe(struct platform_device *devp) {
	struct resource *res;
	unsigned long remap_size;
	int result;
	int msize = BURST_UNIT * MAX_BURST * 4 * 2;
	//unsigned int tmp32;


#if 0    // Spinn2Neu do not have a synchronous software reset inside MISC block
	if (of_property_read_u32(devp->dev.of_node, "iit,reset_reg", &d_support.reset_reg_ph)) {
		printk(KERN_ALERT MSG_PREFIX "Unable to read iit_reset_reg from dts!\n");
		return -EINVAL;
	}
	d_support.reset_reg_virt = ioremap(d_support.reset_reg_ph, sizeof(uint32_t));

    keep_out_from_reset();
#endif

	if ((result = register_chardev(devp)) < 0) {
		printk(KERN_ALERT MSG_PREFIX "Error registering character device!\n");
		return result;
	}

	res = platform_get_resource(devp, IORESOURCE_MEM, 0);
	if (!res) {
		printk(KERN_ALERT MSG_PREFIX "Error getting platform device memory\n");
		return -1;
	}

	remap_size = res->end - res->start + 1;
	if (!request_mem_region(res->start, remap_size, devp->name)) {
		printk(KERN_ALERT MSG_PREFIX "Error allocating device memory\n");
		return -1;
	}

	devp->dev.devt = d_support.devt;
	d_support.base_addr = ioremap(res->start, remap_size);
	d_support.mem_size = remap_size;
	d_support.pm_start = res->start;

	init_waitqueue_head(&(d_support.wait));

	d_support.virt_dma_mem = dma_alloc_coherent(&(devp->dev), PAGE_ALIGN(msize), &(d_support.phys_dma_mem), GFP_KERNEL);

	if (!d_support.virt_dma_mem) {
		printk(KERN_ALERT MSG_PREFIX "Error allocating dma coherent device memory\n");
		return -1;
	}

	sp2neu_init(devp);

    clear_timestamp();

	d_support.irq = platform_get_irq(devp, 0);
	if (d_support.irq < 0) {
		printk(KERN_ALERT MSG_PREFIX "Error getting irq\n");
		return -1;
	}

	result = request_irq(d_support.irq, irq_handler, IRQF_SHARED, "int_sp2neu", &d_support);
	if (result) {
		printk(KERN_ALERT MSG_PREFIX "Error requesting irq: %i\n", result);
		return -1;
	}

	return 0;
}


int register_chardev(struct platform_device *devp) {
	int res;

	if ((res = alloc_chrdev_region(&d_support.devt, 0, 1, SP2NEU_CLASS_NAME)) < 0) {
		printk(KERN_ALERT MSG_PREFIX "Error allocating space for device: %d\n", res);
		return -1;
	}

	d_support.major = MAJOR(d_support.devt);

	if ((sp2neu_class = class_create(THIS_MODULE, SP2NEU_CLASS_NAME)) == NULL) {
		printk(KERN_ALERT MSG_PREFIX "Error creating device class\n");

		unregister_chrdev_region(d_support.devt, MAX_CHANNELS);
		return -1;
	}

	if ((device_create(sp2neu_class, NULL, d_support.devt, NULL, SP2NEU_CTL_DEVNAME)) == NULL) {
		printk(KERN_ALERT MSG_PREFIX "Error creating " SP2NEU_CTL_DEVNAME "\n");

		class_destroy(sp2neu_class);
		unregister_chrdev_region(d_support.devt, MAX_CHANNELS);
		return -1;
	}

	cdev_init(&d_support.chdev, &sp2neu_fops);

	if ((res = cdev_add(&d_support.chdev, d_support.devt, 1)) < 0) {
		printk(KERN_ALERT MSG_PREFIX "Error adding device " SP2NEU_CTL_DEVNAME "\n");

		cdev_del(&d_support.chdev);
		device_destroy(sp2neu_class, d_support.devt);
		class_destroy(sp2neu_class);
		unregister_chrdev_region(d_support.devt, MAX_CHANNELS);
		return -1;
	}

	printk(KERN_DEBUG MSG_PREFIX "Registered chardev /dev/" SP2NEU_CTL_DEVNAME "\n");

    return 0;
}


static irqreturn_t irq_handler(int irq, void *arg) {
	irqreturn_t retval = 0;
	uint32_t *conf_reg = d_support.base_addr + REG_CTRL;
    uint32_t *int_reg = d_support.base_addr + REG_IRQI;
    uint32_t *intmask_reg = d_support.base_addr + REG_MSKI;

    uint32_t intr = ioread32(int_reg) & ioread32(intmask_reg);

	set_register_bits(conf_reg, 0, MSK_CONF_ENAB_INT);

    if (intr & MSK_INT_TSTAMPWRAPPED) {
        d_support.wraptimes++;
        printk(KERN_ALERT MSG_PREFIX "IRQ: TIME STAMP WRAPPED %d\n",d_support.wraptimes);
        set_register_bits(int_reg, 1, MSK_INT_TSTAMPWRAPPED);
        retval = IRQ_HANDLED;
    }
#if 0
    if (intr & MSK_INT_BIASFINISHED) {
        printk(KERN_ALERT MSG_PREFIX "IRQ: BIAS FINISHED INTERRUPT\n");
        set_register_bits(int_reg, 1, MSK_INT_BIASFINISHED);
        retval = IRQ_HANDLED;
    }
#endif

/** These IRQs are not really handled (just printing a message)
 ** Unless an action on the FIFOs is done it is safer to leave these IRQs commented out
 **/

/***
    if (intr & MSK_INT_TXFIFOEMPTY) {
        printk(KERN_ALERT MSG_PREFIX "IRQ: TX FIFO EMPTY\n");
        set_register_bits(int_reg, 1, MSK_INT_TXFIFOEMPTY);
        retval = IRQ_HANDLED;
    }
    if (intr & MSK_INT_RXFIFOEMPTY) {
        printk(KERN_ALERT MSG_PREFIX "IRQ: RX FIFO EMPTY\n");
        set_register_bits(int_reg, 1, MSK_INT_RXFIFOEMPTY);
        retval = IRQ_HANDLED;
    }
    if (intr & MSK_INT_TXFIFOALMFULL) {
        printk(KERN_ALERT MSG_PREFIX "IRQ: TX FIFO ALMOST FULL\n");
        set_register_bits(int_reg, 1, MSK_INT_TXFIFOALMFULL);
        retval = IRQ_HANDLED;
    }
    if (intr & MSK_INT_RXFIFOALMEMPTY) {
        printk(KERN_ALERT MSG_PREFIX "IRQ: RX FIFO ALMOST EMPTY\n");
        set_register_bits(int_reg, 1, MSK_INT_RXFIFOALMEMPTY);
        retval = IRQ_HANDLED;
    }
***/
    if (intr & MSK_INT_TXFIFOFULL) {
        printk(KERN_ALERT MSG_PREFIX "IRQ: TX FIFO FULL\n");
        set_register_bits(int_reg, 1, MSK_INT_TXFIFOFULL);
        retval = IRQ_HANDLED;
    }
    if (intr & MSK_INT_RXFIFOFULL) {
        printk(KERN_ALERT MSG_PREFIX "IRQ: RX FIFO FULL\n");
        set_register_bits(int_reg, 1, MSK_INT_RXFIFOFULL);
        retval = IRQ_HANDLED;
    }
    if (intr & MSK_INT_RXFIFONOTEMPTY) {
        printk(KERN_ALERT MSG_PREFIX "IRQ: RX FIFO NOT EMPTY\n");
        set_register_bits(int_reg, 1, MSK_INT_RXFIFONOTEMPTY);
        retval = IRQ_HANDLED;
    }

    // Spinnaker Driver and Receiver error indications
    if (intr & MSK_INT_TXDUMPMODE) {
        printk(KERN_ALERT MSG_PREFIX "IRQ: TX DUMP MODE\n");
        set_register_bits(int_reg, 1, MSK_INT_TXDUMPMODE);
        retval = IRQ_HANDLED;
    }
    if (intr & MSK_INT_RXPARITYERR) {
        printk(KERN_ALERT MSG_PREFIX "IRQ: RX PARITY ERROR\n");
        set_register_bits(int_reg, 1, MSK_INT_RXPARITYERR);
        retval = IRQ_HANDLED;
    }
    if (intr & MSK_INT_RXMODEMERR) {
        printk(KERN_ALERT MSG_PREFIX "IRQ: RX MODEM ERROR\n");
        set_register_bits(int_reg, 1, MSK_INT_RXMODEMERR);
        retval = IRQ_HANDLED;
    }


	set_register_bits(conf_reg, 1, MSK_CONF_ENAB_INT);

	return retval;
}


static void sp2neu_init(struct platform_device *devp) {
    uint32_t *conf_reg = d_support.base_addr + REG_CTRL;
    uint32_t *intmask_reg = d_support.base_addr + REG_MSKI;
    uint32_t tmp;

    d_support.wraptimes=0;
    clear_timestamp();
    if (tswrapp)
        set_register_bits(intmask_reg,     1, MSK_INT_TSTAMPWRAPPED);
    else    
        set_register_bits(intmask_reg,     0, MSK_INT_TSTAMPWRAPPED);

    set_register_bits(intmask_reg,     0, MSK_INT_RXFIFONOTEMPTY);
//    set_register_bits(conf_reg,    MN256, MSK_CONF_CHIPTYPE);
    set_register_bits(conf_reg,        1, MSK_CONF_ENAB_INT);
    set_register_bits(conf_reg,        1, MSK_CONF_FLUSH_FIFO);
//    set_register_bits(conf_reg,        1, MSK_CONF_ENAB_IP);

    // Enable interrupt for timestamp wrapping
	printk(KERN_DEBUG MSG_PREFIX "Spinn2Neu device ready\n");
    get_register_bits(conf_reg, tmp, 0xFFFFFFFF);
	printk(KERN_DEBUG MSG_PREFIX "conf: 0x%08X\n",tmp);
    get_register_bits(intmask_reg, tmp, 0xFFFFFFFF);
	printk(KERN_DEBUG MSG_PREFIX "mask: 0x%08X\n",tmp);

}


static int dev_remove(struct platform_device *devp) {
//	uint32_t *reg_conf = d_support.base_addr + REG_CTRL;
	dev_t dev = devp->dev.devt;

//    set_register_bits(reg_conf, 0, MSK_CONF_ENAB_IP);
//    printk(KERN_DEBUG MSG_PREFIX "IP stopped\n");

    dma_free_coherent(&(devp->dev), PAGE_ALIGN(BURST_UNIT * MAX_BURST * 4 * 2), d_support.virt_dma_mem, d_support.phys_dma_mem);
    free_irq(d_support.irq, &d_support);

    printk(KERN_DEBUG MSG_PREFIX "Unregister device\n");
    cdev_del(&d_support.chdev);
    device_destroy(sp2neu_class, dev);

    printk(KERN_DEBUG MSG_PREFIX "Destroy class\n");
    class_destroy(sp2neu_class);

    printk(KERN_DEBUG MSG_PREFIX "Unregister chardev region\n");
    unregister_chrdev_region(d_support.devt, 1);

    iounmap(d_support.base_addr);
//    iounmap(d_support.reset_reg_virt);
    release_mem_region(d_support.pm_start, d_support.mem_size);
    return 0;
}


/*************************************************************************************
  Channels file operations handling
**************************************************************************************/

static ssize_t chardev_read (struct file *fp, char *buf, size_t length, loff_t *offset) {
    int i;
    bool endma;
    int lenght_uint;
    int len_trunc;
    unsigned int data_available;
    int ret;

     uint32_t *conf_reg   = d_support.base_addr + REG_CTRL;
     uint32_t *status_reg = d_support.base_addr + REG_RAWI;
    uint32_t *time_reg   = d_support.base_addr + REG_TIBU;
    uint32_t *rxdata_reg = d_support.base_addr + REG_RXBU;

    // printk(KERN_DEBUG MSG_PREFIX "Read\n");

    // Enable IP
//    set_register_bits(conf_reg, 1, MSK_CONF_ENAB_IP);

    len_trunc = (length>(DATA_STORAGE_U32<<2)) ? DATA_STORAGE_U32<<2 : length;
    get_register_bits(conf_reg, endma, MSK_CONF_ENAB_DMA);

    if (!endma) {
        lenght_uint=len_trunc>>2;
        for (i=0; i<lenght_uint; i+=2) {
            get_register_bits(status_reg, data_available, MSK_INT_RXFIFONOTEMPTY);
            if (data_available) {
                get_register_bits(time_reg, d_support.data_read[i], 0xFFFFFFFF);
                get_register_bits(rxdata_reg, d_support.data_read[i+1], 0xFFFFFFFF);
                }
            else
                break;
        }
        ret=copy_to_user(buf, d_support.data_read, i<<2);
        return (i<<2);
    }

    return 0;
}


static ssize_t chardev_write(struct file *fp, const char __user *buf, size_t len, loff_t *off) {
    uint32_t *conf_reg = d_support.base_addr + REG_CTRL;
    uint32_t *txbuffer_reg = d_support.base_addr + REG_TXBU;
    uint32_t *status_reg = d_support.base_addr + REG_RAWI;

    bool endma;
    int lenght_uint;
    int len_trunc;
    int i;
    unsigned int space_notAvailable;
    int ret;

    // printk(KERN_DEBUG MSG_PREFIX "Write\n");

    // Enable IP
//    set_register_bits(conf_reg, 1, MSK_CONF_ENAB_IP);

    len_trunc = (len>(DATA_STORAGE_U32<<2)) ? DATA_STORAGE_U32<<2 : len;
    get_register_bits(conf_reg, endma, MSK_CONF_ENAB_DMA);

    if (!endma) {
        lenght_uint=len_trunc>>2;
        ret=copy_from_user(&d_support.data_write[0], (unsigned int *)buf, lenght_uint*sizeof(unsigned int));
        for (i=0;i<lenght_uint;i++) {
                // printk(KERN_DEBUG MSG_PREFIX "%d 0x%x\n",i,d_support.data_write[i]);

                get_register_bits(status_reg, space_notAvailable, MSK_INT_TXFIFOFULL);
                if (space_notAvailable)
                    break;

                set_register_bits(txbuffer_reg, d_support.data_write[i], 0xFFFFFFFF);
                }
        return (i<<2);
        }

    // Disable IP
    // set_register_bits(conf_reg, 0, MSK_CONF_ENAB_IP)

    return 0;

}


static int chardev_open(struct inode *i, struct file *f) {
    uint32_t *conf_reg = d_support.base_addr + REG_CTRL;

    d_support.open_count++;
    if (d_support.open_count > 1) {
        return 0;
    }

    // printk(KERN_DEBUG MSG_PREFIX "Open\n");

    set_register_bits(conf_reg, 1, MSK_CONF_FLUSH_FIFO);

    d_support.buf_switch = false;
    d_support.buf_offset = 0;
    d_support.burst_err = 0;
    sema_init(&d_support.buf_sem[0], 1);
    sema_init(&d_support.buf_sem[1], 1);

    return 0;
}


static int chardev_close(struct inode *i, struct file *fp) {
    // uint32_t *conf_reg = d_support.base_addr + REG_CTRL;

    d_support.open_count--;
    if (d_support.open_count > 0) {
        return 0;
    }

    return 0;
}


static long sp2neu_ioctl(struct file *filp, unsigned int cmd, unsigned long param) {
    int res = 0;
    unsigned int temp;
    spinn2neu_regs_t temp_reg;

    switch (cmd) {
#if 0
        case IOC_SET_NEUELABTHRESHOLD:

            res = set_threshold(filp, param);
            break;
#endif

        case IOC_GET_VERSION:
            read_version(filp, &temp);
            if (copy_to_user((void __user *)param, &temp, sizeof(unsigned int)))
                goto ctuser_err;
            break;

        case IOC_GET_TIMESTAMP:
            get_timestamp(filp, &temp);
            if (copy_to_user((void __user *)param, &temp, sizeof(unsigned int)))
                goto ctuser_err;
            break;

        case IOC_CLEAR_TIMESTAMP:
            clear_timestamp();
            break;

        case IOC_GEN_REG:
            if (copy_from_user(&temp_reg, (spinn2neu_regs_t *)param, sizeof(spinn2neu_regs_t)))
                goto cfuser_err;

            if (temp_reg.rw==0) {
                read_generic_reg(&temp_reg.data,d_support.base_addr + temp_reg.reg_offset);
                if (copy_to_user((spinn2neu_regs_t *)param, &temp_reg, sizeof(spinn2neu_regs_t)))
                    goto ctuser_err;
            }
            else {
                write_generic_reg(temp_reg.data,d_support.base_addr + temp_reg.reg_offset);
            }
            break;

        case IOC_SET_LOCNEAR_LB:

            if (param) {
                set_local_loopback(1);
            }
            else {
                set_local_loopback(0);
            }
            break;

        case IOC_SET_LOCFAR_LB:

            if (param) {
                set_locfar_loopback(1);
            }
            else {
                set_locfar_loopback(0);
            }
            break;

        case IOC_SET_REMOTE_LB:

            if (param) {
                set_remote_loopback(1);
            }
            else {
                set_remote_loopback(0);
            }
            break;

#if 0
        case IOC_RESET:
            keep_out_from_reset();
#endif

#if 0
        case IOC_GET_TIMESTAMPER:
            read_timestamper(filp, &temp);
            if (copy_to_user((void __user *)param, &temp, sizeof(unsigned int)))
                goto ctuser_err;
            break;
#endif

        default:
            printk(KERN_ALERT MSG_PREFIX "IOCTL request not handled: %i\n", cmd);
            return -EFAULT;
    }

    return res;

    cfuser_err:
        printk(KERN_ALERT MSG_PREFIX "Copy from user space failed\n");
        return -EFAULT;

    ctuser_err:
        printk(KERN_ALERT MSG_PREFIX "Copy to user space failed\n");
        return -EFAULT;
}


#if 0
static long set_threshold(struct file *filep, unsigned int threshold) {
    uint32_t *threshold_reg = d_support.base_addr + REG_ONTH;

    set_register_bits(threshold_reg, threshold, 0xFFFFFFFF);

    // printk(KERN_DEBUG MSG_PREFIX "IOCTL set threshold to: %d\n", threshold);

    return 0;
}
#endif


static long read_version(struct file *filep, unsigned int * version) {
    uint32_t *version_reg = d_support.base_addr + REG_ID;
    uint32_t tmp;

    get_register_bits(version_reg, tmp, 0xFFFFFFFF);
    *version= tmp;

    return 0;
}


static long get_timestamp(struct file *filep, unsigned int * timestampwrap) {
    uint32_t *timestamp_reg = d_support.base_addr + REG_WRAP;
    uint32_t tmp;

    get_register_bits(timestamp_reg, tmp, 0xFFFFFFFF);
    *timestampwrap= tmp;

    return 0;
}


static long clear_timestamp(void) {
    uint32_t *timestamp_reg = d_support.base_addr + REG_WRAP;

    // Any value is fine to clear the reg
    set_register_bits(timestamp_reg, 0xFFFFFFFF, 0xFFFFFFFF);
    d_support.wraptimes=0;

    return 0;
}


static long set_local_loopback(bool value) {
    uint32_t *conf_reg = d_support.base_addr + REG_CTRL;
    uint32_t tmp;

    if (value) {
        set_register_bits(conf_reg, 1, MSK_CONF_LOC_LB);
        get_register_bits(conf_reg, tmp, 0xFFFFFFFF);
        }
    else {
        set_register_bits(conf_reg, 0, MSK_CONF_LOC_LB);
        get_register_bits(conf_reg, tmp, 0xFFFFFFFF);
        }

    return 0;
}


static long set_locfar_loopback(bool value) {
    uint32_t *conf_reg = d_support.base_addr + REG_CTRL;
    uint32_t tmp;

    if (value) {
        set_register_bits(conf_reg, 1, MSK_CONF_LOCFAR_LB);
        get_register_bits(conf_reg, tmp, 0xFFFFFFFF);
        }
    else {
        set_register_bits(conf_reg, 0, MSK_CONF_LOCFAR_LB);
        get_register_bits(conf_reg, tmp, 0xFFFFFFFF);
        }

    return 0;
}


static long set_remote_loopback(bool value) {
    uint32_t *conf_reg = d_support.base_addr + REG_CTRL;
    uint32_t tmp;

    if (value) {
        set_register_bits(conf_reg, 1, MSK_CONF_REM_LB);
        get_register_bits(conf_reg, tmp, 0xFFFFFFFF);
        }
    else {
        set_register_bits(conf_reg, 0, MSK_CONF_REM_LB);
        get_register_bits(conf_reg, tmp, 0xFFFFFFFF);
        }

    return 0;
}


#if 0
static long read_timestamper(struct file *filep, unsigned int * timestamp) {
    uint32_t *timestamp_reg = d_support.base_addr + REG_TIMESTAMP;
    uint32_t tmp;

    get_register_bits(timestamp_reg, tmp, 0xFFFFFFFF);
    *timestamp= tmp;

    return 0;
}
#endif
