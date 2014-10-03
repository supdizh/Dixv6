
kernel：     文件格式 elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 43 35 10 80       	mov    $0x80103543,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 40 84 10 	movl   $0x80108440,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 d4 4b 00 00       	call   80104c22 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 db 10 80 84 	movl   $0x8010db84,0x8010db90
80100055:	db 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 db 10 80 84 	movl   $0x8010db84,0x8010db94
8010005f:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 db 10 80       	mov    0x8010db94,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 db 10 80       	mov    %eax,0x8010db94

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000bd:	e8 81 4b 00 00       	call   80104c43 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 db 10 80       	mov    0x8010db94,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	89 c2                	mov    %eax,%edx
801000f5:	83 ca 01             	or     $0x1,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100104:	e8 9c 4b 00 00       	call   80104ca5 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 3a 48 00 00       	call   8010495e <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 db 10 80       	mov    0x8010db90,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017c:	e8 24 4b 00 00       	call   80104ca5 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 47 84 10 80 	movl   $0x80108447,(%esp)
8010019f:	e8 a2 03 00 00       	call   80100546 <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 5c 27 00 00       	call   80102934 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 58 84 10 80 	movl   $0x80108458,(%esp)
801001f6:	e8 4b 03 00 00       	call   80100546 <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	89 c2                	mov    %eax,%edx
80100202:	83 ca 04             	or     $0x4,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 1f 27 00 00       	call   80102934 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 5f 84 10 80 	movl   $0x8010845f,(%esp)
80100230:	e8 11 03 00 00       	call   80100546 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023c:	e8 02 4a 00 00       	call   80104c43 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 db 10 80       	mov    0x8010db94,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 db 10 80       	mov    %eax,0x8010db94

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	89 c2                	mov    %eax,%edx
8010028f:	83 e2 fe             	and    $0xfffffffe,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 98 47 00 00       	call   80104a3a <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002a9:	e8 f7 49 00 00       	call   80104ca5 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	53                   	push   %ebx
801002b4:	83 ec 14             	sub    $0x14,%esp
801002b7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ba:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002be:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
801002c2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801002c6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801002ca:	ec                   	in     (%dx),%al
801002cb:	89 c3                	mov    %eax,%ebx
801002cd:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801002d0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801002d4:	83 c4 14             	add    $0x14,%esp
801002d7:	5b                   	pop    %ebx
801002d8:	5d                   	pop    %ebp
801002d9:	c3                   	ret    

801002da <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002da:	55                   	push   %ebp
801002db:	89 e5                	mov    %esp,%ebp
801002dd:	83 ec 08             	sub    $0x8,%esp
801002e0:	8b 55 08             	mov    0x8(%ebp),%edx
801002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801002e6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002ea:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002ed:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002f1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002f5:	ee                   	out    %al,(%dx)
}
801002f6:	c9                   	leave  
801002f7:	c3                   	ret    

801002f8 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002f8:	55                   	push   %ebp
801002f9:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002fb:	fa                   	cli    
}
801002fc:	5d                   	pop    %ebp
801002fd:	c3                   	ret    

801002fe <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002fe:	55                   	push   %ebp
801002ff:	89 e5                	mov    %esp,%ebp
80100301:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100304:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100308:	74 1c                	je     80100326 <printint+0x28>
8010030a:	8b 45 08             	mov    0x8(%ebp),%eax
8010030d:	c1 e8 1f             	shr    $0x1f,%eax
80100310:	0f b6 c0             	movzbl %al,%eax
80100313:	89 45 10             	mov    %eax,0x10(%ebp)
80100316:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010031a:	74 0a                	je     80100326 <printint+0x28>
    x = -xx;
8010031c:	8b 45 08             	mov    0x8(%ebp),%eax
8010031f:	f7 d8                	neg    %eax
80100321:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100324:	eb 06                	jmp    8010032c <printint+0x2e>
  else
    x = xx;
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010032c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100333:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100336:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100339:	ba 00 00 00 00       	mov    $0x0,%edx
8010033e:	f7 f1                	div    %ecx
80100340:	89 d0                	mov    %edx,%eax
80100342:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100349:	8d 4d e0             	lea    -0x20(%ebp),%ecx
8010034c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010034f:	01 ca                	add    %ecx,%edx
80100351:	88 02                	mov    %al,(%edx)
80100353:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
80100357:	8b 55 0c             	mov    0xc(%ebp),%edx
8010035a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010035d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100360:	ba 00 00 00 00       	mov    $0x0,%edx
80100365:	f7 75 d4             	divl   -0x2c(%ebp)
80100368:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010036b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010036f:	75 c2                	jne    80100333 <printint+0x35>

  if(sign)
80100371:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100375:	74 27                	je     8010039e <printint+0xa0>
    buf[i++] = '-';
80100377:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037d:	01 d0                	add    %edx,%eax
8010037f:	c6 00 2d             	movb   $0x2d,(%eax)
80100382:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
80100386:	eb 16                	jmp    8010039e <printint+0xa0>
    consputc(buf[i]);
80100388:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010038b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038e:	01 d0                	add    %edx,%eax
80100390:	0f b6 00             	movzbl (%eax),%eax
80100393:	0f be c0             	movsbl %al,%eax
80100396:	89 04 24             	mov    %eax,(%esp)
80100399:	e8 bb 03 00 00       	call   80100759 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010039e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003a6:	79 e0                	jns    80100388 <printint+0x8a>
    consputc(buf[i]);
}
801003a8:	c9                   	leave  
801003a9:	c3                   	ret    

801003aa <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003aa:	55                   	push   %ebp
801003ab:	89 e5                	mov    %esp,%ebp
801003ad:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003b0:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003bc:	74 0c                	je     801003ca <cprintf+0x20>
    acquire(&cons.lock);
801003be:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003c5:	e8 79 48 00 00       	call   80104c43 <acquire>

  if (fmt == 0)
801003ca:	8b 45 08             	mov    0x8(%ebp),%eax
801003cd:	85 c0                	test   %eax,%eax
801003cf:	75 0c                	jne    801003dd <cprintf+0x33>
    panic("null fmt");
801003d1:	c7 04 24 66 84 10 80 	movl   $0x80108466,(%esp)
801003d8:	e8 69 01 00 00       	call   80100546 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003dd:	8d 45 0c             	lea    0xc(%ebp),%eax
801003e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003ea:	e9 20 01 00 00       	jmp    8010050f <cprintf+0x165>
    if(c != '%'){
801003ef:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003f3:	74 10                	je     80100405 <cprintf+0x5b>
      consputc(c);
801003f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003f8:	89 04 24             	mov    %eax,(%esp)
801003fb:	e8 59 03 00 00       	call   80100759 <consputc>
      continue;
80100400:	e9 06 01 00 00       	jmp    8010050b <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
80100405:	8b 55 08             	mov    0x8(%ebp),%edx
80100408:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010040c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010040f:	01 d0                	add    %edx,%eax
80100411:	0f b6 00             	movzbl (%eax),%eax
80100414:	0f be c0             	movsbl %al,%eax
80100417:	25 ff 00 00 00       	and    $0xff,%eax
8010041c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010041f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100423:	0f 84 08 01 00 00    	je     80100531 <cprintf+0x187>
      break;
    switch(c){
80100429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010042c:	83 f8 70             	cmp    $0x70,%eax
8010042f:	74 4d                	je     8010047e <cprintf+0xd4>
80100431:	83 f8 70             	cmp    $0x70,%eax
80100434:	7f 13                	jg     80100449 <cprintf+0x9f>
80100436:	83 f8 25             	cmp    $0x25,%eax
80100439:	0f 84 a6 00 00 00    	je     801004e5 <cprintf+0x13b>
8010043f:	83 f8 64             	cmp    $0x64,%eax
80100442:	74 14                	je     80100458 <cprintf+0xae>
80100444:	e9 aa 00 00 00       	jmp    801004f3 <cprintf+0x149>
80100449:	83 f8 73             	cmp    $0x73,%eax
8010044c:	74 53                	je     801004a1 <cprintf+0xf7>
8010044e:	83 f8 78             	cmp    $0x78,%eax
80100451:	74 2b                	je     8010047e <cprintf+0xd4>
80100453:	e9 9b 00 00 00       	jmp    801004f3 <cprintf+0x149>
    case 'd':
      printint(*argp++, 10, 1);
80100458:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010045b:	8b 00                	mov    (%eax),%eax
8010045d:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100461:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100468:	00 
80100469:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100470:	00 
80100471:	89 04 24             	mov    %eax,(%esp)
80100474:	e8 85 fe ff ff       	call   801002fe <printint>
      break;
80100479:	e9 8d 00 00 00       	jmp    8010050b <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010047e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100481:	8b 00                	mov    (%eax),%eax
80100483:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100487:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010048e:	00 
8010048f:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100496:	00 
80100497:	89 04 24             	mov    %eax,(%esp)
8010049a:	e8 5f fe ff ff       	call   801002fe <printint>
      break;
8010049f:	eb 6a                	jmp    8010050b <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
801004a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004a4:	8b 00                	mov    (%eax),%eax
801004a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ad:	0f 94 c0             	sete   %al
801004b0:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004b4:	84 c0                	test   %al,%al
801004b6:	74 20                	je     801004d8 <cprintf+0x12e>
        s = "(null)";
801004b8:	c7 45 ec 6f 84 10 80 	movl   $0x8010846f,-0x14(%ebp)
      for(; *s; s++)
801004bf:	eb 17                	jmp    801004d8 <cprintf+0x12e>
        consputc(*s);
801004c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004c4:	0f b6 00             	movzbl (%eax),%eax
801004c7:	0f be c0             	movsbl %al,%eax
801004ca:	89 04 24             	mov    %eax,(%esp)
801004cd:	e8 87 02 00 00       	call   80100759 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004d2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d6:	eb 01                	jmp    801004d9 <cprintf+0x12f>
801004d8:	90                   	nop
801004d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004dc:	0f b6 00             	movzbl (%eax),%eax
801004df:	84 c0                	test   %al,%al
801004e1:	75 de                	jne    801004c1 <cprintf+0x117>
        consputc(*s);
      break;
801004e3:	eb 26                	jmp    8010050b <cprintf+0x161>
    case '%':
      consputc('%');
801004e5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ec:	e8 68 02 00 00       	call   80100759 <consputc>
      break;
801004f1:	eb 18                	jmp    8010050b <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004f3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004fa:	e8 5a 02 00 00       	call   80100759 <consputc>
      consputc(c);
801004ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100502:	89 04 24             	mov    %eax,(%esp)
80100505:	e8 4f 02 00 00       	call   80100759 <consputc>
      break;
8010050a:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010050b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010050f:	8b 55 08             	mov    0x8(%ebp),%edx
80100512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100515:	01 d0                	add    %edx,%eax
80100517:	0f b6 00             	movzbl (%eax),%eax
8010051a:	0f be c0             	movsbl %al,%eax
8010051d:	25 ff 00 00 00       	and    $0xff,%eax
80100522:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100525:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100529:	0f 85 c0 fe ff ff    	jne    801003ef <cprintf+0x45>
8010052f:	eb 01                	jmp    80100532 <cprintf+0x188>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100531:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100532:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100536:	74 0c                	je     80100544 <cprintf+0x19a>
    release(&cons.lock);
80100538:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010053f:	e8 61 47 00 00       	call   80104ca5 <release>
}
80100544:	c9                   	leave  
80100545:	c3                   	ret    

80100546 <panic>:

void
panic(char *s)
{
80100546:	55                   	push   %ebp
80100547:	89 e5                	mov    %esp,%ebp
80100549:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
8010054c:	e8 a7 fd ff ff       	call   801002f8 <cli>
  cons.locking = 0;
80100551:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
80100558:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010055b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100561:	0f b6 00             	movzbl (%eax),%eax
80100564:	0f b6 c0             	movzbl %al,%eax
80100567:	89 44 24 04          	mov    %eax,0x4(%esp)
8010056b:	c7 04 24 76 84 10 80 	movl   $0x80108476,(%esp)
80100572:	e8 33 fe ff ff       	call   801003aa <cprintf>
  cprintf(s);
80100577:	8b 45 08             	mov    0x8(%ebp),%eax
8010057a:	89 04 24             	mov    %eax,(%esp)
8010057d:	e8 28 fe ff ff       	call   801003aa <cprintf>
  cprintf("\n");
80100582:	c7 04 24 85 84 10 80 	movl   $0x80108485,(%esp)
80100589:	e8 1c fe ff ff       	call   801003aa <cprintf>
  getcallerpcs(&s, pcs);
8010058e:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100591:	89 44 24 04          	mov    %eax,0x4(%esp)
80100595:	8d 45 08             	lea    0x8(%ebp),%eax
80100598:	89 04 24             	mov    %eax,(%esp)
8010059b:	e8 54 47 00 00       	call   80104cf4 <getcallerpcs>
  for(i=0; i<10; i++)
801005a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005a7:	eb 1b                	jmp    801005c4 <panic+0x7e>
    cprintf(" %p", pcs[i]);
801005a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005ac:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801005b4:	c7 04 24 87 84 10 80 	movl   $0x80108487,(%esp)
801005bb:	e8 ea fd ff ff       	call   801003aa <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005c4:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005c8:	7e df                	jle    801005a9 <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005ca:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005d1:	00 00 00 
  for(;;)
    ;
801005d4:	eb fe                	jmp    801005d4 <panic+0x8e>

801005d6 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005d6:	55                   	push   %ebp
801005d7:	89 e5                	mov    %esp,%ebp
801005d9:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005dc:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005e3:	00 
801005e4:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005eb:	e8 ea fc ff ff       	call   801002da <outb>
  pos = inb(CRTPORT+1) << 8;
801005f0:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005f7:	e8 b4 fc ff ff       	call   801002b0 <inb>
801005fc:	0f b6 c0             	movzbl %al,%eax
801005ff:	c1 e0 08             	shl    $0x8,%eax
80100602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100605:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010060c:	00 
8010060d:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100614:	e8 c1 fc ff ff       	call   801002da <outb>
  pos |= inb(CRTPORT+1);
80100619:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100620:	e8 8b fc ff ff       	call   801002b0 <inb>
80100625:	0f b6 c0             	movzbl %al,%eax
80100628:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010062b:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010062f:	75 30                	jne    80100661 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100631:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100634:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100639:	89 c8                	mov    %ecx,%eax
8010063b:	f7 ea                	imul   %edx
8010063d:	c1 fa 05             	sar    $0x5,%edx
80100640:	89 c8                	mov    %ecx,%eax
80100642:	c1 f8 1f             	sar    $0x1f,%eax
80100645:	29 c2                	sub    %eax,%edx
80100647:	89 d0                	mov    %edx,%eax
80100649:	c1 e0 02             	shl    $0x2,%eax
8010064c:	01 d0                	add    %edx,%eax
8010064e:	c1 e0 04             	shl    $0x4,%eax
80100651:	89 ca                	mov    %ecx,%edx
80100653:	29 c2                	sub    %eax,%edx
80100655:	b8 50 00 00 00       	mov    $0x50,%eax
8010065a:	29 d0                	sub    %edx,%eax
8010065c:	01 45 f4             	add    %eax,-0xc(%ebp)
8010065f:	eb 32                	jmp    80100693 <cgaputc+0xbd>
  else if(c == BACKSPACE){
80100661:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100668:	75 0c                	jne    80100676 <cgaputc+0xa0>
    if(pos > 0) --pos;
8010066a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010066e:	7e 23                	jle    80100693 <cgaputc+0xbd>
80100670:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100674:	eb 1d                	jmp    80100693 <cgaputc+0xbd>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100676:	a1 00 90 10 80       	mov    0x80109000,%eax
8010067b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010067e:	01 d2                	add    %edx,%edx
80100680:	01 c2                	add    %eax,%edx
80100682:	8b 45 08             	mov    0x8(%ebp),%eax
80100685:	66 25 ff 00          	and    $0xff,%ax
80100689:	80 cc 07             	or     $0x7,%ah
8010068c:	66 89 02             	mov    %ax,(%edx)
8010068f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
80100693:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
8010069a:	7e 53                	jle    801006ef <cgaputc+0x119>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010069c:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006a7:	a1 00 90 10 80       	mov    0x80109000,%eax
801006ac:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006b3:	00 
801006b4:	89 54 24 04          	mov    %edx,0x4(%esp)
801006b8:	89 04 24             	mov    %eax,(%esp)
801006bb:	e8 b1 48 00 00       	call   80104f71 <memmove>
    pos -= 80;
801006c0:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006c4:	b8 80 07 00 00       	mov    $0x780,%eax
801006c9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006cc:	01 c0                	add    %eax,%eax
801006ce:	8b 15 00 90 10 80    	mov    0x80109000,%edx
801006d4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006d7:	01 c9                	add    %ecx,%ecx
801006d9:	01 ca                	add    %ecx,%edx
801006db:	89 44 24 08          	mov    %eax,0x8(%esp)
801006df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006e6:	00 
801006e7:	89 14 24             	mov    %edx,(%esp)
801006ea:	e8 af 47 00 00       	call   80104e9e <memset>
  }
  
  outb(CRTPORT, 14);
801006ef:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006f6:	00 
801006f7:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006fe:	e8 d7 fb ff ff       	call   801002da <outb>
  outb(CRTPORT+1, pos>>8);
80100703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100706:	c1 f8 08             	sar    $0x8,%eax
80100709:	0f b6 c0             	movzbl %al,%eax
8010070c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100710:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100717:	e8 be fb ff ff       	call   801002da <outb>
  outb(CRTPORT, 15);
8010071c:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100723:	00 
80100724:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010072b:	e8 aa fb ff ff       	call   801002da <outb>
  outb(CRTPORT+1, pos);
80100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100733:	0f b6 c0             	movzbl %al,%eax
80100736:	89 44 24 04          	mov    %eax,0x4(%esp)
8010073a:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100741:	e8 94 fb ff ff       	call   801002da <outb>
  crt[pos] = ' ' | 0x0700;
80100746:	a1 00 90 10 80       	mov    0x80109000,%eax
8010074b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010074e:	01 d2                	add    %edx,%edx
80100750:	01 d0                	add    %edx,%eax
80100752:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100757:	c9                   	leave  
80100758:	c3                   	ret    

80100759 <consputc>:

void
consputc(int c)
{
80100759:	55                   	push   %ebp
8010075a:	89 e5                	mov    %esp,%ebp
8010075c:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
8010075f:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
80100764:	85 c0                	test   %eax,%eax
80100766:	74 07                	je     8010076f <consputc+0x16>
    cli();
80100768:	e8 8b fb ff ff       	call   801002f8 <cli>
    for(;;)
      ;
8010076d:	eb fe                	jmp    8010076d <consputc+0x14>
  }

  if(c == BACKSPACE){
8010076f:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100776:	75 26                	jne    8010079e <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100778:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010077f:	e8 f5 62 00 00       	call   80106a79 <uartputc>
80100784:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010078b:	e8 e9 62 00 00       	call   80106a79 <uartputc>
80100790:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100797:	e8 dd 62 00 00       	call   80106a79 <uartputc>
8010079c:	eb 0b                	jmp    801007a9 <consputc+0x50>
  } else
    uartputc(c);
8010079e:	8b 45 08             	mov    0x8(%ebp),%eax
801007a1:	89 04 24             	mov    %eax,(%esp)
801007a4:	e8 d0 62 00 00       	call   80106a79 <uartputc>
  cgaputc(c);
801007a9:	8b 45 08             	mov    0x8(%ebp),%eax
801007ac:	89 04 24             	mov    %eax,(%esp)
801007af:	e8 22 fe ff ff       	call   801005d6 <cgaputc>
}
801007b4:	c9                   	leave  
801007b5:	c3                   	ret    

801007b6 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b6:	55                   	push   %ebp
801007b7:	89 e5                	mov    %esp,%ebp
801007b9:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007bc:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801007c3:	e8 7b 44 00 00       	call   80104c43 <acquire>
  while((c = getc()) >= 0){
801007c8:	e9 41 01 00 00       	jmp    8010090e <consoleintr+0x158>
    switch(c){
801007cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007d0:	83 f8 10             	cmp    $0x10,%eax
801007d3:	74 1e                	je     801007f3 <consoleintr+0x3d>
801007d5:	83 f8 10             	cmp    $0x10,%eax
801007d8:	7f 0a                	jg     801007e4 <consoleintr+0x2e>
801007da:	83 f8 08             	cmp    $0x8,%eax
801007dd:	74 68                	je     80100847 <consoleintr+0x91>
801007df:	e9 94 00 00 00       	jmp    80100878 <consoleintr+0xc2>
801007e4:	83 f8 15             	cmp    $0x15,%eax
801007e7:	74 2f                	je     80100818 <consoleintr+0x62>
801007e9:	83 f8 7f             	cmp    $0x7f,%eax
801007ec:	74 59                	je     80100847 <consoleintr+0x91>
801007ee:	e9 85 00 00 00       	jmp    80100878 <consoleintr+0xc2>
    case C('P'):  // Process listing.
      procdump();
801007f3:	e8 e8 42 00 00       	call   80104ae0 <procdump>
      break;
801007f8:	e9 11 01 00 00       	jmp    8010090e <consoleintr+0x158>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007fd:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100802:	83 e8 01             	sub    $0x1,%eax
80100805:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
8010080a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100811:	e8 43 ff ff ff       	call   80100759 <consputc>
80100816:	eb 01                	jmp    80100819 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100818:	90                   	nop
80100819:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010081f:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100824:	39 c2                	cmp    %eax,%edx
80100826:	0f 84 db 00 00 00    	je     80100907 <consoleintr+0x151>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010082c:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100831:	83 e8 01             	sub    $0x1,%eax
80100834:	83 e0 7f             	and    $0x7f,%eax
80100837:	0f b6 80 d4 dd 10 80 	movzbl -0x7fef222c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010083e:	3c 0a                	cmp    $0xa,%al
80100840:	75 bb                	jne    801007fd <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100842:	e9 c0 00 00 00       	jmp    80100907 <consoleintr+0x151>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100847:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010084d:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100852:	39 c2                	cmp    %eax,%edx
80100854:	0f 84 b0 00 00 00    	je     8010090a <consoleintr+0x154>
        input.e--;
8010085a:	a1 5c de 10 80       	mov    0x8010de5c,%eax
8010085f:	83 e8 01             	sub    $0x1,%eax
80100862:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
80100867:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010086e:	e8 e6 fe ff ff       	call   80100759 <consputc>
      }
      break;
80100873:	e9 92 00 00 00       	jmp    8010090a <consoleintr+0x154>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100878:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010087c:	0f 84 8b 00 00 00    	je     8010090d <consoleintr+0x157>
80100882:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100888:	a1 54 de 10 80       	mov    0x8010de54,%eax
8010088d:	89 d1                	mov    %edx,%ecx
8010088f:	29 c1                	sub    %eax,%ecx
80100891:	89 c8                	mov    %ecx,%eax
80100893:	83 f8 7f             	cmp    $0x7f,%eax
80100896:	77 75                	ja     8010090d <consoleintr+0x157>
        c = (c == '\r') ? '\n' : c;
80100898:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010089c:	74 05                	je     801008a3 <consoleintr+0xed>
8010089e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008a1:	eb 05                	jmp    801008a8 <consoleintr+0xf2>
801008a3:	b8 0a 00 00 00       	mov    $0xa,%eax
801008a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008ab:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008b0:	89 c1                	mov    %eax,%ecx
801008b2:	83 e1 7f             	and    $0x7f,%ecx
801008b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008b8:	88 91 d4 dd 10 80    	mov    %dl,-0x7fef222c(%ecx)
801008be:	83 c0 01             	add    $0x1,%eax
801008c1:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(c);
801008c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008c9:	89 04 24             	mov    %eax,(%esp)
801008cc:	e8 88 fe ff ff       	call   80100759 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008d1:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008d5:	74 18                	je     801008ef <consoleintr+0x139>
801008d7:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008db:	74 12                	je     801008ef <consoleintr+0x139>
801008dd:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008e2:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801008e8:	83 ea 80             	sub    $0xffffff80,%edx
801008eb:	39 d0                	cmp    %edx,%eax
801008ed:	75 1e                	jne    8010090d <consoleintr+0x157>
          input.w = input.e;
801008ef:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008f4:	a3 58 de 10 80       	mov    %eax,0x8010de58
          wakeup(&input.r);
801008f9:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
80100900:	e8 35 41 00 00       	call   80104a3a <wakeup>
        }
      }
      break;
80100905:	eb 06                	jmp    8010090d <consoleintr+0x157>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100907:	90                   	nop
80100908:	eb 04                	jmp    8010090e <consoleintr+0x158>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010090a:	90                   	nop
8010090b:	eb 01                	jmp    8010090e <consoleintr+0x158>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
8010090d:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
8010090e:	8b 45 08             	mov    0x8(%ebp),%eax
80100911:	ff d0                	call   *%eax
80100913:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100916:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010091a:	0f 89 ad fe ff ff    	jns    801007cd <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100920:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100927:	e8 79 43 00 00       	call   80104ca5 <release>
}
8010092c:	c9                   	leave  
8010092d:	c3                   	ret    

8010092e <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010092e:	55                   	push   %ebp
8010092f:	89 e5                	mov    %esp,%ebp
80100931:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100934:	8b 45 08             	mov    0x8(%ebp),%eax
80100937:	89 04 24             	mov    %eax,(%esp)
8010093a:	e8 9b 10 00 00       	call   801019da <iunlock>
  target = n;
8010093f:	8b 45 10             	mov    0x10(%ebp),%eax
80100942:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100945:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010094c:	e8 f2 42 00 00       	call   80104c43 <acquire>
  while(n > 0){
80100951:	e9 a8 00 00 00       	jmp    801009fe <consoleread+0xd0>
    while(input.r == input.w){
      if(proc->killed){
80100956:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010095c:	8b 40 24             	mov    0x24(%eax),%eax
8010095f:	85 c0                	test   %eax,%eax
80100961:	74 21                	je     80100984 <consoleread+0x56>
        release(&input.lock);
80100963:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010096a:	e8 36 43 00 00       	call   80104ca5 <release>
        ilock(ip);
8010096f:	8b 45 08             	mov    0x8(%ebp),%eax
80100972:	89 04 24             	mov    %eax,(%esp)
80100975:	e8 12 0f 00 00       	call   8010188c <ilock>
        return -1;
8010097a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010097f:	e9 a9 00 00 00       	jmp    80100a2d <consoleread+0xff>
      }
      sleep(&input.r, &input.lock);
80100984:	c7 44 24 04 a0 dd 10 	movl   $0x8010dda0,0x4(%esp)
8010098b:	80 
8010098c:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
80100993:	e8 c6 3f 00 00       	call   8010495e <sleep>
80100998:	eb 01                	jmp    8010099b <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
8010099a:	90                   	nop
8010099b:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801009a1:	a1 58 de 10 80       	mov    0x8010de58,%eax
801009a6:	39 c2                	cmp    %eax,%edx
801009a8:	74 ac                	je     80100956 <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009aa:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009af:	89 c2                	mov    %eax,%edx
801009b1:	83 e2 7f             	and    $0x7f,%edx
801009b4:	0f b6 92 d4 dd 10 80 	movzbl -0x7fef222c(%edx),%edx
801009bb:	0f be d2             	movsbl %dl,%edx
801009be:	89 55 f0             	mov    %edx,-0x10(%ebp)
801009c1:	83 c0 01             	add    $0x1,%eax
801009c4:	a3 54 de 10 80       	mov    %eax,0x8010de54
    if(c == C('D')){  // EOF
801009c9:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009cd:	75 17                	jne    801009e6 <consoleread+0xb8>
      if(n < target){
801009cf:	8b 45 10             	mov    0x10(%ebp),%eax
801009d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009d5:	73 2f                	jae    80100a06 <consoleread+0xd8>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009d7:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009dc:	83 e8 01             	sub    $0x1,%eax
801009df:	a3 54 de 10 80       	mov    %eax,0x8010de54
      }
      break;
801009e4:	eb 20                	jmp    80100a06 <consoleread+0xd8>
    }
    *dst++ = c;
801009e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009e9:	89 c2                	mov    %eax,%edx
801009eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801009ee:	88 10                	mov    %dl,(%eax)
801009f0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    --n;
801009f4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009f8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009fc:	74 0b                	je     80100a09 <consoleread+0xdb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a02:	7f 96                	jg     8010099a <consoleread+0x6c>
80100a04:	eb 04                	jmp    80100a0a <consoleread+0xdc>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a06:	90                   	nop
80100a07:	eb 01                	jmp    80100a0a <consoleread+0xdc>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a09:	90                   	nop
  }
  release(&input.lock);
80100a0a:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100a11:	e8 8f 42 00 00       	call   80104ca5 <release>
  ilock(ip);
80100a16:	8b 45 08             	mov    0x8(%ebp),%eax
80100a19:	89 04 24             	mov    %eax,(%esp)
80100a1c:	e8 6b 0e 00 00       	call   8010188c <ilock>

  return target - n;
80100a21:	8b 45 10             	mov    0x10(%ebp),%eax
80100a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a27:	89 d1                	mov    %edx,%ecx
80100a29:	29 c1                	sub    %eax,%ecx
80100a2b:	89 c8                	mov    %ecx,%eax
}
80100a2d:	c9                   	leave  
80100a2e:	c3                   	ret    

80100a2f <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a2f:	55                   	push   %ebp
80100a30:	89 e5                	mov    %esp,%ebp
80100a32:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a35:	8b 45 08             	mov    0x8(%ebp),%eax
80100a38:	89 04 24             	mov    %eax,(%esp)
80100a3b:	e8 9a 0f 00 00       	call   801019da <iunlock>
  acquire(&cons.lock);
80100a40:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a47:	e8 f7 41 00 00       	call   80104c43 <acquire>
  for(i = 0; i < n; i++)
80100a4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a53:	eb 1f                	jmp    80100a74 <consolewrite+0x45>
    consputc(buf[i] & 0xff);
80100a55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a5b:	01 d0                	add    %edx,%eax
80100a5d:	0f b6 00             	movzbl (%eax),%eax
80100a60:	0f be c0             	movsbl %al,%eax
80100a63:	25 ff 00 00 00       	and    $0xff,%eax
80100a68:	89 04 24             	mov    %eax,(%esp)
80100a6b:	e8 e9 fc ff ff       	call   80100759 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a70:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a77:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a7a:	7c d9                	jl     80100a55 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a7c:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a83:	e8 1d 42 00 00       	call   80104ca5 <release>
  ilock(ip);
80100a88:	8b 45 08             	mov    0x8(%ebp),%eax
80100a8b:	89 04 24             	mov    %eax,(%esp)
80100a8e:	e8 f9 0d 00 00       	call   8010188c <ilock>

  return n;
80100a93:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a96:	c9                   	leave  
80100a97:	c3                   	ret    

80100a98 <consoleinit>:

void
consoleinit(void)
{
80100a98:	55                   	push   %ebp
80100a99:	89 e5                	mov    %esp,%ebp
80100a9b:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a9e:	c7 44 24 04 8b 84 10 	movl   $0x8010848b,0x4(%esp)
80100aa5:	80 
80100aa6:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100aad:	e8 70 41 00 00       	call   80104c22 <initlock>
  initlock(&input.lock, "input");
80100ab2:	c7 44 24 04 93 84 10 	movl   $0x80108493,0x4(%esp)
80100ab9:	80 
80100aba:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100ac1:	e8 5c 41 00 00       	call   80104c22 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100ac6:	c7 05 0c e8 10 80 2f 	movl   $0x80100a2f,0x8010e80c
80100acd:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ad0:	c7 05 08 e8 10 80 2e 	movl   $0x8010092e,0x8010e808
80100ad7:	09 10 80 
  cons.locking = 1;
80100ada:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100ae1:	00 00 00 

  picenable(IRQ_KBD);
80100ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aeb:	e8 01 31 00 00       	call   80103bf1 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100af0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100af7:	00 
80100af8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aff:	e8 f2 1f 00 00       	call   80102af6 <ioapicenable>
}
80100b04:	c9                   	leave  
80100b05:	c3                   	ret    
80100b06:	66 90                	xchg   %ax,%ax

80100b08 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b08:	55                   	push   %ebp
80100b09:	89 e5                	mov    %esp,%ebp
80100b0b:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100b11:	8b 45 08             	mov    0x8(%ebp),%eax
80100b14:	89 04 24             	mov    %eax,(%esp)
80100b17:	e8 6e 1a 00 00       	call   8010258a <namei>
80100b1c:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b1f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b23:	75 0a                	jne    80100b2f <exec+0x27>
    return -1;
80100b25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b2a:	e9 ef 03 00 00       	jmp    80100f1e <exec+0x416>
  ilock(ip);
80100b2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b32:	89 04 24             	mov    %eax,(%esp)
80100b35:	e8 52 0d 00 00       	call   8010188c <ilock>
  pgdir = 0;
80100b3a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b41:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b48:	00 
80100b49:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b50:	00 
80100b51:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b57:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b5e:	89 04 24             	mov    %eax,(%esp)
80100b61:	e8 70 13 00 00       	call   80101ed6 <readi>
80100b66:	83 f8 33             	cmp    $0x33,%eax
80100b69:	0f 86 69 03 00 00    	jbe    80100ed8 <exec+0x3d0>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b6f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b75:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b7a:	0f 85 5b 03 00 00    	jne    80100edb <exec+0x3d3>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b80:	e8 46 70 00 00       	call   80107bcb <setupkvm>
80100b85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b88:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b8c:	0f 84 4c 03 00 00    	je     80100ede <exec+0x3d6>
    goto bad;

  // Load program into memory.
  sz = 0;
80100b92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b99:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100ba0:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100ba6:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ba9:	e9 c5 00 00 00       	jmp    80100c73 <exec+0x16b>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bb1:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bb8:	00 
80100bb9:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bbd:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bc7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bca:	89 04 24             	mov    %eax,(%esp)
80100bcd:	e8 04 13 00 00       	call   80101ed6 <readi>
80100bd2:	83 f8 20             	cmp    $0x20,%eax
80100bd5:	0f 85 06 03 00 00    	jne    80100ee1 <exec+0x3d9>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bdb:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100be1:	83 f8 01             	cmp    $0x1,%eax
80100be4:	75 7f                	jne    80100c65 <exec+0x15d>
      continue;
    if(ph.memsz < ph.filesz)
80100be6:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100bec:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bf2:	39 c2                	cmp    %eax,%edx
80100bf4:	0f 82 ea 02 00 00    	jb     80100ee4 <exec+0x3dc>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bfa:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c00:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c06:	01 d0                	add    %edx,%eax
80100c08:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c16:	89 04 24             	mov    %eax,(%esp)
80100c19:	e8 7f 73 00 00       	call   80107f9d <allocuvm>
80100c1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c25:	0f 84 bc 02 00 00    	je     80100ee7 <exec+0x3df>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c2b:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c31:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c37:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c3d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c41:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c45:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c48:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c53:	89 04 24             	mov    %eax,(%esp)
80100c56:	e8 53 72 00 00       	call   80107eae <loaduvm>
80100c5b:	85 c0                	test   %eax,%eax
80100c5d:	0f 88 87 02 00 00    	js     80100eea <exec+0x3e2>
80100c63:	eb 01                	jmp    80100c66 <exec+0x15e>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c65:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c66:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c6d:	83 c0 20             	add    $0x20,%eax
80100c70:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c73:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c7a:	0f b7 c0             	movzwl %ax,%eax
80100c7d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c80:	0f 8f 28 ff ff ff    	jg     80100bae <exec+0xa6>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c86:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c89:	89 04 24             	mov    %eax,(%esp)
80100c8c:	e8 7f 0e 00 00       	call   80101b10 <iunlockput>
  ip = 0;
80100c91:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c9b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ca0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ca5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cab:	05 00 20 00 00       	add    $0x2000,%eax
80100cb0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cbe:	89 04 24             	mov    %eax,(%esp)
80100cc1:	e8 d7 72 00 00       	call   80107f9d <allocuvm>
80100cc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ccd:	0f 84 1a 02 00 00    	je     80100eed <exec+0x3e5>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ce2:	89 04 24             	mov    %eax,(%esp)
80100ce5:	e8 e3 74 00 00       	call   801081cd <clearpteu>
  sp = sz;
80100cea:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ced:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cf7:	e9 97 00 00 00       	jmp    80100d93 <exec+0x28b>
    if(argc >= MAXARG)
80100cfc:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d00:	0f 87 ea 01 00 00    	ja     80100ef0 <exec+0x3e8>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d10:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d13:	01 d0                	add    %edx,%eax
80100d15:	8b 00                	mov    (%eax),%eax
80100d17:	89 04 24             	mov    %eax,(%esp)
80100d1a:	e8 fd 43 00 00       	call   8010511c <strlen>
80100d1f:	f7 d0                	not    %eax
80100d21:	89 c2                	mov    %eax,%edx
80100d23:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d26:	01 d0                	add    %edx,%eax
80100d28:	83 e0 fc             	and    $0xfffffffc,%eax
80100d2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d31:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d38:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d3b:	01 d0                	add    %edx,%eax
80100d3d:	8b 00                	mov    (%eax),%eax
80100d3f:	89 04 24             	mov    %eax,(%esp)
80100d42:	e8 d5 43 00 00       	call   8010511c <strlen>
80100d47:	83 c0 01             	add    $0x1,%eax
80100d4a:	89 c2                	mov    %eax,%edx
80100d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d4f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d56:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d59:	01 c8                	add    %ecx,%eax
80100d5b:	8b 00                	mov    (%eax),%eax
80100d5d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d61:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d65:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d68:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d6f:	89 04 24             	mov    %eax,(%esp)
80100d72:	e8 1b 76 00 00       	call   80108392 <copyout>
80100d77:	85 c0                	test   %eax,%eax
80100d79:	0f 88 74 01 00 00    	js     80100ef3 <exec+0x3eb>
      goto bad;
    ustack[3+argc] = sp;
80100d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d82:	8d 50 03             	lea    0x3(%eax),%edx
80100d85:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d88:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d8f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da0:	01 d0                	add    %edx,%eax
80100da2:	8b 00                	mov    (%eax),%eax
80100da4:	85 c0                	test   %eax,%eax
80100da6:	0f 85 50 ff ff ff    	jne    80100cfc <exec+0x1f4>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100daf:	83 c0 03             	add    $0x3,%eax
80100db2:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100db9:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dbd:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dc4:	ff ff ff 
  ustack[1] = argc;
80100dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dca:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd3:	83 c0 01             	add    $0x1,%eax
80100dd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ddd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de0:	29 d0                	sub    %edx,%eax
80100de2:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100deb:	83 c0 04             	add    $0x4,%eax
80100dee:	c1 e0 02             	shl    $0x2,%eax
80100df1:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df7:	83 c0 04             	add    $0x4,%eax
80100dfa:	c1 e0 02             	shl    $0x2,%eax
80100dfd:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e01:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e07:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e15:	89 04 24             	mov    %eax,(%esp)
80100e18:	e8 75 75 00 00       	call   80108392 <copyout>
80100e1d:	85 c0                	test   %eax,%eax
80100e1f:	0f 88 d1 00 00 00    	js     80100ef6 <exec+0x3ee>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e25:	8b 45 08             	mov    0x8(%ebp),%eax
80100e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e31:	eb 17                	jmp    80100e4a <exec+0x342>
    if(*s == '/')
80100e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e36:	0f b6 00             	movzbl (%eax),%eax
80100e39:	3c 2f                	cmp    $0x2f,%al
80100e3b:	75 09                	jne    80100e46 <exec+0x33e>
      last = s+1;
80100e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e40:	83 c0 01             	add    $0x1,%eax
80100e43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e46:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e4d:	0f b6 00             	movzbl (%eax),%eax
80100e50:	84 c0                	test   %al,%al
80100e52:	75 df                	jne    80100e33 <exec+0x32b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e54:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e5a:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e5d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e64:	00 
80100e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e68:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e6c:	89 14 24             	mov    %edx,(%esp)
80100e6f:	e8 5a 42 00 00       	call   801050ce <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7a:	8b 40 04             	mov    0x4(%eax),%eax
80100e7d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e86:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e89:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e92:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e95:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9d:	8b 40 18             	mov    0x18(%eax),%eax
80100ea0:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ea6:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ea9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eaf:	8b 40 18             	mov    0x18(%eax),%eax
80100eb2:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100eb5:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100eb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebe:	89 04 24             	mov    %eax,(%esp)
80100ec1:	e8 f6 6d 00 00       	call   80107cbc <switchuvm>
  freevm(oldpgdir);
80100ec6:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ec9:	89 04 24             	mov    %eax,(%esp)
80100ecc:	e8 62 72 00 00       	call   80108133 <freevm>
  return 0;
80100ed1:	b8 00 00 00 00       	mov    $0x0,%eax
80100ed6:	eb 46                	jmp    80100f1e <exec+0x416>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100ed8:	90                   	nop
80100ed9:	eb 1c                	jmp    80100ef7 <exec+0x3ef>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100edb:	90                   	nop
80100edc:	eb 19                	jmp    80100ef7 <exec+0x3ef>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100ede:	90                   	nop
80100edf:	eb 16                	jmp    80100ef7 <exec+0x3ef>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100ee1:	90                   	nop
80100ee2:	eb 13                	jmp    80100ef7 <exec+0x3ef>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ee4:	90                   	nop
80100ee5:	eb 10                	jmp    80100ef7 <exec+0x3ef>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100ee7:	90                   	nop
80100ee8:	eb 0d                	jmp    80100ef7 <exec+0x3ef>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100eea:	90                   	nop
80100eeb:	eb 0a                	jmp    80100ef7 <exec+0x3ef>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100eed:	90                   	nop
80100eee:	eb 07                	jmp    80100ef7 <exec+0x3ef>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100ef0:	90                   	nop
80100ef1:	eb 04                	jmp    80100ef7 <exec+0x3ef>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100ef3:	90                   	nop
80100ef4:	eb 01                	jmp    80100ef7 <exec+0x3ef>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100ef6:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100ef7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100efb:	74 0b                	je     80100f08 <exec+0x400>
    freevm(pgdir);
80100efd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f00:	89 04 24             	mov    %eax,(%esp)
80100f03:	e8 2b 72 00 00       	call   80108133 <freevm>
  if(ip)
80100f08:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f0c:	74 0b                	je     80100f19 <exec+0x411>
    iunlockput(ip);
80100f0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f11:	89 04 24             	mov    %eax,(%esp)
80100f14:	e8 f7 0b 00 00       	call   80101b10 <iunlockput>
  return -1;
80100f19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f1e:	c9                   	leave  
80100f1f:	c3                   	ret    

80100f20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f26:	c7 44 24 04 99 84 10 	movl   $0x80108499,0x4(%esp)
80100f2d:	80 
80100f2e:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f35:	e8 e8 3c 00 00       	call   80104c22 <initlock>
}
80100f3a:	c9                   	leave  
80100f3b:	c3                   	ret    

80100f3c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f3c:	55                   	push   %ebp
80100f3d:	89 e5                	mov    %esp,%ebp
80100f3f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f42:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f49:	e8 f5 3c 00 00       	call   80104c43 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f4e:	c7 45 f4 94 de 10 80 	movl   $0x8010de94,-0xc(%ebp)
80100f55:	eb 29                	jmp    80100f80 <filealloc+0x44>
    if(f->ref == 0){
80100f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f5a:	8b 40 04             	mov    0x4(%eax),%eax
80100f5d:	85 c0                	test   %eax,%eax
80100f5f:	75 1b                	jne    80100f7c <filealloc+0x40>
      f->ref = 1;
80100f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f64:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f6b:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f72:	e8 2e 3d 00 00       	call   80104ca5 <release>
      return f;
80100f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f7a:	eb 1e                	jmp    80100f9a <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f7c:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f80:	81 7d f4 f4 e7 10 80 	cmpl   $0x8010e7f4,-0xc(%ebp)
80100f87:	72 ce                	jb     80100f57 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f89:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f90:	e8 10 3d 00 00       	call   80104ca5 <release>
  return 0;
80100f95:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f9a:	c9                   	leave  
80100f9b:	c3                   	ret    

80100f9c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f9c:	55                   	push   %ebp
80100f9d:	89 e5                	mov    %esp,%ebp
80100f9f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100fa2:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fa9:	e8 95 3c 00 00       	call   80104c43 <acquire>
  if(f->ref < 1)
80100fae:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb1:	8b 40 04             	mov    0x4(%eax),%eax
80100fb4:	85 c0                	test   %eax,%eax
80100fb6:	7f 0c                	jg     80100fc4 <filedup+0x28>
    panic("filedup");
80100fb8:	c7 04 24 a0 84 10 80 	movl   $0x801084a0,(%esp)
80100fbf:	e8 82 f5 ff ff       	call   80100546 <panic>
  f->ref++;
80100fc4:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc7:	8b 40 04             	mov    0x4(%eax),%eax
80100fca:	8d 50 01             	lea    0x1(%eax),%edx
80100fcd:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd0:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fd3:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fda:	e8 c6 3c 00 00       	call   80104ca5 <release>
  return f;
80100fdf:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fe2:	c9                   	leave  
80100fe3:	c3                   	ret    

80100fe4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fe4:	55                   	push   %ebp
80100fe5:	89 e5                	mov    %esp,%ebp
80100fe7:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fea:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100ff1:	e8 4d 3c 00 00       	call   80104c43 <acquire>
  if(f->ref < 1)
80100ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff9:	8b 40 04             	mov    0x4(%eax),%eax
80100ffc:	85 c0                	test   %eax,%eax
80100ffe:	7f 0c                	jg     8010100c <fileclose+0x28>
    panic("fileclose");
80101000:	c7 04 24 a8 84 10 80 	movl   $0x801084a8,(%esp)
80101007:	e8 3a f5 ff ff       	call   80100546 <panic>
  if(--f->ref > 0){
8010100c:	8b 45 08             	mov    0x8(%ebp),%eax
8010100f:	8b 40 04             	mov    0x4(%eax),%eax
80101012:	8d 50 ff             	lea    -0x1(%eax),%edx
80101015:	8b 45 08             	mov    0x8(%ebp),%eax
80101018:	89 50 04             	mov    %edx,0x4(%eax)
8010101b:	8b 45 08             	mov    0x8(%ebp),%eax
8010101e:	8b 40 04             	mov    0x4(%eax),%eax
80101021:	85 c0                	test   %eax,%eax
80101023:	7e 11                	jle    80101036 <fileclose+0x52>
    release(&ftable.lock);
80101025:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
8010102c:	e8 74 3c 00 00       	call   80104ca5 <release>
80101031:	e9 82 00 00 00       	jmp    801010b8 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101036:	8b 45 08             	mov    0x8(%ebp),%eax
80101039:	8b 10                	mov    (%eax),%edx
8010103b:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010103e:	8b 50 04             	mov    0x4(%eax),%edx
80101041:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101044:	8b 50 08             	mov    0x8(%eax),%edx
80101047:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010104a:	8b 50 0c             	mov    0xc(%eax),%edx
8010104d:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101050:	8b 50 10             	mov    0x10(%eax),%edx
80101053:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101056:	8b 40 14             	mov    0x14(%eax),%eax
80101059:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010105c:	8b 45 08             	mov    0x8(%ebp),%eax
8010105f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101066:	8b 45 08             	mov    0x8(%ebp),%eax
80101069:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010106f:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101076:	e8 2a 3c 00 00       	call   80104ca5 <release>
  
  if(ff.type == FD_PIPE)
8010107b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010107e:	83 f8 01             	cmp    $0x1,%eax
80101081:	75 18                	jne    8010109b <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101083:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101087:	0f be d0             	movsbl %al,%edx
8010108a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010108d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101091:	89 04 24             	mov    %eax,(%esp)
80101094:	e8 12 2e 00 00       	call   80103eab <pipeclose>
80101099:	eb 1d                	jmp    801010b8 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
8010109b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010109e:	83 f8 02             	cmp    $0x2,%eax
801010a1:	75 15                	jne    801010b8 <fileclose+0xd4>
    begin_trans();
801010a3:	e8 07 23 00 00       	call   801033af <begin_trans>
    iput(ff.ip);
801010a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010ab:	89 04 24             	mov    %eax,(%esp)
801010ae:	e8 8c 09 00 00       	call   80101a3f <iput>
    commit_trans();
801010b3:	e8 40 23 00 00       	call   801033f8 <commit_trans>
  }
}
801010b8:	c9                   	leave  
801010b9:	c3                   	ret    

801010ba <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010ba:	55                   	push   %ebp
801010bb:	89 e5                	mov    %esp,%ebp
801010bd:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010c0:	8b 45 08             	mov    0x8(%ebp),%eax
801010c3:	8b 00                	mov    (%eax),%eax
801010c5:	83 f8 02             	cmp    $0x2,%eax
801010c8:	75 38                	jne    80101102 <filestat+0x48>
    ilock(f->ip);
801010ca:	8b 45 08             	mov    0x8(%ebp),%eax
801010cd:	8b 40 10             	mov    0x10(%eax),%eax
801010d0:	89 04 24             	mov    %eax,(%esp)
801010d3:	e8 b4 07 00 00       	call   8010188c <ilock>
    stati(f->ip, st);
801010d8:	8b 45 08             	mov    0x8(%ebp),%eax
801010db:	8b 40 10             	mov    0x10(%eax),%eax
801010de:	8b 55 0c             	mov    0xc(%ebp),%edx
801010e1:	89 54 24 04          	mov    %edx,0x4(%esp)
801010e5:	89 04 24             	mov    %eax,(%esp)
801010e8:	e8 a4 0d 00 00       	call   80101e91 <stati>
    iunlock(f->ip);
801010ed:	8b 45 08             	mov    0x8(%ebp),%eax
801010f0:	8b 40 10             	mov    0x10(%eax),%eax
801010f3:	89 04 24             	mov    %eax,(%esp)
801010f6:	e8 df 08 00 00       	call   801019da <iunlock>
    return 0;
801010fb:	b8 00 00 00 00       	mov    $0x0,%eax
80101100:	eb 05                	jmp    80101107 <filestat+0x4d>
  }
  return -1;
80101102:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101107:	c9                   	leave  
80101108:	c3                   	ret    

80101109 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101109:	55                   	push   %ebp
8010110a:	89 e5                	mov    %esp,%ebp
8010110c:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010110f:	8b 45 08             	mov    0x8(%ebp),%eax
80101112:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101116:	84 c0                	test   %al,%al
80101118:	75 0a                	jne    80101124 <fileread+0x1b>
    return -1;
8010111a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010111f:	e9 9f 00 00 00       	jmp    801011c3 <fileread+0xba>
  if(f->type == FD_PIPE)
80101124:	8b 45 08             	mov    0x8(%ebp),%eax
80101127:	8b 00                	mov    (%eax),%eax
80101129:	83 f8 01             	cmp    $0x1,%eax
8010112c:	75 1e                	jne    8010114c <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010112e:	8b 45 08             	mov    0x8(%ebp),%eax
80101131:	8b 40 0c             	mov    0xc(%eax),%eax
80101134:	8b 55 10             	mov    0x10(%ebp),%edx
80101137:	89 54 24 08          	mov    %edx,0x8(%esp)
8010113b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010113e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101142:	89 04 24             	mov    %eax,(%esp)
80101145:	e8 e5 2e 00 00       	call   8010402f <piperead>
8010114a:	eb 77                	jmp    801011c3 <fileread+0xba>
  if(f->type == FD_INODE){
8010114c:	8b 45 08             	mov    0x8(%ebp),%eax
8010114f:	8b 00                	mov    (%eax),%eax
80101151:	83 f8 02             	cmp    $0x2,%eax
80101154:	75 61                	jne    801011b7 <fileread+0xae>
    ilock(f->ip);
80101156:	8b 45 08             	mov    0x8(%ebp),%eax
80101159:	8b 40 10             	mov    0x10(%eax),%eax
8010115c:	89 04 24             	mov    %eax,(%esp)
8010115f:	e8 28 07 00 00       	call   8010188c <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101164:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101167:	8b 45 08             	mov    0x8(%ebp),%eax
8010116a:	8b 50 14             	mov    0x14(%eax),%edx
8010116d:	8b 45 08             	mov    0x8(%ebp),%eax
80101170:	8b 40 10             	mov    0x10(%eax),%eax
80101173:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101177:	89 54 24 08          	mov    %edx,0x8(%esp)
8010117b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010117e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101182:	89 04 24             	mov    %eax,(%esp)
80101185:	e8 4c 0d 00 00       	call   80101ed6 <readi>
8010118a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010118d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101191:	7e 11                	jle    801011a4 <fileread+0x9b>
      f->off += r;
80101193:	8b 45 08             	mov    0x8(%ebp),%eax
80101196:	8b 50 14             	mov    0x14(%eax),%edx
80101199:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010119c:	01 c2                	add    %eax,%edx
8010119e:	8b 45 08             	mov    0x8(%ebp),%eax
801011a1:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011a4:	8b 45 08             	mov    0x8(%ebp),%eax
801011a7:	8b 40 10             	mov    0x10(%eax),%eax
801011aa:	89 04 24             	mov    %eax,(%esp)
801011ad:	e8 28 08 00 00       	call   801019da <iunlock>
    return r;
801011b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011b5:	eb 0c                	jmp    801011c3 <fileread+0xba>
  }
  panic("fileread");
801011b7:	c7 04 24 b2 84 10 80 	movl   $0x801084b2,(%esp)
801011be:	e8 83 f3 ff ff       	call   80100546 <panic>
}
801011c3:	c9                   	leave  
801011c4:	c3                   	ret    

801011c5 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011c5:	55                   	push   %ebp
801011c6:	89 e5                	mov    %esp,%ebp
801011c8:	53                   	push   %ebx
801011c9:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011cc:	8b 45 08             	mov    0x8(%ebp),%eax
801011cf:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011d3:	84 c0                	test   %al,%al
801011d5:	75 0a                	jne    801011e1 <filewrite+0x1c>
    return -1;
801011d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011dc:	e9 23 01 00 00       	jmp    80101304 <filewrite+0x13f>
  if(f->type == FD_PIPE)
801011e1:	8b 45 08             	mov    0x8(%ebp),%eax
801011e4:	8b 00                	mov    (%eax),%eax
801011e6:	83 f8 01             	cmp    $0x1,%eax
801011e9:	75 21                	jne    8010120c <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011eb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ee:	8b 40 0c             	mov    0xc(%eax),%eax
801011f1:	8b 55 10             	mov    0x10(%ebp),%edx
801011f4:	89 54 24 08          	mov    %edx,0x8(%esp)
801011f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801011fb:	89 54 24 04          	mov    %edx,0x4(%esp)
801011ff:	89 04 24             	mov    %eax,(%esp)
80101202:	e8 36 2d 00 00       	call   80103f3d <pipewrite>
80101207:	e9 f8 00 00 00       	jmp    80101304 <filewrite+0x13f>
  if(f->type == FD_INODE){
8010120c:	8b 45 08             	mov    0x8(%ebp),%eax
8010120f:	8b 00                	mov    (%eax),%eax
80101211:	83 f8 02             	cmp    $0x2,%eax
80101214:	0f 85 de 00 00 00    	jne    801012f8 <filewrite+0x133>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010121a:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101221:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101228:	e9 a8 00 00 00       	jmp    801012d5 <filewrite+0x110>
      int n1 = n - i;
8010122d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101230:	8b 55 10             	mov    0x10(%ebp),%edx
80101233:	89 d1                	mov    %edx,%ecx
80101235:	29 c1                	sub    %eax,%ecx
80101237:	89 c8                	mov    %ecx,%eax
80101239:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010123c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010123f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101242:	7e 06                	jle    8010124a <filewrite+0x85>
        n1 = max;
80101244:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101247:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
8010124a:	e8 60 21 00 00       	call   801033af <begin_trans>
      ilock(f->ip);
8010124f:	8b 45 08             	mov    0x8(%ebp),%eax
80101252:	8b 40 10             	mov    0x10(%eax),%eax
80101255:	89 04 24             	mov    %eax,(%esp)
80101258:	e8 2f 06 00 00       	call   8010188c <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010125d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101260:	8b 45 08             	mov    0x8(%ebp),%eax
80101263:	8b 50 14             	mov    0x14(%eax),%edx
80101266:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101269:	8b 45 0c             	mov    0xc(%ebp),%eax
8010126c:	01 c3                	add    %eax,%ebx
8010126e:	8b 45 08             	mov    0x8(%ebp),%eax
80101271:	8b 40 10             	mov    0x10(%eax),%eax
80101274:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101278:	89 54 24 08          	mov    %edx,0x8(%esp)
8010127c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101280:	89 04 24             	mov    %eax,(%esp)
80101283:	e8 bc 0d 00 00       	call   80102044 <writei>
80101288:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010128b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010128f:	7e 11                	jle    801012a2 <filewrite+0xdd>
        f->off += r;
80101291:	8b 45 08             	mov    0x8(%ebp),%eax
80101294:	8b 50 14             	mov    0x14(%eax),%edx
80101297:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010129a:	01 c2                	add    %eax,%edx
8010129c:	8b 45 08             	mov    0x8(%ebp),%eax
8010129f:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012a2:	8b 45 08             	mov    0x8(%ebp),%eax
801012a5:	8b 40 10             	mov    0x10(%eax),%eax
801012a8:	89 04 24             	mov    %eax,(%esp)
801012ab:	e8 2a 07 00 00       	call   801019da <iunlock>
      commit_trans();
801012b0:	e8 43 21 00 00       	call   801033f8 <commit_trans>

      if(r < 0)
801012b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012b9:	78 28                	js     801012e3 <filewrite+0x11e>
        break;
      if(r != n1)
801012bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012c1:	74 0c                	je     801012cf <filewrite+0x10a>
        panic("short filewrite");
801012c3:	c7 04 24 bb 84 10 80 	movl   $0x801084bb,(%esp)
801012ca:	e8 77 f2 ff ff       	call   80100546 <panic>
      i += r;
801012cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012d2:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012d8:	3b 45 10             	cmp    0x10(%ebp),%eax
801012db:	0f 8c 4c ff ff ff    	jl     8010122d <filewrite+0x68>
801012e1:	eb 01                	jmp    801012e4 <filewrite+0x11f>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
801012e3:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012e7:	3b 45 10             	cmp    0x10(%ebp),%eax
801012ea:	75 05                	jne    801012f1 <filewrite+0x12c>
801012ec:	8b 45 10             	mov    0x10(%ebp),%eax
801012ef:	eb 05                	jmp    801012f6 <filewrite+0x131>
801012f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012f6:	eb 0c                	jmp    80101304 <filewrite+0x13f>
  }
  panic("filewrite");
801012f8:	c7 04 24 cb 84 10 80 	movl   $0x801084cb,(%esp)
801012ff:	e8 42 f2 ff ff       	call   80100546 <panic>
}
80101304:	83 c4 24             	add    $0x24,%esp
80101307:	5b                   	pop    %ebx
80101308:	5d                   	pop    %ebp
80101309:	c3                   	ret    
8010130a:	66 90                	xchg   %ax,%ax

8010130c <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010130c:	55                   	push   %ebp
8010130d:	89 e5                	mov    %esp,%ebp
8010130f:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101312:	8b 45 08             	mov    0x8(%ebp),%eax
80101315:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010131c:	00 
8010131d:	89 04 24             	mov    %eax,(%esp)
80101320:	e8 81 ee ff ff       	call   801001a6 <bread>
80101325:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010132b:	83 c0 18             	add    $0x18,%eax
8010132e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101335:	00 
80101336:	89 44 24 04          	mov    %eax,0x4(%esp)
8010133a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010133d:	89 04 24             	mov    %eax,(%esp)
80101340:	e8 2c 3c 00 00       	call   80104f71 <memmove>
  brelse(bp);
80101345:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101348:	89 04 24             	mov    %eax,(%esp)
8010134b:	e8 c7 ee ff ff       	call   80100217 <brelse>
}
80101350:	c9                   	leave  
80101351:	c3                   	ret    

80101352 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101352:	55                   	push   %ebp
80101353:	89 e5                	mov    %esp,%ebp
80101355:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101358:	8b 55 0c             	mov    0xc(%ebp),%edx
8010135b:	8b 45 08             	mov    0x8(%ebp),%eax
8010135e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101362:	89 04 24             	mov    %eax,(%esp)
80101365:	e8 3c ee ff ff       	call   801001a6 <bread>
8010136a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010136d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101370:	83 c0 18             	add    $0x18,%eax
80101373:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010137a:	00 
8010137b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101382:	00 
80101383:	89 04 24             	mov    %eax,(%esp)
80101386:	e8 13 3b 00 00       	call   80104e9e <memset>
  log_write(bp);
8010138b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010138e:	89 04 24             	mov    %eax,(%esp)
80101391:	e8 ba 20 00 00       	call   80103450 <log_write>
  brelse(bp);
80101396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101399:	89 04 24             	mov    %eax,(%esp)
8010139c:	e8 76 ee ff ff       	call   80100217 <brelse>
}
801013a1:	c9                   	leave  
801013a2:	c3                   	ret    

801013a3 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013a3:	55                   	push   %ebp
801013a4:	89 e5                	mov    %esp,%ebp
801013a6:	53                   	push   %ebx
801013a7:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013b1:	8b 45 08             	mov    0x8(%ebp),%eax
801013b4:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013b7:	89 54 24 04          	mov    %edx,0x4(%esp)
801013bb:	89 04 24             	mov    %eax,(%esp)
801013be:	e8 49 ff ff ff       	call   8010130c <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013ca:	e9 0d 01 00 00       	jmp    801014dc <balloc+0x139>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d2:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013d8:	85 c0                	test   %eax,%eax
801013da:	0f 48 c2             	cmovs  %edx,%eax
801013dd:	c1 f8 0c             	sar    $0xc,%eax
801013e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013e3:	c1 ea 03             	shr    $0x3,%edx
801013e6:	01 d0                	add    %edx,%eax
801013e8:	83 c0 03             	add    $0x3,%eax
801013eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801013ef:	8b 45 08             	mov    0x8(%ebp),%eax
801013f2:	89 04 24             	mov    %eax,(%esp)
801013f5:	e8 ac ed ff ff       	call   801001a6 <bread>
801013fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101404:	e9 a3 00 00 00       	jmp    801014ac <balloc+0x109>
      m = 1 << (bi % 8);
80101409:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010140c:	89 c2                	mov    %eax,%edx
8010140e:	c1 fa 1f             	sar    $0x1f,%edx
80101411:	c1 ea 1d             	shr    $0x1d,%edx
80101414:	01 d0                	add    %edx,%eax
80101416:	83 e0 07             	and    $0x7,%eax
80101419:	29 d0                	sub    %edx,%eax
8010141b:	ba 01 00 00 00       	mov    $0x1,%edx
80101420:	89 d3                	mov    %edx,%ebx
80101422:	89 c1                	mov    %eax,%ecx
80101424:	d3 e3                	shl    %cl,%ebx
80101426:	89 d8                	mov    %ebx,%eax
80101428:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010142b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142e:	8d 50 07             	lea    0x7(%eax),%edx
80101431:	85 c0                	test   %eax,%eax
80101433:	0f 48 c2             	cmovs  %edx,%eax
80101436:	c1 f8 03             	sar    $0x3,%eax
80101439:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010143c:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101441:	0f b6 c0             	movzbl %al,%eax
80101444:	23 45 e8             	and    -0x18(%ebp),%eax
80101447:	85 c0                	test   %eax,%eax
80101449:	75 5d                	jne    801014a8 <balloc+0x105>
        bp->data[bi/8] |= m;  // Mark block in use.
8010144b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010144e:	8d 50 07             	lea    0x7(%eax),%edx
80101451:	85 c0                	test   %eax,%eax
80101453:	0f 48 c2             	cmovs  %edx,%eax
80101456:	c1 f8 03             	sar    $0x3,%eax
80101459:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010145c:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101461:	89 d1                	mov    %edx,%ecx
80101463:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101466:	09 ca                	or     %ecx,%edx
80101468:	89 d1                	mov    %edx,%ecx
8010146a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010146d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101471:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101474:	89 04 24             	mov    %eax,(%esp)
80101477:	e8 d4 1f 00 00       	call   80103450 <log_write>
        brelse(bp);
8010147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010147f:	89 04 24             	mov    %eax,(%esp)
80101482:	e8 90 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101487:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010148d:	01 c2                	add    %eax,%edx
8010148f:	8b 45 08             	mov    0x8(%ebp),%eax
80101492:	89 54 24 04          	mov    %edx,0x4(%esp)
80101496:	89 04 24             	mov    %eax,(%esp)
80101499:	e8 b4 fe ff ff       	call   80101352 <bzero>
        return b + bi;
8010149e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a4:	01 d0                	add    %edx,%eax
801014a6:	eb 4e                	jmp    801014f6 <balloc+0x153>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014a8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014ac:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014b3:	7f 15                	jg     801014ca <balloc+0x127>
801014b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014bb:	01 d0                	add    %edx,%eax
801014bd:	89 c2                	mov    %eax,%edx
801014bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014c2:	39 c2                	cmp    %eax,%edx
801014c4:	0f 82 3f ff ff ff    	jb     80101409 <balloc+0x66>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014cd:	89 04 24             	mov    %eax,(%esp)
801014d0:	e8 42 ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014d5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014df:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014e2:	39 c2                	cmp    %eax,%edx
801014e4:	0f 82 e5 fe ff ff    	jb     801013cf <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014ea:	c7 04 24 d5 84 10 80 	movl   $0x801084d5,(%esp)
801014f1:	e8 50 f0 ff ff       	call   80100546 <panic>
}
801014f6:	83 c4 34             	add    $0x34,%esp
801014f9:	5b                   	pop    %ebx
801014fa:	5d                   	pop    %ebp
801014fb:	c3                   	ret    

801014fc <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014fc:	55                   	push   %ebp
801014fd:	89 e5                	mov    %esp,%ebp
801014ff:	53                   	push   %ebx
80101500:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101503:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101506:	89 44 24 04          	mov    %eax,0x4(%esp)
8010150a:	8b 45 08             	mov    0x8(%ebp),%eax
8010150d:	89 04 24             	mov    %eax,(%esp)
80101510:	e8 f7 fd ff ff       	call   8010130c <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101515:	8b 45 0c             	mov    0xc(%ebp),%eax
80101518:	89 c2                	mov    %eax,%edx
8010151a:	c1 ea 0c             	shr    $0xc,%edx
8010151d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101520:	c1 e8 03             	shr    $0x3,%eax
80101523:	01 d0                	add    %edx,%eax
80101525:	8d 50 03             	lea    0x3(%eax),%edx
80101528:	8b 45 08             	mov    0x8(%ebp),%eax
8010152b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010152f:	89 04 24             	mov    %eax,(%esp)
80101532:	e8 6f ec ff ff       	call   801001a6 <bread>
80101537:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010153a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010153d:	25 ff 0f 00 00       	and    $0xfff,%eax
80101542:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101545:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101548:	89 c2                	mov    %eax,%edx
8010154a:	c1 fa 1f             	sar    $0x1f,%edx
8010154d:	c1 ea 1d             	shr    $0x1d,%edx
80101550:	01 d0                	add    %edx,%eax
80101552:	83 e0 07             	and    $0x7,%eax
80101555:	29 d0                	sub    %edx,%eax
80101557:	ba 01 00 00 00       	mov    $0x1,%edx
8010155c:	89 d3                	mov    %edx,%ebx
8010155e:	89 c1                	mov    %eax,%ecx
80101560:	d3 e3                	shl    %cl,%ebx
80101562:	89 d8                	mov    %ebx,%eax
80101564:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101567:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156a:	8d 50 07             	lea    0x7(%eax),%edx
8010156d:	85 c0                	test   %eax,%eax
8010156f:	0f 48 c2             	cmovs  %edx,%eax
80101572:	c1 f8 03             	sar    $0x3,%eax
80101575:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101578:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010157d:	0f b6 c0             	movzbl %al,%eax
80101580:	23 45 ec             	and    -0x14(%ebp),%eax
80101583:	85 c0                	test   %eax,%eax
80101585:	75 0c                	jne    80101593 <bfree+0x97>
    panic("freeing free block");
80101587:	c7 04 24 eb 84 10 80 	movl   $0x801084eb,(%esp)
8010158e:	e8 b3 ef ff ff       	call   80100546 <panic>
  bp->data[bi/8] &= ~m;
80101593:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101596:	8d 50 07             	lea    0x7(%eax),%edx
80101599:	85 c0                	test   %eax,%eax
8010159b:	0f 48 c2             	cmovs  %edx,%eax
8010159e:	c1 f8 03             	sar    $0x3,%eax
801015a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015a4:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015a9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015ac:	f7 d1                	not    %ecx
801015ae:	21 ca                	and    %ecx,%edx
801015b0:	89 d1                	mov    %edx,%ecx
801015b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015b5:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015bc:	89 04 24             	mov    %eax,(%esp)
801015bf:	e8 8c 1e 00 00       	call   80103450 <log_write>
  brelse(bp);
801015c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015c7:	89 04 24             	mov    %eax,(%esp)
801015ca:	e8 48 ec ff ff       	call   80100217 <brelse>
}
801015cf:	83 c4 34             	add    $0x34,%esp
801015d2:	5b                   	pop    %ebx
801015d3:	5d                   	pop    %ebp
801015d4:	c3                   	ret    

801015d5 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015d5:	55                   	push   %ebp
801015d6:	89 e5                	mov    %esp,%ebp
801015d8:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015db:	c7 44 24 04 fe 84 10 	movl   $0x801084fe,0x4(%esp)
801015e2:	80 
801015e3:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801015ea:	e8 33 36 00 00       	call   80104c22 <initlock>
}
801015ef:	c9                   	leave  
801015f0:	c3                   	ret    

801015f1 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015f1:	55                   	push   %ebp
801015f2:	89 e5                	mov    %esp,%ebp
801015f4:	83 ec 48             	sub    $0x48,%esp
801015f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801015fa:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101601:	8d 55 dc             	lea    -0x24(%ebp),%edx
80101604:	89 54 24 04          	mov    %edx,0x4(%esp)
80101608:	89 04 24             	mov    %eax,(%esp)
8010160b:	e8 fc fc ff ff       	call   8010130c <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
80101610:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101617:	e9 98 00 00 00       	jmp    801016b4 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
8010161c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010161f:	c1 e8 03             	shr    $0x3,%eax
80101622:	83 c0 02             	add    $0x2,%eax
80101625:	89 44 24 04          	mov    %eax,0x4(%esp)
80101629:	8b 45 08             	mov    0x8(%ebp),%eax
8010162c:	89 04 24             	mov    %eax,(%esp)
8010162f:	e8 72 eb ff ff       	call   801001a6 <bread>
80101634:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101637:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010163a:	8d 50 18             	lea    0x18(%eax),%edx
8010163d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101640:	83 e0 07             	and    $0x7,%eax
80101643:	c1 e0 06             	shl    $0x6,%eax
80101646:	01 d0                	add    %edx,%eax
80101648:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010164b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010164e:	0f b7 00             	movzwl (%eax),%eax
80101651:	66 85 c0             	test   %ax,%ax
80101654:	75 4f                	jne    801016a5 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101656:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010165d:	00 
8010165e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101665:	00 
80101666:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101669:	89 04 24             	mov    %eax,(%esp)
8010166c:	e8 2d 38 00 00       	call   80104e9e <memset>
      dip->type = type;
80101671:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101674:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101678:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010167b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010167e:	89 04 24             	mov    %eax,(%esp)
80101681:	e8 ca 1d 00 00       	call   80103450 <log_write>
      brelse(bp);
80101686:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101689:	89 04 24             	mov    %eax,(%esp)
8010168c:	e8 86 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
80101691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101694:	89 44 24 04          	mov    %eax,0x4(%esp)
80101698:	8b 45 08             	mov    0x8(%ebp),%eax
8010169b:	89 04 24             	mov    %eax,(%esp)
8010169e:	e8 e5 00 00 00       	call   80101788 <iget>
801016a3:	eb 29                	jmp    801016ce <ialloc+0xdd>
    }
    brelse(bp);
801016a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a8:	89 04 24             	mov    %eax,(%esp)
801016ab:	e8 67 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016ba:	39 c2                	cmp    %eax,%edx
801016bc:	0f 82 5a ff ff ff    	jb     8010161c <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016c2:	c7 04 24 05 85 10 80 	movl   $0x80108505,(%esp)
801016c9:	e8 78 ee ff ff       	call   80100546 <panic>
}
801016ce:	c9                   	leave  
801016cf:	c3                   	ret    

801016d0 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016d6:	8b 45 08             	mov    0x8(%ebp),%eax
801016d9:	8b 40 04             	mov    0x4(%eax),%eax
801016dc:	c1 e8 03             	shr    $0x3,%eax
801016df:	8d 50 02             	lea    0x2(%eax),%edx
801016e2:	8b 45 08             	mov    0x8(%ebp),%eax
801016e5:	8b 00                	mov    (%eax),%eax
801016e7:	89 54 24 04          	mov    %edx,0x4(%esp)
801016eb:	89 04 24             	mov    %eax,(%esp)
801016ee:	e8 b3 ea ff ff       	call   801001a6 <bread>
801016f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016f9:	8d 50 18             	lea    0x18(%eax),%edx
801016fc:	8b 45 08             	mov    0x8(%ebp),%eax
801016ff:	8b 40 04             	mov    0x4(%eax),%eax
80101702:	83 e0 07             	and    $0x7,%eax
80101705:	c1 e0 06             	shl    $0x6,%eax
80101708:	01 d0                	add    %edx,%eax
8010170a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010170d:	8b 45 08             	mov    0x8(%ebp),%eax
80101710:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101714:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101717:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010171a:	8b 45 08             	mov    0x8(%ebp),%eax
8010171d:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101721:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101724:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101728:	8b 45 08             	mov    0x8(%ebp),%eax
8010172b:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010172f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101732:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101736:	8b 45 08             	mov    0x8(%ebp),%eax
80101739:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010173d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101740:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101744:	8b 45 08             	mov    0x8(%ebp),%eax
80101747:	8b 50 18             	mov    0x18(%eax),%edx
8010174a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010174d:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101750:	8b 45 08             	mov    0x8(%ebp),%eax
80101753:	8d 50 1c             	lea    0x1c(%eax),%edx
80101756:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101759:	83 c0 0c             	add    $0xc,%eax
8010175c:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101763:	00 
80101764:	89 54 24 04          	mov    %edx,0x4(%esp)
80101768:	89 04 24             	mov    %eax,(%esp)
8010176b:	e8 01 38 00 00       	call   80104f71 <memmove>
  log_write(bp);
80101770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101773:	89 04 24             	mov    %eax,(%esp)
80101776:	e8 d5 1c 00 00       	call   80103450 <log_write>
  brelse(bp);
8010177b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177e:	89 04 24             	mov    %eax,(%esp)
80101781:	e8 91 ea ff ff       	call   80100217 <brelse>
}
80101786:	c9                   	leave  
80101787:	c3                   	ret    

80101788 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101788:	55                   	push   %ebp
80101789:	89 e5                	mov    %esp,%ebp
8010178b:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010178e:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101795:	e8 a9 34 00 00       	call   80104c43 <acquire>

  // Is the inode already cached?
  empty = 0;
8010179a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017a1:	c7 45 f4 94 e8 10 80 	movl   $0x8010e894,-0xc(%ebp)
801017a8:	eb 59                	jmp    80101803 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ad:	8b 40 08             	mov    0x8(%eax),%eax
801017b0:	85 c0                	test   %eax,%eax
801017b2:	7e 35                	jle    801017e9 <iget+0x61>
801017b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b7:	8b 00                	mov    (%eax),%eax
801017b9:	3b 45 08             	cmp    0x8(%ebp),%eax
801017bc:	75 2b                	jne    801017e9 <iget+0x61>
801017be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c1:	8b 40 04             	mov    0x4(%eax),%eax
801017c4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017c7:	75 20                	jne    801017e9 <iget+0x61>
      ip->ref++;
801017c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017cc:	8b 40 08             	mov    0x8(%eax),%eax
801017cf:	8d 50 01             	lea    0x1(%eax),%edx
801017d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d5:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017d8:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801017df:	e8 c1 34 00 00       	call   80104ca5 <release>
      return ip;
801017e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e7:	eb 6f                	jmp    80101858 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017ed:	75 10                	jne    801017ff <iget+0x77>
801017ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f2:	8b 40 08             	mov    0x8(%eax),%eax
801017f5:	85 c0                	test   %eax,%eax
801017f7:	75 06                	jne    801017ff <iget+0x77>
      empty = ip;
801017f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017ff:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101803:	81 7d f4 34 f8 10 80 	cmpl   $0x8010f834,-0xc(%ebp)
8010180a:	72 9e                	jb     801017aa <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010180c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101810:	75 0c                	jne    8010181e <iget+0x96>
    panic("iget: no inodes");
80101812:	c7 04 24 17 85 10 80 	movl   $0x80108517,(%esp)
80101819:	e8 28 ed ff ff       	call   80100546 <panic>

  ip = empty;
8010181e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101821:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101824:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101827:	8b 55 08             	mov    0x8(%ebp),%edx
8010182a:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010182c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101832:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101838:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010183f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101842:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101849:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101850:	e8 50 34 00 00       	call   80104ca5 <release>

  return ip;
80101855:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101858:	c9                   	leave  
80101859:	c3                   	ret    

8010185a <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010185a:	55                   	push   %ebp
8010185b:	89 e5                	mov    %esp,%ebp
8010185d:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101860:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101867:	e8 d7 33 00 00       	call   80104c43 <acquire>
  ip->ref++;
8010186c:	8b 45 08             	mov    0x8(%ebp),%eax
8010186f:	8b 40 08             	mov    0x8(%eax),%eax
80101872:	8d 50 01             	lea    0x1(%eax),%edx
80101875:	8b 45 08             	mov    0x8(%ebp),%eax
80101878:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010187b:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101882:	e8 1e 34 00 00       	call   80104ca5 <release>
  return ip;
80101887:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010188a:	c9                   	leave  
8010188b:	c3                   	ret    

8010188c <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010188c:	55                   	push   %ebp
8010188d:	89 e5                	mov    %esp,%ebp
8010188f:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101892:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101896:	74 0a                	je     801018a2 <ilock+0x16>
80101898:	8b 45 08             	mov    0x8(%ebp),%eax
8010189b:	8b 40 08             	mov    0x8(%eax),%eax
8010189e:	85 c0                	test   %eax,%eax
801018a0:	7f 0c                	jg     801018ae <ilock+0x22>
    panic("ilock");
801018a2:	c7 04 24 27 85 10 80 	movl   $0x80108527,(%esp)
801018a9:	e8 98 ec ff ff       	call   80100546 <panic>

  acquire(&icache.lock);
801018ae:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801018b5:	e8 89 33 00 00       	call   80104c43 <acquire>
  while(ip->flags & I_BUSY)
801018ba:	eb 13                	jmp    801018cf <ilock+0x43>
    sleep(ip, &icache.lock);
801018bc:	c7 44 24 04 60 e8 10 	movl   $0x8010e860,0x4(%esp)
801018c3:	80 
801018c4:	8b 45 08             	mov    0x8(%ebp),%eax
801018c7:	89 04 24             	mov    %eax,(%esp)
801018ca:	e8 8f 30 00 00       	call   8010495e <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018cf:	8b 45 08             	mov    0x8(%ebp),%eax
801018d2:	8b 40 0c             	mov    0xc(%eax),%eax
801018d5:	83 e0 01             	and    $0x1,%eax
801018d8:	85 c0                	test   %eax,%eax
801018da:	75 e0                	jne    801018bc <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018dc:	8b 45 08             	mov    0x8(%ebp),%eax
801018df:	8b 40 0c             	mov    0xc(%eax),%eax
801018e2:	89 c2                	mov    %eax,%edx
801018e4:	83 ca 01             	or     $0x1,%edx
801018e7:	8b 45 08             	mov    0x8(%ebp),%eax
801018ea:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018ed:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801018f4:	e8 ac 33 00 00       	call   80104ca5 <release>

  if(!(ip->flags & I_VALID)){
801018f9:	8b 45 08             	mov    0x8(%ebp),%eax
801018fc:	8b 40 0c             	mov    0xc(%eax),%eax
801018ff:	83 e0 02             	and    $0x2,%eax
80101902:	85 c0                	test   %eax,%eax
80101904:	0f 85 ce 00 00 00    	jne    801019d8 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
8010190a:	8b 45 08             	mov    0x8(%ebp),%eax
8010190d:	8b 40 04             	mov    0x4(%eax),%eax
80101910:	c1 e8 03             	shr    $0x3,%eax
80101913:	8d 50 02             	lea    0x2(%eax),%edx
80101916:	8b 45 08             	mov    0x8(%ebp),%eax
80101919:	8b 00                	mov    (%eax),%eax
8010191b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010191f:	89 04 24             	mov    %eax,(%esp)
80101922:	e8 7f e8 ff ff       	call   801001a6 <bread>
80101927:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010192a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192d:	8d 50 18             	lea    0x18(%eax),%edx
80101930:	8b 45 08             	mov    0x8(%ebp),%eax
80101933:	8b 40 04             	mov    0x4(%eax),%eax
80101936:	83 e0 07             	and    $0x7,%eax
80101939:	c1 e0 06             	shl    $0x6,%eax
8010193c:	01 d0                	add    %edx,%eax
8010193e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101941:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101944:	0f b7 10             	movzwl (%eax),%edx
80101947:	8b 45 08             	mov    0x8(%ebp),%eax
8010194a:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010194e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101951:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101955:	8b 45 08             	mov    0x8(%ebp),%eax
80101958:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010195c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010195f:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101963:	8b 45 08             	mov    0x8(%ebp),%eax
80101966:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
8010196a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010196d:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101971:	8b 45 08             	mov    0x8(%ebp),%eax
80101974:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101978:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010197b:	8b 50 08             	mov    0x8(%eax),%edx
8010197e:	8b 45 08             	mov    0x8(%ebp),%eax
80101981:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101984:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101987:	8d 50 0c             	lea    0xc(%eax),%edx
8010198a:	8b 45 08             	mov    0x8(%ebp),%eax
8010198d:	83 c0 1c             	add    $0x1c,%eax
80101990:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101997:	00 
80101998:	89 54 24 04          	mov    %edx,0x4(%esp)
8010199c:	89 04 24             	mov    %eax,(%esp)
8010199f:	e8 cd 35 00 00       	call   80104f71 <memmove>
    brelse(bp);
801019a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a7:	89 04 24             	mov    %eax,(%esp)
801019aa:	e8 68 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
801019af:	8b 45 08             	mov    0x8(%ebp),%eax
801019b2:	8b 40 0c             	mov    0xc(%eax),%eax
801019b5:	89 c2                	mov    %eax,%edx
801019b7:	83 ca 02             	or     $0x2,%edx
801019ba:	8b 45 08             	mov    0x8(%ebp),%eax
801019bd:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019c0:	8b 45 08             	mov    0x8(%ebp),%eax
801019c3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019c7:	66 85 c0             	test   %ax,%ax
801019ca:	75 0c                	jne    801019d8 <ilock+0x14c>
      panic("ilock: no type");
801019cc:	c7 04 24 2d 85 10 80 	movl   $0x8010852d,(%esp)
801019d3:	e8 6e eb ff ff       	call   80100546 <panic>
  }
}
801019d8:	c9                   	leave  
801019d9:	c3                   	ret    

801019da <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019da:	55                   	push   %ebp
801019db:	89 e5                	mov    %esp,%ebp
801019dd:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019e4:	74 17                	je     801019fd <iunlock+0x23>
801019e6:	8b 45 08             	mov    0x8(%ebp),%eax
801019e9:	8b 40 0c             	mov    0xc(%eax),%eax
801019ec:	83 e0 01             	and    $0x1,%eax
801019ef:	85 c0                	test   %eax,%eax
801019f1:	74 0a                	je     801019fd <iunlock+0x23>
801019f3:	8b 45 08             	mov    0x8(%ebp),%eax
801019f6:	8b 40 08             	mov    0x8(%eax),%eax
801019f9:	85 c0                	test   %eax,%eax
801019fb:	7f 0c                	jg     80101a09 <iunlock+0x2f>
    panic("iunlock");
801019fd:	c7 04 24 3c 85 10 80 	movl   $0x8010853c,(%esp)
80101a04:	e8 3d eb ff ff       	call   80100546 <panic>

  acquire(&icache.lock);
80101a09:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a10:	e8 2e 32 00 00       	call   80104c43 <acquire>
  ip->flags &= ~I_BUSY;
80101a15:	8b 45 08             	mov    0x8(%ebp),%eax
80101a18:	8b 40 0c             	mov    0xc(%eax),%eax
80101a1b:	89 c2                	mov    %eax,%edx
80101a1d:	83 e2 fe             	and    $0xfffffffe,%edx
80101a20:	8b 45 08             	mov    0x8(%ebp),%eax
80101a23:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a26:	8b 45 08             	mov    0x8(%ebp),%eax
80101a29:	89 04 24             	mov    %eax,(%esp)
80101a2c:	e8 09 30 00 00       	call   80104a3a <wakeup>
  release(&icache.lock);
80101a31:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a38:	e8 68 32 00 00       	call   80104ca5 <release>
}
80101a3d:	c9                   	leave  
80101a3e:	c3                   	ret    

80101a3f <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a3f:	55                   	push   %ebp
80101a40:	89 e5                	mov    %esp,%ebp
80101a42:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a45:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a4c:	e8 f2 31 00 00       	call   80104c43 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
80101a54:	8b 40 08             	mov    0x8(%eax),%eax
80101a57:	83 f8 01             	cmp    $0x1,%eax
80101a5a:	0f 85 93 00 00 00    	jne    80101af3 <iput+0xb4>
80101a60:	8b 45 08             	mov    0x8(%ebp),%eax
80101a63:	8b 40 0c             	mov    0xc(%eax),%eax
80101a66:	83 e0 02             	and    $0x2,%eax
80101a69:	85 c0                	test   %eax,%eax
80101a6b:	0f 84 82 00 00 00    	je     80101af3 <iput+0xb4>
80101a71:	8b 45 08             	mov    0x8(%ebp),%eax
80101a74:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a78:	66 85 c0             	test   %ax,%ax
80101a7b:	75 76                	jne    80101af3 <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a80:	8b 40 0c             	mov    0xc(%eax),%eax
80101a83:	83 e0 01             	and    $0x1,%eax
80101a86:	85 c0                	test   %eax,%eax
80101a88:	74 0c                	je     80101a96 <iput+0x57>
      panic("iput busy");
80101a8a:	c7 04 24 44 85 10 80 	movl   $0x80108544,(%esp)
80101a91:	e8 b0 ea ff ff       	call   80100546 <panic>
    ip->flags |= I_BUSY;
80101a96:	8b 45 08             	mov    0x8(%ebp),%eax
80101a99:	8b 40 0c             	mov    0xc(%eax),%eax
80101a9c:	89 c2                	mov    %eax,%edx
80101a9e:	83 ca 01             	or     $0x1,%edx
80101aa1:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa4:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101aa7:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101aae:	e8 f2 31 00 00       	call   80104ca5 <release>
    itrunc(ip);
80101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab6:	89 04 24             	mov    %eax,(%esp)
80101ab9:	e8 ba 02 00 00       	call   80101d78 <itrunc>
    ip->type = 0;
80101abe:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac1:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101ac7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aca:	89 04 24             	mov    %eax,(%esp)
80101acd:	e8 fe fb ff ff       	call   801016d0 <iupdate>
    acquire(&icache.lock);
80101ad2:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101ad9:	e8 65 31 00 00       	call   80104c43 <acquire>
    ip->flags = 0;
80101ade:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aeb:	89 04 24             	mov    %eax,(%esp)
80101aee:	e8 47 2f 00 00       	call   80104a3a <wakeup>
  }
  ip->ref--;
80101af3:	8b 45 08             	mov    0x8(%ebp),%eax
80101af6:	8b 40 08             	mov    0x8(%eax),%eax
80101af9:	8d 50 ff             	lea    -0x1(%eax),%edx
80101afc:	8b 45 08             	mov    0x8(%ebp),%eax
80101aff:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b02:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101b09:	e8 97 31 00 00       	call   80104ca5 <release>
}
80101b0e:	c9                   	leave  
80101b0f:	c3                   	ret    

80101b10 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b16:	8b 45 08             	mov    0x8(%ebp),%eax
80101b19:	89 04 24             	mov    %eax,(%esp)
80101b1c:	e8 b9 fe ff ff       	call   801019da <iunlock>
  iput(ip);
80101b21:	8b 45 08             	mov    0x8(%ebp),%eax
80101b24:	89 04 24             	mov    %eax,(%esp)
80101b27:	e8 13 ff ff ff       	call   80101a3f <iput>
}
80101b2c:	c9                   	leave  
80101b2d:	c3                   	ret    

80101b2e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b2e:	55                   	push   %ebp
80101b2f:	89 e5                	mov    %esp,%ebp
80101b31:	53                   	push   %ebx
80101b32:	83 ec 34             	sub    $0x34,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b35:	83 7d 0c 0a          	cmpl   $0xa,0xc(%ebp)
80101b39:	77 3e                	ja     80101b79 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b41:	83 c2 04             	add    $0x4,%edx
80101b44:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b4f:	75 20                	jne    80101b71 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b51:	8b 45 08             	mov    0x8(%ebp),%eax
80101b54:	8b 00                	mov    (%eax),%eax
80101b56:	89 04 24             	mov    %eax,(%esp)
80101b59:	e8 45 f8 ff ff       	call   801013a3 <balloc>
80101b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b61:	8b 45 08             	mov    0x8(%ebp),%eax
80101b64:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b67:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b6d:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b74:	e9 f9 01 00 00       	jmp    80101d72 <bmap+0x244>
  }
  bn -= NDIRECT;
80101b79:	83 6d 0c 0b          	subl   $0xb,0xc(%ebp)

  if(bn < NINDIRECT){
80101b7d:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b81:	0f 87 a5 00 00 00    	ja     80101c2c <bmap+0xfe>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b87:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8a:	8b 40 48             	mov    0x48(%eax),%eax
80101b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b94:	75 19                	jne    80101baf <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b96:	8b 45 08             	mov    0x8(%ebp),%eax
80101b99:	8b 00                	mov    (%eax),%eax
80101b9b:	89 04 24             	mov    %eax,(%esp)
80101b9e:	e8 00 f8 ff ff       	call   801013a3 <balloc>
80101ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bac:	89 50 48             	mov    %edx,0x48(%eax)
    bp = bread(ip->dev, addr);
80101baf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb2:	8b 00                	mov    (%eax),%eax
80101bb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bb7:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bbb:	89 04 24             	mov    %eax,(%esp)
80101bbe:	e8 e3 e5 ff ff       	call   801001a6 <bread>
80101bc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bc9:	83 c0 18             	add    $0x18,%eax
80101bcc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bd2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bdc:	01 d0                	add    %edx,%eax
80101bde:	8b 00                	mov    (%eax),%eax
80101be0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101be3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101be7:	75 30                	jne    80101c19 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101be9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bf6:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfc:	8b 00                	mov    (%eax),%eax
80101bfe:	89 04 24             	mov    %eax,(%esp)
80101c01:	e8 9d f7 ff ff       	call   801013a3 <balloc>
80101c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c0c:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c11:	89 04 24             	mov    %eax,(%esp)
80101c14:	e8 37 18 00 00       	call   80103450 <log_write>
    }
    brelse(bp);
80101c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c1c:	89 04 24             	mov    %eax,(%esp)
80101c1f:	e8 f3 e5 ff ff       	call   80100217 <brelse>
    return addr;
80101c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c27:	e9 46 01 00 00       	jmp    80101d72 <bmap+0x244>
  }

  //doubly indirect adress
  bn -= NINDIRECT;
80101c2c:	83 45 0c 80          	addl   $0xffffff80,0xc(%ebp)

  if(bn < NINDIRECT * NINDIRECT){
80101c30:	81 7d 0c ff 3f 00 00 	cmpl   $0x3fff,0xc(%ebp)
80101c37:	0f 87 29 01 00 00    	ja     80101d66 <bmap+0x238>
    if((addr = ip->addrs[NDIRECT+1]) == 0)
80101c3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c40:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c4a:	75 19                	jne    80101c65 <bmap+0x137>
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
80101c4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4f:	8b 00                	mov    (%eax),%eax
80101c51:	89 04 24             	mov    %eax,(%esp)
80101c54:	e8 4a f7 ff ff       	call   801013a3 <balloc>
80101c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c62:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c65:	8b 45 08             	mov    0x8(%ebp),%eax
80101c68:	8b 00                	mov    (%eax),%eax
80101c6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c6d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c71:	89 04 24             	mov    %eax,(%esp)
80101c74:	e8 2d e5 ff ff       	call   801001a6 <bread>
80101c79:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*) bp->data;
80101c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c7f:	83 c0 18             	add    $0x18,%eax
80101c82:	89 45 ec             	mov    %eax,-0x14(%ebp)
    int idx = bn/NINDIRECT;
80101c85:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c88:	c1 e8 07             	shr    $0x7,%eax
80101c8b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if((addr = a[idx]) == 0){
80101c8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101c91:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c9b:	01 d0                	add    %edx,%eax
80101c9d:	8b 00                	mov    (%eax),%eax
80101c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ca6:	75 30                	jne    80101cd8 <bmap+0x1aa>
      a[idx] = addr = balloc(ip->dev);
80101ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cb5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101cb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbb:	8b 00                	mov    (%eax),%eax
80101cbd:	89 04 24             	mov    %eax,(%esp)
80101cc0:	e8 de f6 ff ff       	call   801013a3 <balloc>
80101cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ccb:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cd0:	89 04 24             	mov    %eax,(%esp)
80101cd3:	e8 78 17 00 00       	call   80103450 <log_write>
    }
    brelse(bp);
80101cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cdb:	89 04 24             	mov    %eax,(%esp)
80101cde:	e8 34 e5 ff ff       	call   80100217 <brelse>

    bp = bread(ip->dev, addr);
80101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce6:	8b 00                	mov    (%eax),%eax
80101ce8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ceb:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cef:	89 04 24             	mov    %eax,(%esp)
80101cf2:	e8 af e4 ff ff       	call   801001a6 <bread>
80101cf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cfd:	83 c0 18             	add    $0x18,%eax
80101d00:	89 45 ec             	mov    %eax,-0x14(%ebp)
    int jdx = bn%NINDIRECT;
80101d03:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d06:	83 e0 7f             	and    $0x7f,%eax
80101d09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((addr = a[jdx]) == 0){
80101d0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d16:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d19:	01 d0                	add    %edx,%eax
80101d1b:	8b 00                	mov    (%eax),%eax
80101d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d24:	75 30                	jne    80101d56 <bmap+0x228>
      a[jdx] = addr = balloc(ip->dev);
80101d26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d33:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d36:	8b 45 08             	mov    0x8(%ebp),%eax
80101d39:	8b 00                	mov    (%eax),%eax
80101d3b:	89 04 24             	mov    %eax,(%esp)
80101d3e:	e8 60 f6 ff ff       	call   801013a3 <balloc>
80101d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d49:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d4e:	89 04 24             	mov    %eax,(%esp)
80101d51:	e8 fa 16 00 00       	call   80103450 <log_write>
    }
    brelse(bp);
80101d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d59:	89 04 24             	mov    %eax,(%esp)
80101d5c:	e8 b6 e4 ff ff       	call   80100217 <brelse>
    return addr;
80101d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d64:	eb 0c                	jmp    80101d72 <bmap+0x244>
  }


  panic("bmap: out of range");
80101d66:	c7 04 24 4e 85 10 80 	movl   $0x8010854e,(%esp)
80101d6d:	e8 d4 e7 ff ff       	call   80100546 <panic>
}
80101d72:	83 c4 34             	add    $0x34,%esp
80101d75:	5b                   	pop    %ebx
80101d76:	5d                   	pop    %ebp
80101d77:	c3                   	ret    

80101d78 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d78:	55                   	push   %ebp
80101d79:	89 e5                	mov    %esp,%ebp
80101d7b:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d85:	eb 44                	jmp    80101dcb <itrunc+0x53>
    if(ip->addrs[i]){
80101d87:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d8d:	83 c2 04             	add    $0x4,%edx
80101d90:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d94:	85 c0                	test   %eax,%eax
80101d96:	74 2f                	je     80101dc7 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101d98:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d9e:	83 c2 04             	add    $0x4,%edx
80101da1:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101da5:	8b 45 08             	mov    0x8(%ebp),%eax
80101da8:	8b 00                	mov    (%eax),%eax
80101daa:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dae:	89 04 24             	mov    %eax,(%esp)
80101db1:	e8 46 f7 ff ff       	call   801014fc <bfree>
      ip->addrs[i] = 0;
80101db6:	8b 45 08             	mov    0x8(%ebp),%eax
80101db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dbc:	83 c2 04             	add    $0x4,%edx
80101dbf:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101dc6:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101dc7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101dcb:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80101dcf:	7e b6                	jle    80101d87 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd4:	8b 40 48             	mov    0x48(%eax),%eax
80101dd7:	85 c0                	test   %eax,%eax
80101dd9:	0f 84 9b 00 00 00    	je     80101e7a <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ddf:	8b 45 08             	mov    0x8(%ebp),%eax
80101de2:	8b 50 48             	mov    0x48(%eax),%edx
80101de5:	8b 45 08             	mov    0x8(%ebp),%eax
80101de8:	8b 00                	mov    (%eax),%eax
80101dea:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dee:	89 04 24             	mov    %eax,(%esp)
80101df1:	e8 b0 e3 ff ff       	call   801001a6 <bread>
80101df6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dfc:	83 c0 18             	add    $0x18,%eax
80101dff:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e09:	eb 3b                	jmp    80101e46 <itrunc+0xce>
      if(a[j])
80101e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e15:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e18:	01 d0                	add    %edx,%eax
80101e1a:	8b 00                	mov    (%eax),%eax
80101e1c:	85 c0                	test   %eax,%eax
80101e1e:	74 22                	je     80101e42 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e2d:	01 d0                	add    %edx,%eax
80101e2f:	8b 10                	mov    (%eax),%edx
80101e31:	8b 45 08             	mov    0x8(%ebp),%eax
80101e34:	8b 00                	mov    (%eax),%eax
80101e36:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e3a:	89 04 24             	mov    %eax,(%esp)
80101e3d:	e8 ba f6 ff ff       	call   801014fc <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101e42:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e49:	83 f8 7f             	cmp    $0x7f,%eax
80101e4c:	76 bd                	jbe    80101e0b <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101e4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e51:	89 04 24             	mov    %eax,(%esp)
80101e54:	e8 be e3 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e59:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5c:	8b 50 48             	mov    0x48(%eax),%edx
80101e5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e62:	8b 00                	mov    (%eax),%eax
80101e64:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e68:	89 04 24             	mov    %eax,(%esp)
80101e6b:	e8 8c f6 ff ff       	call   801014fc <bfree>
    ip->addrs[NDIRECT] = 0;
80101e70:	8b 45 08             	mov    0x8(%ebp),%eax
80101e73:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
  }

  ip->size = 0;
80101e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e84:	8b 45 08             	mov    0x8(%ebp),%eax
80101e87:	89 04 24             	mov    %eax,(%esp)
80101e8a:	e8 41 f8 ff ff       	call   801016d0 <iupdate>
}
80101e8f:	c9                   	leave  
80101e90:	c3                   	ret    

80101e91 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e91:	55                   	push   %ebp
80101e92:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e94:	8b 45 08             	mov    0x8(%ebp),%eax
80101e97:	8b 00                	mov    (%eax),%eax
80101e99:	89 c2                	mov    %eax,%edx
80101e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e9e:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea4:	8b 50 04             	mov    0x4(%eax),%edx
80101ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eaa:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101ead:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb0:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb7:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101eba:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebd:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec4:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	8b 50 18             	mov    0x18(%eax),%edx
80101ece:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed1:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    

80101ed6 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ed6:	55                   	push   %ebp
80101ed7:	89 e5                	mov    %esp,%ebp
80101ed9:	53                   	push   %ebx
80101eda:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101edd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ee4:	66 83 f8 03          	cmp    $0x3,%ax
80101ee8:	75 60                	jne    80101f4a <readi+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101eea:	8b 45 08             	mov    0x8(%ebp),%eax
80101eed:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ef1:	66 85 c0             	test   %ax,%ax
80101ef4:	78 20                	js     80101f16 <readi+0x40>
80101ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101efd:	66 83 f8 09          	cmp    $0x9,%ax
80101f01:	7f 13                	jg     80101f16 <readi+0x40>
80101f03:	8b 45 08             	mov    0x8(%ebp),%eax
80101f06:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f0a:	98                   	cwtl   
80101f0b:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101f12:	85 c0                	test   %eax,%eax
80101f14:	75 0a                	jne    80101f20 <readi+0x4a>
      return -1;
80101f16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f1b:	e9 1e 01 00 00       	jmp    8010203e <readi+0x168>
    return devsw[ip->major].read(ip, dst, n);
80101f20:	8b 45 08             	mov    0x8(%ebp),%eax
80101f23:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f27:	98                   	cwtl   
80101f28:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101f2f:	8b 55 14             	mov    0x14(%ebp),%edx
80101f32:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f36:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f39:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f3d:	8b 55 08             	mov    0x8(%ebp),%edx
80101f40:	89 14 24             	mov    %edx,(%esp)
80101f43:	ff d0                	call   *%eax
80101f45:	e9 f4 00 00 00       	jmp    8010203e <readi+0x168>
  }

  if(off > ip->size || off + n < off)
80101f4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4d:	8b 40 18             	mov    0x18(%eax),%eax
80101f50:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f53:	72 0d                	jb     80101f62 <readi+0x8c>
80101f55:	8b 45 14             	mov    0x14(%ebp),%eax
80101f58:	8b 55 10             	mov    0x10(%ebp),%edx
80101f5b:	01 d0                	add    %edx,%eax
80101f5d:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f60:	73 0a                	jae    80101f6c <readi+0x96>
    return -1;
80101f62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f67:	e9 d2 00 00 00       	jmp    8010203e <readi+0x168>
  if(off + n > ip->size)
80101f6c:	8b 45 14             	mov    0x14(%ebp),%eax
80101f6f:	8b 55 10             	mov    0x10(%ebp),%edx
80101f72:	01 c2                	add    %eax,%edx
80101f74:	8b 45 08             	mov    0x8(%ebp),%eax
80101f77:	8b 40 18             	mov    0x18(%eax),%eax
80101f7a:	39 c2                	cmp    %eax,%edx
80101f7c:	76 0c                	jbe    80101f8a <readi+0xb4>
    n = ip->size - off;
80101f7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f81:	8b 40 18             	mov    0x18(%eax),%eax
80101f84:	2b 45 10             	sub    0x10(%ebp),%eax
80101f87:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f91:	e9 99 00 00 00       	jmp    8010202f <readi+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f96:	8b 45 10             	mov    0x10(%ebp),%eax
80101f99:	c1 e8 09             	shr    $0x9,%eax
80101f9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fa0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa3:	89 04 24             	mov    %eax,(%esp)
80101fa6:	e8 83 fb ff ff       	call   80101b2e <bmap>
80101fab:	8b 55 08             	mov    0x8(%ebp),%edx
80101fae:	8b 12                	mov    (%edx),%edx
80101fb0:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fb4:	89 14 24             	mov    %edx,(%esp)
80101fb7:	e8 ea e1 ff ff       	call   801001a6 <bread>
80101fbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fbf:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc2:	89 c2                	mov    %eax,%edx
80101fc4:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101fca:	b8 00 02 00 00       	mov    $0x200,%eax
80101fcf:	89 c1                	mov    %eax,%ecx
80101fd1:	29 d1                	sub    %edx,%ecx
80101fd3:	89 ca                	mov    %ecx,%edx
80101fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fd8:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fdb:	89 cb                	mov    %ecx,%ebx
80101fdd:	29 c3                	sub    %eax,%ebx
80101fdf:	89 d8                	mov    %ebx,%eax
80101fe1:	39 c2                	cmp    %eax,%edx
80101fe3:	0f 46 c2             	cmovbe %edx,%eax
80101fe6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101fe9:	8b 45 10             	mov    0x10(%ebp),%eax
80101fec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ff1:	8d 50 10             	lea    0x10(%eax),%edx
80101ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff7:	01 d0                	add    %edx,%eax
80101ff9:	8d 50 08             	lea    0x8(%eax),%edx
80101ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fff:	89 44 24 08          	mov    %eax,0x8(%esp)
80102003:	89 54 24 04          	mov    %edx,0x4(%esp)
80102007:	8b 45 0c             	mov    0xc(%ebp),%eax
8010200a:	89 04 24             	mov    %eax,(%esp)
8010200d:	e8 5f 2f 00 00       	call   80104f71 <memmove>
    brelse(bp);
80102012:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102015:	89 04 24             	mov    %eax,(%esp)
80102018:	e8 fa e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010201d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102020:	01 45 f4             	add    %eax,-0xc(%ebp)
80102023:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102026:	01 45 10             	add    %eax,0x10(%ebp)
80102029:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010202c:	01 45 0c             	add    %eax,0xc(%ebp)
8010202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102032:	3b 45 14             	cmp    0x14(%ebp),%eax
80102035:	0f 82 5b ff ff ff    	jb     80101f96 <readi+0xc0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
8010203b:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010203e:	83 c4 24             	add    $0x24,%esp
80102041:	5b                   	pop    %ebx
80102042:	5d                   	pop    %ebp
80102043:	c3                   	ret    

80102044 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102044:	55                   	push   %ebp
80102045:	89 e5                	mov    %esp,%ebp
80102047:	53                   	push   %ebx
80102048:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010204b:	8b 45 08             	mov    0x8(%ebp),%eax
8010204e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102052:	66 83 f8 03          	cmp    $0x3,%ax
80102056:	75 60                	jne    801020b8 <writei+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102058:	8b 45 08             	mov    0x8(%ebp),%eax
8010205b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010205f:	66 85 c0             	test   %ax,%ax
80102062:	78 20                	js     80102084 <writei+0x40>
80102064:	8b 45 08             	mov    0x8(%ebp),%eax
80102067:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010206b:	66 83 f8 09          	cmp    $0x9,%ax
8010206f:	7f 13                	jg     80102084 <writei+0x40>
80102071:	8b 45 08             	mov    0x8(%ebp),%eax
80102074:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102078:	98                   	cwtl   
80102079:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80102080:	85 c0                	test   %eax,%eax
80102082:	75 0a                	jne    8010208e <writei+0x4a>
      return -1;
80102084:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102089:	e9 49 01 00 00       	jmp    801021d7 <writei+0x193>
    return devsw[ip->major].write(ip, src, n);
8010208e:	8b 45 08             	mov    0x8(%ebp),%eax
80102091:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102095:	98                   	cwtl   
80102096:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
8010209d:	8b 55 14             	mov    0x14(%ebp),%edx
801020a0:	89 54 24 08          	mov    %edx,0x8(%esp)
801020a4:	8b 55 0c             	mov    0xc(%ebp),%edx
801020a7:	89 54 24 04          	mov    %edx,0x4(%esp)
801020ab:	8b 55 08             	mov    0x8(%ebp),%edx
801020ae:	89 14 24             	mov    %edx,(%esp)
801020b1:	ff d0                	call   *%eax
801020b3:	e9 1f 01 00 00       	jmp    801021d7 <writei+0x193>
  }

  if(off > ip->size || off + n < off)
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	8b 40 18             	mov    0x18(%eax),%eax
801020be:	3b 45 10             	cmp    0x10(%ebp),%eax
801020c1:	72 0d                	jb     801020d0 <writei+0x8c>
801020c3:	8b 45 14             	mov    0x14(%ebp),%eax
801020c6:	8b 55 10             	mov    0x10(%ebp),%edx
801020c9:	01 d0                	add    %edx,%eax
801020cb:	3b 45 10             	cmp    0x10(%ebp),%eax
801020ce:	73 0a                	jae    801020da <writei+0x96>
    return -1;
801020d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d5:	e9 fd 00 00 00       	jmp    801021d7 <writei+0x193>
  if(off + n > MAXFILE*BSIZE)
801020da:	8b 45 14             	mov    0x14(%ebp),%eax
801020dd:	8b 55 10             	mov    0x10(%ebp),%edx
801020e0:	01 d0                	add    %edx,%eax
801020e2:	3d 00 16 81 00       	cmp    $0x811600,%eax
801020e7:	76 0a                	jbe    801020f3 <writei+0xaf>
    return -1;
801020e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020ee:	e9 e4 00 00 00       	jmp    801021d7 <writei+0x193>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020fa:	e9 a4 00 00 00       	jmp    801021a3 <writei+0x15f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020ff:	8b 45 10             	mov    0x10(%ebp),%eax
80102102:	c1 e8 09             	shr    $0x9,%eax
80102105:	89 44 24 04          	mov    %eax,0x4(%esp)
80102109:	8b 45 08             	mov    0x8(%ebp),%eax
8010210c:	89 04 24             	mov    %eax,(%esp)
8010210f:	e8 1a fa ff ff       	call   80101b2e <bmap>
80102114:	8b 55 08             	mov    0x8(%ebp),%edx
80102117:	8b 12                	mov    (%edx),%edx
80102119:	89 44 24 04          	mov    %eax,0x4(%esp)
8010211d:	89 14 24             	mov    %edx,(%esp)
80102120:	e8 81 e0 ff ff       	call   801001a6 <bread>
80102125:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102128:	8b 45 10             	mov    0x10(%ebp),%eax
8010212b:	89 c2                	mov    %eax,%edx
8010212d:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102133:	b8 00 02 00 00       	mov    $0x200,%eax
80102138:	89 c1                	mov    %eax,%ecx
8010213a:	29 d1                	sub    %edx,%ecx
8010213c:	89 ca                	mov    %ecx,%edx
8010213e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102141:	8b 4d 14             	mov    0x14(%ebp),%ecx
80102144:	89 cb                	mov    %ecx,%ebx
80102146:	29 c3                	sub    %eax,%ebx
80102148:	89 d8                	mov    %ebx,%eax
8010214a:	39 c2                	cmp    %eax,%edx
8010214c:	0f 46 c2             	cmovbe %edx,%eax
8010214f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102152:	8b 45 10             	mov    0x10(%ebp),%eax
80102155:	25 ff 01 00 00       	and    $0x1ff,%eax
8010215a:	8d 50 10             	lea    0x10(%eax),%edx
8010215d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102160:	01 d0                	add    %edx,%eax
80102162:	8d 50 08             	lea    0x8(%eax),%edx
80102165:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102168:	89 44 24 08          	mov    %eax,0x8(%esp)
8010216c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010216f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102173:	89 14 24             	mov    %edx,(%esp)
80102176:	e8 f6 2d 00 00       	call   80104f71 <memmove>
    log_write(bp);
8010217b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010217e:	89 04 24             	mov    %eax,(%esp)
80102181:	e8 ca 12 00 00       	call   80103450 <log_write>
    brelse(bp);
80102186:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102189:	89 04 24             	mov    %eax,(%esp)
8010218c:	e8 86 e0 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102191:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102194:	01 45 f4             	add    %eax,-0xc(%ebp)
80102197:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010219a:	01 45 10             	add    %eax,0x10(%ebp)
8010219d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021a0:	01 45 0c             	add    %eax,0xc(%ebp)
801021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021a6:	3b 45 14             	cmp    0x14(%ebp),%eax
801021a9:	0f 82 50 ff ff ff    	jb     801020ff <writei+0xbb>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801021af:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801021b3:	74 1f                	je     801021d4 <writei+0x190>
801021b5:	8b 45 08             	mov    0x8(%ebp),%eax
801021b8:	8b 40 18             	mov    0x18(%eax),%eax
801021bb:	3b 45 10             	cmp    0x10(%ebp),%eax
801021be:	73 14                	jae    801021d4 <writei+0x190>
    ip->size = off;
801021c0:	8b 45 08             	mov    0x8(%ebp),%eax
801021c3:	8b 55 10             	mov    0x10(%ebp),%edx
801021c6:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801021c9:	8b 45 08             	mov    0x8(%ebp),%eax
801021cc:	89 04 24             	mov    %eax,(%esp)
801021cf:	e8 fc f4 ff ff       	call   801016d0 <iupdate>
  }
  return n;
801021d4:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021d7:	83 c4 24             	add    $0x24,%esp
801021da:	5b                   	pop    %ebx
801021db:	5d                   	pop    %ebp
801021dc:	c3                   	ret    

801021dd <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021dd:	55                   	push   %ebp
801021de:	89 e5                	mov    %esp,%ebp
801021e0:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801021e3:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021ea:	00 
801021eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801021ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801021f2:	8b 45 08             	mov    0x8(%ebp),%eax
801021f5:	89 04 24             	mov    %eax,(%esp)
801021f8:	e8 18 2e 00 00       	call   80105015 <strncmp>
}
801021fd:	c9                   	leave  
801021fe:	c3                   	ret    

801021ff <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021ff:	55                   	push   %ebp
80102200:	89 e5                	mov    %esp,%ebp
80102202:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102205:	8b 45 08             	mov    0x8(%ebp),%eax
80102208:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010220c:	66 83 f8 01          	cmp    $0x1,%ax
80102210:	74 0c                	je     8010221e <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102212:	c7 04 24 61 85 10 80 	movl   $0x80108561,(%esp)
80102219:	e8 28 e3 ff ff       	call   80100546 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010221e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102225:	e9 87 00 00 00       	jmp    801022b1 <dirlookup+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010222a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102231:	00 
80102232:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102235:	89 44 24 08          	mov    %eax,0x8(%esp)
80102239:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010223c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102240:	8b 45 08             	mov    0x8(%ebp),%eax
80102243:	89 04 24             	mov    %eax,(%esp)
80102246:	e8 8b fc ff ff       	call   80101ed6 <readi>
8010224b:	83 f8 10             	cmp    $0x10,%eax
8010224e:	74 0c                	je     8010225c <dirlookup+0x5d>
      panic("dirlink read");
80102250:	c7 04 24 73 85 10 80 	movl   $0x80108573,(%esp)
80102257:	e8 ea e2 ff ff       	call   80100546 <panic>
    if(de.inum == 0)
8010225c:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102260:	66 85 c0             	test   %ax,%ax
80102263:	74 47                	je     801022ac <dirlookup+0xad>
      continue;
    if(namecmp(name, de.name) == 0){
80102265:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102268:	83 c0 02             	add    $0x2,%eax
8010226b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010226f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102272:	89 04 24             	mov    %eax,(%esp)
80102275:	e8 63 ff ff ff       	call   801021dd <namecmp>
8010227a:	85 c0                	test   %eax,%eax
8010227c:	75 2f                	jne    801022ad <dirlookup+0xae>
      // entry matches path element
      if(poff)
8010227e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102282:	74 08                	je     8010228c <dirlookup+0x8d>
        *poff = off;
80102284:	8b 45 10             	mov    0x10(%ebp),%eax
80102287:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010228a:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010228c:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102290:	0f b7 c0             	movzwl %ax,%eax
80102293:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102296:	8b 45 08             	mov    0x8(%ebp),%eax
80102299:	8b 00                	mov    (%eax),%eax
8010229b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010229e:	89 54 24 04          	mov    %edx,0x4(%esp)
801022a2:	89 04 24             	mov    %eax,(%esp)
801022a5:	e8 de f4 ff ff       	call   80101788 <iget>
801022aa:	eb 19                	jmp    801022c5 <dirlookup+0xc6>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
801022ac:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801022ad:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801022b1:	8b 45 08             	mov    0x8(%ebp),%eax
801022b4:	8b 40 18             	mov    0x18(%eax),%eax
801022b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801022ba:	0f 87 6a ff ff ff    	ja     8010222a <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801022c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022c5:	c9                   	leave  
801022c6:	c3                   	ret    

801022c7 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801022c7:	55                   	push   %ebp
801022c8:	89 e5                	mov    %esp,%ebp
801022ca:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801022cd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801022d4:	00 
801022d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801022d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801022dc:	8b 45 08             	mov    0x8(%ebp),%eax
801022df:	89 04 24             	mov    %eax,(%esp)
801022e2:	e8 18 ff ff ff       	call   801021ff <dirlookup>
801022e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022ee:	74 15                	je     80102305 <dirlink+0x3e>
    iput(ip);
801022f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022f3:	89 04 24             	mov    %eax,(%esp)
801022f6:	e8 44 f7 ff ff       	call   80101a3f <iput>
    return -1;
801022fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102300:	e9 b8 00 00 00       	jmp    801023bd <dirlink+0xf6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102305:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010230c:	eb 44                	jmp    80102352 <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102311:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102318:	00 
80102319:	89 44 24 08          	mov    %eax,0x8(%esp)
8010231d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102320:	89 44 24 04          	mov    %eax,0x4(%esp)
80102324:	8b 45 08             	mov    0x8(%ebp),%eax
80102327:	89 04 24             	mov    %eax,(%esp)
8010232a:	e8 a7 fb ff ff       	call   80101ed6 <readi>
8010232f:	83 f8 10             	cmp    $0x10,%eax
80102332:	74 0c                	je     80102340 <dirlink+0x79>
      panic("dirlink read");
80102334:	c7 04 24 73 85 10 80 	movl   $0x80108573,(%esp)
8010233b:	e8 06 e2 ff ff       	call   80100546 <panic>
    if(de.inum == 0)
80102340:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102344:	66 85 c0             	test   %ax,%ax
80102347:	74 18                	je     80102361 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010234c:	83 c0 10             	add    $0x10,%eax
8010234f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102352:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102355:	8b 45 08             	mov    0x8(%ebp),%eax
80102358:	8b 40 18             	mov    0x18(%eax),%eax
8010235b:	39 c2                	cmp    %eax,%edx
8010235d:	72 af                	jb     8010230e <dirlink+0x47>
8010235f:	eb 01                	jmp    80102362 <dirlink+0x9b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102361:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102362:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102369:	00 
8010236a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010236d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102371:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102374:	83 c0 02             	add    $0x2,%eax
80102377:	89 04 24             	mov    %eax,(%esp)
8010237a:	e8 ee 2c 00 00       	call   8010506d <strncpy>
  de.inum = inum;
8010237f:	8b 45 10             	mov    0x10(%ebp),%eax
80102382:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102386:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102389:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102390:	00 
80102391:	89 44 24 08          	mov    %eax,0x8(%esp)
80102395:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102398:	89 44 24 04          	mov    %eax,0x4(%esp)
8010239c:	8b 45 08             	mov    0x8(%ebp),%eax
8010239f:	89 04 24             	mov    %eax,(%esp)
801023a2:	e8 9d fc ff ff       	call   80102044 <writei>
801023a7:	83 f8 10             	cmp    $0x10,%eax
801023aa:	74 0c                	je     801023b8 <dirlink+0xf1>
    panic("dirlink");
801023ac:	c7 04 24 80 85 10 80 	movl   $0x80108580,(%esp)
801023b3:	e8 8e e1 ff ff       	call   80100546 <panic>
  
  return 0;
801023b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023bd:	c9                   	leave  
801023be:	c3                   	ret    

801023bf <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801023bf:	55                   	push   %ebp
801023c0:	89 e5                	mov    %esp,%ebp
801023c2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
801023c5:	eb 04                	jmp    801023cb <skipelem+0xc>
    path++;
801023c7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801023cb:	8b 45 08             	mov    0x8(%ebp),%eax
801023ce:	0f b6 00             	movzbl (%eax),%eax
801023d1:	3c 2f                	cmp    $0x2f,%al
801023d3:	74 f2                	je     801023c7 <skipelem+0x8>
    path++;
  if(*path == 0)
801023d5:	8b 45 08             	mov    0x8(%ebp),%eax
801023d8:	0f b6 00             	movzbl (%eax),%eax
801023db:	84 c0                	test   %al,%al
801023dd:	75 0a                	jne    801023e9 <skipelem+0x2a>
    return 0;
801023df:	b8 00 00 00 00       	mov    $0x0,%eax
801023e4:	e9 88 00 00 00       	jmp    80102471 <skipelem+0xb2>
  s = path;
801023e9:	8b 45 08             	mov    0x8(%ebp),%eax
801023ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801023ef:	eb 04                	jmp    801023f5 <skipelem+0x36>
    path++;
801023f1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801023f5:	8b 45 08             	mov    0x8(%ebp),%eax
801023f8:	0f b6 00             	movzbl (%eax),%eax
801023fb:	3c 2f                	cmp    $0x2f,%al
801023fd:	74 0a                	je     80102409 <skipelem+0x4a>
801023ff:	8b 45 08             	mov    0x8(%ebp),%eax
80102402:	0f b6 00             	movzbl (%eax),%eax
80102405:	84 c0                	test   %al,%al
80102407:	75 e8                	jne    801023f1 <skipelem+0x32>
    path++;
  len = path - s;
80102409:	8b 55 08             	mov    0x8(%ebp),%edx
8010240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010240f:	89 d1                	mov    %edx,%ecx
80102411:	29 c1                	sub    %eax,%ecx
80102413:	89 c8                	mov    %ecx,%eax
80102415:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102418:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010241c:	7e 1c                	jle    8010243a <skipelem+0x7b>
    memmove(name, s, DIRSIZ);
8010241e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102425:	00 
80102426:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102429:	89 44 24 04          	mov    %eax,0x4(%esp)
8010242d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102430:	89 04 24             	mov    %eax,(%esp)
80102433:	e8 39 2b 00 00       	call   80104f71 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102438:	eb 2a                	jmp    80102464 <skipelem+0xa5>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
8010243a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010243d:	89 44 24 08          	mov    %eax,0x8(%esp)
80102441:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102444:	89 44 24 04          	mov    %eax,0x4(%esp)
80102448:	8b 45 0c             	mov    0xc(%ebp),%eax
8010244b:	89 04 24             	mov    %eax,(%esp)
8010244e:	e8 1e 2b 00 00       	call   80104f71 <memmove>
    name[len] = 0;
80102453:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102456:	8b 45 0c             	mov    0xc(%ebp),%eax
80102459:	01 d0                	add    %edx,%eax
8010245b:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010245e:	eb 04                	jmp    80102464 <skipelem+0xa5>
    path++;
80102460:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102464:	8b 45 08             	mov    0x8(%ebp),%eax
80102467:	0f b6 00             	movzbl (%eax),%eax
8010246a:	3c 2f                	cmp    $0x2f,%al
8010246c:	74 f2                	je     80102460 <skipelem+0xa1>
    path++;
  return path;
8010246e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102471:	c9                   	leave  
80102472:	c3                   	ret    

80102473 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102473:	55                   	push   %ebp
80102474:	89 e5                	mov    %esp,%ebp
80102476:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102479:	8b 45 08             	mov    0x8(%ebp),%eax
8010247c:	0f b6 00             	movzbl (%eax),%eax
8010247f:	3c 2f                	cmp    $0x2f,%al
80102481:	75 1c                	jne    8010249f <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102483:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010248a:	00 
8010248b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102492:	e8 f1 f2 ff ff       	call   80101788 <iget>
80102497:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010249a:	e9 af 00 00 00       	jmp    8010254e <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010249f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801024a5:	8b 40 68             	mov    0x68(%eax),%eax
801024a8:	89 04 24             	mov    %eax,(%esp)
801024ab:	e8 aa f3 ff ff       	call   8010185a <idup>
801024b0:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801024b3:	e9 96 00 00 00       	jmp    8010254e <namex+0xdb>
    ilock(ip);
801024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024bb:	89 04 24             	mov    %eax,(%esp)
801024be:	e8 c9 f3 ff ff       	call   8010188c <ilock>
    if(ip->type != T_DIR){
801024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024c6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801024ca:	66 83 f8 01          	cmp    $0x1,%ax
801024ce:	74 15                	je     801024e5 <namex+0x72>
      iunlockput(ip);
801024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024d3:	89 04 24             	mov    %eax,(%esp)
801024d6:	e8 35 f6 ff ff       	call   80101b10 <iunlockput>
      return 0;
801024db:	b8 00 00 00 00       	mov    $0x0,%eax
801024e0:	e9 a3 00 00 00       	jmp    80102588 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
801024e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024e9:	74 1d                	je     80102508 <namex+0x95>
801024eb:	8b 45 08             	mov    0x8(%ebp),%eax
801024ee:	0f b6 00             	movzbl (%eax),%eax
801024f1:	84 c0                	test   %al,%al
801024f3:	75 13                	jne    80102508 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
801024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024f8:	89 04 24             	mov    %eax,(%esp)
801024fb:	e8 da f4 ff ff       	call   801019da <iunlock>
      return ip;
80102500:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102503:	e9 80 00 00 00       	jmp    80102588 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102508:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010250f:	00 
80102510:	8b 45 10             	mov    0x10(%ebp),%eax
80102513:	89 44 24 04          	mov    %eax,0x4(%esp)
80102517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010251a:	89 04 24             	mov    %eax,(%esp)
8010251d:	e8 dd fc ff ff       	call   801021ff <dirlookup>
80102522:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102525:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102529:	75 12                	jne    8010253d <namex+0xca>
      iunlockput(ip);
8010252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010252e:	89 04 24             	mov    %eax,(%esp)
80102531:	e8 da f5 ff ff       	call   80101b10 <iunlockput>
      return 0;
80102536:	b8 00 00 00 00       	mov    $0x0,%eax
8010253b:	eb 4b                	jmp    80102588 <namex+0x115>
    }
    iunlockput(ip);
8010253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102540:	89 04 24             	mov    %eax,(%esp)
80102543:	e8 c8 f5 ff ff       	call   80101b10 <iunlockput>
    ip = next;
80102548:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010254b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010254e:	8b 45 10             	mov    0x10(%ebp),%eax
80102551:	89 44 24 04          	mov    %eax,0x4(%esp)
80102555:	8b 45 08             	mov    0x8(%ebp),%eax
80102558:	89 04 24             	mov    %eax,(%esp)
8010255b:	e8 5f fe ff ff       	call   801023bf <skipelem>
80102560:	89 45 08             	mov    %eax,0x8(%ebp)
80102563:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102567:	0f 85 4b ff ff ff    	jne    801024b8 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010256d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102571:	74 12                	je     80102585 <namex+0x112>
    iput(ip);
80102573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102576:	89 04 24             	mov    %eax,(%esp)
80102579:	e8 c1 f4 ff ff       	call   80101a3f <iput>
    return 0;
8010257e:	b8 00 00 00 00       	mov    $0x0,%eax
80102583:	eb 03                	jmp    80102588 <namex+0x115>
  }
  return ip;
80102585:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102588:	c9                   	leave  
80102589:	c3                   	ret    

8010258a <namei>:

struct inode*
namei(char *path)
{
8010258a:	55                   	push   %ebp
8010258b:	89 e5                	mov    %esp,%ebp
8010258d:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102590:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102593:	89 44 24 08          	mov    %eax,0x8(%esp)
80102597:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010259e:	00 
8010259f:	8b 45 08             	mov    0x8(%ebp),%eax
801025a2:	89 04 24             	mov    %eax,(%esp)
801025a5:	e8 c9 fe ff ff       	call   80102473 <namex>
}
801025aa:	c9                   	leave  
801025ab:	c3                   	ret    

801025ac <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801025ac:	55                   	push   %ebp
801025ad:	89 e5                	mov    %esp,%ebp
801025af:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
801025b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801025b5:	89 44 24 08          	mov    %eax,0x8(%esp)
801025b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801025c0:	00 
801025c1:	8b 45 08             	mov    0x8(%ebp),%eax
801025c4:	89 04 24             	mov    %eax,(%esp)
801025c7:	e8 a7 fe ff ff       	call   80102473 <namex>
}
801025cc:	c9                   	leave  
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax

801025d0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	53                   	push   %ebx
801025d4:	83 ec 14             	sub    $0x14,%esp
801025d7:	8b 45 08             	mov    0x8(%ebp),%eax
801025da:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025de:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
801025e2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801025e6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801025ea:	ec                   	in     (%dx),%al
801025eb:	89 c3                	mov    %eax,%ebx
801025ed:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801025f0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801025f4:	83 c4 14             	add    $0x14,%esp
801025f7:	5b                   	pop    %ebx
801025f8:	5d                   	pop    %ebp
801025f9:	c3                   	ret    

801025fa <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801025fa:	55                   	push   %ebp
801025fb:	89 e5                	mov    %esp,%ebp
801025fd:	57                   	push   %edi
801025fe:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801025ff:	8b 55 08             	mov    0x8(%ebp),%edx
80102602:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102605:	8b 45 10             	mov    0x10(%ebp),%eax
80102608:	89 cb                	mov    %ecx,%ebx
8010260a:	89 df                	mov    %ebx,%edi
8010260c:	89 c1                	mov    %eax,%ecx
8010260e:	fc                   	cld    
8010260f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102611:	89 c8                	mov    %ecx,%eax
80102613:	89 fb                	mov    %edi,%ebx
80102615:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102618:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010261b:	5b                   	pop    %ebx
8010261c:	5f                   	pop    %edi
8010261d:	5d                   	pop    %ebp
8010261e:	c3                   	ret    

8010261f <outb>:

static inline void
outb(ushort port, uchar data)
{
8010261f:	55                   	push   %ebp
80102620:	89 e5                	mov    %esp,%ebp
80102622:	83 ec 08             	sub    $0x8,%esp
80102625:	8b 55 08             	mov    0x8(%ebp),%edx
80102628:	8b 45 0c             	mov    0xc(%ebp),%eax
8010262b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010262f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102632:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102636:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010263a:	ee                   	out    %al,(%dx)
}
8010263b:	c9                   	leave  
8010263c:	c3                   	ret    

8010263d <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010263d:	55                   	push   %ebp
8010263e:	89 e5                	mov    %esp,%ebp
80102640:	56                   	push   %esi
80102641:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102642:	8b 55 08             	mov    0x8(%ebp),%edx
80102645:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102648:	8b 45 10             	mov    0x10(%ebp),%eax
8010264b:	89 cb                	mov    %ecx,%ebx
8010264d:	89 de                	mov    %ebx,%esi
8010264f:	89 c1                	mov    %eax,%ecx
80102651:	fc                   	cld    
80102652:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102654:	89 c8                	mov    %ecx,%eax
80102656:	89 f3                	mov    %esi,%ebx
80102658:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010265b:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010265e:	5b                   	pop    %ebx
8010265f:	5e                   	pop    %esi
80102660:	5d                   	pop    %ebp
80102661:	c3                   	ret    

80102662 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102662:	55                   	push   %ebp
80102663:	89 e5                	mov    %esp,%ebp
80102665:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102668:	90                   	nop
80102669:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102670:	e8 5b ff ff ff       	call   801025d0 <inb>
80102675:	0f b6 c0             	movzbl %al,%eax
80102678:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010267b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010267e:	25 c0 00 00 00       	and    $0xc0,%eax
80102683:	83 f8 40             	cmp    $0x40,%eax
80102686:	75 e1                	jne    80102669 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102688:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010268c:	74 11                	je     8010269f <idewait+0x3d>
8010268e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102691:	83 e0 21             	and    $0x21,%eax
80102694:	85 c0                	test   %eax,%eax
80102696:	74 07                	je     8010269f <idewait+0x3d>
    return -1;
80102698:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010269d:	eb 05                	jmp    801026a4 <idewait+0x42>
  return 0;
8010269f:	b8 00 00 00 00       	mov    $0x0,%eax
}
801026a4:	c9                   	leave  
801026a5:	c3                   	ret    

801026a6 <ideinit>:

void
ideinit(void)
{
801026a6:	55                   	push   %ebp
801026a7:	89 e5                	mov    %esp,%ebp
801026a9:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
801026ac:	c7 44 24 04 88 85 10 	movl   $0x80108588,0x4(%esp)
801026b3:	80 
801026b4:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801026bb:	e8 62 25 00 00       	call   80104c22 <initlock>
  picenable(IRQ_IDE);
801026c0:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801026c7:	e8 25 15 00 00       	call   80103bf1 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
801026cc:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801026d1:	83 e8 01             	sub    $0x1,%eax
801026d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801026d8:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801026df:	e8 12 04 00 00       	call   80102af6 <ioapicenable>
  idewait(0);
801026e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801026eb:	e8 72 ff ff ff       	call   80102662 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801026f0:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801026f7:	00 
801026f8:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026ff:	e8 1b ff ff ff       	call   8010261f <outb>
  for(i=0; i<1000; i++){
80102704:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010270b:	eb 20                	jmp    8010272d <ideinit+0x87>
    if(inb(0x1f7) != 0){
8010270d:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102714:	e8 b7 fe ff ff       	call   801025d0 <inb>
80102719:	84 c0                	test   %al,%al
8010271b:	74 0c                	je     80102729 <ideinit+0x83>
      havedisk1 = 1;
8010271d:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
80102724:	00 00 00 
      break;
80102727:	eb 0d                	jmp    80102736 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102729:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010272d:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102734:	7e d7                	jle    8010270d <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102736:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
8010273d:	00 
8010273e:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102745:	e8 d5 fe ff ff       	call   8010261f <outb>
}
8010274a:	c9                   	leave  
8010274b:	c3                   	ret    

8010274c <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010274c:	55                   	push   %ebp
8010274d:	89 e5                	mov    %esp,%ebp
8010274f:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102752:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102756:	75 0c                	jne    80102764 <idestart+0x18>
    panic("idestart");
80102758:	c7 04 24 8c 85 10 80 	movl   $0x8010858c,(%esp)
8010275f:	e8 e2 dd ff ff       	call   80100546 <panic>

  idewait(0);
80102764:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010276b:	e8 f2 fe ff ff       	call   80102662 <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102770:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102777:	00 
80102778:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
8010277f:	e8 9b fe ff ff       	call   8010261f <outb>
  outb(0x1f2, 1);  // number of sectors
80102784:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010278b:	00 
8010278c:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102793:	e8 87 fe ff ff       	call   8010261f <outb>
  outb(0x1f3, b->sector & 0xff);
80102798:	8b 45 08             	mov    0x8(%ebp),%eax
8010279b:	8b 40 08             	mov    0x8(%eax),%eax
8010279e:	0f b6 c0             	movzbl %al,%eax
801027a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801027a5:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
801027ac:	e8 6e fe ff ff       	call   8010261f <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
801027b1:	8b 45 08             	mov    0x8(%ebp),%eax
801027b4:	8b 40 08             	mov    0x8(%eax),%eax
801027b7:	c1 e8 08             	shr    $0x8,%eax
801027ba:	0f b6 c0             	movzbl %al,%eax
801027bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801027c1:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
801027c8:	e8 52 fe ff ff       	call   8010261f <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
801027cd:	8b 45 08             	mov    0x8(%ebp),%eax
801027d0:	8b 40 08             	mov    0x8(%eax),%eax
801027d3:	c1 e8 10             	shr    $0x10,%eax
801027d6:	0f b6 c0             	movzbl %al,%eax
801027d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801027dd:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
801027e4:	e8 36 fe ff ff       	call   8010261f <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
801027e9:	8b 45 08             	mov    0x8(%ebp),%eax
801027ec:	8b 40 04             	mov    0x4(%eax),%eax
801027ef:	83 e0 01             	and    $0x1,%eax
801027f2:	89 c2                	mov    %eax,%edx
801027f4:	c1 e2 04             	shl    $0x4,%edx
801027f7:	8b 45 08             	mov    0x8(%ebp),%eax
801027fa:	8b 40 08             	mov    0x8(%eax),%eax
801027fd:	c1 e8 18             	shr    $0x18,%eax
80102800:	83 e0 0f             	and    $0xf,%eax
80102803:	09 d0                	or     %edx,%eax
80102805:	83 c8 e0             	or     $0xffffffe0,%eax
80102808:	0f b6 c0             	movzbl %al,%eax
8010280b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010280f:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102816:	e8 04 fe ff ff       	call   8010261f <outb>
  if(b->flags & B_DIRTY){
8010281b:	8b 45 08             	mov    0x8(%ebp),%eax
8010281e:	8b 00                	mov    (%eax),%eax
80102820:	83 e0 04             	and    $0x4,%eax
80102823:	85 c0                	test   %eax,%eax
80102825:	74 34                	je     8010285b <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
80102827:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
8010282e:	00 
8010282f:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102836:	e8 e4 fd ff ff       	call   8010261f <outb>
    outsl(0x1f0, b->data, 512/4);
8010283b:	8b 45 08             	mov    0x8(%ebp),%eax
8010283e:	83 c0 18             	add    $0x18,%eax
80102841:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102848:	00 
80102849:	89 44 24 04          	mov    %eax,0x4(%esp)
8010284d:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102854:	e8 e4 fd ff ff       	call   8010263d <outsl>
80102859:	eb 14                	jmp    8010286f <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
8010285b:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80102862:	00 
80102863:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010286a:	e8 b0 fd ff ff       	call   8010261f <outb>
  }
}
8010286f:	c9                   	leave  
80102870:	c3                   	ret    

80102871 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102871:	55                   	push   %ebp
80102872:	89 e5                	mov    %esp,%ebp
80102874:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102877:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010287e:	e8 c0 23 00 00       	call   80104c43 <acquire>
  if((b = idequeue) == 0){
80102883:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102888:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010288b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010288f:	75 11                	jne    801028a2 <ideintr+0x31>
    release(&idelock);
80102891:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102898:	e8 08 24 00 00       	call   80104ca5 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010289d:	e9 90 00 00 00       	jmp    80102932 <ideintr+0xc1>
  }
  idequeue = b->qnext;
801028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028a5:	8b 40 14             	mov    0x14(%eax),%eax
801028a8:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b0:	8b 00                	mov    (%eax),%eax
801028b2:	83 e0 04             	and    $0x4,%eax
801028b5:	85 c0                	test   %eax,%eax
801028b7:	75 2e                	jne    801028e7 <ideintr+0x76>
801028b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028c0:	e8 9d fd ff ff       	call   80102662 <idewait>
801028c5:	85 c0                	test   %eax,%eax
801028c7:	78 1e                	js     801028e7 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
801028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028cc:	83 c0 18             	add    $0x18,%eax
801028cf:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801028d6:	00 
801028d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801028db:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801028e2:	e8 13 fd ff ff       	call   801025fa <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ea:	8b 00                	mov    (%eax),%eax
801028ec:	89 c2                	mov    %eax,%edx
801028ee:	83 ca 02             	or     $0x2,%edx
801028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f4:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f9:	8b 00                	mov    (%eax),%eax
801028fb:	89 c2                	mov    %eax,%edx
801028fd:	83 e2 fb             	and    $0xfffffffb,%edx
80102900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102903:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102908:	89 04 24             	mov    %eax,(%esp)
8010290b:	e8 2a 21 00 00       	call   80104a3a <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102910:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <ideintr+0xb5>
    idestart(idequeue);
80102919:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010291e:	89 04 24             	mov    %eax,(%esp)
80102921:	e8 26 fe ff ff       	call   8010274c <idestart>

  release(&idelock);
80102926:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010292d:	e8 73 23 00 00       	call   80104ca5 <release>
}
80102932:	c9                   	leave  
80102933:	c3                   	ret    

80102934 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102934:	55                   	push   %ebp
80102935:	89 e5                	mov    %esp,%ebp
80102937:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010293a:	8b 45 08             	mov    0x8(%ebp),%eax
8010293d:	8b 00                	mov    (%eax),%eax
8010293f:	83 e0 01             	and    $0x1,%eax
80102942:	85 c0                	test   %eax,%eax
80102944:	75 0c                	jne    80102952 <iderw+0x1e>
    panic("iderw: buf not busy");
80102946:	c7 04 24 95 85 10 80 	movl   $0x80108595,(%esp)
8010294d:	e8 f4 db ff ff       	call   80100546 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102952:	8b 45 08             	mov    0x8(%ebp),%eax
80102955:	8b 00                	mov    (%eax),%eax
80102957:	83 e0 06             	and    $0x6,%eax
8010295a:	83 f8 02             	cmp    $0x2,%eax
8010295d:	75 0c                	jne    8010296b <iderw+0x37>
    panic("iderw: nothing to do");
8010295f:	c7 04 24 a9 85 10 80 	movl   $0x801085a9,(%esp)
80102966:	e8 db db ff ff       	call   80100546 <panic>
  if(b->dev != 0 && !havedisk1)
8010296b:	8b 45 08             	mov    0x8(%ebp),%eax
8010296e:	8b 40 04             	mov    0x4(%eax),%eax
80102971:	85 c0                	test   %eax,%eax
80102973:	74 15                	je     8010298a <iderw+0x56>
80102975:	a1 38 b6 10 80       	mov    0x8010b638,%eax
8010297a:	85 c0                	test   %eax,%eax
8010297c:	75 0c                	jne    8010298a <iderw+0x56>
    panic("iderw: ide disk 1 not present");
8010297e:	c7 04 24 be 85 10 80 	movl   $0x801085be,(%esp)
80102985:	e8 bc db ff ff       	call   80100546 <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010298a:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102991:	e8 ad 22 00 00       	call   80104c43 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102996:	8b 45 08             	mov    0x8(%ebp),%eax
80102999:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029a0:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
801029a7:	eb 0b                	jmp    801029b4 <iderw+0x80>
801029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029ac:	8b 00                	mov    (%eax),%eax
801029ae:	83 c0 14             	add    $0x14,%eax
801029b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029b7:	8b 00                	mov    (%eax),%eax
801029b9:	85 c0                	test   %eax,%eax
801029bb:	75 ec                	jne    801029a9 <iderw+0x75>
    ;
  *pp = b;
801029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029c0:	8b 55 08             	mov    0x8(%ebp),%edx
801029c3:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801029c5:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801029ca:	3b 45 08             	cmp    0x8(%ebp),%eax
801029cd:	75 22                	jne    801029f1 <iderw+0xbd>
    idestart(b);
801029cf:	8b 45 08             	mov    0x8(%ebp),%eax
801029d2:	89 04 24             	mov    %eax,(%esp)
801029d5:	e8 72 fd ff ff       	call   8010274c <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029da:	eb 15                	jmp    801029f1 <iderw+0xbd>
    sleep(b, &idelock);
801029dc:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
801029e3:	80 
801029e4:	8b 45 08             	mov    0x8(%ebp),%eax
801029e7:	89 04 24             	mov    %eax,(%esp)
801029ea:	e8 6f 1f 00 00       	call   8010495e <sleep>
801029ef:	eb 01                	jmp    801029f2 <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029f1:	90                   	nop
801029f2:	8b 45 08             	mov    0x8(%ebp),%eax
801029f5:	8b 00                	mov    (%eax),%eax
801029f7:	83 e0 06             	and    $0x6,%eax
801029fa:	83 f8 02             	cmp    $0x2,%eax
801029fd:	75 dd                	jne    801029dc <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
801029ff:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102a06:	e8 9a 22 00 00       	call   80104ca5 <release>
}
80102a0b:	c9                   	leave  
80102a0c:	c3                   	ret    
80102a0d:	66 90                	xchg   %ax,%ax
80102a0f:	90                   	nop

80102a10 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a13:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102a18:	8b 55 08             	mov    0x8(%ebp),%edx
80102a1b:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a1d:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102a22:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a25:	5d                   	pop    %ebp
80102a26:	c3                   	ret    

80102a27 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a27:	55                   	push   %ebp
80102a28:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a2a:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102a2f:	8b 55 08             	mov    0x8(%ebp),%edx
80102a32:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a34:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102a39:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a3c:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a3f:	5d                   	pop    %ebp
80102a40:	c3                   	ret    

80102a41 <ioapicinit>:

void
ioapicinit(void)
{
80102a41:	55                   	push   %ebp
80102a42:	89 e5                	mov    %esp,%ebp
80102a44:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80102a47:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80102a4c:	85 c0                	test   %eax,%eax
80102a4e:	0f 84 9f 00 00 00    	je     80102af3 <ioapicinit+0xb2>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a54:	c7 05 34 f8 10 80 00 	movl   $0xfec00000,0x8010f834
80102a5b:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102a65:	e8 a6 ff ff ff       	call   80102a10 <ioapicread>
80102a6a:	c1 e8 10             	shr    $0x10,%eax
80102a6d:	25 ff 00 00 00       	and    $0xff,%eax
80102a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102a7c:	e8 8f ff ff ff       	call   80102a10 <ioapicread>
80102a81:	c1 e8 18             	shr    $0x18,%eax
80102a84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a87:	0f b6 05 00 f9 10 80 	movzbl 0x8010f900,%eax
80102a8e:	0f b6 c0             	movzbl %al,%eax
80102a91:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102a94:	74 0c                	je     80102aa2 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a96:	c7 04 24 dc 85 10 80 	movl   $0x801085dc,(%esp)
80102a9d:	e8 08 d9 ff ff       	call   801003aa <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102aa2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102aa9:	eb 3e                	jmp    80102ae9 <ioapicinit+0xa8>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aae:	83 c0 20             	add    $0x20,%eax
80102ab1:	0d 00 00 01 00       	or     $0x10000,%eax
80102ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102ab9:	83 c2 08             	add    $0x8,%edx
80102abc:	01 d2                	add    %edx,%edx
80102abe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ac2:	89 14 24             	mov    %edx,(%esp)
80102ac5:	e8 5d ff ff ff       	call   80102a27 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102acd:	83 c0 08             	add    $0x8,%eax
80102ad0:	01 c0                	add    %eax,%eax
80102ad2:	83 c0 01             	add    $0x1,%eax
80102ad5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102adc:	00 
80102add:	89 04 24             	mov    %eax,(%esp)
80102ae0:	e8 42 ff ff ff       	call   80102a27 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102ae5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102aef:	7e ba                	jle    80102aab <ioapicinit+0x6a>
80102af1:	eb 01                	jmp    80102af4 <ioapicinit+0xb3>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102af3:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102af4:	c9                   	leave  
80102af5:	c3                   	ret    

80102af6 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102af6:	55                   	push   %ebp
80102af7:	89 e5                	mov    %esp,%ebp
80102af9:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102afc:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80102b01:	85 c0                	test   %eax,%eax
80102b03:	74 39                	je     80102b3e <ioapicenable+0x48>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b05:	8b 45 08             	mov    0x8(%ebp),%eax
80102b08:	83 c0 20             	add    $0x20,%eax
80102b0b:	8b 55 08             	mov    0x8(%ebp),%edx
80102b0e:	83 c2 08             	add    $0x8,%edx
80102b11:	01 d2                	add    %edx,%edx
80102b13:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b17:	89 14 24             	mov    %edx,(%esp)
80102b1a:	e8 08 ff ff ff       	call   80102a27 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b22:	c1 e0 18             	shl    $0x18,%eax
80102b25:	8b 55 08             	mov    0x8(%ebp),%edx
80102b28:	83 c2 08             	add    $0x8,%edx
80102b2b:	01 d2                	add    %edx,%edx
80102b2d:	83 c2 01             	add    $0x1,%edx
80102b30:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b34:	89 14 24             	mov    %edx,(%esp)
80102b37:	e8 eb fe ff ff       	call   80102a27 <ioapicwrite>
80102b3c:	eb 01                	jmp    80102b3f <ioapicenable+0x49>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102b3e:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102b3f:	c9                   	leave  
80102b40:	c3                   	ret    
80102b41:	66 90                	xchg   %ax,%ax
80102b43:	90                   	nop

80102b44 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102b44:	55                   	push   %ebp
80102b45:	89 e5                	mov    %esp,%ebp
80102b47:	8b 45 08             	mov    0x8(%ebp),%eax
80102b4a:	05 00 00 00 80       	add    $0x80000000,%eax
80102b4f:	5d                   	pop    %ebp
80102b50:	c3                   	ret    

80102b51 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b51:	55                   	push   %ebp
80102b52:	89 e5                	mov    %esp,%ebp
80102b54:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102b57:	c7 44 24 04 0e 86 10 	movl   $0x8010860e,0x4(%esp)
80102b5e:	80 
80102b5f:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b66:	e8 b7 20 00 00       	call   80104c22 <initlock>
  kmem.use_lock = 0;
80102b6b:	c7 05 74 f8 10 80 00 	movl   $0x0,0x8010f874
80102b72:	00 00 00 
  freerange(vstart, vend);
80102b75:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b78:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b7c:	8b 45 08             	mov    0x8(%ebp),%eax
80102b7f:	89 04 24             	mov    %eax,(%esp)
80102b82:	e8 26 00 00 00       	call   80102bad <freerange>
}
80102b87:	c9                   	leave  
80102b88:	c3                   	ret    

80102b89 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b89:	55                   	push   %ebp
80102b8a:	89 e5                	mov    %esp,%ebp
80102b8c:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b92:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b96:	8b 45 08             	mov    0x8(%ebp),%eax
80102b99:	89 04 24             	mov    %eax,(%esp)
80102b9c:	e8 0c 00 00 00       	call   80102bad <freerange>
  kmem.use_lock = 1;
80102ba1:	c7 05 74 f8 10 80 01 	movl   $0x1,0x8010f874
80102ba8:	00 00 00 
}
80102bab:	c9                   	leave  
80102bac:	c3                   	ret    

80102bad <freerange>:

void
freerange(void *vstart, void *vend)
{
80102bad:	55                   	push   %ebp
80102bae:	89 e5                	mov    %esp,%ebp
80102bb0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102bb3:	8b 45 08             	mov    0x8(%ebp),%eax
80102bb6:	05 ff 0f 00 00       	add    $0xfff,%eax
80102bbb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bc3:	eb 12                	jmp    80102bd7 <freerange+0x2a>
    kfree(p);
80102bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bc8:	89 04 24             	mov    %eax,(%esp)
80102bcb:	e8 16 00 00 00       	call   80102be6 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bd0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bda:	05 00 10 00 00       	add    $0x1000,%eax
80102bdf:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102be2:	76 e1                	jbe    80102bc5 <freerange+0x18>
    kfree(p);
}
80102be4:	c9                   	leave  
80102be5:	c3                   	ret    

80102be6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102be6:	55                   	push   %ebp
80102be7:	89 e5                	mov    %esp,%ebp
80102be9:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102bec:	8b 45 08             	mov    0x8(%ebp),%eax
80102bef:	25 ff 0f 00 00       	and    $0xfff,%eax
80102bf4:	85 c0                	test   %eax,%eax
80102bf6:	75 1b                	jne    80102c13 <kfree+0x2d>
80102bf8:	81 7d 08 fc 29 11 80 	cmpl   $0x801129fc,0x8(%ebp)
80102bff:	72 12                	jb     80102c13 <kfree+0x2d>
80102c01:	8b 45 08             	mov    0x8(%ebp),%eax
80102c04:	89 04 24             	mov    %eax,(%esp)
80102c07:	e8 38 ff ff ff       	call   80102b44 <v2p>
80102c0c:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c11:	76 0c                	jbe    80102c1f <kfree+0x39>
    panic("kfree");
80102c13:	c7 04 24 13 86 10 80 	movl   $0x80108613,(%esp)
80102c1a:	e8 27 d9 ff ff       	call   80100546 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c1f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102c26:	00 
80102c27:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102c2e:	00 
80102c2f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c32:	89 04 24             	mov    %eax,(%esp)
80102c35:	e8 64 22 00 00       	call   80104e9e <memset>

  if(kmem.use_lock)
80102c3a:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102c3f:	85 c0                	test   %eax,%eax
80102c41:	74 0c                	je     80102c4f <kfree+0x69>
    acquire(&kmem.lock);
80102c43:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102c4a:	e8 f4 1f 00 00       	call   80104c43 <acquire>
  r = (struct run*)v;
80102c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c55:	8b 15 78 f8 10 80    	mov    0x8010f878,%edx
80102c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c5e:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c63:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102c68:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102c6d:	85 c0                	test   %eax,%eax
80102c6f:	74 0c                	je     80102c7d <kfree+0x97>
    release(&kmem.lock);
80102c71:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102c78:	e8 28 20 00 00       	call   80104ca5 <release>
}
80102c7d:	c9                   	leave  
80102c7e:	c3                   	ret    

80102c7f <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c7f:	55                   	push   %ebp
80102c80:	89 e5                	mov    %esp,%ebp
80102c82:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102c85:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102c8a:	85 c0                	test   %eax,%eax
80102c8c:	74 0c                	je     80102c9a <kalloc+0x1b>
    acquire(&kmem.lock);
80102c8e:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102c95:	e8 a9 1f 00 00       	call   80104c43 <acquire>
  r = kmem.freelist;
80102c9a:	a1 78 f8 10 80       	mov    0x8010f878,%eax
80102c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102ca2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102ca6:	74 0a                	je     80102cb2 <kalloc+0x33>
    kmem.freelist = r->next;
80102ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cab:	8b 00                	mov    (%eax),%eax
80102cad:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102cb2:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102cb7:	85 c0                	test   %eax,%eax
80102cb9:	74 0c                	je     80102cc7 <kalloc+0x48>
    release(&kmem.lock);
80102cbb:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102cc2:	e8 de 1f 00 00       	call   80104ca5 <release>
  return (char*)r;
80102cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102cca:	c9                   	leave  
80102ccb:	c3                   	ret    

80102ccc <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102ccc:	55                   	push   %ebp
80102ccd:	89 e5                	mov    %esp,%ebp
80102ccf:	53                   	push   %ebx
80102cd0:	83 ec 14             	sub    $0x14,%esp
80102cd3:	8b 45 08             	mov    0x8(%ebp),%eax
80102cd6:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cda:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80102cde:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102ce2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
80102ce6:	ec                   	in     (%dx),%al
80102ce7:	89 c3                	mov    %eax,%ebx
80102ce9:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102cec:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80102cf0:	83 c4 14             	add    $0x14,%esp
80102cf3:	5b                   	pop    %ebx
80102cf4:	5d                   	pop    %ebp
80102cf5:	c3                   	ret    

80102cf6 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102cf6:	55                   	push   %ebp
80102cf7:	89 e5                	mov    %esp,%ebp
80102cf9:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102cfc:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102d03:	e8 c4 ff ff ff       	call   80102ccc <inb>
80102d08:	0f b6 c0             	movzbl %al,%eax
80102d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d11:	83 e0 01             	and    $0x1,%eax
80102d14:	85 c0                	test   %eax,%eax
80102d16:	75 0a                	jne    80102d22 <kbdgetc+0x2c>
    return -1;
80102d18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d1d:	e9 25 01 00 00       	jmp    80102e47 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102d22:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102d29:	e8 9e ff ff ff       	call   80102ccc <inb>
80102d2e:	0f b6 c0             	movzbl %al,%eax
80102d31:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d34:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d3b:	75 17                	jne    80102d54 <kbdgetc+0x5e>
    shift |= E0ESC;
80102d3d:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d42:	83 c8 40             	or     $0x40,%eax
80102d45:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102d4a:	b8 00 00 00 00       	mov    $0x0,%eax
80102d4f:	e9 f3 00 00 00       	jmp    80102e47 <kbdgetc+0x151>
  } else if(data & 0x80){
80102d54:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d57:	25 80 00 00 00       	and    $0x80,%eax
80102d5c:	85 c0                	test   %eax,%eax
80102d5e:	74 45                	je     80102da5 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d60:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d65:	83 e0 40             	and    $0x40,%eax
80102d68:	85 c0                	test   %eax,%eax
80102d6a:	75 08                	jne    80102d74 <kbdgetc+0x7e>
80102d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d6f:	83 e0 7f             	and    $0x7f,%eax
80102d72:	eb 03                	jmp    80102d77 <kbdgetc+0x81>
80102d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d77:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d7d:	05 20 90 10 80       	add    $0x80109020,%eax
80102d82:	0f b6 00             	movzbl (%eax),%eax
80102d85:	83 c8 40             	or     $0x40,%eax
80102d88:	0f b6 c0             	movzbl %al,%eax
80102d8b:	f7 d0                	not    %eax
80102d8d:	89 c2                	mov    %eax,%edx
80102d8f:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d94:	21 d0                	and    %edx,%eax
80102d96:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102d9b:	b8 00 00 00 00       	mov    $0x0,%eax
80102da0:	e9 a2 00 00 00       	jmp    80102e47 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102da5:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102daa:	83 e0 40             	and    $0x40,%eax
80102dad:	85 c0                	test   %eax,%eax
80102daf:	74 14                	je     80102dc5 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102db1:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102db8:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102dbd:	83 e0 bf             	and    $0xffffffbf,%eax
80102dc0:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102dc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dc8:	05 20 90 10 80       	add    $0x80109020,%eax
80102dcd:	0f b6 00             	movzbl (%eax),%eax
80102dd0:	0f b6 d0             	movzbl %al,%edx
80102dd3:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102dd8:	09 d0                	or     %edx,%eax
80102dda:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102de2:	05 20 91 10 80       	add    $0x80109120,%eax
80102de7:	0f b6 00             	movzbl (%eax),%eax
80102dea:	0f b6 d0             	movzbl %al,%edx
80102ded:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102df2:	31 d0                	xor    %edx,%eax
80102df4:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102df9:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102dfe:	83 e0 03             	and    $0x3,%eax
80102e01:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e0b:	01 d0                	add    %edx,%eax
80102e0d:	0f b6 00             	movzbl (%eax),%eax
80102e10:	0f b6 c0             	movzbl %al,%eax
80102e13:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e16:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102e1b:	83 e0 08             	and    $0x8,%eax
80102e1e:	85 c0                	test   %eax,%eax
80102e20:	74 22                	je     80102e44 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102e22:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e26:	76 0c                	jbe    80102e34 <kbdgetc+0x13e>
80102e28:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e2c:	77 06                	ja     80102e34 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102e2e:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e32:	eb 10                	jmp    80102e44 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102e34:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e38:	76 0a                	jbe    80102e44 <kbdgetc+0x14e>
80102e3a:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e3e:	77 04                	ja     80102e44 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102e40:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e44:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e47:	c9                   	leave  
80102e48:	c3                   	ret    

80102e49 <kbdintr>:

void
kbdintr(void)
{
80102e49:	55                   	push   %ebp
80102e4a:	89 e5                	mov    %esp,%ebp
80102e4c:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102e4f:	c7 04 24 f6 2c 10 80 	movl   $0x80102cf6,(%esp)
80102e56:	e8 5b d9 ff ff       	call   801007b6 <consoleintr>
}
80102e5b:	c9                   	leave  
80102e5c:	c3                   	ret    
80102e5d:	66 90                	xchg   %ax,%ax
80102e5f:	90                   	nop

80102e60 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	83 ec 08             	sub    $0x8,%esp
80102e66:	8b 55 08             	mov    0x8(%ebp),%edx
80102e69:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e6c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102e70:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e73:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102e77:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102e7b:	ee                   	out    %al,(%dx)
}
80102e7c:	c9                   	leave  
80102e7d:	c3                   	ret    

80102e7e <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102e7e:	55                   	push   %ebp
80102e7f:	89 e5                	mov    %esp,%ebp
80102e81:	53                   	push   %ebx
80102e82:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102e85:	9c                   	pushf  
80102e86:	5b                   	pop    %ebx
80102e87:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80102e8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e8d:	83 c4 10             	add    $0x10,%esp
80102e90:	5b                   	pop    %ebx
80102e91:	5d                   	pop    %ebp
80102e92:	c3                   	ret    

80102e93 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102e93:	55                   	push   %ebp
80102e94:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e96:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e9b:	8b 55 08             	mov    0x8(%ebp),%edx
80102e9e:	c1 e2 02             	shl    $0x2,%edx
80102ea1:	01 c2                	add    %eax,%edx
80102ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ea6:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ea8:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ead:	83 c0 20             	add    $0x20,%eax
80102eb0:	8b 00                	mov    (%eax),%eax
}
80102eb2:	5d                   	pop    %ebp
80102eb3:	c3                   	ret    

80102eb4 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102eb4:	55                   	push   %ebp
80102eb5:	89 e5                	mov    %esp,%ebp
80102eb7:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102eba:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ebf:	85 c0                	test   %eax,%eax
80102ec1:	0f 84 47 01 00 00    	je     8010300e <lapicinit+0x15a>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102ec7:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102ece:	00 
80102ecf:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102ed6:	e8 b8 ff ff ff       	call   80102e93 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102edb:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102ee2:	00 
80102ee3:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102eea:	e8 a4 ff ff ff       	call   80102e93 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102eef:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102ef6:	00 
80102ef7:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102efe:	e8 90 ff ff ff       	call   80102e93 <lapicw>
  lapicw(TICR, 10000000); 
80102f03:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102f0a:	00 
80102f0b:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102f12:	e8 7c ff ff ff       	call   80102e93 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f17:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102f1e:	00 
80102f1f:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102f26:	e8 68 ff ff ff       	call   80102e93 <lapicw>
  lapicw(LINT1, MASKED);
80102f2b:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102f32:	00 
80102f33:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102f3a:	e8 54 ff ff ff       	call   80102e93 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f3f:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102f44:	83 c0 30             	add    $0x30,%eax
80102f47:	8b 00                	mov    (%eax),%eax
80102f49:	c1 e8 10             	shr    $0x10,%eax
80102f4c:	25 ff 00 00 00       	and    $0xff,%eax
80102f51:	83 f8 03             	cmp    $0x3,%eax
80102f54:	76 14                	jbe    80102f6a <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102f56:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102f5d:	00 
80102f5e:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102f65:	e8 29 ff ff ff       	call   80102e93 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f6a:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102f71:	00 
80102f72:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102f79:	e8 15 ff ff ff       	call   80102e93 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f7e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f85:	00 
80102f86:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102f8d:	e8 01 ff ff ff       	call   80102e93 <lapicw>
  lapicw(ESR, 0);
80102f92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f99:	00 
80102f9a:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102fa1:	e8 ed fe ff ff       	call   80102e93 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102fa6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102fad:	00 
80102fae:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102fb5:	e8 d9 fe ff ff       	call   80102e93 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102fba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102fc1:	00 
80102fc2:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fc9:	e8 c5 fe ff ff       	call   80102e93 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102fce:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102fd5:	00 
80102fd6:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fdd:	e8 b1 fe ff ff       	call   80102e93 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102fe2:	90                   	nop
80102fe3:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102fe8:	05 00 03 00 00       	add    $0x300,%eax
80102fed:	8b 00                	mov    (%eax),%eax
80102fef:	25 00 10 00 00       	and    $0x1000,%eax
80102ff4:	85 c0                	test   %eax,%eax
80102ff6:	75 eb                	jne    80102fe3 <lapicinit+0x12f>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102ff8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102fff:	00 
80103000:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103007:	e8 87 fe ff ff       	call   80102e93 <lapicw>
8010300c:	eb 01                	jmp    8010300f <lapicinit+0x15b>

void
lapicinit(void)
{
  if(!lapic) 
    return;
8010300e:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
8010300f:	c9                   	leave  
80103010:	c3                   	ret    

80103011 <cpunum>:

int
cpunum(void)
{
80103011:	55                   	push   %ebp
80103012:	89 e5                	mov    %esp,%ebp
80103014:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80103017:	e8 62 fe ff ff       	call   80102e7e <readeflags>
8010301c:	25 00 02 00 00       	and    $0x200,%eax
80103021:	85 c0                	test   %eax,%eax
80103023:	74 29                	je     8010304e <cpunum+0x3d>
    static int n;
    if(n++ == 0)
80103025:	a1 40 b6 10 80       	mov    0x8010b640,%eax
8010302a:	85 c0                	test   %eax,%eax
8010302c:	0f 94 c2             	sete   %dl
8010302f:	83 c0 01             	add    $0x1,%eax
80103032:	a3 40 b6 10 80       	mov    %eax,0x8010b640
80103037:	84 d2                	test   %dl,%dl
80103039:	74 13                	je     8010304e <cpunum+0x3d>
      cprintf("cpu called from %x with interrupts enabled\n",
8010303b:	8b 45 04             	mov    0x4(%ebp),%eax
8010303e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103042:	c7 04 24 1c 86 10 80 	movl   $0x8010861c,(%esp)
80103049:	e8 5c d3 ff ff       	call   801003aa <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
8010304e:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80103053:	85 c0                	test   %eax,%eax
80103055:	74 0f                	je     80103066 <cpunum+0x55>
    return lapic[ID]>>24;
80103057:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
8010305c:	83 c0 20             	add    $0x20,%eax
8010305f:	8b 00                	mov    (%eax),%eax
80103061:	c1 e8 18             	shr    $0x18,%eax
80103064:	eb 05                	jmp    8010306b <cpunum+0x5a>
  return 0;
80103066:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010306b:	c9                   	leave  
8010306c:	c3                   	ret    

8010306d <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010306d:	55                   	push   %ebp
8010306e:	89 e5                	mov    %esp,%ebp
80103070:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80103073:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80103078:	85 c0                	test   %eax,%eax
8010307a:	74 14                	je     80103090 <lapiceoi+0x23>
    lapicw(EOI, 0);
8010307c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103083:	00 
80103084:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
8010308b:	e8 03 fe ff ff       	call   80102e93 <lapicw>
}
80103090:	c9                   	leave  
80103091:	c3                   	ret    

80103092 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103092:	55                   	push   %ebp
80103093:	89 e5                	mov    %esp,%ebp
}
80103095:	5d                   	pop    %ebp
80103096:	c3                   	ret    

80103097 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103097:	55                   	push   %ebp
80103098:	89 e5                	mov    %esp,%ebp
8010309a:	83 ec 1c             	sub    $0x1c,%esp
8010309d:	8b 45 08             	mov    0x8(%ebp),%eax
801030a0:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
801030a3:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
801030aa:	00 
801030ab:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801030b2:	e8 a9 fd ff ff       	call   80102e60 <outb>
  outb(IO_RTC+1, 0x0A);
801030b7:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
801030be:	00 
801030bf:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801030c6:	e8 95 fd ff ff       	call   80102e60 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801030cb:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801030d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030d5:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801030da:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030dd:	8d 50 02             	lea    0x2(%eax),%edx
801030e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801030e3:	c1 e8 04             	shr    $0x4,%eax
801030e6:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801030e9:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030ed:	c1 e0 18             	shl    $0x18,%eax
801030f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801030f4:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801030fb:	e8 93 fd ff ff       	call   80102e93 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103100:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80103107:	00 
80103108:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010310f:	e8 7f fd ff ff       	call   80102e93 <lapicw>
  microdelay(200);
80103114:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010311b:	e8 72 ff ff ff       	call   80103092 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103120:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80103127:	00 
80103128:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010312f:	e8 5f fd ff ff       	call   80102e93 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103134:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
8010313b:	e8 52 ff ff ff       	call   80103092 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103140:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103147:	eb 40                	jmp    80103189 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80103149:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010314d:	c1 e0 18             	shl    $0x18,%eax
80103150:	89 44 24 04          	mov    %eax,0x4(%esp)
80103154:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010315b:	e8 33 fd ff ff       	call   80102e93 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80103160:	8b 45 0c             	mov    0xc(%ebp),%eax
80103163:	c1 e8 0c             	shr    $0xc,%eax
80103166:	80 cc 06             	or     $0x6,%ah
80103169:	89 44 24 04          	mov    %eax,0x4(%esp)
8010316d:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103174:	e8 1a fd ff ff       	call   80102e93 <lapicw>
    microdelay(200);
80103179:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103180:	e8 0d ff ff ff       	call   80103092 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103185:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103189:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010318d:	7e ba                	jle    80103149 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010318f:	c9                   	leave  
80103190:	c3                   	ret    
80103191:	66 90                	xchg   %ax,%ax
80103193:	90                   	nop

80103194 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80103194:	55                   	push   %ebp
80103195:	89 e5                	mov    %esp,%ebp
80103197:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010319a:	c7 44 24 04 48 86 10 	movl   $0x80108648,0x4(%esp)
801031a1:	80 
801031a2:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801031a9:	e8 74 1a 00 00       	call   80104c22 <initlock>
  readsb(ROOTDEV, &sb);
801031ae:	8d 45 e8             	lea    -0x18(%ebp),%eax
801031b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801031b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801031bc:	e8 4b e1 ff ff       	call   8010130c <readsb>
  log.start = sb.size - sb.nlog;
801031c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
801031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031c7:	89 d1                	mov    %edx,%ecx
801031c9:	29 c1                	sub    %eax,%ecx
801031cb:	89 c8                	mov    %ecx,%eax
801031cd:	a3 b4 f8 10 80       	mov    %eax,0x8010f8b4
  log.size = sb.nlog;
801031d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031d5:	a3 b8 f8 10 80       	mov    %eax,0x8010f8b8
  log.dev = ROOTDEV;
801031da:	c7 05 c0 f8 10 80 01 	movl   $0x1,0x8010f8c0
801031e1:	00 00 00 
  recover_from_log();
801031e4:	e8 a5 01 00 00       	call   8010338e <recover_from_log>
}
801031e9:	c9                   	leave  
801031ea:	c3                   	ret    

801031eb <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801031eb:	55                   	push   %ebp
801031ec:	89 e5                	mov    %esp,%ebp
801031ee:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801031f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031f8:	e9 97 00 00 00       	jmp    80103294 <install_trans+0xa9>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // write log
801031fd:	8b 15 b4 f8 10 80    	mov    0x8010f8b4,%edx
80103203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103206:	01 d0                	add    %edx,%eax
80103208:	83 c0 01             	add    $0x1,%eax
8010320b:	89 c2                	mov    %eax,%edx
8010320d:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103212:	89 54 24 04          	mov    %edx,0x4(%esp)
80103216:	89 04 24             	mov    %eax,(%esp)
80103219:	e8 88 cf ff ff       	call   801001a6 <bread>
8010321e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103221:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103224:	83 c0 10             	add    $0x10,%eax
80103227:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
8010322e:	89 c2                	mov    %eax,%edx
80103230:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103235:	89 54 24 04          	mov    %edx,0x4(%esp)
80103239:	89 04 24             	mov    %eax,(%esp)
8010323c:	e8 65 cf ff ff       	call   801001a6 <bread>
80103241:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(lbuf->data,dbuf->data, BSIZE);  // copy block to dst
80103244:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103247:	8d 50 18             	lea    0x18(%eax),%edx
8010324a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010324d:	83 c0 18             	add    $0x18,%eax
80103250:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103257:	00 
80103258:	89 54 24 04          	mov    %edx,0x4(%esp)
8010325c:	89 04 24             	mov    %eax,(%esp)
8010325f:	e8 0d 1d 00 00       	call   80104f71 <memmove>
    bwrite(lbuf);  //write to log disk
80103264:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103267:	89 04 24             	mov    %eax,(%esp)
8010326a:	e8 6e cf ff ff       	call   801001dd <bwrite>
    bwrite(dbuf);  // write dst to disk
8010326f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103272:	89 04 24             	mov    %eax,(%esp)
80103275:	e8 63 cf ff ff       	call   801001dd <bwrite>
    
    brelse(lbuf); 
8010327a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010327d:	89 04 24             	mov    %eax,(%esp)
80103280:	e8 92 cf ff ff       	call   80100217 <brelse>
    brelse(dbuf);
80103285:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103288:	89 04 24             	mov    %eax,(%esp)
8010328b:	e8 87 cf ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103290:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103294:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103299:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010329c:	0f 8f 5b ff ff ff    	jg     801031fd <install_trans+0x12>
    bwrite(dbuf);  // write dst to disk
    
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801032a2:	c9                   	leave  
801032a3:	c3                   	ret    

801032a4 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801032a4:	55                   	push   %ebp
801032a5:	89 e5                	mov    %esp,%ebp
801032a7:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801032aa:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
801032af:	89 c2                	mov    %eax,%edx
801032b1:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801032b6:	89 54 24 04          	mov    %edx,0x4(%esp)
801032ba:	89 04 24             	mov    %eax,(%esp)
801032bd:	e8 e4 ce ff ff       	call   801001a6 <bread>
801032c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801032c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032c8:	83 c0 18             	add    $0x18,%eax
801032cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801032ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032d1:	8b 00                	mov    (%eax),%eax
801032d3:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  for (i = 0; i < log.lh.n; i++) {
801032d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032df:	eb 1b                	jmp    801032fc <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
801032e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801032e7:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801032eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801032ee:	83 c2 10             	add    $0x10,%edx
801032f1:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801032f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032fc:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103301:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103304:	7f db                	jg     801032e1 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103306:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103309:	89 04 24             	mov    %eax,(%esp)
8010330c:	e8 06 cf ff ff       	call   80100217 <brelse>
}
80103311:	c9                   	leave  
80103312:	c3                   	ret    

80103313 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103313:	55                   	push   %ebp
80103314:	89 e5                	mov    %esp,%ebp
80103316:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103319:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
8010331e:	89 c2                	mov    %eax,%edx
80103320:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103325:	89 54 24 04          	mov    %edx,0x4(%esp)
80103329:	89 04 24             	mov    %eax,(%esp)
8010332c:	e8 75 ce ff ff       	call   801001a6 <bread>
80103331:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103337:	83 c0 18             	add    $0x18,%eax
8010333a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010333d:	8b 15 c4 f8 10 80    	mov    0x8010f8c4,%edx
80103343:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103346:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010334f:	eb 1b                	jmp    8010336c <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
80103351:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103354:	83 c0 10             	add    $0x10,%eax
80103357:	8b 0c 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%ecx
8010335e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103361:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103364:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103368:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010336c:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103371:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103374:	7f db                	jg     80103351 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103376:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103379:	89 04 24             	mov    %eax,(%esp)
8010337c:	e8 5c ce ff ff       	call   801001dd <bwrite>
  brelse(buf);
80103381:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103384:	89 04 24             	mov    %eax,(%esp)
80103387:	e8 8b ce ff ff       	call   80100217 <brelse>
}
8010338c:	c9                   	leave  
8010338d:	c3                   	ret    

8010338e <recover_from_log>:

static void
recover_from_log(void)
{
8010338e:	55                   	push   %ebp
8010338f:	89 e5                	mov    %esp,%ebp
80103391:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103394:	e8 0b ff ff ff       	call   801032a4 <read_head>
  //cprintf("recovery: n=%d but ignoring\n", log.lh.n);
  install_trans(); // if committed, copy from log to disk
80103399:	e8 4d fe ff ff       	call   801031eb <install_trans>
  log.lh.n = 0;
8010339e:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
801033a5:	00 00 00 
  write_head(); // clear the log
801033a8:	e8 66 ff ff ff       	call   80103313 <write_head>
}
801033ad:	c9                   	leave  
801033ae:	c3                   	ret    

801033af <begin_trans>:

void
begin_trans(void)
{
801033af:	55                   	push   %ebp
801033b0:	89 e5                	mov    %esp,%ebp
801033b2:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801033b5:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801033bc:	e8 82 18 00 00       	call   80104c43 <acquire>
  while (log.busy) {
801033c1:	eb 14                	jmp    801033d7 <begin_trans+0x28>
    sleep(&log, &log.lock);
801033c3:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
801033ca:	80 
801033cb:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801033d2:	e8 87 15 00 00       	call   8010495e <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
801033d7:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
801033dc:	85 c0                	test   %eax,%eax
801033de:	75 e3                	jne    801033c3 <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
801033e0:	c7 05 bc f8 10 80 01 	movl   $0x1,0x8010f8bc
801033e7:	00 00 00 
  release(&log.lock);
801033ea:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801033f1:	e8 af 18 00 00       	call   80104ca5 <release>
}
801033f6:	c9                   	leave  
801033f7:	c3                   	ret    

801033f8 <commit_trans>:

void
commit_trans(void)
{
801033f8:	55                   	push   %ebp
801033f9:	89 e5                	mov    %esp,%ebp
801033fb:	83 ec 18             	sub    $0x18,%esp
  
  if (log.lh.n > 0) {
801033fe:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103403:	85 c0                	test   %eax,%eax
80103405:	7e 19                	jle    80103420 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103407:	e8 07 ff ff ff       	call   80103313 <write_head>
    install_trans(); // Now install writes to home locations
8010340c:	e8 da fd ff ff       	call   801031eb <install_trans>
    log.lh.n = 0; 
80103411:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
80103418:	00 00 00 
    write_head();    // Erase the transaction from the log
8010341b:	e8 f3 fe ff ff       	call   80103313 <write_head>
  }
  
  acquire(&log.lock);
80103420:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103427:	e8 17 18 00 00       	call   80104c43 <acquire>
  log.busy = 0;
8010342c:	c7 05 bc f8 10 80 00 	movl   $0x0,0x8010f8bc
80103433:	00 00 00 
  wakeup(&log);
80103436:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010343d:	e8 f8 15 00 00       	call   80104a3a <wakeup>
  release(&log.lock);
80103442:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103449:	e8 57 18 00 00       	call   80104ca5 <release>
}
8010344e:	c9                   	leave  
8010344f:	c3                   	ret    

80103450 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103456:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010345b:	83 f8 09             	cmp    $0x9,%eax
8010345e:	7f 12                	jg     80103472 <log_write+0x22>
80103460:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103465:	8b 15 b8 f8 10 80    	mov    0x8010f8b8,%edx
8010346b:	83 ea 01             	sub    $0x1,%edx
8010346e:	39 d0                	cmp    %edx,%eax
80103470:	7c 0c                	jl     8010347e <log_write+0x2e>
    panic("too big a transaction");
80103472:	c7 04 24 4c 86 10 80 	movl   $0x8010864c,(%esp)
80103479:	e8 c8 d0 ff ff       	call   80100546 <panic>
  if (!log.busy)
8010347e:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
80103483:	85 c0                	test   %eax,%eax
80103485:	75 0c                	jne    80103493 <log_write+0x43>
    panic("write outside of trans");
80103487:	c7 04 24 62 86 10 80 	movl   $0x80108662,(%esp)
8010348e:	e8 b3 d0 ff ff       	call   80100546 <panic>

  for (i = 0; i < log.lh.n; i++) {
80103493:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010349a:	eb 1d                	jmp    801034b9 <log_write+0x69>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
8010349c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010349f:	83 c0 10             	add    $0x10,%eax
801034a2:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
801034a9:	89 c2                	mov    %eax,%edx
801034ab:	8b 45 08             	mov    0x8(%ebp),%eax
801034ae:	8b 40 08             	mov    0x8(%eax),%eax
801034b1:	39 c2                	cmp    %eax,%edx
801034b3:	74 10                	je     801034c5 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
801034b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034b9:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801034be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034c1:	7f d9                	jg     8010349c <log_write+0x4c>
801034c3:	eb 01                	jmp    801034c6 <log_write+0x76>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
801034c5:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
801034c6:	8b 45 08             	mov    0x8(%ebp),%eax
801034c9:	8b 40 08             	mov    0x8(%eax),%eax
801034cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034cf:	83 c2 10             	add    $0x10,%edx
801034d2:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
  //delay write on log in disk to commit
  //struct buf *lbuf = bread(b->dev, log.start+i+1);
  //memmove(lbuf->data, b->data, BSIZE);
  //bwrite(lbuf);
  //brelse(lbuf);
  if (i == log.lh.n)
801034d9:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801034de:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034e1:	75 0d                	jne    801034f0 <log_write+0xa0>
    log.lh.n++;
801034e3:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801034e8:	83 c0 01             	add    $0x1,%eax
801034eb:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  b->flags |= B_DIRTY; // XXX prevent eviction
801034f0:	8b 45 08             	mov    0x8(%ebp),%eax
801034f3:	8b 00                	mov    (%eax),%eax
801034f5:	89 c2                	mov    %eax,%edx
801034f7:	83 ca 04             	or     $0x4,%edx
801034fa:	8b 45 08             	mov    0x8(%ebp),%eax
801034fd:	89 10                	mov    %edx,(%eax)
}
801034ff:	c9                   	leave  
80103500:	c3                   	ret    
80103501:	66 90                	xchg   %ax,%ax
80103503:	90                   	nop

80103504 <v2p>:
80103504:	55                   	push   %ebp
80103505:	89 e5                	mov    %esp,%ebp
80103507:	8b 45 08             	mov    0x8(%ebp),%eax
8010350a:	05 00 00 00 80       	add    $0x80000000,%eax
8010350f:	5d                   	pop    %ebp
80103510:	c3                   	ret    

80103511 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103511:	55                   	push   %ebp
80103512:	89 e5                	mov    %esp,%ebp
80103514:	8b 45 08             	mov    0x8(%ebp),%eax
80103517:	05 00 00 00 80       	add    $0x80000000,%eax
8010351c:	5d                   	pop    %ebp
8010351d:	c3                   	ret    

8010351e <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010351e:	55                   	push   %ebp
8010351f:	89 e5                	mov    %esp,%ebp
80103521:	53                   	push   %ebx
80103522:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
80103525:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103528:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
8010352b:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010352e:	89 c3                	mov    %eax,%ebx
80103530:	89 d8                	mov    %ebx,%eax
80103532:	f0 87 02             	lock xchg %eax,(%edx)
80103535:	89 c3                	mov    %eax,%ebx
80103537:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010353a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010353d:	83 c4 10             	add    $0x10,%esp
80103540:	5b                   	pop    %ebx
80103541:	5d                   	pop    %ebp
80103542:	c3                   	ret    

80103543 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103543:	55                   	push   %ebp
80103544:	89 e5                	mov    %esp,%ebp
80103546:	83 e4 f0             	and    $0xfffffff0,%esp
80103549:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010354c:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103553:	80 
80103554:	c7 04 24 fc 29 11 80 	movl   $0x801129fc,(%esp)
8010355b:	e8 f1 f5 ff ff       	call   80102b51 <kinit1>
  kvmalloc();      // kernel page table
80103560:	e8 23 47 00 00       	call   80107c88 <kvmalloc>
  mpinit();        // collect info about this machine
80103565:	e8 57 04 00 00       	call   801039c1 <mpinit>
  lapicinit();
8010356a:	e8 45 f9 ff ff       	call   80102eb4 <lapicinit>
  seginit();       // set up segments
8010356f:	e8 a9 40 00 00       	call   8010761d <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103574:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010357a:	0f b6 00             	movzbl (%eax),%eax
8010357d:	0f b6 c0             	movzbl %al,%eax
80103580:	89 44 24 04          	mov    %eax,0x4(%esp)
80103584:	c7 04 24 79 86 10 80 	movl   $0x80108679,(%esp)
8010358b:	e8 1a ce ff ff       	call   801003aa <cprintf>
  picinit();       // interrupt controller
80103590:	e8 91 06 00 00       	call   80103c26 <picinit>
  ioapicinit();    // another interrupt controller
80103595:	e8 a7 f4 ff ff       	call   80102a41 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010359a:	e8 f9 d4 ff ff       	call   80100a98 <consoleinit>
  uartinit();      // serial port
8010359f:	e8 c4 33 00 00       	call   80106968 <uartinit>
  pinit();         // process table
801035a4:	e8 96 0b 00 00       	call   8010413f <pinit>
  tvinit();        // trap vectors
801035a9:	e8 36 2e 00 00       	call   801063e4 <tvinit>
  binit();         // buffer cache
801035ae:	e8 81 ca ff ff       	call   80100034 <binit>
  fileinit();      // file table
801035b3:	e8 68 d9 ff ff       	call   80100f20 <fileinit>
  iinit();         // inode cache
801035b8:	e8 18 e0 ff ff       	call   801015d5 <iinit>
  ideinit();       // disk
801035bd:	e8 e4 f0 ff ff       	call   801026a6 <ideinit>
  if(!ismp)
801035c2:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801035c7:	85 c0                	test   %eax,%eax
801035c9:	75 05                	jne    801035d0 <main+0x8d>
    timerinit();   // uniprocessor timer
801035cb:	e8 4a 2d 00 00       	call   8010631a <timerinit>
  startothers();   // start other processors
801035d0:	e8 7f 00 00 00       	call   80103654 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801035d5:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801035dc:	8e 
801035dd:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801035e4:	e8 a0 f5 ff ff       	call   80102b89 <kinit2>
  userinit();      // first user process
801035e9:	e8 6f 0c 00 00       	call   8010425d <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801035ee:	e8 1a 00 00 00       	call   8010360d <mpmain>

801035f3 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801035f3:	55                   	push   %ebp
801035f4:	89 e5                	mov    %esp,%ebp
801035f6:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801035f9:	e8 a1 46 00 00       	call   80107c9f <switchkvm>
  seginit();
801035fe:	e8 1a 40 00 00       	call   8010761d <seginit>
  lapicinit();
80103603:	e8 ac f8 ff ff       	call   80102eb4 <lapicinit>
  mpmain();
80103608:	e8 00 00 00 00       	call   8010360d <mpmain>

8010360d <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010360d:	55                   	push   %ebp
8010360e:	89 e5                	mov    %esp,%ebp
80103610:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103613:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103619:	0f b6 00             	movzbl (%eax),%eax
8010361c:	0f b6 c0             	movzbl %al,%eax
8010361f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103623:	c7 04 24 90 86 10 80 	movl   $0x80108690,(%esp)
8010362a:	e8 7b cd ff ff       	call   801003aa <cprintf>
  idtinit();       // load idt register
8010362f:	e8 24 2f 00 00       	call   80106558 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103634:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010363a:	05 a8 00 00 00       	add    $0xa8,%eax
8010363f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103646:	00 
80103647:	89 04 24             	mov    %eax,(%esp)
8010364a:	e8 cf fe ff ff       	call   8010351e <xchg>
  scheduler();     // start running processes
8010364f:	e8 5e 11 00 00       	call   801047b2 <scheduler>

80103654 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103654:	55                   	push   %ebp
80103655:	89 e5                	mov    %esp,%ebp
80103657:	53                   	push   %ebx
80103658:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010365b:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103662:	e8 aa fe ff ff       	call   80103511 <p2v>
80103667:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010366a:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010366f:	89 44 24 08          	mov    %eax,0x8(%esp)
80103673:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
8010367a:	80 
8010367b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010367e:	89 04 24             	mov    %eax,(%esp)
80103681:	e8 eb 18 00 00       	call   80104f71 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103686:	c7 45 f4 20 f9 10 80 	movl   $0x8010f920,-0xc(%ebp)
8010368d:	e9 86 00 00 00       	jmp    80103718 <startothers+0xc4>
    if(c == cpus+cpunum())  // We've started already.
80103692:	e8 7a f9 ff ff       	call   80103011 <cpunum>
80103697:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010369d:	05 20 f9 10 80       	add    $0x8010f920,%eax
801036a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036a5:	74 69                	je     80103710 <startothers+0xbc>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801036a7:	e8 d3 f5 ff ff       	call   80102c7f <kalloc>
801036ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801036af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036b2:	83 e8 04             	sub    $0x4,%eax
801036b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
801036b8:	81 c2 00 10 00 00    	add    $0x1000,%edx
801036be:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801036c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036c3:	83 e8 08             	sub    $0x8,%eax
801036c6:	c7 00 f3 35 10 80    	movl   $0x801035f3,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801036cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036cf:	8d 58 f4             	lea    -0xc(%eax),%ebx
801036d2:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
801036d9:	e8 26 fe ff ff       	call   80103504 <v2p>
801036de:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801036e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036e3:	89 04 24             	mov    %eax,(%esp)
801036e6:	e8 19 fe ff ff       	call   80103504 <v2p>
801036eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036ee:	0f b6 12             	movzbl (%edx),%edx
801036f1:	0f b6 d2             	movzbl %dl,%edx
801036f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801036f8:	89 14 24             	mov    %edx,(%esp)
801036fb:	e8 97 f9 ff ff       	call   80103097 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103700:	90                   	nop
80103701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103704:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010370a:	85 c0                	test   %eax,%eax
8010370c:	74 f3                	je     80103701 <startothers+0xad>
8010370e:	eb 01                	jmp    80103711 <startothers+0xbd>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103710:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103711:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103718:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010371d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103723:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103728:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010372b:	0f 87 61 ff ff ff    	ja     80103692 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103731:	83 c4 24             	add    $0x24,%esp
80103734:	5b                   	pop    %ebx
80103735:	5d                   	pop    %ebp
80103736:	c3                   	ret    
80103737:	90                   	nop

80103738 <p2v>:
80103738:	55                   	push   %ebp
80103739:	89 e5                	mov    %esp,%ebp
8010373b:	8b 45 08             	mov    0x8(%ebp),%eax
8010373e:	05 00 00 00 80       	add    $0x80000000,%eax
80103743:	5d                   	pop    %ebp
80103744:	c3                   	ret    

80103745 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103745:	55                   	push   %ebp
80103746:	89 e5                	mov    %esp,%ebp
80103748:	53                   	push   %ebx
80103749:	83 ec 14             	sub    $0x14,%esp
8010374c:	8b 45 08             	mov    0x8(%ebp),%eax
8010374f:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103753:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80103757:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
8010375b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
8010375f:	ec                   	in     (%dx),%al
80103760:	89 c3                	mov    %eax,%ebx
80103762:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80103765:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80103769:	83 c4 14             	add    $0x14,%esp
8010376c:	5b                   	pop    %ebx
8010376d:	5d                   	pop    %ebp
8010376e:	c3                   	ret    

8010376f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010376f:	55                   	push   %ebp
80103770:	89 e5                	mov    %esp,%ebp
80103772:	83 ec 08             	sub    $0x8,%esp
80103775:	8b 55 08             	mov    0x8(%ebp),%edx
80103778:	8b 45 0c             	mov    0xc(%ebp),%eax
8010377b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010377f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103782:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103786:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010378a:	ee                   	out    %al,(%dx)
}
8010378b:	c9                   	leave  
8010378c:	c3                   	ret    

8010378d <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
8010378d:	55                   	push   %ebp
8010378e:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103790:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80103795:	89 c2                	mov    %eax,%edx
80103797:	b8 20 f9 10 80       	mov    $0x8010f920,%eax
8010379c:	89 d1                	mov    %edx,%ecx
8010379e:	29 c1                	sub    %eax,%ecx
801037a0:	89 c8                	mov    %ecx,%eax
801037a2:	c1 f8 02             	sar    $0x2,%eax
801037a5:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
801037ab:	5d                   	pop    %ebp
801037ac:	c3                   	ret    

801037ad <sum>:

static uchar
sum(uchar *addr, int len)
{
801037ad:	55                   	push   %ebp
801037ae:	89 e5                	mov    %esp,%ebp
801037b0:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
801037b3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
801037ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801037c1:	eb 15                	jmp    801037d8 <sum+0x2b>
    sum += addr[i];
801037c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
801037c6:	8b 45 08             	mov    0x8(%ebp),%eax
801037c9:	01 d0                	add    %edx,%eax
801037cb:	0f b6 00             	movzbl (%eax),%eax
801037ce:	0f b6 c0             	movzbl %al,%eax
801037d1:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
801037d4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801037d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801037db:	3b 45 0c             	cmp    0xc(%ebp),%eax
801037de:	7c e3                	jl     801037c3 <sum+0x16>
    sum += addr[i];
  return sum;
801037e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801037e3:	c9                   	leave  
801037e4:	c3                   	ret    

801037e5 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801037e5:	55                   	push   %ebp
801037e6:	89 e5                	mov    %esp,%ebp
801037e8:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801037eb:	8b 45 08             	mov    0x8(%ebp),%eax
801037ee:	89 04 24             	mov    %eax,(%esp)
801037f1:	e8 42 ff ff ff       	call   80103738 <p2v>
801037f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801037f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801037fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037ff:	01 d0                	add    %edx,%eax
80103801:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103804:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103807:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010380a:	eb 3f                	jmp    8010384b <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010380c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103813:	00 
80103814:	c7 44 24 04 a4 86 10 	movl   $0x801086a4,0x4(%esp)
8010381b:	80 
8010381c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010381f:	89 04 24             	mov    %eax,(%esp)
80103822:	e8 ee 16 00 00       	call   80104f15 <memcmp>
80103827:	85 c0                	test   %eax,%eax
80103829:	75 1c                	jne    80103847 <mpsearch1+0x62>
8010382b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103832:	00 
80103833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103836:	89 04 24             	mov    %eax,(%esp)
80103839:	e8 6f ff ff ff       	call   801037ad <sum>
8010383e:	84 c0                	test   %al,%al
80103840:	75 05                	jne    80103847 <mpsearch1+0x62>
      return (struct mp*)p;
80103842:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103845:	eb 11                	jmp    80103858 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103847:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010384b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010384e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103851:	72 b9                	jb     8010380c <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103853:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103858:	c9                   	leave  
80103859:	c3                   	ret    

8010385a <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
8010385a:	55                   	push   %ebp
8010385b:	89 e5                	mov    %esp,%ebp
8010385d:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103860:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103867:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010386a:	83 c0 0f             	add    $0xf,%eax
8010386d:	0f b6 00             	movzbl (%eax),%eax
80103870:	0f b6 c0             	movzbl %al,%eax
80103873:	89 c2                	mov    %eax,%edx
80103875:	c1 e2 08             	shl    $0x8,%edx
80103878:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010387b:	83 c0 0e             	add    $0xe,%eax
8010387e:	0f b6 00             	movzbl (%eax),%eax
80103881:	0f b6 c0             	movzbl %al,%eax
80103884:	09 d0                	or     %edx,%eax
80103886:	c1 e0 04             	shl    $0x4,%eax
80103889:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010388c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103890:	74 21                	je     801038b3 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103892:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103899:	00 
8010389a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010389d:	89 04 24             	mov    %eax,(%esp)
801038a0:	e8 40 ff ff ff       	call   801037e5 <mpsearch1>
801038a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801038a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801038ac:	74 50                	je     801038fe <mpsearch+0xa4>
      return mp;
801038ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038b1:	eb 5f                	jmp    80103912 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801038b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038b6:	83 c0 14             	add    $0x14,%eax
801038b9:	0f b6 00             	movzbl (%eax),%eax
801038bc:	0f b6 c0             	movzbl %al,%eax
801038bf:	89 c2                	mov    %eax,%edx
801038c1:	c1 e2 08             	shl    $0x8,%edx
801038c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038c7:	83 c0 13             	add    $0x13,%eax
801038ca:	0f b6 00             	movzbl (%eax),%eax
801038cd:	0f b6 c0             	movzbl %al,%eax
801038d0:	09 d0                	or     %edx,%eax
801038d2:	c1 e0 0a             	shl    $0xa,%eax
801038d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
801038d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038db:	2d 00 04 00 00       	sub    $0x400,%eax
801038e0:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
801038e7:	00 
801038e8:	89 04 24             	mov    %eax,(%esp)
801038eb:	e8 f5 fe ff ff       	call   801037e5 <mpsearch1>
801038f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
801038f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801038f7:	74 05                	je     801038fe <mpsearch+0xa4>
      return mp;
801038f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038fc:	eb 14                	jmp    80103912 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
801038fe:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103905:	00 
80103906:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
8010390d:	e8 d3 fe ff ff       	call   801037e5 <mpsearch1>
}
80103912:	c9                   	leave  
80103913:	c3                   	ret    

80103914 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103914:	55                   	push   %ebp
80103915:	89 e5                	mov    %esp,%ebp
80103917:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010391a:	e8 3b ff ff ff       	call   8010385a <mpsearch>
8010391f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103922:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103926:	74 0a                	je     80103932 <mpconfig+0x1e>
80103928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010392b:	8b 40 04             	mov    0x4(%eax),%eax
8010392e:	85 c0                	test   %eax,%eax
80103930:	75 0a                	jne    8010393c <mpconfig+0x28>
    return 0;
80103932:	b8 00 00 00 00       	mov    $0x0,%eax
80103937:	e9 83 00 00 00       	jmp    801039bf <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
8010393c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010393f:	8b 40 04             	mov    0x4(%eax),%eax
80103942:	89 04 24             	mov    %eax,(%esp)
80103945:	e8 ee fd ff ff       	call   80103738 <p2v>
8010394a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010394d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103954:	00 
80103955:	c7 44 24 04 a9 86 10 	movl   $0x801086a9,0x4(%esp)
8010395c:	80 
8010395d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103960:	89 04 24             	mov    %eax,(%esp)
80103963:	e8 ad 15 00 00       	call   80104f15 <memcmp>
80103968:	85 c0                	test   %eax,%eax
8010396a:	74 07                	je     80103973 <mpconfig+0x5f>
    return 0;
8010396c:	b8 00 00 00 00       	mov    $0x0,%eax
80103971:	eb 4c                	jmp    801039bf <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103973:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103976:	0f b6 40 06          	movzbl 0x6(%eax),%eax
8010397a:	3c 01                	cmp    $0x1,%al
8010397c:	74 12                	je     80103990 <mpconfig+0x7c>
8010397e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103981:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103985:	3c 04                	cmp    $0x4,%al
80103987:	74 07                	je     80103990 <mpconfig+0x7c>
    return 0;
80103989:	b8 00 00 00 00       	mov    $0x0,%eax
8010398e:	eb 2f                	jmp    801039bf <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103990:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103993:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103997:	0f b7 c0             	movzwl %ax,%eax
8010399a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010399e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039a1:	89 04 24             	mov    %eax,(%esp)
801039a4:	e8 04 fe ff ff       	call   801037ad <sum>
801039a9:	84 c0                	test   %al,%al
801039ab:	74 07                	je     801039b4 <mpconfig+0xa0>
    return 0;
801039ad:	b8 00 00 00 00       	mov    $0x0,%eax
801039b2:	eb 0b                	jmp    801039bf <mpconfig+0xab>
  *pmp = mp;
801039b4:	8b 45 08             	mov    0x8(%ebp),%eax
801039b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801039ba:	89 10                	mov    %edx,(%eax)
  return conf;
801039bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801039bf:	c9                   	leave  
801039c0:	c3                   	ret    

801039c1 <mpinit>:

void
mpinit(void)
{
801039c1:	55                   	push   %ebp
801039c2:	89 e5                	mov    %esp,%ebp
801039c4:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
801039c7:	c7 05 44 b6 10 80 20 	movl   $0x8010f920,0x8010b644
801039ce:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
801039d1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801039d4:	89 04 24             	mov    %eax,(%esp)
801039d7:	e8 38 ff ff ff       	call   80103914 <mpconfig>
801039dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801039df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801039e3:	0f 84 9c 01 00 00    	je     80103b85 <mpinit+0x1c4>
    return;
  ismp = 1;
801039e9:	c7 05 04 f9 10 80 01 	movl   $0x1,0x8010f904
801039f0:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801039f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039f6:	8b 40 24             	mov    0x24(%eax),%eax
801039f9:	a3 7c f8 10 80       	mov    %eax,0x8010f87c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a01:	83 c0 2c             	add    $0x2c,%eax
80103a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a0a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103a0e:	0f b7 d0             	movzwl %ax,%edx
80103a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a14:	01 d0                	add    %edx,%eax
80103a16:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a19:	e9 f4 00 00 00       	jmp    80103b12 <mpinit+0x151>
    switch(*p){
80103a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a21:	0f b6 00             	movzbl (%eax),%eax
80103a24:	0f b6 c0             	movzbl %al,%eax
80103a27:	83 f8 04             	cmp    $0x4,%eax
80103a2a:	0f 87 bf 00 00 00    	ja     80103aef <mpinit+0x12e>
80103a30:	8b 04 85 ec 86 10 80 	mov    -0x7fef7914(,%eax,4),%eax
80103a37:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103a42:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103a46:	0f b6 d0             	movzbl %al,%edx
80103a49:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103a4e:	39 c2                	cmp    %eax,%edx
80103a50:	74 2d                	je     80103a7f <mpinit+0xbe>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103a52:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103a55:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103a59:	0f b6 d0             	movzbl %al,%edx
80103a5c:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103a61:	89 54 24 08          	mov    %edx,0x8(%esp)
80103a65:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a69:	c7 04 24 ae 86 10 80 	movl   $0x801086ae,(%esp)
80103a70:	e8 35 c9 ff ff       	call   801003aa <cprintf>
        ismp = 0;
80103a75:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
80103a7c:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103a82:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103a86:	0f b6 c0             	movzbl %al,%eax
80103a89:	83 e0 02             	and    $0x2,%eax
80103a8c:	85 c0                	test   %eax,%eax
80103a8e:	74 15                	je     80103aa5 <mpinit+0xe4>
        bcpu = &cpus[ncpu];
80103a90:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103a95:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a9b:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103aa0:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103aa5:	8b 15 00 ff 10 80    	mov    0x8010ff00,%edx
80103aab:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103ab0:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103ab6:	81 c2 20 f9 10 80    	add    $0x8010f920,%edx
80103abc:	88 02                	mov    %al,(%edx)
      ncpu++;
80103abe:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103ac3:	83 c0 01             	add    $0x1,%eax
80103ac6:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
      p += sizeof(struct mpproc);
80103acb:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103acf:	eb 41                	jmp    80103b12 <mpinit+0x151>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ad4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103ad7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ada:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ade:	a2 00 f9 10 80       	mov    %al,0x8010f900
      p += sizeof(struct mpioapic);
80103ae3:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ae7:	eb 29                	jmp    80103b12 <mpinit+0x151>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103ae9:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103aed:	eb 23                	jmp    80103b12 <mpinit+0x151>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af2:	0f b6 00             	movzbl (%eax),%eax
80103af5:	0f b6 c0             	movzbl %al,%eax
80103af8:	89 44 24 04          	mov    %eax,0x4(%esp)
80103afc:	c7 04 24 cc 86 10 80 	movl   $0x801086cc,(%esp)
80103b03:	e8 a2 c8 ff ff       	call   801003aa <cprintf>
      ismp = 0;
80103b08:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
80103b0f:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b15:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103b18:	0f 82 00 ff ff ff    	jb     80103a1e <mpinit+0x5d>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103b1e:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103b23:	85 c0                	test   %eax,%eax
80103b25:	75 1d                	jne    80103b44 <mpinit+0x183>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103b27:	c7 05 00 ff 10 80 01 	movl   $0x1,0x8010ff00
80103b2e:	00 00 00 
    lapic = 0;
80103b31:	c7 05 7c f8 10 80 00 	movl   $0x0,0x8010f87c
80103b38:	00 00 00 
    ioapicid = 0;
80103b3b:	c6 05 00 f9 10 80 00 	movb   $0x0,0x8010f900
80103b42:	eb 41                	jmp    80103b85 <mpinit+0x1c4>
    return;
  }

  if(mp->imcrp){
80103b44:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103b47:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103b4b:	84 c0                	test   %al,%al
80103b4d:	74 36                	je     80103b85 <mpinit+0x1c4>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103b4f:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103b56:	00 
80103b57:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103b5e:	e8 0c fc ff ff       	call   8010376f <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103b63:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103b6a:	e8 d6 fb ff ff       	call   80103745 <inb>
80103b6f:	83 c8 01             	or     $0x1,%eax
80103b72:	0f b6 c0             	movzbl %al,%eax
80103b75:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b79:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103b80:	e8 ea fb ff ff       	call   8010376f <outb>
  }
}
80103b85:	c9                   	leave  
80103b86:	c3                   	ret    
80103b87:	90                   	nop

80103b88 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b88:	55                   	push   %ebp
80103b89:	89 e5                	mov    %esp,%ebp
80103b8b:	83 ec 08             	sub    $0x8,%esp
80103b8e:	8b 55 08             	mov    0x8(%ebp),%edx
80103b91:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b94:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b98:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b9b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b9f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103ba3:	ee                   	out    %al,(%dx)
}
80103ba4:	c9                   	leave  
80103ba5:	c3                   	ret    

80103ba6 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103ba6:	55                   	push   %ebp
80103ba7:	89 e5                	mov    %esp,%ebp
80103ba9:	83 ec 0c             	sub    $0xc,%esp
80103bac:	8b 45 08             	mov    0x8(%ebp),%eax
80103baf:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103bb3:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103bb7:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103bbd:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103bc1:	0f b6 c0             	movzbl %al,%eax
80103bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bc8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103bcf:	e8 b4 ff ff ff       	call   80103b88 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103bd4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103bd8:	66 c1 e8 08          	shr    $0x8,%ax
80103bdc:	0f b6 c0             	movzbl %al,%eax
80103bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
80103be3:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bea:	e8 99 ff ff ff       	call   80103b88 <outb>
}
80103bef:	c9                   	leave  
80103bf0:	c3                   	ret    

80103bf1 <picenable>:

void
picenable(int irq)
{
80103bf1:	55                   	push   %ebp
80103bf2:	89 e5                	mov    %esp,%ebp
80103bf4:	53                   	push   %ebx
80103bf5:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103bf8:	8b 45 08             	mov    0x8(%ebp),%eax
80103bfb:	ba 01 00 00 00       	mov    $0x1,%edx
80103c00:	89 d3                	mov    %edx,%ebx
80103c02:	89 c1                	mov    %eax,%ecx
80103c04:	d3 e3                	shl    %cl,%ebx
80103c06:	89 d8                	mov    %ebx,%eax
80103c08:	89 c2                	mov    %eax,%edx
80103c0a:	f7 d2                	not    %edx
80103c0c:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c13:	21 d0                	and    %edx,%eax
80103c15:	0f b7 c0             	movzwl %ax,%eax
80103c18:	89 04 24             	mov    %eax,(%esp)
80103c1b:	e8 86 ff ff ff       	call   80103ba6 <picsetmask>
}
80103c20:	83 c4 04             	add    $0x4,%esp
80103c23:	5b                   	pop    %ebx
80103c24:	5d                   	pop    %ebp
80103c25:	c3                   	ret    

80103c26 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103c26:	55                   	push   %ebp
80103c27:	89 e5                	mov    %esp,%ebp
80103c29:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103c2c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103c33:	00 
80103c34:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103c3b:	e8 48 ff ff ff       	call   80103b88 <outb>
  outb(IO_PIC2+1, 0xFF);
80103c40:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103c47:	00 
80103c48:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103c4f:	e8 34 ff ff ff       	call   80103b88 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103c54:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103c5b:	00 
80103c5c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103c63:	e8 20 ff ff ff       	call   80103b88 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103c68:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103c6f:	00 
80103c70:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103c77:	e8 0c ff ff ff       	call   80103b88 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103c7c:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103c83:	00 
80103c84:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103c8b:	e8 f8 fe ff ff       	call   80103b88 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103c90:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103c97:	00 
80103c98:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103c9f:	e8 e4 fe ff ff       	call   80103b88 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103ca4:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103cab:	00 
80103cac:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103cb3:	e8 d0 fe ff ff       	call   80103b88 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103cb8:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103cbf:	00 
80103cc0:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103cc7:	e8 bc fe ff ff       	call   80103b88 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103ccc:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103cd3:	00 
80103cd4:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103cdb:	e8 a8 fe ff ff       	call   80103b88 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103ce0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103ce7:	00 
80103ce8:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103cef:	e8 94 fe ff ff       	call   80103b88 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103cf4:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103cfb:	00 
80103cfc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103d03:	e8 80 fe ff ff       	call   80103b88 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103d08:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103d0f:	00 
80103d10:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103d17:	e8 6c fe ff ff       	call   80103b88 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103d1c:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103d23:	00 
80103d24:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103d2b:	e8 58 fe ff ff       	call   80103b88 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103d30:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103d37:	00 
80103d38:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103d3f:	e8 44 fe ff ff       	call   80103b88 <outb>

  if(irqmask != 0xFFFF)
80103d44:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103d4b:	66 83 f8 ff          	cmp    $0xffff,%ax
80103d4f:	74 12                	je     80103d63 <picinit+0x13d>
    picsetmask(irqmask);
80103d51:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103d58:	0f b7 c0             	movzwl %ax,%eax
80103d5b:	89 04 24             	mov    %eax,(%esp)
80103d5e:	e8 43 fe ff ff       	call   80103ba6 <picsetmask>
}
80103d63:	c9                   	leave  
80103d64:	c3                   	ret    
80103d65:	66 90                	xchg   %ax,%ax
80103d67:	90                   	nop

80103d68 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103d68:	55                   	push   %ebp
80103d69:	89 e5                	mov    %esp,%ebp
80103d6b:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103d6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103d75:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d81:	8b 10                	mov    (%eax),%edx
80103d83:	8b 45 08             	mov    0x8(%ebp),%eax
80103d86:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103d88:	e8 af d1 ff ff       	call   80100f3c <filealloc>
80103d8d:	8b 55 08             	mov    0x8(%ebp),%edx
80103d90:	89 02                	mov    %eax,(%edx)
80103d92:	8b 45 08             	mov    0x8(%ebp),%eax
80103d95:	8b 00                	mov    (%eax),%eax
80103d97:	85 c0                	test   %eax,%eax
80103d99:	0f 84 c8 00 00 00    	je     80103e67 <pipealloc+0xff>
80103d9f:	e8 98 d1 ff ff       	call   80100f3c <filealloc>
80103da4:	8b 55 0c             	mov    0xc(%ebp),%edx
80103da7:	89 02                	mov    %eax,(%edx)
80103da9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dac:	8b 00                	mov    (%eax),%eax
80103dae:	85 c0                	test   %eax,%eax
80103db0:	0f 84 b1 00 00 00    	je     80103e67 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103db6:	e8 c4 ee ff ff       	call   80102c7f <kalloc>
80103dbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103dbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103dc2:	0f 84 9e 00 00 00    	je     80103e66 <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
80103dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dcb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103dd2:	00 00 00 
  p->writeopen = 1;
80103dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dd8:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ddf:	00 00 00 
  p->nwrite = 0;
80103de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103de5:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103dec:	00 00 00 
  p->nread = 0;
80103def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103df2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103df9:	00 00 00 
  initlock(&p->lock, "pipe");
80103dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dff:	c7 44 24 04 00 87 10 	movl   $0x80108700,0x4(%esp)
80103e06:	80 
80103e07:	89 04 24             	mov    %eax,(%esp)
80103e0a:	e8 13 0e 00 00       	call   80104c22 <initlock>
  (*f0)->type = FD_PIPE;
80103e0f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e12:	8b 00                	mov    (%eax),%eax
80103e14:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103e1a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e1d:	8b 00                	mov    (%eax),%eax
80103e1f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103e23:	8b 45 08             	mov    0x8(%ebp),%eax
80103e26:	8b 00                	mov    (%eax),%eax
80103e28:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2f:	8b 00                	mov    (%eax),%eax
80103e31:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e34:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103e37:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e3a:	8b 00                	mov    (%eax),%eax
80103e3c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103e42:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e45:	8b 00                	mov    (%eax),%eax
80103e47:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e4e:	8b 00                	mov    (%eax),%eax
80103e50:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103e54:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e57:	8b 00                	mov    (%eax),%eax
80103e59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e5c:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103e5f:	b8 00 00 00 00       	mov    $0x0,%eax
80103e64:	eb 43                	jmp    80103ea9 <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103e66:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103e67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e6b:	74 0b                	je     80103e78 <pipealloc+0x110>
    kfree((char*)p);
80103e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e70:	89 04 24             	mov    %eax,(%esp)
80103e73:	e8 6e ed ff ff       	call   80102be6 <kfree>
  if(*f0)
80103e78:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7b:	8b 00                	mov    (%eax),%eax
80103e7d:	85 c0                	test   %eax,%eax
80103e7f:	74 0d                	je     80103e8e <pipealloc+0x126>
    fileclose(*f0);
80103e81:	8b 45 08             	mov    0x8(%ebp),%eax
80103e84:	8b 00                	mov    (%eax),%eax
80103e86:	89 04 24             	mov    %eax,(%esp)
80103e89:	e8 56 d1 ff ff       	call   80100fe4 <fileclose>
  if(*f1)
80103e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e91:	8b 00                	mov    (%eax),%eax
80103e93:	85 c0                	test   %eax,%eax
80103e95:	74 0d                	je     80103ea4 <pipealloc+0x13c>
    fileclose(*f1);
80103e97:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e9a:	8b 00                	mov    (%eax),%eax
80103e9c:	89 04 24             	mov    %eax,(%esp)
80103e9f:	e8 40 d1 ff ff       	call   80100fe4 <fileclose>
  return -1;
80103ea4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ea9:	c9                   	leave  
80103eaa:	c3                   	ret    

80103eab <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103eab:	55                   	push   %ebp
80103eac:	89 e5                	mov    %esp,%ebp
80103eae:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103eb1:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb4:	89 04 24             	mov    %eax,(%esp)
80103eb7:	e8 87 0d 00 00       	call   80104c43 <acquire>
  if(writable){
80103ebc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103ec0:	74 1f                	je     80103ee1 <pipeclose+0x36>
    p->writeopen = 0;
80103ec2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec5:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103ecc:	00 00 00 
    wakeup(&p->nread);
80103ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed2:	05 34 02 00 00       	add    $0x234,%eax
80103ed7:	89 04 24             	mov    %eax,(%esp)
80103eda:	e8 5b 0b 00 00       	call   80104a3a <wakeup>
80103edf:	eb 1d                	jmp    80103efe <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103ee1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee4:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103eeb:	00 00 00 
    wakeup(&p->nwrite);
80103eee:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef1:	05 38 02 00 00       	add    $0x238,%eax
80103ef6:	89 04 24             	mov    %eax,(%esp)
80103ef9:	e8 3c 0b 00 00       	call   80104a3a <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103efe:	8b 45 08             	mov    0x8(%ebp),%eax
80103f01:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103f07:	85 c0                	test   %eax,%eax
80103f09:	75 25                	jne    80103f30 <pipeclose+0x85>
80103f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f0e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f14:	85 c0                	test   %eax,%eax
80103f16:	75 18                	jne    80103f30 <pipeclose+0x85>
    release(&p->lock);
80103f18:	8b 45 08             	mov    0x8(%ebp),%eax
80103f1b:	89 04 24             	mov    %eax,(%esp)
80103f1e:	e8 82 0d 00 00       	call   80104ca5 <release>
    kfree((char*)p);
80103f23:	8b 45 08             	mov    0x8(%ebp),%eax
80103f26:	89 04 24             	mov    %eax,(%esp)
80103f29:	e8 b8 ec ff ff       	call   80102be6 <kfree>
80103f2e:	eb 0b                	jmp    80103f3b <pipeclose+0x90>
  } else
    release(&p->lock);
80103f30:	8b 45 08             	mov    0x8(%ebp),%eax
80103f33:	89 04 24             	mov    %eax,(%esp)
80103f36:	e8 6a 0d 00 00       	call   80104ca5 <release>
}
80103f3b:	c9                   	leave  
80103f3c:	c3                   	ret    

80103f3d <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103f3d:	55                   	push   %ebp
80103f3e:	89 e5                	mov    %esp,%ebp
80103f40:	53                   	push   %ebx
80103f41:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103f44:	8b 45 08             	mov    0x8(%ebp),%eax
80103f47:	89 04 24             	mov    %eax,(%esp)
80103f4a:	e8 f4 0c 00 00       	call   80104c43 <acquire>
  for(i = 0; i < n; i++){
80103f4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f56:	e9 a8 00 00 00       	jmp    80104003 <pipewrite+0xc6>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103f5b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f5e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103f64:	85 c0                	test   %eax,%eax
80103f66:	74 0d                	je     80103f75 <pipewrite+0x38>
80103f68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f6e:	8b 40 24             	mov    0x24(%eax),%eax
80103f71:	85 c0                	test   %eax,%eax
80103f73:	74 15                	je     80103f8a <pipewrite+0x4d>
        release(&p->lock);
80103f75:	8b 45 08             	mov    0x8(%ebp),%eax
80103f78:	89 04 24             	mov    %eax,(%esp)
80103f7b:	e8 25 0d 00 00       	call   80104ca5 <release>
        return -1;
80103f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f85:	e9 9f 00 00 00       	jmp    80104029 <pipewrite+0xec>
      }
      wakeup(&p->nread);
80103f8a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8d:	05 34 02 00 00       	add    $0x234,%eax
80103f92:	89 04 24             	mov    %eax,(%esp)
80103f95:	e8 a0 0a 00 00       	call   80104a3a <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f9d:	8b 55 08             	mov    0x8(%ebp),%edx
80103fa0:	81 c2 38 02 00 00    	add    $0x238,%edx
80103fa6:	89 44 24 04          	mov    %eax,0x4(%esp)
80103faa:	89 14 24             	mov    %edx,(%esp)
80103fad:	e8 ac 09 00 00       	call   8010495e <sleep>
80103fb2:	eb 01                	jmp    80103fb5 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103fb4:	90                   	nop
80103fb5:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb8:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103fbe:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc1:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103fc7:	05 00 02 00 00       	add    $0x200,%eax
80103fcc:	39 c2                	cmp    %eax,%edx
80103fce:	74 8b                	je     80103f5b <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd3:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103fd9:	89 c3                	mov    %eax,%ebx
80103fdb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103fe1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103fe4:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fe7:	01 ca                	add    %ecx,%edx
80103fe9:	0f b6 0a             	movzbl (%edx),%ecx
80103fec:	8b 55 08             	mov    0x8(%ebp),%edx
80103fef:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103ff3:	8d 50 01             	lea    0x1(%eax),%edx
80103ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff9:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103fff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104006:	3b 45 10             	cmp    0x10(%ebp),%eax
80104009:	7c a9                	jl     80103fb4 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010400b:	8b 45 08             	mov    0x8(%ebp),%eax
8010400e:	05 34 02 00 00       	add    $0x234,%eax
80104013:	89 04 24             	mov    %eax,(%esp)
80104016:	e8 1f 0a 00 00       	call   80104a3a <wakeup>
  release(&p->lock);
8010401b:	8b 45 08             	mov    0x8(%ebp),%eax
8010401e:	89 04 24             	mov    %eax,(%esp)
80104021:	e8 7f 0c 00 00       	call   80104ca5 <release>
  return n;
80104026:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104029:	83 c4 24             	add    $0x24,%esp
8010402c:	5b                   	pop    %ebx
8010402d:	5d                   	pop    %ebp
8010402e:	c3                   	ret    

8010402f <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010402f:	55                   	push   %ebp
80104030:	89 e5                	mov    %esp,%ebp
80104032:	53                   	push   %ebx
80104033:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104036:	8b 45 08             	mov    0x8(%ebp),%eax
80104039:	89 04 24             	mov    %eax,(%esp)
8010403c:	e8 02 0c 00 00       	call   80104c43 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104041:	eb 3a                	jmp    8010407d <piperead+0x4e>
    if(proc->killed){
80104043:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104049:	8b 40 24             	mov    0x24(%eax),%eax
8010404c:	85 c0                	test   %eax,%eax
8010404e:	74 15                	je     80104065 <piperead+0x36>
      release(&p->lock);
80104050:	8b 45 08             	mov    0x8(%ebp),%eax
80104053:	89 04 24             	mov    %eax,(%esp)
80104056:	e8 4a 0c 00 00       	call   80104ca5 <release>
      return -1;
8010405b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104060:	e9 b7 00 00 00       	jmp    8010411c <piperead+0xed>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104065:	8b 45 08             	mov    0x8(%ebp),%eax
80104068:	8b 55 08             	mov    0x8(%ebp),%edx
8010406b:	81 c2 34 02 00 00    	add    $0x234,%edx
80104071:	89 44 24 04          	mov    %eax,0x4(%esp)
80104075:	89 14 24             	mov    %edx,(%esp)
80104078:	e8 e1 08 00 00       	call   8010495e <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010407d:	8b 45 08             	mov    0x8(%ebp),%eax
80104080:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104086:	8b 45 08             	mov    0x8(%ebp),%eax
80104089:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010408f:	39 c2                	cmp    %eax,%edx
80104091:	75 0d                	jne    801040a0 <piperead+0x71>
80104093:	8b 45 08             	mov    0x8(%ebp),%eax
80104096:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010409c:	85 c0                	test   %eax,%eax
8010409e:	75 a3                	jne    80104043 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801040a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801040a7:	eb 4a                	jmp    801040f3 <piperead+0xc4>
    if(p->nread == p->nwrite)
801040a9:	8b 45 08             	mov    0x8(%ebp),%eax
801040ac:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801040b2:	8b 45 08             	mov    0x8(%ebp),%eax
801040b5:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801040bb:	39 c2                	cmp    %eax,%edx
801040bd:	74 3e                	je     801040fd <piperead+0xce>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801040bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801040c8:	8b 45 08             	mov    0x8(%ebp),%eax
801040cb:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801040d1:	89 c3                	mov    %eax,%ebx
801040d3:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801040d9:	8b 55 08             	mov    0x8(%ebp),%edx
801040dc:	0f b6 54 1a 34       	movzbl 0x34(%edx,%ebx,1),%edx
801040e1:	88 11                	mov    %dl,(%ecx)
801040e3:	8d 50 01             	lea    0x1(%eax),%edx
801040e6:	8b 45 08             	mov    0x8(%ebp),%eax
801040e9:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801040ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801040f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f6:	3b 45 10             	cmp    0x10(%ebp),%eax
801040f9:	7c ae                	jl     801040a9 <piperead+0x7a>
801040fb:	eb 01                	jmp    801040fe <piperead+0xcf>
    if(p->nread == p->nwrite)
      break;
801040fd:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801040fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104101:	05 38 02 00 00       	add    $0x238,%eax
80104106:	89 04 24             	mov    %eax,(%esp)
80104109:	e8 2c 09 00 00       	call   80104a3a <wakeup>
  release(&p->lock);
8010410e:	8b 45 08             	mov    0x8(%ebp),%eax
80104111:	89 04 24             	mov    %eax,(%esp)
80104114:	e8 8c 0b 00 00       	call   80104ca5 <release>
  return i;
80104119:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010411c:	83 c4 24             	add    $0x24,%esp
8010411f:	5b                   	pop    %ebx
80104120:	5d                   	pop    %ebp
80104121:	c3                   	ret    
80104122:	66 90                	xchg   %ax,%ax

80104124 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104124:	55                   	push   %ebp
80104125:	89 e5                	mov    %esp,%ebp
80104127:	53                   	push   %ebx
80104128:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010412b:	9c                   	pushf  
8010412c:	5b                   	pop    %ebx
8010412d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104130:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104133:	83 c4 10             	add    $0x10,%esp
80104136:	5b                   	pop    %ebx
80104137:	5d                   	pop    %ebp
80104138:	c3                   	ret    

80104139 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104139:	55                   	push   %ebp
8010413a:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010413c:	fb                   	sti    
}
8010413d:	5d                   	pop    %ebp
8010413e:	c3                   	ret    

8010413f <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010413f:	55                   	push   %ebp
80104140:	89 e5                	mov    %esp,%ebp
80104142:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104145:	c7 44 24 04 05 87 10 	movl   $0x80108705,0x4(%esp)
8010414c:	80 
8010414d:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104154:	e8 c9 0a 00 00       	call   80104c22 <initlock>
}
80104159:	c9                   	leave  
8010415a:	c3                   	ret    

8010415b <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010415b:	55                   	push   %ebp
8010415c:	89 e5                	mov    %esp,%ebp
8010415e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104161:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104168:	e8 d6 0a 00 00       	call   80104c43 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010416d:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104174:	eb 11                	jmp    80104187 <allocproc+0x2c>
    if(p->state == UNUSED)
80104176:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104179:	8b 40 0c             	mov    0xc(%eax),%eax
8010417c:	85 c0                	test   %eax,%eax
8010417e:	74 26                	je     801041a6 <allocproc+0x4b>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104180:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104187:	81 7d f4 54 21 11 80 	cmpl   $0x80112154,-0xc(%ebp)
8010418e:	72 e6                	jb     80104176 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104190:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104197:	e8 09 0b 00 00       	call   80104ca5 <release>
  return 0;
8010419c:	b8 00 00 00 00       	mov    $0x0,%eax
801041a1:	e9 b5 00 00 00       	jmp    8010425b <allocproc+0x100>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
801041a6:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801041a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041aa:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801041b1:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801041b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041b9:	89 42 10             	mov    %eax,0x10(%edx)
801041bc:	83 c0 01             	add    $0x1,%eax
801041bf:	a3 04 b0 10 80       	mov    %eax,0x8010b004
  release(&ptable.lock);
801041c4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801041cb:	e8 d5 0a 00 00       	call   80104ca5 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801041d0:	e8 aa ea ff ff       	call   80102c7f <kalloc>
801041d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041d8:	89 42 08             	mov    %eax,0x8(%edx)
801041db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041de:	8b 40 08             	mov    0x8(%eax),%eax
801041e1:	85 c0                	test   %eax,%eax
801041e3:	75 11                	jne    801041f6 <allocproc+0x9b>
    p->state = UNUSED;
801041e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801041ef:	b8 00 00 00 00       	mov    $0x0,%eax
801041f4:	eb 65                	jmp    8010425b <allocproc+0x100>
  }
  sp = p->kstack + KSTACKSIZE;
801041f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f9:	8b 40 08             	mov    0x8(%eax),%eax
801041fc:	05 00 10 00 00       	add    $0x1000,%eax
80104201:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104204:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104208:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010420b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010420e:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104211:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104215:	ba 8c 63 10 80       	mov    $0x8010638c,%edx
8010421a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010421d:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010421f:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104223:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104226:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104229:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010422c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104232:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104239:	00 
8010423a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104241:	00 
80104242:	89 04 24             	mov    %eax,(%esp)
80104245:	e8 54 0c 00 00       	call   80104e9e <memset>
  p->context->eip = (uint)forkret;
8010424a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104250:	ba 32 49 10 80       	mov    $0x80104932,%edx
80104255:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104258:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010425b:	c9                   	leave  
8010425c:	c3                   	ret    

8010425d <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010425d:	55                   	push   %ebp
8010425e:	89 e5                	mov    %esp,%ebp
80104260:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104263:	e8 f3 fe ff ff       	call   8010415b <allocproc>
80104268:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010426b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426e:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
80104273:	e8 53 39 00 00       	call   80107bcb <setupkvm>
80104278:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010427b:	89 42 04             	mov    %eax,0x4(%edx)
8010427e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104281:	8b 40 04             	mov    0x4(%eax),%eax
80104284:	85 c0                	test   %eax,%eax
80104286:	75 0c                	jne    80104294 <userinit+0x37>
    panic("userinit: out of memory?");
80104288:	c7 04 24 0c 87 10 80 	movl   $0x8010870c,(%esp)
8010428f:	e8 b2 c2 ff ff       	call   80100546 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104294:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104299:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010429c:	8b 40 04             	mov    0x4(%eax),%eax
8010429f:	89 54 24 08          	mov    %edx,0x8(%esp)
801042a3:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
801042aa:	80 
801042ab:	89 04 24             	mov    %eax,(%esp)
801042ae:	e8 70 3b 00 00       	call   80107e23 <inituvm>
  p->sz = PGSIZE;
801042b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b6:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801042bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042bf:	8b 40 18             	mov    0x18(%eax),%eax
801042c2:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801042c9:	00 
801042ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801042d1:	00 
801042d2:	89 04 24             	mov    %eax,(%esp)
801042d5:	e8 c4 0b 00 00       	call   80104e9e <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042dd:	8b 40 18             	mov    0x18(%eax),%eax
801042e0:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e9:	8b 40 18             	mov    0x18(%eax),%eax
801042ec:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801042f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f5:	8b 40 18             	mov    0x18(%eax),%eax
801042f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042fb:	8b 52 18             	mov    0x18(%edx),%edx
801042fe:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104302:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104309:	8b 40 18             	mov    0x18(%eax),%eax
8010430c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010430f:	8b 52 18             	mov    0x18(%edx),%edx
80104312:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104316:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010431a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010431d:	8b 40 18             	mov    0x18(%eax),%eax
80104320:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104327:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432a:	8b 40 18             	mov    0x18(%eax),%eax
8010432d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104337:	8b 40 18             	mov    0x18(%eax),%eax
8010433a:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104341:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104344:	83 c0 6c             	add    $0x6c,%eax
80104347:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010434e:	00 
8010434f:	c7 44 24 04 25 87 10 	movl   $0x80108725,0x4(%esp)
80104356:	80 
80104357:	89 04 24             	mov    %eax,(%esp)
8010435a:	e8 6f 0d 00 00       	call   801050ce <safestrcpy>
  p->cwd = namei("/");
8010435f:	c7 04 24 2e 87 10 80 	movl   $0x8010872e,(%esp)
80104366:	e8 1f e2 ff ff       	call   8010258a <namei>
8010436b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010436e:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104371:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104374:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
8010437b:	c9                   	leave  
8010437c:	c3                   	ret    

8010437d <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010437d:	55                   	push   %ebp
8010437e:	89 e5                	mov    %esp,%ebp
80104380:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104383:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104389:	8b 00                	mov    (%eax),%eax
8010438b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010438e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104392:	7e 34                	jle    801043c8 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104394:	8b 55 08             	mov    0x8(%ebp),%edx
80104397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010439a:	01 c2                	add    %eax,%edx
8010439c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043a2:	8b 40 04             	mov    0x4(%eax),%eax
801043a5:	89 54 24 08          	mov    %edx,0x8(%esp)
801043a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043ac:	89 54 24 04          	mov    %edx,0x4(%esp)
801043b0:	89 04 24             	mov    %eax,(%esp)
801043b3:	e8 e5 3b 00 00       	call   80107f9d <allocuvm>
801043b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043bf:	75 41                	jne    80104402 <growproc+0x85>
      return -1;
801043c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043c6:	eb 58                	jmp    80104420 <growproc+0xa3>
  } else if(n < 0){
801043c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801043cc:	79 34                	jns    80104402 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801043ce:	8b 55 08             	mov    0x8(%ebp),%edx
801043d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043d4:	01 c2                	add    %eax,%edx
801043d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043dc:	8b 40 04             	mov    0x4(%eax),%eax
801043df:	89 54 24 08          	mov    %edx,0x8(%esp)
801043e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043e6:	89 54 24 04          	mov    %edx,0x4(%esp)
801043ea:	89 04 24             	mov    %eax,(%esp)
801043ed:	e8 85 3c 00 00       	call   80108077 <deallocuvm>
801043f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043f9:	75 07                	jne    80104402 <growproc+0x85>
      return -1;
801043fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104400:	eb 1e                	jmp    80104420 <growproc+0xa3>
  }
  proc->sz = sz;
80104402:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104408:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010440b:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
8010440d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104413:	89 04 24             	mov    %eax,(%esp)
80104416:	e8 a1 38 00 00       	call   80107cbc <switchuvm>
  return 0;
8010441b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104420:	c9                   	leave  
80104421:	c3                   	ret    

80104422 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104422:	55                   	push   %ebp
80104423:	89 e5                	mov    %esp,%ebp
80104425:	57                   	push   %edi
80104426:	56                   	push   %esi
80104427:	53                   	push   %ebx
80104428:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010442b:	e8 2b fd ff ff       	call   8010415b <allocproc>
80104430:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104433:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104437:	75 0a                	jne    80104443 <fork+0x21>
    return -1;
80104439:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010443e:	e9 3a 01 00 00       	jmp    8010457d <fork+0x15b>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104443:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104449:	8b 10                	mov    (%eax),%edx
8010444b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104451:	8b 40 04             	mov    0x4(%eax),%eax
80104454:	89 54 24 04          	mov    %edx,0x4(%esp)
80104458:	89 04 24             	mov    %eax,(%esp)
8010445b:	e8 b3 3d 00 00       	call   80108213 <copyuvm>
80104460:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104463:	89 42 04             	mov    %eax,0x4(%edx)
80104466:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104469:	8b 40 04             	mov    0x4(%eax),%eax
8010446c:	85 c0                	test   %eax,%eax
8010446e:	75 2c                	jne    8010449c <fork+0x7a>
    kfree(np->kstack);
80104470:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104473:	8b 40 08             	mov    0x8(%eax),%eax
80104476:	89 04 24             	mov    %eax,(%esp)
80104479:	e8 68 e7 ff ff       	call   80102be6 <kfree>
    np->kstack = 0;
8010447e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104481:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104488:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010448b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104492:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104497:	e9 e1 00 00 00       	jmp    8010457d <fork+0x15b>
  }
  np->sz = proc->sz;
8010449c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044a2:	8b 10                	mov    (%eax),%edx
801044a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044a7:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801044a9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801044b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044b3:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801044b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044b9:	8b 50 18             	mov    0x18(%eax),%edx
801044bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044c2:	8b 40 18             	mov    0x18(%eax),%eax
801044c5:	89 c3                	mov    %eax,%ebx
801044c7:	b8 13 00 00 00       	mov    $0x13,%eax
801044cc:	89 d7                	mov    %edx,%edi
801044ce:	89 de                	mov    %ebx,%esi
801044d0:	89 c1                	mov    %eax,%ecx
801044d2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801044d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044d7:	8b 40 18             	mov    0x18(%eax),%eax
801044da:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801044e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801044e8:	eb 3d                	jmp    80104527 <fork+0x105>
    if(proc->ofile[i])
801044ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801044f3:	83 c2 08             	add    $0x8,%edx
801044f6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044fa:	85 c0                	test   %eax,%eax
801044fc:	74 25                	je     80104523 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
801044fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104504:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104507:	83 c2 08             	add    $0x8,%edx
8010450a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010450e:	89 04 24             	mov    %eax,(%esp)
80104511:	e8 86 ca ff ff       	call   80100f9c <filedup>
80104516:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104519:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010451c:	83 c1 08             	add    $0x8,%ecx
8010451f:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104523:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104527:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010452b:	7e bd                	jle    801044ea <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010452d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104533:	8b 40 68             	mov    0x68(%eax),%eax
80104536:	89 04 24             	mov    %eax,(%esp)
80104539:	e8 1c d3 ff ff       	call   8010185a <idup>
8010453e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104541:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
80104544:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104547:	8b 40 10             	mov    0x10(%eax),%eax
8010454a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
8010454d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104550:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104557:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010455d:	8d 50 6c             	lea    0x6c(%eax),%edx
80104560:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104563:	83 c0 6c             	add    $0x6c,%eax
80104566:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010456d:	00 
8010456e:	89 54 24 04          	mov    %edx,0x4(%esp)
80104572:	89 04 24             	mov    %eax,(%esp)
80104575:	e8 54 0b 00 00       	call   801050ce <safestrcpy>
  return pid;
8010457a:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
8010457d:	83 c4 2c             	add    $0x2c,%esp
80104580:	5b                   	pop    %ebx
80104581:	5e                   	pop    %esi
80104582:	5f                   	pop    %edi
80104583:	5d                   	pop    %ebp
80104584:	c3                   	ret    

80104585 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104585:	55                   	push   %ebp
80104586:	89 e5                	mov    %esp,%ebp
80104588:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
8010458b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104592:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104597:	39 c2                	cmp    %eax,%edx
80104599:	75 0c                	jne    801045a7 <exit+0x22>
    panic("init exiting");
8010459b:	c7 04 24 30 87 10 80 	movl   $0x80108730,(%esp)
801045a2:	e8 9f bf ff ff       	call   80100546 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801045a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801045ae:	eb 44                	jmp    801045f4 <exit+0x6f>
    if(proc->ofile[fd]){
801045b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045b9:	83 c2 08             	add    $0x8,%edx
801045bc:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045c0:	85 c0                	test   %eax,%eax
801045c2:	74 2c                	je     801045f0 <exit+0x6b>
      fileclose(proc->ofile[fd]);
801045c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045cd:	83 c2 08             	add    $0x8,%edx
801045d0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045d4:	89 04 24             	mov    %eax,(%esp)
801045d7:	e8 08 ca ff ff       	call   80100fe4 <fileclose>
      proc->ofile[fd] = 0;
801045dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045e5:	83 c2 08             	add    $0x8,%edx
801045e8:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801045ef:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801045f0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801045f4:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801045f8:	7e b6                	jle    801045b0 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
801045fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104600:	8b 40 68             	mov    0x68(%eax),%eax
80104603:	89 04 24             	mov    %eax,(%esp)
80104606:	e8 34 d4 ff ff       	call   80101a3f <iput>
  proc->cwd = 0;
8010460b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104611:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104618:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010461f:	e8 1f 06 00 00       	call   80104c43 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104624:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010462a:	8b 40 14             	mov    0x14(%eax),%eax
8010462d:	89 04 24             	mov    %eax,(%esp)
80104630:	e8 c4 03 00 00       	call   801049f9 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104635:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
8010463c:	eb 3b                	jmp    80104679 <exit+0xf4>
    if(p->parent == proc){
8010463e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104641:	8b 50 14             	mov    0x14(%eax),%edx
80104644:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010464a:	39 c2                	cmp    %eax,%edx
8010464c:	75 24                	jne    80104672 <exit+0xed>
      p->parent = initproc;
8010464e:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
80104654:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104657:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010465a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465d:	8b 40 0c             	mov    0xc(%eax),%eax
80104660:	83 f8 05             	cmp    $0x5,%eax
80104663:	75 0d                	jne    80104672 <exit+0xed>
        wakeup1(initproc);
80104665:	a1 48 b6 10 80       	mov    0x8010b648,%eax
8010466a:	89 04 24             	mov    %eax,(%esp)
8010466d:	e8 87 03 00 00       	call   801049f9 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104672:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104679:	81 7d f4 54 21 11 80 	cmpl   $0x80112154,-0xc(%ebp)
80104680:	72 bc                	jb     8010463e <exit+0xb9>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104682:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104688:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010468f:	e8 ba 01 00 00       	call   8010484e <sched>
  panic("zombie exit");
80104694:	c7 04 24 3d 87 10 80 	movl   $0x8010873d,(%esp)
8010469b:	e8 a6 be ff ff       	call   80100546 <panic>

801046a0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801046a6:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801046ad:	e8 91 05 00 00       	call   80104c43 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801046b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046b9:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801046c0:	e9 9d 00 00 00       	jmp    80104762 <wait+0xc2>
      if(p->parent != proc)
801046c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c8:	8b 50 14             	mov    0x14(%eax),%edx
801046cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046d1:	39 c2                	cmp    %eax,%edx
801046d3:	0f 85 81 00 00 00    	jne    8010475a <wait+0xba>
        continue;
      havekids = 1;
801046d9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801046e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e3:	8b 40 0c             	mov    0xc(%eax),%eax
801046e6:	83 f8 05             	cmp    $0x5,%eax
801046e9:	75 70                	jne    8010475b <wait+0xbb>
        // Found one.
        pid = p->pid;
801046eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ee:	8b 40 10             	mov    0x10(%eax),%eax
801046f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801046f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f7:	8b 40 08             	mov    0x8(%eax),%eax
801046fa:	89 04 24             	mov    %eax,(%esp)
801046fd:	e8 e4 e4 ff ff       	call   80102be6 <kfree>
        p->kstack = 0;
80104702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104705:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010470c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010470f:	8b 40 04             	mov    0x4(%eax),%eax
80104712:	89 04 24             	mov    %eax,(%esp)
80104715:	e8 19 3a 00 00       	call   80108133 <freevm>
        p->state = UNUSED;
8010471a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010471d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104724:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104727:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010472e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104731:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010473b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010473f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104742:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104749:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104750:	e8 50 05 00 00       	call   80104ca5 <release>
        return pid;
80104755:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104758:	eb 56                	jmp    801047b0 <wait+0x110>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
8010475a:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010475b:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104762:	81 7d f4 54 21 11 80 	cmpl   $0x80112154,-0xc(%ebp)
80104769:	0f 82 56 ff ff ff    	jb     801046c5 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
8010476f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104773:	74 0d                	je     80104782 <wait+0xe2>
80104775:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010477b:	8b 40 24             	mov    0x24(%eax),%eax
8010477e:	85 c0                	test   %eax,%eax
80104780:	74 13                	je     80104795 <wait+0xf5>
      release(&ptable.lock);
80104782:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104789:	e8 17 05 00 00       	call   80104ca5 <release>
      return -1;
8010478e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104793:	eb 1b                	jmp    801047b0 <wait+0x110>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104795:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010479b:	c7 44 24 04 20 ff 10 	movl   $0x8010ff20,0x4(%esp)
801047a2:	80 
801047a3:	89 04 24             	mov    %eax,(%esp)
801047a6:	e8 b3 01 00 00       	call   8010495e <sleep>
  }
801047ab:	e9 02 ff ff ff       	jmp    801046b2 <wait+0x12>
}
801047b0:	c9                   	leave  
801047b1:	c3                   	ret    

801047b2 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801047b2:	55                   	push   %ebp
801047b3:	89 e5                	mov    %esp,%ebp
801047b5:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
801047b8:	e8 7c f9 ff ff       	call   80104139 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801047bd:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801047c4:	e8 7a 04 00 00       	call   80104c43 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047c9:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801047d0:	eb 62                	jmp    80104834 <scheduler+0x82>
      if(p->state != RUNNABLE)
801047d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d5:	8b 40 0c             	mov    0xc(%eax),%eax
801047d8:	83 f8 03             	cmp    $0x3,%eax
801047db:	75 4f                	jne    8010482c <scheduler+0x7a>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
801047dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e0:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
801047e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e9:	89 04 24             	mov    %eax,(%esp)
801047ec:	e8 cb 34 00 00       	call   80107cbc <switchuvm>
      p->state = RUNNING;
801047f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f4:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
801047fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104801:	8b 40 1c             	mov    0x1c(%eax),%eax
80104804:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010480b:	83 c2 04             	add    $0x4,%edx
8010480e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104812:	89 14 24             	mov    %edx,(%esp)
80104815:	e8 2a 09 00 00       	call   80105144 <swtch>
      switchkvm();
8010481a:	e8 80 34 00 00       	call   80107c9f <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
8010481f:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104826:	00 00 00 00 
8010482a:	eb 01                	jmp    8010482d <scheduler+0x7b>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
8010482c:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010482d:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104834:	81 7d f4 54 21 11 80 	cmpl   $0x80112154,-0xc(%ebp)
8010483b:	72 95                	jb     801047d2 <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
8010483d:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104844:	e8 5c 04 00 00       	call   80104ca5 <release>

  }
80104849:	e9 6a ff ff ff       	jmp    801047b8 <scheduler+0x6>

8010484e <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
8010484e:	55                   	push   %ebp
8010484f:	89 e5                	mov    %esp,%ebp
80104851:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104854:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010485b:	e8 0d 05 00 00       	call   80104d6d <holding>
80104860:	85 c0                	test   %eax,%eax
80104862:	75 0c                	jne    80104870 <sched+0x22>
    panic("sched ptable.lock");
80104864:	c7 04 24 49 87 10 80 	movl   $0x80108749,(%esp)
8010486b:	e8 d6 bc ff ff       	call   80100546 <panic>
  if(cpu->ncli != 1)
80104870:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104876:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010487c:	83 f8 01             	cmp    $0x1,%eax
8010487f:	74 0c                	je     8010488d <sched+0x3f>
    panic("sched locks");
80104881:	c7 04 24 5b 87 10 80 	movl   $0x8010875b,(%esp)
80104888:	e8 b9 bc ff ff       	call   80100546 <panic>
  if(proc->state == RUNNING)
8010488d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104893:	8b 40 0c             	mov    0xc(%eax),%eax
80104896:	83 f8 04             	cmp    $0x4,%eax
80104899:	75 0c                	jne    801048a7 <sched+0x59>
    panic("sched running");
8010489b:	c7 04 24 67 87 10 80 	movl   $0x80108767,(%esp)
801048a2:	e8 9f bc ff ff       	call   80100546 <panic>
  if(readeflags()&FL_IF)
801048a7:	e8 78 f8 ff ff       	call   80104124 <readeflags>
801048ac:	25 00 02 00 00       	and    $0x200,%eax
801048b1:	85 c0                	test   %eax,%eax
801048b3:	74 0c                	je     801048c1 <sched+0x73>
    panic("sched interruptible");
801048b5:	c7 04 24 75 87 10 80 	movl   $0x80108775,(%esp)
801048bc:	e8 85 bc ff ff       	call   80100546 <panic>
  intena = cpu->intena;
801048c1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801048c7:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801048cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
801048d0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801048d6:	8b 40 04             	mov    0x4(%eax),%eax
801048d9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048e0:	83 c2 1c             	add    $0x1c,%edx
801048e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801048e7:	89 14 24             	mov    %edx,(%esp)
801048ea:	e8 55 08 00 00       	call   80105144 <swtch>
  cpu->intena = intena;
801048ef:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801048f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048f8:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801048fe:	c9                   	leave  
801048ff:	c3                   	ret    

80104900 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104906:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010490d:	e8 31 03 00 00       	call   80104c43 <acquire>
  proc->state = RUNNABLE;
80104912:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104918:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010491f:	e8 2a ff ff ff       	call   8010484e <sched>
  release(&ptable.lock);
80104924:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010492b:	e8 75 03 00 00       	call   80104ca5 <release>
}
80104930:	c9                   	leave  
80104931:	c3                   	ret    

80104932 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104932:	55                   	push   %ebp
80104933:	89 e5                	mov    %esp,%ebp
80104935:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104938:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010493f:	e8 61 03 00 00       	call   80104ca5 <release>

  if (first) {
80104944:	a1 20 b0 10 80       	mov    0x8010b020,%eax
80104949:	85 c0                	test   %eax,%eax
8010494b:	74 0f                	je     8010495c <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
8010494d:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
80104954:	00 00 00 
    initlog();
80104957:	e8 38 e8 ff ff       	call   80103194 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
8010495c:	c9                   	leave  
8010495d:	c3                   	ret    

8010495e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
8010495e:	55                   	push   %ebp
8010495f:	89 e5                	mov    %esp,%ebp
80104961:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104964:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010496a:	85 c0                	test   %eax,%eax
8010496c:	75 0c                	jne    8010497a <sleep+0x1c>
    panic("sleep");
8010496e:	c7 04 24 89 87 10 80 	movl   $0x80108789,(%esp)
80104975:	e8 cc bb ff ff       	call   80100546 <panic>

  if(lk == 0)
8010497a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010497e:	75 0c                	jne    8010498c <sleep+0x2e>
    panic("sleep without lk");
80104980:	c7 04 24 8f 87 10 80 	movl   $0x8010878f,(%esp)
80104987:	e8 ba bb ff ff       	call   80100546 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010498c:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
80104993:	74 17                	je     801049ac <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104995:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010499c:	e8 a2 02 00 00       	call   80104c43 <acquire>
    release(lk);
801049a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801049a4:	89 04 24             	mov    %eax,(%esp)
801049a7:	e8 f9 02 00 00       	call   80104ca5 <release>
  }

  // Go to sleep.
  proc->chan = chan;
801049ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049b2:	8b 55 08             	mov    0x8(%ebp),%edx
801049b5:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
801049b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049be:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801049c5:	e8 84 fe ff ff       	call   8010484e <sched>

  // Tidy up.
  proc->chan = 0;
801049ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049d0:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801049d7:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
801049de:	74 17                	je     801049f7 <sleep+0x99>
    release(&ptable.lock);
801049e0:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801049e7:	e8 b9 02 00 00       	call   80104ca5 <release>
    acquire(lk);
801049ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ef:	89 04 24             	mov    %eax,(%esp)
801049f2:	e8 4c 02 00 00       	call   80104c43 <acquire>
  }
}
801049f7:	c9                   	leave  
801049f8:	c3                   	ret    

801049f9 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801049f9:	55                   	push   %ebp
801049fa:	89 e5                	mov    %esp,%ebp
801049fc:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049ff:	c7 45 fc 54 ff 10 80 	movl   $0x8010ff54,-0x4(%ebp)
80104a06:	eb 27                	jmp    80104a2f <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104a08:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a0b:	8b 40 0c             	mov    0xc(%eax),%eax
80104a0e:	83 f8 02             	cmp    $0x2,%eax
80104a11:	75 15                	jne    80104a28 <wakeup1+0x2f>
80104a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a16:	8b 40 20             	mov    0x20(%eax),%eax
80104a19:	3b 45 08             	cmp    0x8(%ebp),%eax
80104a1c:	75 0a                	jne    80104a28 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104a1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a21:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a28:	81 45 fc 88 00 00 00 	addl   $0x88,-0x4(%ebp)
80104a2f:	81 7d fc 54 21 11 80 	cmpl   $0x80112154,-0x4(%ebp)
80104a36:	72 d0                	jb     80104a08 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104a38:	c9                   	leave  
80104a39:	c3                   	ret    

80104a3a <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104a3a:	55                   	push   %ebp
80104a3b:	89 e5                	mov    %esp,%ebp
80104a3d:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104a40:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104a47:	e8 f7 01 00 00       	call   80104c43 <acquire>
  wakeup1(chan);
80104a4c:	8b 45 08             	mov    0x8(%ebp),%eax
80104a4f:	89 04 24             	mov    %eax,(%esp)
80104a52:	e8 a2 ff ff ff       	call   801049f9 <wakeup1>
  release(&ptable.lock);
80104a57:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104a5e:	e8 42 02 00 00       	call   80104ca5 <release>
}
80104a63:	c9                   	leave  
80104a64:	c3                   	ret    

80104a65 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104a65:	55                   	push   %ebp
80104a66:	89 e5                	mov    %esp,%ebp
80104a68:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104a6b:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104a72:	e8 cc 01 00 00       	call   80104c43 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a77:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104a7e:	eb 44                	jmp    80104ac4 <kill+0x5f>
    if(p->pid == pid){
80104a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a83:	8b 40 10             	mov    0x10(%eax),%eax
80104a86:	3b 45 08             	cmp    0x8(%ebp),%eax
80104a89:	75 32                	jne    80104abd <kill+0x58>
      p->killed = 1;
80104a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a8e:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a98:	8b 40 0c             	mov    0xc(%eax),%eax
80104a9b:	83 f8 02             	cmp    $0x2,%eax
80104a9e:	75 0a                	jne    80104aaa <kill+0x45>
        p->state = RUNNABLE;
80104aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104aaa:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104ab1:	e8 ef 01 00 00       	call   80104ca5 <release>
      return 0;
80104ab6:	b8 00 00 00 00       	mov    $0x0,%eax
80104abb:	eb 21                	jmp    80104ade <kill+0x79>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104abd:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104ac4:	81 7d f4 54 21 11 80 	cmpl   $0x80112154,-0xc(%ebp)
80104acb:	72 b3                	jb     80104a80 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104acd:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104ad4:	e8 cc 01 00 00       	call   80104ca5 <release>
  return -1;
80104ad9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ade:	c9                   	leave  
80104adf:	c3                   	ret    

80104ae0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ae6:	c7 45 f0 54 ff 10 80 	movl   $0x8010ff54,-0x10(%ebp)
80104aed:	e9 db 00 00 00       	jmp    80104bcd <procdump+0xed>
    if(p->state == UNUSED)
80104af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104af5:	8b 40 0c             	mov    0xc(%eax),%eax
80104af8:	85 c0                	test   %eax,%eax
80104afa:	0f 84 c5 00 00 00    	je     80104bc5 <procdump+0xe5>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b03:	8b 40 0c             	mov    0xc(%eax),%eax
80104b06:	83 f8 05             	cmp    $0x5,%eax
80104b09:	77 23                	ja     80104b2e <procdump+0x4e>
80104b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b0e:	8b 40 0c             	mov    0xc(%eax),%eax
80104b11:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104b18:	85 c0                	test   %eax,%eax
80104b1a:	74 12                	je     80104b2e <procdump+0x4e>
      state = states[p->state];
80104b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b1f:	8b 40 0c             	mov    0xc(%eax),%eax
80104b22:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104b29:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104b2c:	eb 07                	jmp    80104b35 <procdump+0x55>
    else
      state = "???";
80104b2e:	c7 45 ec a0 87 10 80 	movl   $0x801087a0,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b38:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b3e:	8b 40 10             	mov    0x10(%eax),%eax
80104b41:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104b45:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104b48:	89 54 24 08          	mov    %edx,0x8(%esp)
80104b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b50:	c7 04 24 a4 87 10 80 	movl   $0x801087a4,(%esp)
80104b57:	e8 4e b8 ff ff       	call   801003aa <cprintf>
    if(p->state == SLEEPING){
80104b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b5f:	8b 40 0c             	mov    0xc(%eax),%eax
80104b62:	83 f8 02             	cmp    $0x2,%eax
80104b65:	75 50                	jne    80104bb7 <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b6a:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b6d:	8b 40 0c             	mov    0xc(%eax),%eax
80104b70:	83 c0 08             	add    $0x8,%eax
80104b73:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104b76:	89 54 24 04          	mov    %edx,0x4(%esp)
80104b7a:	89 04 24             	mov    %eax,(%esp)
80104b7d:	e8 72 01 00 00       	call   80104cf4 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104b89:	eb 1b                	jmp    80104ba6 <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104b92:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b96:	c7 04 24 ad 87 10 80 	movl   $0x801087ad,(%esp)
80104b9d:	e8 08 b8 ff ff       	call   801003aa <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104ba2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104ba6:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104baa:	7f 0b                	jg     80104bb7 <procdump+0xd7>
80104bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104baf:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104bb3:	85 c0                	test   %eax,%eax
80104bb5:	75 d4                	jne    80104b8b <procdump+0xab>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104bb7:	c7 04 24 b1 87 10 80 	movl   $0x801087b1,(%esp)
80104bbe:	e8 e7 b7 ff ff       	call   801003aa <cprintf>
80104bc3:	eb 01                	jmp    80104bc6 <procdump+0xe6>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104bc5:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bc6:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
80104bcd:	81 7d f0 54 21 11 80 	cmpl   $0x80112154,-0x10(%ebp)
80104bd4:	0f 82 18 ff ff ff    	jb     80104af2 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104bda:	c9                   	leave  
80104bdb:	c3                   	ret    

80104bdc <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104bdc:	55                   	push   %ebp
80104bdd:	89 e5                	mov    %esp,%ebp
80104bdf:	53                   	push   %ebx
80104be0:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104be3:	9c                   	pushf  
80104be4:	5b                   	pop    %ebx
80104be5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104be8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104beb:	83 c4 10             	add    $0x10,%esp
80104bee:	5b                   	pop    %ebx
80104bef:	5d                   	pop    %ebp
80104bf0:	c3                   	ret    

80104bf1 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104bf1:	55                   	push   %ebp
80104bf2:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104bf4:	fa                   	cli    
}
80104bf5:	5d                   	pop    %ebp
80104bf6:	c3                   	ret    

80104bf7 <sti>:

static inline void
sti(void)
{
80104bf7:	55                   	push   %ebp
80104bf8:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104bfa:	fb                   	sti    
}
80104bfb:	5d                   	pop    %ebp
80104bfc:	c3                   	ret    

80104bfd <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104bfd:	55                   	push   %ebp
80104bfe:	89 e5                	mov    %esp,%ebp
80104c00:	53                   	push   %ebx
80104c01:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
80104c04:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104c07:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80104c0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104c0d:	89 c3                	mov    %eax,%ebx
80104c0f:	89 d8                	mov    %ebx,%eax
80104c11:	f0 87 02             	lock xchg %eax,(%edx)
80104c14:	89 c3                	mov    %eax,%ebx
80104c16:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104c19:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104c1c:	83 c4 10             	add    $0x10,%esp
80104c1f:	5b                   	pop    %ebx
80104c20:	5d                   	pop    %ebp
80104c21:	c3                   	ret    

80104c22 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c22:	55                   	push   %ebp
80104c23:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104c25:	8b 45 08             	mov    0x8(%ebp),%eax
80104c28:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c2b:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104c2e:	8b 45 08             	mov    0x8(%ebp),%eax
80104c31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104c37:	8b 45 08             	mov    0x8(%ebp),%eax
80104c3a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c41:	5d                   	pop    %ebp
80104c42:	c3                   	ret    

80104c43 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104c43:	55                   	push   %ebp
80104c44:	89 e5                	mov    %esp,%ebp
80104c46:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104c49:	e8 49 01 00 00       	call   80104d97 <pushcli>
  if(holding(lk))
80104c4e:	8b 45 08             	mov    0x8(%ebp),%eax
80104c51:	89 04 24             	mov    %eax,(%esp)
80104c54:	e8 14 01 00 00       	call   80104d6d <holding>
80104c59:	85 c0                	test   %eax,%eax
80104c5b:	74 0c                	je     80104c69 <acquire+0x26>
    panic("acquire");
80104c5d:	c7 04 24 dd 87 10 80 	movl   $0x801087dd,(%esp)
80104c64:	e8 dd b8 ff ff       	call   80100546 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104c69:	90                   	nop
80104c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80104c6d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104c74:	00 
80104c75:	89 04 24             	mov    %eax,(%esp)
80104c78:	e8 80 ff ff ff       	call   80104bfd <xchg>
80104c7d:	85 c0                	test   %eax,%eax
80104c7f:	75 e9                	jne    80104c6a <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104c81:	8b 45 08             	mov    0x8(%ebp),%eax
80104c84:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c8b:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104c8e:	8b 45 08             	mov    0x8(%ebp),%eax
80104c91:	83 c0 0c             	add    $0xc,%eax
80104c94:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c98:	8d 45 08             	lea    0x8(%ebp),%eax
80104c9b:	89 04 24             	mov    %eax,(%esp)
80104c9e:	e8 51 00 00 00       	call   80104cf4 <getcallerpcs>
}
80104ca3:	c9                   	leave  
80104ca4:	c3                   	ret    

80104ca5 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104ca5:	55                   	push   %ebp
80104ca6:	89 e5                	mov    %esp,%ebp
80104ca8:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104cab:	8b 45 08             	mov    0x8(%ebp),%eax
80104cae:	89 04 24             	mov    %eax,(%esp)
80104cb1:	e8 b7 00 00 00       	call   80104d6d <holding>
80104cb6:	85 c0                	test   %eax,%eax
80104cb8:	75 0c                	jne    80104cc6 <release+0x21>
    panic("release");
80104cba:	c7 04 24 e5 87 10 80 	movl   $0x801087e5,(%esp)
80104cc1:	e8 80 b8 ff ff       	call   80100546 <panic>

  lk->pcs[0] = 0;
80104cc6:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104cd0:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104cda:	8b 45 08             	mov    0x8(%ebp),%eax
80104cdd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104ce4:	00 
80104ce5:	89 04 24             	mov    %eax,(%esp)
80104ce8:	e8 10 ff ff ff       	call   80104bfd <xchg>

  popcli();
80104ced:	e8 ed 00 00 00       	call   80104ddf <popcli>
}
80104cf2:	c9                   	leave  
80104cf3:	c3                   	ret    

80104cf4 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104cf4:	55                   	push   %ebp
80104cf5:	89 e5                	mov    %esp,%ebp
80104cf7:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80104cfd:	83 e8 08             	sub    $0x8,%eax
80104d00:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104d03:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104d0a:	eb 38                	jmp    80104d44 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104d10:	74 53                	je     80104d65 <getcallerpcs+0x71>
80104d12:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104d19:	76 4a                	jbe    80104d65 <getcallerpcs+0x71>
80104d1b:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104d1f:	74 44                	je     80104d65 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d21:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d2e:	01 c2                	add    %eax,%edx
80104d30:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d33:	8b 40 04             	mov    0x4(%eax),%eax
80104d36:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104d38:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d3b:	8b 00                	mov    (%eax),%eax
80104d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d40:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104d44:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104d48:	7e c2                	jle    80104d0c <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104d4a:	eb 19                	jmp    80104d65 <getcallerpcs+0x71>
    pcs[i] = 0;
80104d4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104d56:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d59:	01 d0                	add    %edx,%eax
80104d5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104d61:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104d65:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104d69:	7e e1                	jle    80104d4c <getcallerpcs+0x58>
    pcs[i] = 0;
}
80104d6b:	c9                   	leave  
80104d6c:	c3                   	ret    

80104d6d <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104d6d:	55                   	push   %ebp
80104d6e:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104d70:	8b 45 08             	mov    0x8(%ebp),%eax
80104d73:	8b 00                	mov    (%eax),%eax
80104d75:	85 c0                	test   %eax,%eax
80104d77:	74 17                	je     80104d90 <holding+0x23>
80104d79:	8b 45 08             	mov    0x8(%ebp),%eax
80104d7c:	8b 50 08             	mov    0x8(%eax),%edx
80104d7f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d85:	39 c2                	cmp    %eax,%edx
80104d87:	75 07                	jne    80104d90 <holding+0x23>
80104d89:	b8 01 00 00 00       	mov    $0x1,%eax
80104d8e:	eb 05                	jmp    80104d95 <holding+0x28>
80104d90:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d95:	5d                   	pop    %ebp
80104d96:	c3                   	ret    

80104d97 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d97:	55                   	push   %ebp
80104d98:	89 e5                	mov    %esp,%ebp
80104d9a:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104d9d:	e8 3a fe ff ff       	call   80104bdc <readeflags>
80104da2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104da5:	e8 47 fe ff ff       	call   80104bf1 <cli>
  if(cpu->ncli++ == 0)
80104daa:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104db0:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104db6:	85 d2                	test   %edx,%edx
80104db8:	0f 94 c1             	sete   %cl
80104dbb:	83 c2 01             	add    $0x1,%edx
80104dbe:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104dc4:	84 c9                	test   %cl,%cl
80104dc6:	74 15                	je     80104ddd <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
80104dc8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dce:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104dd1:	81 e2 00 02 00 00    	and    $0x200,%edx
80104dd7:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104ddd:	c9                   	leave  
80104dde:	c3                   	ret    

80104ddf <popcli>:

void
popcli(void)
{
80104ddf:	55                   	push   %ebp
80104de0:	89 e5                	mov    %esp,%ebp
80104de2:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104de5:	e8 f2 fd ff ff       	call   80104bdc <readeflags>
80104dea:	25 00 02 00 00       	and    $0x200,%eax
80104def:	85 c0                	test   %eax,%eax
80104df1:	74 0c                	je     80104dff <popcli+0x20>
    panic("popcli - interruptible");
80104df3:	c7 04 24 ed 87 10 80 	movl   $0x801087ed,(%esp)
80104dfa:	e8 47 b7 ff ff       	call   80100546 <panic>
  if(--cpu->ncli < 0)
80104dff:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e05:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104e0b:	83 ea 01             	sub    $0x1,%edx
80104e0e:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104e14:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e1a:	85 c0                	test   %eax,%eax
80104e1c:	79 0c                	jns    80104e2a <popcli+0x4b>
    panic("popcli");
80104e1e:	c7 04 24 04 88 10 80 	movl   $0x80108804,(%esp)
80104e25:	e8 1c b7 ff ff       	call   80100546 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104e2a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e30:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e36:	85 c0                	test   %eax,%eax
80104e38:	75 15                	jne    80104e4f <popcli+0x70>
80104e3a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e40:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104e46:	85 c0                	test   %eax,%eax
80104e48:	74 05                	je     80104e4f <popcli+0x70>
    sti();
80104e4a:	e8 a8 fd ff ff       	call   80104bf7 <sti>
}
80104e4f:	c9                   	leave  
80104e50:	c3                   	ret    
80104e51:	66 90                	xchg   %ax,%ax
80104e53:	90                   	nop

80104e54 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104e54:	55                   	push   %ebp
80104e55:	89 e5                	mov    %esp,%ebp
80104e57:	57                   	push   %edi
80104e58:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104e59:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e5c:	8b 55 10             	mov    0x10(%ebp),%edx
80104e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e62:	89 cb                	mov    %ecx,%ebx
80104e64:	89 df                	mov    %ebx,%edi
80104e66:	89 d1                	mov    %edx,%ecx
80104e68:	fc                   	cld    
80104e69:	f3 aa                	rep stos %al,%es:(%edi)
80104e6b:	89 ca                	mov    %ecx,%edx
80104e6d:	89 fb                	mov    %edi,%ebx
80104e6f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104e72:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104e75:	5b                   	pop    %ebx
80104e76:	5f                   	pop    %edi
80104e77:	5d                   	pop    %ebp
80104e78:	c3                   	ret    

80104e79 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80104e79:	55                   	push   %ebp
80104e7a:	89 e5                	mov    %esp,%ebp
80104e7c:	57                   	push   %edi
80104e7d:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104e7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e81:	8b 55 10             	mov    0x10(%ebp),%edx
80104e84:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e87:	89 cb                	mov    %ecx,%ebx
80104e89:	89 df                	mov    %ebx,%edi
80104e8b:	89 d1                	mov    %edx,%ecx
80104e8d:	fc                   	cld    
80104e8e:	f3 ab                	rep stos %eax,%es:(%edi)
80104e90:	89 ca                	mov    %ecx,%edx
80104e92:	89 fb                	mov    %edi,%ebx
80104e94:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104e97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104e9a:	5b                   	pop    %ebx
80104e9b:	5f                   	pop    %edi
80104e9c:	5d                   	pop    %ebp
80104e9d:	c3                   	ret    

80104e9e <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e9e:	55                   	push   %ebp
80104e9f:	89 e5                	mov    %esp,%ebp
80104ea1:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80104ea4:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea7:	83 e0 03             	and    $0x3,%eax
80104eaa:	85 c0                	test   %eax,%eax
80104eac:	75 49                	jne    80104ef7 <memset+0x59>
80104eae:	8b 45 10             	mov    0x10(%ebp),%eax
80104eb1:	83 e0 03             	and    $0x3,%eax
80104eb4:	85 c0                	test   %eax,%eax
80104eb6:	75 3f                	jne    80104ef7 <memset+0x59>
    c &= 0xFF;
80104eb8:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104ebf:	8b 45 10             	mov    0x10(%ebp),%eax
80104ec2:	c1 e8 02             	shr    $0x2,%eax
80104ec5:	89 c2                	mov    %eax,%edx
80104ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eca:	89 c1                	mov    %eax,%ecx
80104ecc:	c1 e1 18             	shl    $0x18,%ecx
80104ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ed2:	c1 e0 10             	shl    $0x10,%eax
80104ed5:	09 c1                	or     %eax,%ecx
80104ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eda:	c1 e0 08             	shl    $0x8,%eax
80104edd:	09 c8                	or     %ecx,%eax
80104edf:	0b 45 0c             	or     0xc(%ebp),%eax
80104ee2:	89 54 24 08          	mov    %edx,0x8(%esp)
80104ee6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eea:	8b 45 08             	mov    0x8(%ebp),%eax
80104eed:	89 04 24             	mov    %eax,(%esp)
80104ef0:	e8 84 ff ff ff       	call   80104e79 <stosl>
80104ef5:	eb 19                	jmp    80104f10 <memset+0x72>
  } else
    stosb(dst, c, n);
80104ef7:	8b 45 10             	mov    0x10(%ebp),%eax
80104efa:	89 44 24 08          	mov    %eax,0x8(%esp)
80104efe:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f01:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f05:	8b 45 08             	mov    0x8(%ebp),%eax
80104f08:	89 04 24             	mov    %eax,(%esp)
80104f0b:	e8 44 ff ff ff       	call   80104e54 <stosb>
  return dst;
80104f10:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104f13:	c9                   	leave  
80104f14:	c3                   	ret    

80104f15 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f15:	55                   	push   %ebp
80104f16:	89 e5                	mov    %esp,%ebp
80104f18:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80104f1b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104f21:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f24:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104f27:	eb 32                	jmp    80104f5b <memcmp+0x46>
    if(*s1 != *s2)
80104f29:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f2c:	0f b6 10             	movzbl (%eax),%edx
80104f2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f32:	0f b6 00             	movzbl (%eax),%eax
80104f35:	38 c2                	cmp    %al,%dl
80104f37:	74 1a                	je     80104f53 <memcmp+0x3e>
      return *s1 - *s2;
80104f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f3c:	0f b6 00             	movzbl (%eax),%eax
80104f3f:	0f b6 d0             	movzbl %al,%edx
80104f42:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f45:	0f b6 00             	movzbl (%eax),%eax
80104f48:	0f b6 c0             	movzbl %al,%eax
80104f4b:	89 d1                	mov    %edx,%ecx
80104f4d:	29 c1                	sub    %eax,%ecx
80104f4f:	89 c8                	mov    %ecx,%eax
80104f51:	eb 1c                	jmp    80104f6f <memcmp+0x5a>
    s1++, s2++;
80104f53:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104f57:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f5f:	0f 95 c0             	setne  %al
80104f62:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104f66:	84 c0                	test   %al,%al
80104f68:	75 bf                	jne    80104f29 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104f6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f6f:	c9                   	leave  
80104f70:	c3                   	ret    

80104f71 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f71:	55                   	push   %ebp
80104f72:	89 e5                	mov    %esp,%ebp
80104f74:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104f77:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80104f80:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f86:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104f89:	73 54                	jae    80104fdf <memmove+0x6e>
80104f8b:	8b 45 10             	mov    0x10(%ebp),%eax
80104f8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104f91:	01 d0                	add    %edx,%eax
80104f93:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104f96:	76 47                	jbe    80104fdf <memmove+0x6e>
    s += n;
80104f98:	8b 45 10             	mov    0x10(%ebp),%eax
80104f9b:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104f9e:	8b 45 10             	mov    0x10(%ebp),%eax
80104fa1:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104fa4:	eb 13                	jmp    80104fb9 <memmove+0x48>
      *--d = *--s;
80104fa6:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104faa:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fb1:	0f b6 10             	movzbl (%eax),%edx
80104fb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fb7:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104fb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fbd:	0f 95 c0             	setne  %al
80104fc0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104fc4:	84 c0                	test   %al,%al
80104fc6:	75 de                	jne    80104fa6 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104fc8:	eb 25                	jmp    80104fef <memmove+0x7e>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80104fca:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fcd:	0f b6 10             	movzbl (%eax),%edx
80104fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fd3:	88 10                	mov    %dl,(%eax)
80104fd5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104fd9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104fdd:	eb 01                	jmp    80104fe0 <memmove+0x6f>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104fdf:	90                   	nop
80104fe0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fe4:	0f 95 c0             	setne  %al
80104fe7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104feb:	84 c0                	test   %al,%al
80104fed:	75 db                	jne    80104fca <memmove+0x59>
      *d++ = *s++;

  return dst;
80104fef:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104ff2:	c9                   	leave  
80104ff3:	c3                   	ret    

80104ff4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80104ffa:	8b 45 10             	mov    0x10(%ebp),%eax
80104ffd:	89 44 24 08          	mov    %eax,0x8(%esp)
80105001:	8b 45 0c             	mov    0xc(%ebp),%eax
80105004:	89 44 24 04          	mov    %eax,0x4(%esp)
80105008:	8b 45 08             	mov    0x8(%ebp),%eax
8010500b:	89 04 24             	mov    %eax,(%esp)
8010500e:	e8 5e ff ff ff       	call   80104f71 <memmove>
}
80105013:	c9                   	leave  
80105014:	c3                   	ret    

80105015 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105015:	55                   	push   %ebp
80105016:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105018:	eb 0c                	jmp    80105026 <strncmp+0x11>
    n--, p++, q++;
8010501a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010501e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105022:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105026:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010502a:	74 1a                	je     80105046 <strncmp+0x31>
8010502c:	8b 45 08             	mov    0x8(%ebp),%eax
8010502f:	0f b6 00             	movzbl (%eax),%eax
80105032:	84 c0                	test   %al,%al
80105034:	74 10                	je     80105046 <strncmp+0x31>
80105036:	8b 45 08             	mov    0x8(%ebp),%eax
80105039:	0f b6 10             	movzbl (%eax),%edx
8010503c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010503f:	0f b6 00             	movzbl (%eax),%eax
80105042:	38 c2                	cmp    %al,%dl
80105044:	74 d4                	je     8010501a <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105046:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010504a:	75 07                	jne    80105053 <strncmp+0x3e>
    return 0;
8010504c:	b8 00 00 00 00       	mov    $0x0,%eax
80105051:	eb 18                	jmp    8010506b <strncmp+0x56>
  return (uchar)*p - (uchar)*q;
80105053:	8b 45 08             	mov    0x8(%ebp),%eax
80105056:	0f b6 00             	movzbl (%eax),%eax
80105059:	0f b6 d0             	movzbl %al,%edx
8010505c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010505f:	0f b6 00             	movzbl (%eax),%eax
80105062:	0f b6 c0             	movzbl %al,%eax
80105065:	89 d1                	mov    %edx,%ecx
80105067:	29 c1                	sub    %eax,%ecx
80105069:	89 c8                	mov    %ecx,%eax
}
8010506b:	5d                   	pop    %ebp
8010506c:	c3                   	ret    

8010506d <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010506d:	55                   	push   %ebp
8010506e:	89 e5                	mov    %esp,%ebp
80105070:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105073:	8b 45 08             	mov    0x8(%ebp),%eax
80105076:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105079:	90                   	nop
8010507a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010507e:	0f 9f c0             	setg   %al
80105081:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105085:	84 c0                	test   %al,%al
80105087:	74 30                	je     801050b9 <strncpy+0x4c>
80105089:	8b 45 0c             	mov    0xc(%ebp),%eax
8010508c:	0f b6 10             	movzbl (%eax),%edx
8010508f:	8b 45 08             	mov    0x8(%ebp),%eax
80105092:	88 10                	mov    %dl,(%eax)
80105094:	8b 45 08             	mov    0x8(%ebp),%eax
80105097:	0f b6 00             	movzbl (%eax),%eax
8010509a:	84 c0                	test   %al,%al
8010509c:	0f 95 c0             	setne  %al
8010509f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801050a3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801050a7:	84 c0                	test   %al,%al
801050a9:	75 cf                	jne    8010507a <strncpy+0xd>
    ;
  while(n-- > 0)
801050ab:	eb 0c                	jmp    801050b9 <strncpy+0x4c>
    *s++ = 0;
801050ad:	8b 45 08             	mov    0x8(%ebp),%eax
801050b0:	c6 00 00             	movb   $0x0,(%eax)
801050b3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801050b7:	eb 01                	jmp    801050ba <strncpy+0x4d>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801050b9:	90                   	nop
801050ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050be:	0f 9f c0             	setg   %al
801050c1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801050c5:	84 c0                	test   %al,%al
801050c7:	75 e4                	jne    801050ad <strncpy+0x40>
    *s++ = 0;
  return os;
801050c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050cc:	c9                   	leave  
801050cd:	c3                   	ret    

801050ce <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801050ce:	55                   	push   %ebp
801050cf:	89 e5                	mov    %esp,%ebp
801050d1:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801050d4:	8b 45 08             	mov    0x8(%ebp),%eax
801050d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801050da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050de:	7f 05                	jg     801050e5 <safestrcpy+0x17>
    return os;
801050e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050e3:	eb 35                	jmp    8010511a <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
801050e5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801050e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050ed:	7e 22                	jle    80105111 <safestrcpy+0x43>
801050ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801050f2:	0f b6 10             	movzbl (%eax),%edx
801050f5:	8b 45 08             	mov    0x8(%ebp),%eax
801050f8:	88 10                	mov    %dl,(%eax)
801050fa:	8b 45 08             	mov    0x8(%ebp),%eax
801050fd:	0f b6 00             	movzbl (%eax),%eax
80105100:	84 c0                	test   %al,%al
80105102:	0f 95 c0             	setne  %al
80105105:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105109:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010510d:	84 c0                	test   %al,%al
8010510f:	75 d4                	jne    801050e5 <safestrcpy+0x17>
    ;
  *s = 0;
80105111:	8b 45 08             	mov    0x8(%ebp),%eax
80105114:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105117:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010511a:	c9                   	leave  
8010511b:	c3                   	ret    

8010511c <strlen>:

int
strlen(const char *s)
{
8010511c:	55                   	push   %ebp
8010511d:	89 e5                	mov    %esp,%ebp
8010511f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105122:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105129:	eb 04                	jmp    8010512f <strlen+0x13>
8010512b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010512f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105132:	8b 45 08             	mov    0x8(%ebp),%eax
80105135:	01 d0                	add    %edx,%eax
80105137:	0f b6 00             	movzbl (%eax),%eax
8010513a:	84 c0                	test   %al,%al
8010513c:	75 ed                	jne    8010512b <strlen+0xf>
    ;
  return n;
8010513e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105141:	c9                   	leave  
80105142:	c3                   	ret    
80105143:	90                   	nop

80105144 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105144:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105148:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010514c:	55                   	push   %ebp
  pushl %ebx
8010514d:	53                   	push   %ebx
  pushl %esi
8010514e:	56                   	push   %esi
  pushl %edi
8010514f:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105150:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105152:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105154:	5f                   	pop    %edi
  popl %esi
80105155:	5e                   	pop    %esi
  popl %ebx
80105156:	5b                   	pop    %ebx
  popl %ebp
80105157:	5d                   	pop    %ebp
  ret
80105158:	c3                   	ret    
80105159:	66 90                	xchg   %ax,%ax
8010515b:	90                   	nop

8010515c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010515c:	55                   	push   %ebp
8010515d:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010515f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105165:	8b 00                	mov    (%eax),%eax
80105167:	3b 45 08             	cmp    0x8(%ebp),%eax
8010516a:	76 12                	jbe    8010517e <fetchint+0x22>
8010516c:	8b 45 08             	mov    0x8(%ebp),%eax
8010516f:	8d 50 04             	lea    0x4(%eax),%edx
80105172:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105178:	8b 00                	mov    (%eax),%eax
8010517a:	39 c2                	cmp    %eax,%edx
8010517c:	76 07                	jbe    80105185 <fetchint+0x29>
    return -1;
8010517e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105183:	eb 0f                	jmp    80105194 <fetchint+0x38>
  *ip = *(int*)(addr);
80105185:	8b 45 08             	mov    0x8(%ebp),%eax
80105188:	8b 10                	mov    (%eax),%edx
8010518a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010518d:	89 10                	mov    %edx,(%eax)
  return 0;
8010518f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105194:	5d                   	pop    %ebp
80105195:	c3                   	ret    

80105196 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105196:	55                   	push   %ebp
80105197:	89 e5                	mov    %esp,%ebp
80105199:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010519c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051a2:	8b 00                	mov    (%eax),%eax
801051a4:	3b 45 08             	cmp    0x8(%ebp),%eax
801051a7:	77 07                	ja     801051b0 <fetchstr+0x1a>
    return -1;
801051a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ae:	eb 48                	jmp    801051f8 <fetchstr+0x62>
  *pp = (char*)addr;
801051b0:	8b 55 08             	mov    0x8(%ebp),%edx
801051b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801051b6:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801051b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051be:	8b 00                	mov    (%eax),%eax
801051c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801051c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801051c6:	8b 00                	mov    (%eax),%eax
801051c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
801051cb:	eb 1e                	jmp    801051eb <fetchstr+0x55>
    if(*s == 0)
801051cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051d0:	0f b6 00             	movzbl (%eax),%eax
801051d3:	84 c0                	test   %al,%al
801051d5:	75 10                	jne    801051e7 <fetchstr+0x51>
      return s - *pp;
801051d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801051da:	8b 45 0c             	mov    0xc(%ebp),%eax
801051dd:	8b 00                	mov    (%eax),%eax
801051df:	89 d1                	mov    %edx,%ecx
801051e1:	29 c1                	sub    %eax,%ecx
801051e3:	89 c8                	mov    %ecx,%eax
801051e5:	eb 11                	jmp    801051f8 <fetchstr+0x62>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801051e7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801051eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801051f1:	72 da                	jb     801051cd <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801051f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f8:	c9                   	leave  
801051f9:	c3                   	ret    

801051fa <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801051fa:	55                   	push   %ebp
801051fb:	89 e5                	mov    %esp,%ebp
801051fd:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105200:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105206:	8b 40 18             	mov    0x18(%eax),%eax
80105209:	8b 50 44             	mov    0x44(%eax),%edx
8010520c:	8b 45 08             	mov    0x8(%ebp),%eax
8010520f:	c1 e0 02             	shl    $0x2,%eax
80105212:	01 d0                	add    %edx,%eax
80105214:	8d 50 04             	lea    0x4(%eax),%edx
80105217:	8b 45 0c             	mov    0xc(%ebp),%eax
8010521a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010521e:	89 14 24             	mov    %edx,(%esp)
80105221:	e8 36 ff ff ff       	call   8010515c <fetchint>
}
80105226:	c9                   	leave  
80105227:	c3                   	ret    

80105228 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105228:	55                   	push   %ebp
80105229:	89 e5                	mov    %esp,%ebp
8010522b:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
8010522e:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105231:	89 44 24 04          	mov    %eax,0x4(%esp)
80105235:	8b 45 08             	mov    0x8(%ebp),%eax
80105238:	89 04 24             	mov    %eax,(%esp)
8010523b:	e8 ba ff ff ff       	call   801051fa <argint>
80105240:	85 c0                	test   %eax,%eax
80105242:	79 07                	jns    8010524b <argptr+0x23>
    return -1;
80105244:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105249:	eb 3d                	jmp    80105288 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010524b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010524e:	89 c2                	mov    %eax,%edx
80105250:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105256:	8b 00                	mov    (%eax),%eax
80105258:	39 c2                	cmp    %eax,%edx
8010525a:	73 16                	jae    80105272 <argptr+0x4a>
8010525c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010525f:	89 c2                	mov    %eax,%edx
80105261:	8b 45 10             	mov    0x10(%ebp),%eax
80105264:	01 c2                	add    %eax,%edx
80105266:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010526c:	8b 00                	mov    (%eax),%eax
8010526e:	39 c2                	cmp    %eax,%edx
80105270:	76 07                	jbe    80105279 <argptr+0x51>
    return -1;
80105272:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105277:	eb 0f                	jmp    80105288 <argptr+0x60>
  *pp = (char*)i;
80105279:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010527c:	89 c2                	mov    %eax,%edx
8010527e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105281:	89 10                	mov    %edx,(%eax)
  return 0;
80105283:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105288:	c9                   	leave  
80105289:	c3                   	ret    

8010528a <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010528a:	55                   	push   %ebp
8010528b:	89 e5                	mov    %esp,%ebp
8010528d:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105290:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105293:	89 44 24 04          	mov    %eax,0x4(%esp)
80105297:	8b 45 08             	mov    0x8(%ebp),%eax
8010529a:	89 04 24             	mov    %eax,(%esp)
8010529d:	e8 58 ff ff ff       	call   801051fa <argint>
801052a2:	85 c0                	test   %eax,%eax
801052a4:	79 07                	jns    801052ad <argstr+0x23>
    return -1;
801052a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ab:	eb 12                	jmp    801052bf <argstr+0x35>
  return fetchstr(addr, pp);
801052ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801052b3:	89 54 24 04          	mov    %edx,0x4(%esp)
801052b7:	89 04 24             	mov    %eax,(%esp)
801052ba:	e8 d7 fe ff ff       	call   80105196 <fetchstr>
}
801052bf:	c9                   	leave  
801052c0:	c3                   	ret    

801052c1 <syscall>:
*/


void
syscall(void)
{
801052c1:	55                   	push   %ebp
801052c2:	89 e5                	mov    %esp,%ebp
801052c4:	53                   	push   %ebx
801052c5:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
801052c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052ce:	8b 40 18             	mov    0x18(%eax),%eax
801052d1:	8b 40 1c             	mov    0x1c(%eax),%eax
801052d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801052d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801052db:	7e 30                	jle    8010530d <syscall+0x4c>
801052dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052e0:	83 f8 17             	cmp    $0x17,%eax
801052e3:	77 28                	ja     8010530d <syscall+0x4c>
801052e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052e8:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801052ef:	85 c0                	test   %eax,%eax
801052f1:	74 1a                	je     8010530d <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801052f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052f9:	8b 58 18             	mov    0x18(%eax),%ebx
801052fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ff:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105306:	ff d0                	call   *%eax
80105308:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010530b:	eb 3d                	jmp    8010534a <syscall+0x89>
    //cprintf("%s -> %d\n",syscalls_n[num],proc->tf->eax);
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
8010530d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105313:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105316:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
    //cprintf("%s -> %d\n",syscalls_n[num],proc->tf->eax);
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010531c:	8b 40 10             	mov    0x10(%eax),%eax
8010531f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105322:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105326:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010532a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010532e:	c7 04 24 0b 88 10 80 	movl   $0x8010880b,(%esp)
80105335:	e8 70 b0 ff ff       	call   801003aa <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010533a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105340:	8b 40 18             	mov    0x18(%eax),%eax
80105343:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010534a:	83 c4 24             	add    $0x24,%esp
8010534d:	5b                   	pop    %ebx
8010534e:	5d                   	pop    %ebp
8010534f:	c3                   	ret    

80105350 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105356:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105359:	89 44 24 04          	mov    %eax,0x4(%esp)
8010535d:	8b 45 08             	mov    0x8(%ebp),%eax
80105360:	89 04 24             	mov    %eax,(%esp)
80105363:	e8 92 fe ff ff       	call   801051fa <argint>
80105368:	85 c0                	test   %eax,%eax
8010536a:	79 07                	jns    80105373 <argfd+0x23>
    return -1;
8010536c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105371:	eb 50                	jmp    801053c3 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105376:	85 c0                	test   %eax,%eax
80105378:	78 21                	js     8010539b <argfd+0x4b>
8010537a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010537d:	83 f8 0f             	cmp    $0xf,%eax
80105380:	7f 19                	jg     8010539b <argfd+0x4b>
80105382:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105388:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010538b:	83 c2 08             	add    $0x8,%edx
8010538e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105392:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105395:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105399:	75 07                	jne    801053a2 <argfd+0x52>
    return -1;
8010539b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053a0:	eb 21                	jmp    801053c3 <argfd+0x73>
  if(pfd)
801053a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801053a6:	74 08                	je     801053b0 <argfd+0x60>
    *pfd = fd;
801053a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801053ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ae:	89 10                	mov    %edx,(%eax)
  if(pf)
801053b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053b4:	74 08                	je     801053be <argfd+0x6e>
    *pf = f;
801053b6:	8b 45 10             	mov    0x10(%ebp),%eax
801053b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053bc:	89 10                	mov    %edx,(%eax)
  return 0;
801053be:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053c3:	c9                   	leave  
801053c4:	c3                   	ret    

801053c5 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801053c5:	55                   	push   %ebp
801053c6:	89 e5                	mov    %esp,%ebp
801053c8:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801053cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801053d2:	eb 30                	jmp    80105404 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801053d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053da:	8b 55 fc             	mov    -0x4(%ebp),%edx
801053dd:	83 c2 08             	add    $0x8,%edx
801053e0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801053e4:	85 c0                	test   %eax,%eax
801053e6:	75 18                	jne    80105400 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801053e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
801053f1:	8d 4a 08             	lea    0x8(%edx),%ecx
801053f4:	8b 55 08             	mov    0x8(%ebp),%edx
801053f7:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801053fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053fe:	eb 0f                	jmp    8010540f <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105400:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105404:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105408:	7e ca                	jle    801053d4 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010540a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010540f:	c9                   	leave  
80105410:	c3                   	ret    

80105411 <sys_dup>:

int
sys_dup(void)
{
80105411:	55                   	push   %ebp
80105412:	89 e5                	mov    %esp,%ebp
80105414:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105417:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010541a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010541e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105425:	00 
80105426:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010542d:	e8 1e ff ff ff       	call   80105350 <argfd>
80105432:	85 c0                	test   %eax,%eax
80105434:	79 07                	jns    8010543d <sys_dup+0x2c>
    return -1;
80105436:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543b:	eb 29                	jmp    80105466 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010543d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105440:	89 04 24             	mov    %eax,(%esp)
80105443:	e8 7d ff ff ff       	call   801053c5 <fdalloc>
80105448:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010544b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010544f:	79 07                	jns    80105458 <sys_dup+0x47>
    return -1;
80105451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105456:	eb 0e                	jmp    80105466 <sys_dup+0x55>
  filedup(f);
80105458:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010545b:	89 04 24             	mov    %eax,(%esp)
8010545e:	e8 39 bb ff ff       	call   80100f9c <filedup>
  return fd;
80105463:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105466:	c9                   	leave  
80105467:	c3                   	ret    

80105468 <sys_read>:

int
sys_read(void)
{
80105468:	55                   	push   %ebp
80105469:	89 e5                	mov    %esp,%ebp
8010546b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010546e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105471:	89 44 24 08          	mov    %eax,0x8(%esp)
80105475:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010547c:	00 
8010547d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105484:	e8 c7 fe ff ff       	call   80105350 <argfd>
80105489:	85 c0                	test   %eax,%eax
8010548b:	78 35                	js     801054c2 <sys_read+0x5a>
8010548d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105490:	89 44 24 04          	mov    %eax,0x4(%esp)
80105494:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010549b:	e8 5a fd ff ff       	call   801051fa <argint>
801054a0:	85 c0                	test   %eax,%eax
801054a2:	78 1e                	js     801054c2 <sys_read+0x5a>
801054a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054a7:	89 44 24 08          	mov    %eax,0x8(%esp)
801054ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801054b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801054b9:	e8 6a fd ff ff       	call   80105228 <argptr>
801054be:	85 c0                	test   %eax,%eax
801054c0:	79 07                	jns    801054c9 <sys_read+0x61>
    return -1;
801054c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c7:	eb 19                	jmp    801054e2 <sys_read+0x7a>
  return fileread(f, p, n);
801054c9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801054cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
801054cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801054d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801054da:	89 04 24             	mov    %eax,(%esp)
801054dd:	e8 27 bc ff ff       	call   80101109 <fileread>
}
801054e2:	c9                   	leave  
801054e3:	c3                   	ret    

801054e4 <sys_write>:

int
sys_write(void)
{
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
801054e7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ed:	89 44 24 08          	mov    %eax,0x8(%esp)
801054f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801054f8:	00 
801054f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105500:	e8 4b fe ff ff       	call   80105350 <argfd>
80105505:	85 c0                	test   %eax,%eax
80105507:	78 35                	js     8010553e <sys_write+0x5a>
80105509:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010550c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105510:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105517:	e8 de fc ff ff       	call   801051fa <argint>
8010551c:	85 c0                	test   %eax,%eax
8010551e:	78 1e                	js     8010553e <sys_write+0x5a>
80105520:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105523:	89 44 24 08          	mov    %eax,0x8(%esp)
80105527:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010552a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010552e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105535:	e8 ee fc ff ff       	call   80105228 <argptr>
8010553a:	85 c0                	test   %eax,%eax
8010553c:	79 07                	jns    80105545 <sys_write+0x61>
    return -1;
8010553e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105543:	eb 19                	jmp    8010555e <sys_write+0x7a>
  return filewrite(f, p, n);
80105545:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105548:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010554b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010554e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105552:	89 54 24 04          	mov    %edx,0x4(%esp)
80105556:	89 04 24             	mov    %eax,(%esp)
80105559:	e8 67 bc ff ff       	call   801011c5 <filewrite>
}
8010555e:	c9                   	leave  
8010555f:	c3                   	ret    

80105560 <sys_close>:

int
sys_close(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105566:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105569:	89 44 24 08          	mov    %eax,0x8(%esp)
8010556d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105570:	89 44 24 04          	mov    %eax,0x4(%esp)
80105574:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010557b:	e8 d0 fd ff ff       	call   80105350 <argfd>
80105580:	85 c0                	test   %eax,%eax
80105582:	79 07                	jns    8010558b <sys_close+0x2b>
    return -1;
80105584:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105589:	eb 24                	jmp    801055af <sys_close+0x4f>
  proc->ofile[fd] = 0;
8010558b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105591:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105594:	83 c2 08             	add    $0x8,%edx
80105597:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010559e:	00 
  fileclose(f);
8010559f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055a2:	89 04 24             	mov    %eax,(%esp)
801055a5:	e8 3a ba ff ff       	call   80100fe4 <fileclose>
  return 0;
801055aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055af:	c9                   	leave  
801055b0:	c3                   	ret    

801055b1 <sys_fstat>:

int
sys_fstat(void)
{
801055b1:	55                   	push   %ebp
801055b2:	89 e5                	mov    %esp,%ebp
801055b4:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801055b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ba:	89 44 24 08          	mov    %eax,0x8(%esp)
801055be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801055c5:	00 
801055c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055cd:	e8 7e fd ff ff       	call   80105350 <argfd>
801055d2:	85 c0                	test   %eax,%eax
801055d4:	78 1f                	js     801055f5 <sys_fstat+0x44>
801055d6:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801055dd:	00 
801055de:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801055e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801055ec:	e8 37 fc ff ff       	call   80105228 <argptr>
801055f1:	85 c0                	test   %eax,%eax
801055f3:	79 07                	jns    801055fc <sys_fstat+0x4b>
    return -1;
801055f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055fa:	eb 12                	jmp    8010560e <sys_fstat+0x5d>
  return filestat(f, st);
801055fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801055ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105602:	89 54 24 04          	mov    %edx,0x4(%esp)
80105606:	89 04 24             	mov    %eax,(%esp)
80105609:	e8 ac ba ff ff       	call   801010ba <filestat>
}
8010560e:	c9                   	leave  
8010560f:	c3                   	ret    

80105610 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105616:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105619:	89 44 24 04          	mov    %eax,0x4(%esp)
8010561d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105624:	e8 61 fc ff ff       	call   8010528a <argstr>
80105629:	85 c0                	test   %eax,%eax
8010562b:	78 17                	js     80105644 <sys_link+0x34>
8010562d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105630:	89 44 24 04          	mov    %eax,0x4(%esp)
80105634:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010563b:	e8 4a fc ff ff       	call   8010528a <argstr>
80105640:	85 c0                	test   %eax,%eax
80105642:	79 0a                	jns    8010564e <sys_link+0x3e>
    return -1;
80105644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105649:	e9 3c 01 00 00       	jmp    8010578a <sys_link+0x17a>
  if((ip = namei(old)) == 0)
8010564e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105651:	89 04 24             	mov    %eax,(%esp)
80105654:	e8 31 cf ff ff       	call   8010258a <namei>
80105659:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010565c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105660:	75 0a                	jne    8010566c <sys_link+0x5c>
    return -1;
80105662:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105667:	e9 1e 01 00 00       	jmp    8010578a <sys_link+0x17a>

  begin_trans();
8010566c:	e8 3e dd ff ff       	call   801033af <begin_trans>

  ilock(ip);
80105671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105674:	89 04 24             	mov    %eax,(%esp)
80105677:	e8 10 c2 ff ff       	call   8010188c <ilock>
  if(ip->type == T_DIR){
8010567c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010567f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105683:	66 83 f8 01          	cmp    $0x1,%ax
80105687:	75 1a                	jne    801056a3 <sys_link+0x93>
    iunlockput(ip);
80105689:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010568c:	89 04 24             	mov    %eax,(%esp)
8010568f:	e8 7c c4 ff ff       	call   80101b10 <iunlockput>
    commit_trans();
80105694:	e8 5f dd ff ff       	call   801033f8 <commit_trans>
    return -1;
80105699:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010569e:	e9 e7 00 00 00       	jmp    8010578a <sys_link+0x17a>
  }

  ip->nlink++;
801056a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a6:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801056aa:	8d 50 01             	lea    0x1(%eax),%edx
801056ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056b0:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801056b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056b7:	89 04 24             	mov    %eax,(%esp)
801056ba:	e8 11 c0 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
801056bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056c2:	89 04 24             	mov    %eax,(%esp)
801056c5:	e8 10 c3 ff ff       	call   801019da <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801056ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056cd:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801056d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801056d4:	89 04 24             	mov    %eax,(%esp)
801056d7:	e8 d0 ce ff ff       	call   801025ac <nameiparent>
801056dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801056df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801056e3:	74 68                	je     8010574d <sys_link+0x13d>
    goto bad;
  ilock(dp);
801056e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056e8:	89 04 24             	mov    %eax,(%esp)
801056eb:	e8 9c c1 ff ff       	call   8010188c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801056f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f3:	8b 10                	mov    (%eax),%edx
801056f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056f8:	8b 00                	mov    (%eax),%eax
801056fa:	39 c2                	cmp    %eax,%edx
801056fc:	75 20                	jne    8010571e <sys_link+0x10e>
801056fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105701:	8b 40 04             	mov    0x4(%eax),%eax
80105704:	89 44 24 08          	mov    %eax,0x8(%esp)
80105708:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010570b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010570f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105712:	89 04 24             	mov    %eax,(%esp)
80105715:	e8 ad cb ff ff       	call   801022c7 <dirlink>
8010571a:	85 c0                	test   %eax,%eax
8010571c:	79 0d                	jns    8010572b <sys_link+0x11b>
    iunlockput(dp);
8010571e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105721:	89 04 24             	mov    %eax,(%esp)
80105724:	e8 e7 c3 ff ff       	call   80101b10 <iunlockput>
    goto bad;
80105729:	eb 23                	jmp    8010574e <sys_link+0x13e>
  }
  iunlockput(dp);
8010572b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010572e:	89 04 24             	mov    %eax,(%esp)
80105731:	e8 da c3 ff ff       	call   80101b10 <iunlockput>
  iput(ip);
80105736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105739:	89 04 24             	mov    %eax,(%esp)
8010573c:	e8 fe c2 ff ff       	call   80101a3f <iput>

  commit_trans();
80105741:	e8 b2 dc ff ff       	call   801033f8 <commit_trans>

  return 0;
80105746:	b8 00 00 00 00       	mov    $0x0,%eax
8010574b:	eb 3d                	jmp    8010578a <sys_link+0x17a>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
8010574d:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
8010574e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105751:	89 04 24             	mov    %eax,(%esp)
80105754:	e8 33 c1 ff ff       	call   8010188c <ilock>
  ip->nlink--;
80105759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010575c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105760:	8d 50 ff             	lea    -0x1(%eax),%edx
80105763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105766:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010576a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010576d:	89 04 24             	mov    %eax,(%esp)
80105770:	e8 5b bf ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105778:	89 04 24             	mov    %eax,(%esp)
8010577b:	e8 90 c3 ff ff       	call   80101b10 <iunlockput>
  commit_trans();
80105780:	e8 73 dc ff ff       	call   801033f8 <commit_trans>
  return -1;
80105785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010578a:	c9                   	leave  
8010578b:	c3                   	ret    

8010578c <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010578c:	55                   	push   %ebp
8010578d:	89 e5                	mov    %esp,%ebp
8010578f:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105792:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105799:	eb 4b                	jmp    801057e6 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010579b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010579e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801057a5:	00 
801057a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801057aa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801057b1:	8b 45 08             	mov    0x8(%ebp),%eax
801057b4:	89 04 24             	mov    %eax,(%esp)
801057b7:	e8 1a c7 ff ff       	call   80101ed6 <readi>
801057bc:	83 f8 10             	cmp    $0x10,%eax
801057bf:	74 0c                	je     801057cd <isdirempty+0x41>
      panic("isdirempty: readi");
801057c1:	c7 04 24 27 88 10 80 	movl   $0x80108827,(%esp)
801057c8:	e8 79 ad ff ff       	call   80100546 <panic>
    if(de.inum != 0)
801057cd:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801057d1:	66 85 c0             	test   %ax,%ax
801057d4:	74 07                	je     801057dd <isdirempty+0x51>
      return 0;
801057d6:	b8 00 00 00 00       	mov    $0x0,%eax
801057db:	eb 1b                	jmp    801057f8 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e0:	83 c0 10             	add    $0x10,%eax
801057e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057e9:	8b 45 08             	mov    0x8(%ebp),%eax
801057ec:	8b 40 18             	mov    0x18(%eax),%eax
801057ef:	39 c2                	cmp    %eax,%edx
801057f1:	72 a8                	jb     8010579b <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801057f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801057f8:	c9                   	leave  
801057f9:	c3                   	ret    

801057fa <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801057fa:	55                   	push   %ebp
801057fb:	89 e5                	mov    %esp,%ebp
801057fd:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105800:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105803:	89 44 24 04          	mov    %eax,0x4(%esp)
80105807:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010580e:	e8 77 fa ff ff       	call   8010528a <argstr>
80105813:	85 c0                	test   %eax,%eax
80105815:	79 0a                	jns    80105821 <sys_unlink+0x27>
    return -1;
80105817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581c:	e9 aa 01 00 00       	jmp    801059cb <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80105821:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105824:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105827:	89 54 24 04          	mov    %edx,0x4(%esp)
8010582b:	89 04 24             	mov    %eax,(%esp)
8010582e:	e8 79 cd ff ff       	call   801025ac <nameiparent>
80105833:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105836:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010583a:	75 0a                	jne    80105846 <sys_unlink+0x4c>
    return -1;
8010583c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105841:	e9 85 01 00 00       	jmp    801059cb <sys_unlink+0x1d1>

  begin_trans();
80105846:	e8 64 db ff ff       	call   801033af <begin_trans>

  ilock(dp);
8010584b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010584e:	89 04 24             	mov    %eax,(%esp)
80105851:	e8 36 c0 ff ff       	call   8010188c <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105856:	c7 44 24 04 39 88 10 	movl   $0x80108839,0x4(%esp)
8010585d:	80 
8010585e:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105861:	89 04 24             	mov    %eax,(%esp)
80105864:	e8 74 c9 ff ff       	call   801021dd <namecmp>
80105869:	85 c0                	test   %eax,%eax
8010586b:	0f 84 45 01 00 00    	je     801059b6 <sys_unlink+0x1bc>
80105871:	c7 44 24 04 3b 88 10 	movl   $0x8010883b,0x4(%esp)
80105878:	80 
80105879:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010587c:	89 04 24             	mov    %eax,(%esp)
8010587f:	e8 59 c9 ff ff       	call   801021dd <namecmp>
80105884:	85 c0                	test   %eax,%eax
80105886:	0f 84 2a 01 00 00    	je     801059b6 <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010588c:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010588f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105893:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105896:	89 44 24 04          	mov    %eax,0x4(%esp)
8010589a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010589d:	89 04 24             	mov    %eax,(%esp)
801058a0:	e8 5a c9 ff ff       	call   801021ff <dirlookup>
801058a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801058a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058ac:	0f 84 03 01 00 00    	je     801059b5 <sys_unlink+0x1bb>
    goto bad;
  ilock(ip);
801058b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058b5:	89 04 24             	mov    %eax,(%esp)
801058b8:	e8 cf bf ff ff       	call   8010188c <ilock>

  if(ip->nlink < 1)
801058bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058c0:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801058c4:	66 85 c0             	test   %ax,%ax
801058c7:	7f 0c                	jg     801058d5 <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
801058c9:	c7 04 24 3e 88 10 80 	movl   $0x8010883e,(%esp)
801058d0:	e8 71 ac ff ff       	call   80100546 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801058d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058d8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801058dc:	66 83 f8 01          	cmp    $0x1,%ax
801058e0:	75 1f                	jne    80105901 <sys_unlink+0x107>
801058e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058e5:	89 04 24             	mov    %eax,(%esp)
801058e8:	e8 9f fe ff ff       	call   8010578c <isdirempty>
801058ed:	85 c0                	test   %eax,%eax
801058ef:	75 10                	jne    80105901 <sys_unlink+0x107>
    iunlockput(ip);
801058f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058f4:	89 04 24             	mov    %eax,(%esp)
801058f7:	e8 14 c2 ff ff       	call   80101b10 <iunlockput>
    goto bad;
801058fc:	e9 b5 00 00 00       	jmp    801059b6 <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
80105901:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105908:	00 
80105909:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105910:	00 
80105911:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105914:	89 04 24             	mov    %eax,(%esp)
80105917:	e8 82 f5 ff ff       	call   80104e9e <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010591c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010591f:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105926:	00 
80105927:	89 44 24 08          	mov    %eax,0x8(%esp)
8010592b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010592e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105932:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105935:	89 04 24             	mov    %eax,(%esp)
80105938:	e8 07 c7 ff ff       	call   80102044 <writei>
8010593d:	83 f8 10             	cmp    $0x10,%eax
80105940:	74 0c                	je     8010594e <sys_unlink+0x154>
    panic("unlink: writei");
80105942:	c7 04 24 50 88 10 80 	movl   $0x80108850,(%esp)
80105949:	e8 f8 ab ff ff       	call   80100546 <panic>
  if(ip->type == T_DIR){
8010594e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105951:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105955:	66 83 f8 01          	cmp    $0x1,%ax
80105959:	75 1c                	jne    80105977 <sys_unlink+0x17d>
    dp->nlink--;
8010595b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010595e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105962:	8d 50 ff             	lea    -0x1(%eax),%edx
80105965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105968:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010596c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010596f:	89 04 24             	mov    %eax,(%esp)
80105972:	e8 59 bd ff ff       	call   801016d0 <iupdate>
  }
  iunlockput(dp);
80105977:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010597a:	89 04 24             	mov    %eax,(%esp)
8010597d:	e8 8e c1 ff ff       	call   80101b10 <iunlockput>

  ip->nlink--;
80105982:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105985:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105989:	8d 50 ff             	lea    -0x1(%eax),%edx
8010598c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010598f:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105993:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105996:	89 04 24             	mov    %eax,(%esp)
80105999:	e8 32 bd ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010599e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059a1:	89 04 24             	mov    %eax,(%esp)
801059a4:	e8 67 c1 ff ff       	call   80101b10 <iunlockput>

  commit_trans();
801059a9:	e8 4a da ff ff       	call   801033f8 <commit_trans>

  return 0;
801059ae:	b8 00 00 00 00       	mov    $0x0,%eax
801059b3:	eb 16                	jmp    801059cb <sys_unlink+0x1d1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
801059b5:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
801059b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b9:	89 04 24             	mov    %eax,(%esp)
801059bc:	e8 4f c1 ff ff       	call   80101b10 <iunlockput>
  commit_trans();
801059c1:	e8 32 da ff ff       	call   801033f8 <commit_trans>
  return -1;
801059c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059cb:	c9                   	leave  
801059cc:	c3                   	ret    

801059cd <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801059cd:	55                   	push   %ebp
801059ce:	89 e5                	mov    %esp,%ebp
801059d0:	83 ec 48             	sub    $0x48,%esp
801059d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801059d6:	8b 55 10             	mov    0x10(%ebp),%edx
801059d9:	8b 45 14             	mov    0x14(%ebp),%eax
801059dc:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801059e0:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801059e4:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801059e8:	8d 45 de             	lea    -0x22(%ebp),%eax
801059eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801059ef:	8b 45 08             	mov    0x8(%ebp),%eax
801059f2:	89 04 24             	mov    %eax,(%esp)
801059f5:	e8 b2 cb ff ff       	call   801025ac <nameiparent>
801059fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a01:	75 0a                	jne    80105a0d <create+0x40>
    return 0;
80105a03:	b8 00 00 00 00       	mov    $0x0,%eax
80105a08:	e9 7e 01 00 00       	jmp    80105b8b <create+0x1be>
  ilock(dp);
80105a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a10:	89 04 24             	mov    %eax,(%esp)
80105a13:	e8 74 be ff ff       	call   8010188c <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105a18:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a1b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a1f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105a22:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a29:	89 04 24             	mov    %eax,(%esp)
80105a2c:	e8 ce c7 ff ff       	call   801021ff <dirlookup>
80105a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a38:	74 47                	je     80105a81 <create+0xb4>
    iunlockput(dp);
80105a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3d:	89 04 24             	mov    %eax,(%esp)
80105a40:	e8 cb c0 ff ff       	call   80101b10 <iunlockput>
    ilock(ip);
80105a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a48:	89 04 24             	mov    %eax,(%esp)
80105a4b:	e8 3c be ff ff       	call   8010188c <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105a50:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105a55:	75 15                	jne    80105a6c <create+0x9f>
80105a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a5a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105a5e:	66 83 f8 02          	cmp    $0x2,%ax
80105a62:	75 08                	jne    80105a6c <create+0x9f>
      return ip;
80105a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a67:	e9 1f 01 00 00       	jmp    80105b8b <create+0x1be>
    iunlockput(ip);
80105a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a6f:	89 04 24             	mov    %eax,(%esp)
80105a72:	e8 99 c0 ff ff       	call   80101b10 <iunlockput>
    return 0;
80105a77:	b8 00 00 00 00       	mov    $0x0,%eax
80105a7c:	e9 0a 01 00 00       	jmp    80105b8b <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105a81:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a88:	8b 00                	mov    (%eax),%eax
80105a8a:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a8e:	89 04 24             	mov    %eax,(%esp)
80105a91:	e8 5b bb ff ff       	call   801015f1 <ialloc>
80105a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a9d:	75 0c                	jne    80105aab <create+0xde>
    panic("create: ialloc");
80105a9f:	c7 04 24 5f 88 10 80 	movl   $0x8010885f,(%esp)
80105aa6:	e8 9b aa ff ff       	call   80100546 <panic>

  ilock(ip);
80105aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aae:	89 04 24             	mov    %eax,(%esp)
80105ab1:	e8 d6 bd ff ff       	call   8010188c <ilock>
  ip->major = major;
80105ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab9:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105abd:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ac4:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105ac8:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105acf:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ad8:	89 04 24             	mov    %eax,(%esp)
80105adb:	e8 f0 bb ff ff       	call   801016d0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105ae0:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105ae5:	75 6a                	jne    80105b51 <create+0x184>
    dp->nlink++;  // for ".."
80105ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aea:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105aee:	8d 50 01             	lea    0x1(%eax),%edx
80105af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af4:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105afb:	89 04 24             	mov    %eax,(%esp)
80105afe:	e8 cd bb ff ff       	call   801016d0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b06:	8b 40 04             	mov    0x4(%eax),%eax
80105b09:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b0d:	c7 44 24 04 39 88 10 	movl   $0x80108839,0x4(%esp)
80105b14:	80 
80105b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b18:	89 04 24             	mov    %eax,(%esp)
80105b1b:	e8 a7 c7 ff ff       	call   801022c7 <dirlink>
80105b20:	85 c0                	test   %eax,%eax
80105b22:	78 21                	js     80105b45 <create+0x178>
80105b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b27:	8b 40 04             	mov    0x4(%eax),%eax
80105b2a:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b2e:	c7 44 24 04 3b 88 10 	movl   $0x8010883b,0x4(%esp)
80105b35:	80 
80105b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b39:	89 04 24             	mov    %eax,(%esp)
80105b3c:	e8 86 c7 ff ff       	call   801022c7 <dirlink>
80105b41:	85 c0                	test   %eax,%eax
80105b43:	79 0c                	jns    80105b51 <create+0x184>
      panic("create dots");
80105b45:	c7 04 24 6e 88 10 80 	movl   $0x8010886e,(%esp)
80105b4c:	e8 f5 a9 ff ff       	call   80100546 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b54:	8b 40 04             	mov    0x4(%eax),%eax
80105b57:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b5b:	8d 45 de             	lea    -0x22(%ebp),%eax
80105b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b65:	89 04 24             	mov    %eax,(%esp)
80105b68:	e8 5a c7 ff ff       	call   801022c7 <dirlink>
80105b6d:	85 c0                	test   %eax,%eax
80105b6f:	79 0c                	jns    80105b7d <create+0x1b0>
    panic("create: dirlink");
80105b71:	c7 04 24 7a 88 10 80 	movl   $0x8010887a,(%esp)
80105b78:	e8 c9 a9 ff ff       	call   80100546 <panic>

  iunlockput(dp);
80105b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b80:	89 04 24             	mov    %eax,(%esp)
80105b83:	e8 88 bf ff ff       	call   80101b10 <iunlockput>

  return ip;
80105b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105b8b:	c9                   	leave  
80105b8c:	c3                   	ret    

80105b8d <sys_open>:

int
sys_open(void)
{
80105b8d:	55                   	push   %ebp
80105b8e:	89 e5                	mov    %esp,%ebp
80105b90:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b93:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105b96:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ba1:	e8 e4 f6 ff ff       	call   8010528a <argstr>
80105ba6:	85 c0                	test   %eax,%eax
80105ba8:	78 17                	js     80105bc1 <sys_open+0x34>
80105baa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bad:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bb1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105bb8:	e8 3d f6 ff ff       	call   801051fa <argint>
80105bbd:	85 c0                	test   %eax,%eax
80105bbf:	79 0a                	jns    80105bcb <sys_open+0x3e>
    return -1;
80105bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc6:	e9 48 01 00 00       	jmp    80105d13 <sys_open+0x186>
  if(omode & O_CREATE){
80105bcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105bce:	25 00 02 00 00       	and    $0x200,%eax
80105bd3:	85 c0                	test   %eax,%eax
80105bd5:	74 40                	je     80105c17 <sys_open+0x8a>
    begin_trans();
80105bd7:	e8 d3 d7 ff ff       	call   801033af <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105bdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105bdf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105be6:	00 
80105be7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105bee:	00 
80105bef:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105bf6:	00 
80105bf7:	89 04 24             	mov    %eax,(%esp)
80105bfa:	e8 ce fd ff ff       	call   801059cd <create>
80105bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105c02:	e8 f1 d7 ff ff       	call   801033f8 <commit_trans>
    if(ip == 0)
80105c07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c0b:	75 5c                	jne    80105c69 <sys_open+0xdc>
      return -1;
80105c0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c12:	e9 fc 00 00 00       	jmp    80105d13 <sys_open+0x186>
  } else {
    if((ip = namei(path)) == 0)
80105c17:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c1a:	89 04 24             	mov    %eax,(%esp)
80105c1d:	e8 68 c9 ff ff       	call   8010258a <namei>
80105c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c29:	75 0a                	jne    80105c35 <sys_open+0xa8>
      return -1;
80105c2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c30:	e9 de 00 00 00       	jmp    80105d13 <sys_open+0x186>
    ilock(ip);
80105c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c38:	89 04 24             	mov    %eax,(%esp)
80105c3b:	e8 4c bc ff ff       	call   8010188c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c43:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c47:	66 83 f8 01          	cmp    $0x1,%ax
80105c4b:	75 1c                	jne    80105c69 <sys_open+0xdc>
80105c4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c50:	85 c0                	test   %eax,%eax
80105c52:	74 15                	je     80105c69 <sys_open+0xdc>
      iunlockput(ip);
80105c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c57:	89 04 24             	mov    %eax,(%esp)
80105c5a:	e8 b1 be ff ff       	call   80101b10 <iunlockput>
      return -1;
80105c5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c64:	e9 aa 00 00 00       	jmp    80105d13 <sys_open+0x186>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105c69:	e8 ce b2 ff ff       	call   80100f3c <filealloc>
80105c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c75:	74 14                	je     80105c8b <sys_open+0xfe>
80105c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c7a:	89 04 24             	mov    %eax,(%esp)
80105c7d:	e8 43 f7 ff ff       	call   801053c5 <fdalloc>
80105c82:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105c85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105c89:	79 23                	jns    80105cae <sys_open+0x121>
    if(f)
80105c8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c8f:	74 0b                	je     80105c9c <sys_open+0x10f>
      fileclose(f);
80105c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c94:	89 04 24             	mov    %eax,(%esp)
80105c97:	e8 48 b3 ff ff       	call   80100fe4 <fileclose>
    iunlockput(ip);
80105c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9f:	89 04 24             	mov    %eax,(%esp)
80105ca2:	e8 69 be ff ff       	call   80101b10 <iunlockput>
    return -1;
80105ca7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cac:	eb 65                	jmp    80105d13 <sys_open+0x186>
  }
  iunlock(ip);
80105cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb1:	89 04 24             	mov    %eax,(%esp)
80105cb4:	e8 21 bd ff ff       	call   801019da <iunlock>

  f->type = FD_INODE;
80105cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cbc:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cc8:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cce:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105cd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cd8:	83 e0 01             	and    $0x1,%eax
80105cdb:	85 c0                	test   %eax,%eax
80105cdd:	0f 94 c0             	sete   %al
80105ce0:	89 c2                	mov    %eax,%edx
80105ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ce5:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ce8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ceb:	83 e0 01             	and    $0x1,%eax
80105cee:	85 c0                	test   %eax,%eax
80105cf0:	75 0a                	jne    80105cfc <sys_open+0x16f>
80105cf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cf5:	83 e0 02             	and    $0x2,%eax
80105cf8:	85 c0                	test   %eax,%eax
80105cfa:	74 07                	je     80105d03 <sys_open+0x176>
80105cfc:	b8 01 00 00 00       	mov    $0x1,%eax
80105d01:	eb 05                	jmp    80105d08 <sys_open+0x17b>
80105d03:	b8 00 00 00 00       	mov    $0x0,%eax
80105d08:	89 c2                	mov    %eax,%edx
80105d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d0d:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105d13:	c9                   	leave  
80105d14:	c3                   	ret    

80105d15 <sys_mkdir>:

int
sys_mkdir(void)
{
80105d15:	55                   	push   %ebp
80105d16:	89 e5                	mov    %esp,%ebp
80105d18:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105d1b:	e8 8f d6 ff ff       	call   801033af <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105d20:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d23:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d2e:	e8 57 f5 ff ff       	call   8010528a <argstr>
80105d33:	85 c0                	test   %eax,%eax
80105d35:	78 2c                	js     80105d63 <sys_mkdir+0x4e>
80105d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d3a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105d41:	00 
80105d42:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105d49:	00 
80105d4a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105d51:	00 
80105d52:	89 04 24             	mov    %eax,(%esp)
80105d55:	e8 73 fc ff ff       	call   801059cd <create>
80105d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d61:	75 0c                	jne    80105d6f <sys_mkdir+0x5a>
    commit_trans();
80105d63:	e8 90 d6 ff ff       	call   801033f8 <commit_trans>
    return -1;
80105d68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d6d:	eb 15                	jmp    80105d84 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d72:	89 04 24             	mov    %eax,(%esp)
80105d75:	e8 96 bd ff ff       	call   80101b10 <iunlockput>
  commit_trans();
80105d7a:	e8 79 d6 ff ff       	call   801033f8 <commit_trans>
  return 0;
80105d7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d84:	c9                   	leave  
80105d85:	c3                   	ret    

80105d86 <sys_mknod>:

int
sys_mknod(void)
{
80105d86:	55                   	push   %ebp
80105d87:	89 e5                	mov    %esp,%ebp
80105d89:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105d8c:	e8 1e d6 ff ff       	call   801033af <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105d91:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d94:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d9f:	e8 e6 f4 ff ff       	call   8010528a <argstr>
80105da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105da7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dab:	78 5e                	js     80105e0b <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80105dad:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105db0:	89 44 24 04          	mov    %eax,0x4(%esp)
80105db4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105dbb:	e8 3a f4 ff ff       	call   801051fa <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105dc0:	85 c0                	test   %eax,%eax
80105dc2:	78 47                	js     80105e0b <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105dc4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dcb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105dd2:	e8 23 f4 ff ff       	call   801051fa <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	78 30                	js     80105e0b <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dde:	0f bf c8             	movswl %ax,%ecx
80105de1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105de4:	0f bf d0             	movswl %ax,%edx
80105de7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105dea:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105dee:	89 54 24 08          	mov    %edx,0x8(%esp)
80105df2:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105df9:	00 
80105dfa:	89 04 24             	mov    %eax,(%esp)
80105dfd:	e8 cb fb ff ff       	call   801059cd <create>
80105e02:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e09:	75 0c                	jne    80105e17 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80105e0b:	e8 e8 d5 ff ff       	call   801033f8 <commit_trans>
    return -1;
80105e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e15:	eb 15                	jmp    80105e2c <sys_mknod+0xa6>
  }
  iunlockput(ip);
80105e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e1a:	89 04 24             	mov    %eax,(%esp)
80105e1d:	e8 ee bc ff ff       	call   80101b10 <iunlockput>
  commit_trans();
80105e22:	e8 d1 d5 ff ff       	call   801033f8 <commit_trans>
  return 0;
80105e27:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e2c:	c9                   	leave  
80105e2d:	c3                   	ret    

80105e2e <sys_chdir>:

int
sys_chdir(void)
{
80105e2e:	55                   	push   %ebp
80105e2f:	89 e5                	mov    %esp,%ebp
80105e31:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105e34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e37:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e42:	e8 43 f4 ff ff       	call   8010528a <argstr>
80105e47:	85 c0                	test   %eax,%eax
80105e49:	78 14                	js     80105e5f <sys_chdir+0x31>
80105e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e4e:	89 04 24             	mov    %eax,(%esp)
80105e51:	e8 34 c7 ff ff       	call   8010258a <namei>
80105e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e5d:	75 07                	jne    80105e66 <sys_chdir+0x38>
    return -1;
80105e5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e64:	eb 57                	jmp    80105ebd <sys_chdir+0x8f>
  ilock(ip);
80105e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e69:	89 04 24             	mov    %eax,(%esp)
80105e6c:	e8 1b ba ff ff       	call   8010188c <ilock>
  if(ip->type != T_DIR){
80105e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e74:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105e78:	66 83 f8 01          	cmp    $0x1,%ax
80105e7c:	74 12                	je     80105e90 <sys_chdir+0x62>
    iunlockput(ip);
80105e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e81:	89 04 24             	mov    %eax,(%esp)
80105e84:	e8 87 bc ff ff       	call   80101b10 <iunlockput>
    return -1;
80105e89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e8e:	eb 2d                	jmp    80105ebd <sys_chdir+0x8f>
  }
  iunlock(ip);
80105e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e93:	89 04 24             	mov    %eax,(%esp)
80105e96:	e8 3f bb ff ff       	call   801019da <iunlock>
  iput(proc->cwd);
80105e9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ea1:	8b 40 68             	mov    0x68(%eax),%eax
80105ea4:	89 04 24             	mov    %eax,(%esp)
80105ea7:	e8 93 bb ff ff       	call   80101a3f <iput>
  proc->cwd = ip;
80105eac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105eb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105eb5:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105eb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ebd:	c9                   	leave  
80105ebe:	c3                   	ret    

80105ebf <sys_exec>:

int
sys_exec(void)
{
80105ebf:	55                   	push   %ebp
80105ec0:	89 e5                	mov    %esp,%ebp
80105ec2:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ec8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ecb:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ecf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ed6:	e8 af f3 ff ff       	call   8010528a <argstr>
80105edb:	85 c0                	test   %eax,%eax
80105edd:	78 1a                	js     80105ef9 <sys_exec+0x3a>
80105edf:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105ee5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ee9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ef0:	e8 05 f3 ff ff       	call   801051fa <argint>
80105ef5:	85 c0                	test   %eax,%eax
80105ef7:	79 0a                	jns    80105f03 <sys_exec+0x44>
    return -1;
80105ef9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105efe:	e9 c8 00 00 00       	jmp    80105fcb <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
80105f03:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105f0a:	00 
80105f0b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105f12:	00 
80105f13:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105f19:	89 04 24             	mov    %eax,(%esp)
80105f1c:	e8 7d ef ff ff       	call   80104e9e <memset>
  for(i=0;; i++){
80105f21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f2b:	83 f8 1f             	cmp    $0x1f,%eax
80105f2e:	76 0a                	jbe    80105f3a <sys_exec+0x7b>
      return -1;
80105f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f35:	e9 91 00 00 00       	jmp    80105fcb <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f3d:	c1 e0 02             	shl    $0x2,%eax
80105f40:	89 c2                	mov    %eax,%edx
80105f42:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105f48:	01 c2                	add    %eax,%edx
80105f4a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105f50:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f54:	89 14 24             	mov    %edx,(%esp)
80105f57:	e8 00 f2 ff ff       	call   8010515c <fetchint>
80105f5c:	85 c0                	test   %eax,%eax
80105f5e:	79 07                	jns    80105f67 <sys_exec+0xa8>
      return -1;
80105f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f65:	eb 64                	jmp    80105fcb <sys_exec+0x10c>
    if(uarg == 0){
80105f67:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105f6d:	85 c0                	test   %eax,%eax
80105f6f:	75 26                	jne    80105f97 <sys_exec+0xd8>
      argv[i] = 0;
80105f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f74:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105f7b:	00 00 00 00 
      break;
80105f7f:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f83:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105f89:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f8d:	89 04 24             	mov    %eax,(%esp)
80105f90:	e8 73 ab ff ff       	call   80100b08 <exec>
80105f95:	eb 34                	jmp    80105fcb <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105f97:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105f9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fa0:	c1 e2 02             	shl    $0x2,%edx
80105fa3:	01 c2                	add    %eax,%edx
80105fa5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105fab:	89 54 24 04          	mov    %edx,0x4(%esp)
80105faf:	89 04 24             	mov    %eax,(%esp)
80105fb2:	e8 df f1 ff ff       	call   80105196 <fetchstr>
80105fb7:	85 c0                	test   %eax,%eax
80105fb9:	79 07                	jns    80105fc2 <sys_exec+0x103>
      return -1;
80105fbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc0:	eb 09                	jmp    80105fcb <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105fc2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80105fc6:	e9 5d ff ff ff       	jmp    80105f28 <sys_exec+0x69>
  return exec(path, argv);
}
80105fcb:	c9                   	leave  
80105fcc:	c3                   	ret    

80105fcd <sys_pipe>:

int
sys_pipe(void)
{
80105fcd:	55                   	push   %ebp
80105fce:	89 e5                	mov    %esp,%ebp
80105fd0:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105fd3:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105fda:	00 
80105fdb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105fde:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fe2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fe9:	e8 3a f2 ff ff       	call   80105228 <argptr>
80105fee:	85 c0                	test   %eax,%eax
80105ff0:	79 0a                	jns    80105ffc <sys_pipe+0x2f>
    return -1;
80105ff2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ff7:	e9 9b 00 00 00       	jmp    80106097 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80105ffc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fff:	89 44 24 04          	mov    %eax,0x4(%esp)
80106003:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106006:	89 04 24             	mov    %eax,(%esp)
80106009:	e8 5a dd ff ff       	call   80103d68 <pipealloc>
8010600e:	85 c0                	test   %eax,%eax
80106010:	79 07                	jns    80106019 <sys_pipe+0x4c>
    return -1;
80106012:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106017:	eb 7e                	jmp    80106097 <sys_pipe+0xca>
  fd0 = -1;
80106019:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106020:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106023:	89 04 24             	mov    %eax,(%esp)
80106026:	e8 9a f3 ff ff       	call   801053c5 <fdalloc>
8010602b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010602e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106032:	78 14                	js     80106048 <sys_pipe+0x7b>
80106034:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106037:	89 04 24             	mov    %eax,(%esp)
8010603a:	e8 86 f3 ff ff       	call   801053c5 <fdalloc>
8010603f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106042:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106046:	79 37                	jns    8010607f <sys_pipe+0xb2>
    if(fd0 >= 0)
80106048:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010604c:	78 14                	js     80106062 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
8010604e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106054:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106057:	83 c2 08             	add    $0x8,%edx
8010605a:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106061:	00 
    fileclose(rf);
80106062:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106065:	89 04 24             	mov    %eax,(%esp)
80106068:	e8 77 af ff ff       	call   80100fe4 <fileclose>
    fileclose(wf);
8010606d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106070:	89 04 24             	mov    %eax,(%esp)
80106073:	e8 6c af ff ff       	call   80100fe4 <fileclose>
    return -1;
80106078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010607d:	eb 18                	jmp    80106097 <sys_pipe+0xca>
  }
  fd[0] = fd0;
8010607f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106082:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106085:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106087:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010608a:	8d 50 04             	lea    0x4(%eax),%edx
8010608d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106090:	89 02                	mov    %eax,(%edx)
  return 0;
80106092:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106097:	c9                   	leave  
80106098:	c3                   	ret    
80106099:	66 90                	xchg   %ax,%ax
8010609b:	90                   	nop

8010609c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010609c:	55                   	push   %ebp
8010609d:	89 e5                	mov    %esp,%ebp
8010609f:	83 ec 08             	sub    $0x8,%esp
801060a2:	8b 55 08             	mov    0x8(%ebp),%edx
801060a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801060a8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801060ac:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060af:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801060b3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801060b7:	ee                   	out    %al,(%dx)
}
801060b8:	c9                   	leave  
801060b9:	c3                   	ret    

801060ba <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801060ba:	55                   	push   %ebp
801060bb:	89 e5                	mov    %esp,%ebp
801060bd:	83 ec 08             	sub    $0x8,%esp
  return fork();
801060c0:	e8 5d e3 ff ff       	call   80104422 <fork>
}
801060c5:	c9                   	leave  
801060c6:	c3                   	ret    

801060c7 <sys_exit>:

int
sys_exit(void)
{
801060c7:	55                   	push   %ebp
801060c8:	89 e5                	mov    %esp,%ebp
801060ca:	83 ec 08             	sub    $0x8,%esp
  exit();
801060cd:	e8 b3 e4 ff ff       	call   80104585 <exit>
  return 0;  // not reached
801060d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060d7:	c9                   	leave  
801060d8:	c3                   	ret    

801060d9 <sys_wait>:

int
sys_wait(void)
{
801060d9:	55                   	push   %ebp
801060da:	89 e5                	mov    %esp,%ebp
801060dc:	83 ec 08             	sub    $0x8,%esp
  return wait();
801060df:	e8 bc e5 ff ff       	call   801046a0 <wait>
}
801060e4:	c9                   	leave  
801060e5:	c3                   	ret    

801060e6 <sys_kill>:

int
sys_kill(void)
{
801060e6:	55                   	push   %ebp
801060e7:	89 e5                	mov    %esp,%ebp
801060e9:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801060ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801060f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060fa:	e8 fb f0 ff ff       	call   801051fa <argint>
801060ff:	85 c0                	test   %eax,%eax
80106101:	79 07                	jns    8010610a <sys_kill+0x24>
    return -1;
80106103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106108:	eb 0b                	jmp    80106115 <sys_kill+0x2f>
  return kill(pid);
8010610a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010610d:	89 04 24             	mov    %eax,(%esp)
80106110:	e8 50 e9 ff ff       	call   80104a65 <kill>
}
80106115:	c9                   	leave  
80106116:	c3                   	ret    

80106117 <sys_getpid>:

int
sys_getpid(void)
{
80106117:	55                   	push   %ebp
80106118:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010611a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106120:	8b 40 10             	mov    0x10(%eax),%eax
}
80106123:	5d                   	pop    %ebp
80106124:	c3                   	ret    

80106125 <sys_sbrk>:

int
sys_sbrk(void)
{
80106125:	55                   	push   %ebp
80106126:	89 e5                	mov    %esp,%ebp
80106128:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010612b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010612e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106132:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106139:	e8 bc f0 ff ff       	call   801051fa <argint>
8010613e:	85 c0                	test   %eax,%eax
80106140:	79 07                	jns    80106149 <sys_sbrk+0x24>
    return -1;
80106142:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106147:	eb 3a                	jmp    80106183 <sys_sbrk+0x5e>
  addr = proc->sz;
80106149:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010614f:	8b 00                	mov    (%eax),%eax
80106151:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106154:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106157:	89 04 24             	mov    %eax,(%esp)
8010615a:	e8 1e e2 ff ff       	call   8010437d <growproc>
8010615f:	85 c0                	test   %eax,%eax
80106161:	79 07                	jns    8010616a <sys_sbrk+0x45>
    return -1;
80106163:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106168:	eb 19                	jmp    80106183 <sys_sbrk+0x5e>
  proc->sz = proc->sz + n;
8010616a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106170:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106177:	8b 0a                	mov    (%edx),%ecx
80106179:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010617c:	01 ca                	add    %ecx,%edx
8010617e:	89 10                	mov    %edx,(%eax)
  return addr;
80106180:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106183:	c9                   	leave  
80106184:	c3                   	ret    

80106185 <sys_sleep>:

int
sys_sleep(void)
{
80106185:	55                   	push   %ebp
80106186:	89 e5                	mov    %esp,%ebp
80106188:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010618b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010618e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106192:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106199:	e8 5c f0 ff ff       	call   801051fa <argint>
8010619e:	85 c0                	test   %eax,%eax
801061a0:	79 07                	jns    801061a9 <sys_sleep+0x24>
    return -1;
801061a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061a7:	eb 6c                	jmp    80106215 <sys_sleep+0x90>
  acquire(&tickslock);
801061a9:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
801061b0:	e8 8e ea ff ff       	call   80104c43 <acquire>
  ticks0 = ticks;
801061b5:	a1 a0 29 11 80       	mov    0x801129a0,%eax
801061ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801061bd:	eb 34                	jmp    801061f3 <sys_sleep+0x6e>
    if(proc->killed){
801061bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061c5:	8b 40 24             	mov    0x24(%eax),%eax
801061c8:	85 c0                	test   %eax,%eax
801061ca:	74 13                	je     801061df <sys_sleep+0x5a>
      release(&tickslock);
801061cc:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
801061d3:	e8 cd ea ff ff       	call   80104ca5 <release>
      return -1;
801061d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061dd:	eb 36                	jmp    80106215 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
801061df:	c7 44 24 04 60 21 11 	movl   $0x80112160,0x4(%esp)
801061e6:	80 
801061e7:	c7 04 24 a0 29 11 80 	movl   $0x801129a0,(%esp)
801061ee:	e8 6b e7 ff ff       	call   8010495e <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801061f3:	a1 a0 29 11 80       	mov    0x801129a0,%eax
801061f8:	89 c2                	mov    %eax,%edx
801061fa:	2b 55 f4             	sub    -0xc(%ebp),%edx
801061fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106200:	39 c2                	cmp    %eax,%edx
80106202:	72 bb                	jb     801061bf <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106204:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
8010620b:	e8 95 ea ff ff       	call   80104ca5 <release>
  return 0;
80106210:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106215:	c9                   	leave  
80106216:	c3                   	ret    

80106217 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106217:	55                   	push   %ebp
80106218:	89 e5                	mov    %esp,%ebp
8010621a:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
8010621d:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
80106224:	e8 1a ea ff ff       	call   80104c43 <acquire>
  xticks = ticks;
80106229:	a1 a0 29 11 80       	mov    0x801129a0,%eax
8010622e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106231:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
80106238:	e8 68 ea ff ff       	call   80104ca5 <release>
  return xticks;
8010623d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106240:	c9                   	leave  
80106241:	c3                   	ret    

80106242 <sys_halt>:

//halt the xv6
int
sys_halt(void)
{
80106242:	55                   	push   %ebp
80106243:	89 e5                	mov    %esp,%ebp
80106245:	83 ec 18             	sub    $0x18,%esp
  char *p = "Shutdown";
80106248:	c7 45 fc 8a 88 10 80 	movl   $0x8010888a,-0x4(%ebp)
  for( ; *p; p++)
8010624f:	eb 1d                	jmp    8010626e <sys_halt+0x2c>
    outb(0x8900, *p);
80106251:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106254:	0f b6 00             	movzbl (%eax),%eax
80106257:	0f b6 c0             	movzbl %al,%eax
8010625a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010625e:	c7 04 24 00 89 00 00 	movl   $0x8900,(%esp)
80106265:	e8 32 fe ff ff       	call   8010609c <outb>
//halt the xv6
int
sys_halt(void)
{
  char *p = "Shutdown";
  for( ; *p; p++)
8010626a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010626e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106271:	0f b6 00             	movzbl (%eax),%eax
80106274:	84 c0                	test   %al,%al
80106276:	75 d9                	jne    80106251 <sys_halt+0xf>
    outb(0x8900, *p);

  return 0;
80106278:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010627d:	c9                   	leave  
8010627e:	c3                   	ret    

8010627f <sys_alarm>:

//alarm
int
sys_alarm(void)
{
8010627f:	55                   	push   %ebp
80106280:	89 e5                	mov    %esp,%ebp
80106282:	83 ec 28             	sub    $0x28,%esp
  int ticks;
  void (*handler)();

  if(argint(0, &ticks) < 0)
80106285:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106288:	89 44 24 04          	mov    %eax,0x4(%esp)
8010628c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106293:	e8 62 ef ff ff       	call   801051fa <argint>
80106298:	85 c0                	test   %eax,%eax
8010629a:	79 07                	jns    801062a3 <sys_alarm+0x24>
    return -1;
8010629c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062a1:	eb 56                	jmp    801062f9 <sys_alarm+0x7a>
  if(argptr(1, (char**)&handler, 1) < 0)
801062a3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801062aa:	00 
801062ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801062b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801062b9:	e8 6a ef ff ff       	call   80105228 <argptr>
801062be:	85 c0                	test   %eax,%eax
801062c0:	79 07                	jns    801062c9 <sys_alarm+0x4a>
    return -1;
801062c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062c7:	eb 30                	jmp    801062f9 <sys_alarm+0x7a>
  proc->alarmticks = ticks;
801062c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062d2:	89 50 7c             	mov    %edx,0x7c(%eax)
  proc->alarmticked = 0;
801062d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801062e2:	00 00 00 
  proc->alarmhandler = handler;
801062e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801062ee:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  return 0;
801062f4:	b8 00 00 00 00       	mov    $0x0,%eax
801062f9:	c9                   	leave  
801062fa:	c3                   	ret    
801062fb:	90                   	nop

801062fc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801062fc:	55                   	push   %ebp
801062fd:	89 e5                	mov    %esp,%ebp
801062ff:	83 ec 08             	sub    $0x8,%esp
80106302:	8b 55 08             	mov    0x8(%ebp),%edx
80106305:	8b 45 0c             	mov    0xc(%ebp),%eax
80106308:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010630c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010630f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106313:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106317:	ee                   	out    %al,(%dx)
}
80106318:	c9                   	leave  
80106319:	c3                   	ret    

8010631a <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010631a:	55                   	push   %ebp
8010631b:	89 e5                	mov    %esp,%ebp
8010631d:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106320:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106327:	00 
80106328:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
8010632f:	e8 c8 ff ff ff       	call   801062fc <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106334:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
8010633b:	00 
8010633c:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106343:	e8 b4 ff ff ff       	call   801062fc <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106348:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
8010634f:	00 
80106350:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106357:	e8 a0 ff ff ff       	call   801062fc <outb>
  picenable(IRQ_TIMER);
8010635c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106363:	e8 89 d8 ff ff       	call   80103bf1 <picenable>
}
80106368:	c9                   	leave  
80106369:	c3                   	ret    
8010636a:	66 90                	xchg   %ax,%ax

8010636c <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010636c:	1e                   	push   %ds
  pushl %es
8010636d:	06                   	push   %es
  pushl %fs
8010636e:	0f a0                	push   %fs
  pushl %gs
80106370:	0f a8                	push   %gs
  pushal
80106372:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106373:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106377:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106379:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010637b:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010637f:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106381:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106383:	54                   	push   %esp
  call trap
80106384:	e8 eb 01 00 00       	call   80106574 <trap>
  addl $4, %esp
80106389:	83 c4 04             	add    $0x4,%esp

8010638c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010638c:	61                   	popa   
  popl %gs
8010638d:	0f a9                	pop    %gs
  popl %fs
8010638f:	0f a1                	pop    %fs
  popl %es
80106391:	07                   	pop    %es
  popl %ds
80106392:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106393:	83 c4 08             	add    $0x8,%esp
  iret
80106396:	cf                   	iret   
80106397:	90                   	nop

80106398 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80106398:	55                   	push   %ebp
80106399:	89 e5                	mov    %esp,%ebp
8010639b:	8b 45 08             	mov    0x8(%ebp),%eax
8010639e:	05 00 00 00 80       	add    $0x80000000,%eax
801063a3:	5d                   	pop    %ebp
801063a4:	c3                   	ret    

801063a5 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801063a5:	55                   	push   %ebp
801063a6:	89 e5                	mov    %esp,%ebp
801063a8:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801063ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801063ae:	83 e8 01             	sub    $0x1,%eax
801063b1:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801063b5:	8b 45 08             	mov    0x8(%ebp),%eax
801063b8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801063bc:	8b 45 08             	mov    0x8(%ebp),%eax
801063bf:	c1 e8 10             	shr    $0x10,%eax
801063c2:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801063c6:	8d 45 fa             	lea    -0x6(%ebp),%eax
801063c9:	0f 01 18             	lidtl  (%eax)
}
801063cc:	c9                   	leave  
801063cd:	c3                   	ret    

801063ce <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801063ce:	55                   	push   %ebp
801063cf:	89 e5                	mov    %esp,%ebp
801063d1:	53                   	push   %ebx
801063d2:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801063d5:	0f 20 d3             	mov    %cr2,%ebx
801063d8:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
801063db:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801063de:	83 c4 10             	add    $0x10,%esp
801063e1:	5b                   	pop    %ebx
801063e2:	5d                   	pop    %ebp
801063e3:	c3                   	ret    

801063e4 <tvinit>:

int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);
pte_t *walkpgdir(pde_t *pgdir, const void *va, int alloc);
void
tvinit(void)
{
801063e4:	55                   	push   %ebp
801063e5:	89 e5                	mov    %esp,%ebp
801063e7:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801063ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801063f1:	e9 c3 00 00 00       	jmp    801064b9 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801063f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063f9:	8b 04 85 a0 b0 10 80 	mov    -0x7fef4f60(,%eax,4),%eax
80106400:	89 c2                	mov    %eax,%edx
80106402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106405:	66 89 14 c5 a0 21 11 	mov    %dx,-0x7feede60(,%eax,8)
8010640c:	80 
8010640d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106410:	66 c7 04 c5 a2 21 11 	movw   $0x8,-0x7feede5e(,%eax,8)
80106417:	80 08 00 
8010641a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010641d:	0f b6 14 c5 a4 21 11 	movzbl -0x7feede5c(,%eax,8),%edx
80106424:	80 
80106425:	83 e2 e0             	and    $0xffffffe0,%edx
80106428:	88 14 c5 a4 21 11 80 	mov    %dl,-0x7feede5c(,%eax,8)
8010642f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106432:	0f b6 14 c5 a4 21 11 	movzbl -0x7feede5c(,%eax,8),%edx
80106439:	80 
8010643a:	83 e2 1f             	and    $0x1f,%edx
8010643d:	88 14 c5 a4 21 11 80 	mov    %dl,-0x7feede5c(,%eax,8)
80106444:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106447:	0f b6 14 c5 a5 21 11 	movzbl -0x7feede5b(,%eax,8),%edx
8010644e:	80 
8010644f:	83 e2 f0             	and    $0xfffffff0,%edx
80106452:	83 ca 0e             	or     $0xe,%edx
80106455:	88 14 c5 a5 21 11 80 	mov    %dl,-0x7feede5b(,%eax,8)
8010645c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010645f:	0f b6 14 c5 a5 21 11 	movzbl -0x7feede5b(,%eax,8),%edx
80106466:	80 
80106467:	83 e2 ef             	and    $0xffffffef,%edx
8010646a:	88 14 c5 a5 21 11 80 	mov    %dl,-0x7feede5b(,%eax,8)
80106471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106474:	0f b6 14 c5 a5 21 11 	movzbl -0x7feede5b(,%eax,8),%edx
8010647b:	80 
8010647c:	83 e2 9f             	and    $0xffffff9f,%edx
8010647f:	88 14 c5 a5 21 11 80 	mov    %dl,-0x7feede5b(,%eax,8)
80106486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106489:	0f b6 14 c5 a5 21 11 	movzbl -0x7feede5b(,%eax,8),%edx
80106490:	80 
80106491:	83 ca 80             	or     $0xffffff80,%edx
80106494:	88 14 c5 a5 21 11 80 	mov    %dl,-0x7feede5b(,%eax,8)
8010649b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010649e:	8b 04 85 a0 b0 10 80 	mov    -0x7fef4f60(,%eax,4),%eax
801064a5:	c1 e8 10             	shr    $0x10,%eax
801064a8:	89 c2                	mov    %eax,%edx
801064aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064ad:	66 89 14 c5 a6 21 11 	mov    %dx,-0x7feede5a(,%eax,8)
801064b4:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801064b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801064b9:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801064c0:	0f 8e 30 ff ff ff    	jle    801063f6 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064c6:	a1 a0 b1 10 80       	mov    0x8010b1a0,%eax
801064cb:	66 a3 a0 23 11 80    	mov    %ax,0x801123a0
801064d1:	66 c7 05 a2 23 11 80 	movw   $0x8,0x801123a2
801064d8:	08 00 
801064da:	0f b6 05 a4 23 11 80 	movzbl 0x801123a4,%eax
801064e1:	83 e0 e0             	and    $0xffffffe0,%eax
801064e4:	a2 a4 23 11 80       	mov    %al,0x801123a4
801064e9:	0f b6 05 a4 23 11 80 	movzbl 0x801123a4,%eax
801064f0:	83 e0 1f             	and    $0x1f,%eax
801064f3:	a2 a4 23 11 80       	mov    %al,0x801123a4
801064f8:	0f b6 05 a5 23 11 80 	movzbl 0x801123a5,%eax
801064ff:	83 c8 0f             	or     $0xf,%eax
80106502:	a2 a5 23 11 80       	mov    %al,0x801123a5
80106507:	0f b6 05 a5 23 11 80 	movzbl 0x801123a5,%eax
8010650e:	83 e0 ef             	and    $0xffffffef,%eax
80106511:	a2 a5 23 11 80       	mov    %al,0x801123a5
80106516:	0f b6 05 a5 23 11 80 	movzbl 0x801123a5,%eax
8010651d:	83 c8 60             	or     $0x60,%eax
80106520:	a2 a5 23 11 80       	mov    %al,0x801123a5
80106525:	0f b6 05 a5 23 11 80 	movzbl 0x801123a5,%eax
8010652c:	83 c8 80             	or     $0xffffff80,%eax
8010652f:	a2 a5 23 11 80       	mov    %al,0x801123a5
80106534:	a1 a0 b1 10 80       	mov    0x8010b1a0,%eax
80106539:	c1 e8 10             	shr    $0x10,%eax
8010653c:	66 a3 a6 23 11 80    	mov    %ax,0x801123a6
  
  initlock(&tickslock, "time");
80106542:	c7 44 24 04 94 88 10 	movl   $0x80108894,0x4(%esp)
80106549:	80 
8010654a:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
80106551:	e8 cc e6 ff ff       	call   80104c22 <initlock>
}
80106556:	c9                   	leave  
80106557:	c3                   	ret    

80106558 <idtinit>:

void
idtinit(void)
{
80106558:	55                   	push   %ebp
80106559:	89 e5                	mov    %esp,%ebp
8010655b:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
8010655e:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106565:	00 
80106566:	c7 04 24 a0 21 11 80 	movl   $0x801121a0,(%esp)
8010656d:	e8 33 fe ff ff       	call   801063a5 <lidt>
}
80106572:	c9                   	leave  
80106573:	c3                   	ret    

80106574 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106574:	55                   	push   %ebp
80106575:	89 e5                	mov    %esp,%ebp
80106577:	57                   	push   %edi
80106578:	56                   	push   %esi
80106579:	53                   	push   %ebx
8010657a:	83 ec 4c             	sub    $0x4c,%esp
  char* mem;
  if(tf->trapno == T_SYSCALL){
8010657d:	8b 45 08             	mov    0x8(%ebp),%eax
80106580:	8b 40 30             	mov    0x30(%eax),%eax
80106583:	83 f8 40             	cmp    $0x40,%eax
80106586:	75 3e                	jne    801065c6 <trap+0x52>
    if(proc->killed)
80106588:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010658e:	8b 40 24             	mov    0x24(%eax),%eax
80106591:	85 c0                	test   %eax,%eax
80106593:	74 05                	je     8010659a <trap+0x26>
      exit();
80106595:	e8 eb df ff ff       	call   80104585 <exit>
    proc->tf = tf;
8010659a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065a0:	8b 55 08             	mov    0x8(%ebp),%edx
801065a3:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801065a6:	e8 16 ed ff ff       	call   801052c1 <syscall>
    if(proc->killed)
801065ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065b1:	8b 40 24             	mov    0x24(%eax),%eax
801065b4:	85 c0                	test   %eax,%eax
801065b6:	0f 84 5a 03 00 00    	je     80106916 <trap+0x3a2>
      exit();
801065bc:	e8 c4 df ff ff       	call   80104585 <exit>
    return;
801065c1:	e9 50 03 00 00       	jmp    80106916 <trap+0x3a2>
  }

  switch(tf->trapno){
801065c6:	8b 45 08             	mov    0x8(%ebp),%eax
801065c9:	8b 40 30             	mov    0x30(%eax),%eax
801065cc:	83 e8 0e             	sub    $0xe,%eax
801065cf:	83 f8 31             	cmp    $0x31,%eax
801065d2:	0f 87 e2 01 00 00    	ja     801067ba <trap+0x246>
801065d8:	8b 04 85 58 89 10 80 	mov    -0x7fef76a8(,%eax,4),%eax
801065df:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801065e1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801065e7:	0f b6 00             	movzbl (%eax),%eax
801065ea:	84 c0                	test   %al,%al
801065ec:	75 31                	jne    8010661f <trap+0xab>
      acquire(&tickslock);
801065ee:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
801065f5:	e8 49 e6 ff ff       	call   80104c43 <acquire>
      ticks++;
801065fa:	a1 a0 29 11 80       	mov    0x801129a0,%eax
801065ff:	83 c0 01             	add    $0x1,%eax
80106602:	a3 a0 29 11 80       	mov    %eax,0x801129a0
      wakeup(&ticks);
80106607:	c7 04 24 a0 29 11 80 	movl   $0x801129a0,(%esp)
8010660e:	e8 27 e4 ff ff       	call   80104a3a <wakeup>
      release(&tickslock);
80106613:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
8010661a:	e8 86 e6 ff ff       	call   80104ca5 <release>
    }
    if(proc && (tf->cs&3)==3 && proc->alarmhandler!=0){
8010661f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106625:	85 c0                	test   %eax,%eax
80106627:	0f 84 a2 00 00 00    	je     801066cf <trap+0x15b>
8010662d:	8b 45 08             	mov    0x8(%ebp),%eax
80106630:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106634:	0f b7 c0             	movzwl %ax,%eax
80106637:	83 e0 03             	and    $0x3,%eax
8010663a:	83 f8 03             	cmp    $0x3,%eax
8010663d:	0f 85 8c 00 00 00    	jne    801066cf <trap+0x15b>
80106643:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106649:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010664f:	85 c0                	test   %eax,%eax
80106651:	74 7c                	je     801066cf <trap+0x15b>
      proc->alarmticked += 1;
80106653:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106659:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106660:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
80106666:	83 c2 01             	add    $0x1,%edx
80106669:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
      if(proc->alarmticked >= proc->alarmticks){
8010666f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106675:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
8010667b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106681:	8b 40 7c             	mov    0x7c(%eax),%eax
80106684:	39 c2                	cmp    %eax,%edx
80106686:	72 47                	jb     801066cf <trap+0x15b>
        proc->alarmticked = 0;
80106688:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010668e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80106695:	00 00 00 
        tf->esp -= 4;
80106698:	8b 45 08             	mov    0x8(%ebp),%eax
8010669b:	8b 40 44             	mov    0x44(%eax),%eax
8010669e:	8d 50 fc             	lea    -0x4(%eax),%edx
801066a1:	8b 45 08             	mov    0x8(%ebp),%eax
801066a4:	89 50 44             	mov    %edx,0x44(%eax)
        uint* handler_ret = (uint*) tf->esp;
801066a7:	8b 45 08             	mov    0x8(%ebp),%eax
801066aa:	8b 40 44             	mov    0x44(%eax),%eax
801066ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        *handler_ret = tf->eip;
801066b0:	8b 45 08             	mov    0x8(%ebp),%eax
801066b3:	8b 50 38             	mov    0x38(%eax),%edx
801066b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066b9:	89 10                	mov    %edx,(%eax)
        tf->eip = (uint) proc->alarmhandler;
801066bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066c1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801066c7:	89 c2                	mov    %eax,%edx
801066c9:	8b 45 08             	mov    0x8(%ebp),%eax
801066cc:	89 50 38             	mov    %edx,0x38(%eax)
      }
    }
    lapiceoi();
801066cf:	e8 99 c9 ff ff       	call   8010306d <lapiceoi>
    break;
801066d4:	e9 b7 01 00 00       	jmp    80106890 <trap+0x31c>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801066d9:	e8 93 c1 ff ff       	call   80102871 <ideintr>
    lapiceoi();
801066de:	e8 8a c9 ff ff       	call   8010306d <lapiceoi>
    break;
801066e3:	e9 a8 01 00 00       	jmp    80106890 <trap+0x31c>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801066e8:	e8 5c c7 ff ff       	call   80102e49 <kbdintr>
    lapiceoi();
801066ed:	e8 7b c9 ff ff       	call   8010306d <lapiceoi>
    break;
801066f2:	e9 99 01 00 00       	jmp    80106890 <trap+0x31c>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801066f7:	e8 20 04 00 00       	call   80106b1c <uartintr>
    lapiceoi();
801066fc:	e8 6c c9 ff ff       	call   8010306d <lapiceoi>
    break;
80106701:	e9 8a 01 00 00       	jmp    80106890 <trap+0x31c>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
80106706:	8b 45 08             	mov    0x8(%ebp),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106709:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
8010670c:	8b 45 08             	mov    0x8(%ebp),%eax
8010670f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106713:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106716:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010671c:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010671f:	0f b6 c0             	movzbl %al,%eax
80106722:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106726:	89 54 24 08          	mov    %edx,0x8(%esp)
8010672a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010672e:	c7 04 24 9c 88 10 80 	movl   $0x8010889c,(%esp)
80106735:	e8 70 9c ff ff       	call   801003aa <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010673a:	e8 2e c9 ff ff       	call   8010306d <lapiceoi>
    break;
8010673f:	e9 4c 01 00 00       	jmp    80106890 <trap+0x31c>
  case T_PGFLT:
    cprintf("page fault,lazy allocation\n");
80106744:	c7 04 24 c0 88 10 80 	movl   $0x801088c0,(%esp)
8010674b:	e8 5a 9c ff ff       	call   801003aa <cprintf>
    mem = kalloc();
80106750:	e8 2a c5 ff ff       	call   80102c7f <kalloc>
80106755:	89 45 e0             	mov    %eax,-0x20(%ebp)
    memset(mem, 0, PGSIZE);
80106758:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010675f:	00 
80106760:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106767:	00 
80106768:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010676b:	89 04 24             	mov    %eax,(%esp)
8010676e:	e8 2b e7 ff ff       	call   80104e9e <memset>
    mappages(proc->pgdir,(char*)PGROUNDDOWN(rcr2()),PGSIZE,v2p(mem),PTE_W|PTE_U);
80106773:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106776:	89 04 24             	mov    %eax,(%esp)
80106779:	e8 1a fc ff ff       	call   80106398 <v2p>
8010677e:	89 c3                	mov    %eax,%ebx
80106780:	e8 49 fc ff ff       	call   801063ce <rcr2>
80106785:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010678a:	89 c2                	mov    %eax,%edx
8010678c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106792:	8b 40 04             	mov    0x4(%eax),%eax
80106795:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010679c:	00 
8010679d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801067a1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801067a8:	00 
801067a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801067ad:	89 04 24             	mov    %eax,(%esp)
801067b0:	e8 80 13 00 00       	call   80107b35 <mappages>
    break;
801067b5:	e9 d6 00 00 00       	jmp    80106890 <trap+0x31c>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801067ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067c0:	85 c0                	test   %eax,%eax
801067c2:	74 11                	je     801067d5 <trap+0x261>
801067c4:	8b 45 08             	mov    0x8(%ebp),%eax
801067c7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801067cb:	0f b7 c0             	movzwl %ax,%eax
801067ce:	83 e0 03             	and    $0x3,%eax
801067d1:	85 c0                	test   %eax,%eax
801067d3:	75 46                	jne    8010681b <trap+0x2a7>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801067d5:	e8 f4 fb ff ff       	call   801063ce <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
801067da:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801067dd:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
801067e0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801067e7:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801067ea:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801067ed:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801067f0:	8b 52 30             	mov    0x30(%edx),%edx
801067f3:	89 44 24 10          	mov    %eax,0x10(%esp)
801067f7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801067fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801067ff:	89 54 24 04          	mov    %edx,0x4(%esp)
80106803:	c7 04 24 dc 88 10 80 	movl   $0x801088dc,(%esp)
8010680a:	e8 9b 9b ff ff       	call   801003aa <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010680f:	c7 04 24 0e 89 10 80 	movl   $0x8010890e,(%esp)
80106816:	e8 2b 9d ff ff       	call   80100546 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010681b:	e8 ae fb ff ff       	call   801063ce <rcr2>
80106820:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106822:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106825:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106828:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010682e:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106831:	0f b6 f0             	movzbl %al,%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106834:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106837:	8b 58 34             	mov    0x34(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010683a:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010683d:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106840:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106846:	83 c0 6c             	add    $0x6c,%eax
80106849:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010684c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106852:	8b 40 10             	mov    0x10(%eax),%eax
80106855:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106859:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010685d:	89 74 24 14          	mov    %esi,0x14(%esp)
80106861:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106865:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106869:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010686c:	89 54 24 08          	mov    %edx,0x8(%esp)
80106870:	89 44 24 04          	mov    %eax,0x4(%esp)
80106874:	c7 04 24 14 89 10 80 	movl   $0x80108914,(%esp)
8010687b:	e8 2a 9b ff ff       	call   801003aa <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106880:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106886:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010688d:	eb 01                	jmp    80106890 <trap+0x31c>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010688f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106890:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106896:	85 c0                	test   %eax,%eax
80106898:	74 24                	je     801068be <trap+0x34a>
8010689a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068a0:	8b 40 24             	mov    0x24(%eax),%eax
801068a3:	85 c0                	test   %eax,%eax
801068a5:	74 17                	je     801068be <trap+0x34a>
801068a7:	8b 45 08             	mov    0x8(%ebp),%eax
801068aa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801068ae:	0f b7 c0             	movzwl %ax,%eax
801068b1:	83 e0 03             	and    $0x3,%eax
801068b4:	83 f8 03             	cmp    $0x3,%eax
801068b7:	75 05                	jne    801068be <trap+0x34a>
    exit();
801068b9:	e8 c7 dc ff ff       	call   80104585 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801068be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068c4:	85 c0                	test   %eax,%eax
801068c6:	74 1e                	je     801068e6 <trap+0x372>
801068c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068ce:	8b 40 0c             	mov    0xc(%eax),%eax
801068d1:	83 f8 04             	cmp    $0x4,%eax
801068d4:	75 10                	jne    801068e6 <trap+0x372>
801068d6:	8b 45 08             	mov    0x8(%ebp),%eax
801068d9:	8b 40 30             	mov    0x30(%eax),%eax
801068dc:	83 f8 20             	cmp    $0x20,%eax
801068df:	75 05                	jne    801068e6 <trap+0x372>
    yield();
801068e1:	e8 1a e0 ff ff       	call   80104900 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801068e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068ec:	85 c0                	test   %eax,%eax
801068ee:	74 27                	je     80106917 <trap+0x3a3>
801068f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068f6:	8b 40 24             	mov    0x24(%eax),%eax
801068f9:	85 c0                	test   %eax,%eax
801068fb:	74 1a                	je     80106917 <trap+0x3a3>
801068fd:	8b 45 08             	mov    0x8(%ebp),%eax
80106900:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106904:	0f b7 c0             	movzwl %ax,%eax
80106907:	83 e0 03             	and    $0x3,%eax
8010690a:	83 f8 03             	cmp    $0x3,%eax
8010690d:	75 08                	jne    80106917 <trap+0x3a3>
    exit();
8010690f:	e8 71 dc ff ff       	call   80104585 <exit>
80106914:	eb 01                	jmp    80106917 <trap+0x3a3>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106916:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106917:	83 c4 4c             	add    $0x4c,%esp
8010691a:	5b                   	pop    %ebx
8010691b:	5e                   	pop    %esi
8010691c:	5f                   	pop    %edi
8010691d:	5d                   	pop    %ebp
8010691e:	c3                   	ret    
8010691f:	90                   	nop

80106920 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	53                   	push   %ebx
80106924:	83 ec 14             	sub    $0x14,%esp
80106927:	8b 45 08             	mov    0x8(%ebp),%eax
8010692a:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010692e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80106932:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80106936:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
8010693a:	ec                   	in     (%dx),%al
8010693b:	89 c3                	mov    %eax,%ebx
8010693d:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80106940:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80106944:	83 c4 14             	add    $0x14,%esp
80106947:	5b                   	pop    %ebx
80106948:	5d                   	pop    %ebp
80106949:	c3                   	ret    

8010694a <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010694a:	55                   	push   %ebp
8010694b:	89 e5                	mov    %esp,%ebp
8010694d:	83 ec 08             	sub    $0x8,%esp
80106950:	8b 55 08             	mov    0x8(%ebp),%edx
80106953:	8b 45 0c             	mov    0xc(%ebp),%eax
80106956:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010695a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010695d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106961:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106965:	ee                   	out    %al,(%dx)
}
80106966:	c9                   	leave  
80106967:	c3                   	ret    

80106968 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106968:	55                   	push   %ebp
80106969:	89 e5                	mov    %esp,%ebp
8010696b:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010696e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106975:	00 
80106976:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010697d:	e8 c8 ff ff ff       	call   8010694a <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106982:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106989:	00 
8010698a:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106991:	e8 b4 ff ff ff       	call   8010694a <outb>
  outb(COM1+0, 115200/9600);
80106996:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
8010699d:	00 
8010699e:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801069a5:	e8 a0 ff ff ff       	call   8010694a <outb>
  outb(COM1+1, 0);
801069aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069b1:	00 
801069b2:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801069b9:	e8 8c ff ff ff       	call   8010694a <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801069be:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801069c5:	00 
801069c6:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801069cd:	e8 78 ff ff ff       	call   8010694a <outb>
  outb(COM1+4, 0);
801069d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069d9:	00 
801069da:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
801069e1:	e8 64 ff ff ff       	call   8010694a <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801069e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801069ed:	00 
801069ee:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801069f5:	e8 50 ff ff ff       	call   8010694a <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801069fa:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106a01:	e8 1a ff ff ff       	call   80106920 <inb>
80106a06:	3c ff                	cmp    $0xff,%al
80106a08:	74 6c                	je     80106a76 <uartinit+0x10e>
    return;
  uart = 1;
80106a0a:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
80106a11:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106a14:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106a1b:	e8 00 ff ff ff       	call   80106920 <inb>
  inb(COM1+0);
80106a20:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106a27:	e8 f4 fe ff ff       	call   80106920 <inb>
  picenable(IRQ_COM1);
80106a2c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106a33:	e8 b9 d1 ff ff       	call   80103bf1 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106a38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a3f:	00 
80106a40:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106a47:	e8 aa c0 ff ff       	call   80102af6 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106a4c:	c7 45 f4 20 8a 10 80 	movl   $0x80108a20,-0xc(%ebp)
80106a53:	eb 15                	jmp    80106a6a <uartinit+0x102>
    uartputc(*p);
80106a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a58:	0f b6 00             	movzbl (%eax),%eax
80106a5b:	0f be c0             	movsbl %al,%eax
80106a5e:	89 04 24             	mov    %eax,(%esp)
80106a61:	e8 13 00 00 00       	call   80106a79 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106a66:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a6d:	0f b6 00             	movzbl (%eax),%eax
80106a70:	84 c0                	test   %al,%al
80106a72:	75 e1                	jne    80106a55 <uartinit+0xed>
80106a74:	eb 01                	jmp    80106a77 <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106a76:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106a77:	c9                   	leave  
80106a78:	c3                   	ret    

80106a79 <uartputc>:

void
uartputc(int c)
{
80106a79:	55                   	push   %ebp
80106a7a:	89 e5                	mov    %esp,%ebp
80106a7c:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106a7f:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106a84:	85 c0                	test   %eax,%eax
80106a86:	74 4d                	je     80106ad5 <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106a8f:	eb 10                	jmp    80106aa1 <uartputc+0x28>
    microdelay(10);
80106a91:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106a98:	e8 f5 c5 ff ff       	call   80103092 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106a9d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106aa1:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106aa5:	7f 16                	jg     80106abd <uartputc+0x44>
80106aa7:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106aae:	e8 6d fe ff ff       	call   80106920 <inb>
80106ab3:	0f b6 c0             	movzbl %al,%eax
80106ab6:	83 e0 20             	and    $0x20,%eax
80106ab9:	85 c0                	test   %eax,%eax
80106abb:	74 d4                	je     80106a91 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106abd:	8b 45 08             	mov    0x8(%ebp),%eax
80106ac0:	0f b6 c0             	movzbl %al,%eax
80106ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ac7:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106ace:	e8 77 fe ff ff       	call   8010694a <outb>
80106ad3:	eb 01                	jmp    80106ad6 <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106ad5:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106ad6:	c9                   	leave  
80106ad7:	c3                   	ret    

80106ad8 <uartgetc>:

static int
uartgetc(void)
{
80106ad8:	55                   	push   %ebp
80106ad9:	89 e5                	mov    %esp,%ebp
80106adb:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106ade:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106ae3:	85 c0                	test   %eax,%eax
80106ae5:	75 07                	jne    80106aee <uartgetc+0x16>
    return -1;
80106ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aec:	eb 2c                	jmp    80106b1a <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106aee:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106af5:	e8 26 fe ff ff       	call   80106920 <inb>
80106afa:	0f b6 c0             	movzbl %al,%eax
80106afd:	83 e0 01             	and    $0x1,%eax
80106b00:	85 c0                	test   %eax,%eax
80106b02:	75 07                	jne    80106b0b <uartgetc+0x33>
    return -1;
80106b04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b09:	eb 0f                	jmp    80106b1a <uartgetc+0x42>
  return inb(COM1+0);
80106b0b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b12:	e8 09 fe ff ff       	call   80106920 <inb>
80106b17:	0f b6 c0             	movzbl %al,%eax
}
80106b1a:	c9                   	leave  
80106b1b:	c3                   	ret    

80106b1c <uartintr>:

void
uartintr(void)
{
80106b1c:	55                   	push   %ebp
80106b1d:	89 e5                	mov    %esp,%ebp
80106b1f:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106b22:	c7 04 24 d8 6a 10 80 	movl   $0x80106ad8,(%esp)
80106b29:	e8 88 9c ff ff       	call   801007b6 <consoleintr>
}
80106b2e:	c9                   	leave  
80106b2f:	c3                   	ret    

80106b30 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106b30:	6a 00                	push   $0x0
  pushl $0
80106b32:	6a 00                	push   $0x0
  jmp alltraps
80106b34:	e9 33 f8 ff ff       	jmp    8010636c <alltraps>

80106b39 <vector1>:
.globl vector1
vector1:
  pushl $0
80106b39:	6a 00                	push   $0x0
  pushl $1
80106b3b:	6a 01                	push   $0x1
  jmp alltraps
80106b3d:	e9 2a f8 ff ff       	jmp    8010636c <alltraps>

80106b42 <vector2>:
.globl vector2
vector2:
  pushl $0
80106b42:	6a 00                	push   $0x0
  pushl $2
80106b44:	6a 02                	push   $0x2
  jmp alltraps
80106b46:	e9 21 f8 ff ff       	jmp    8010636c <alltraps>

80106b4b <vector3>:
.globl vector3
vector3:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $3
80106b4d:	6a 03                	push   $0x3
  jmp alltraps
80106b4f:	e9 18 f8 ff ff       	jmp    8010636c <alltraps>

80106b54 <vector4>:
.globl vector4
vector4:
  pushl $0
80106b54:	6a 00                	push   $0x0
  pushl $4
80106b56:	6a 04                	push   $0x4
  jmp alltraps
80106b58:	e9 0f f8 ff ff       	jmp    8010636c <alltraps>

80106b5d <vector5>:
.globl vector5
vector5:
  pushl $0
80106b5d:	6a 00                	push   $0x0
  pushl $5
80106b5f:	6a 05                	push   $0x5
  jmp alltraps
80106b61:	e9 06 f8 ff ff       	jmp    8010636c <alltraps>

80106b66 <vector6>:
.globl vector6
vector6:
  pushl $0
80106b66:	6a 00                	push   $0x0
  pushl $6
80106b68:	6a 06                	push   $0x6
  jmp alltraps
80106b6a:	e9 fd f7 ff ff       	jmp    8010636c <alltraps>

80106b6f <vector7>:
.globl vector7
vector7:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $7
80106b71:	6a 07                	push   $0x7
  jmp alltraps
80106b73:	e9 f4 f7 ff ff       	jmp    8010636c <alltraps>

80106b78 <vector8>:
.globl vector8
vector8:
  pushl $8
80106b78:	6a 08                	push   $0x8
  jmp alltraps
80106b7a:	e9 ed f7 ff ff       	jmp    8010636c <alltraps>

80106b7f <vector9>:
.globl vector9
vector9:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $9
80106b81:	6a 09                	push   $0x9
  jmp alltraps
80106b83:	e9 e4 f7 ff ff       	jmp    8010636c <alltraps>

80106b88 <vector10>:
.globl vector10
vector10:
  pushl $10
80106b88:	6a 0a                	push   $0xa
  jmp alltraps
80106b8a:	e9 dd f7 ff ff       	jmp    8010636c <alltraps>

80106b8f <vector11>:
.globl vector11
vector11:
  pushl $11
80106b8f:	6a 0b                	push   $0xb
  jmp alltraps
80106b91:	e9 d6 f7 ff ff       	jmp    8010636c <alltraps>

80106b96 <vector12>:
.globl vector12
vector12:
  pushl $12
80106b96:	6a 0c                	push   $0xc
  jmp alltraps
80106b98:	e9 cf f7 ff ff       	jmp    8010636c <alltraps>

80106b9d <vector13>:
.globl vector13
vector13:
  pushl $13
80106b9d:	6a 0d                	push   $0xd
  jmp alltraps
80106b9f:	e9 c8 f7 ff ff       	jmp    8010636c <alltraps>

80106ba4 <vector14>:
.globl vector14
vector14:
  pushl $14
80106ba4:	6a 0e                	push   $0xe
  jmp alltraps
80106ba6:	e9 c1 f7 ff ff       	jmp    8010636c <alltraps>

80106bab <vector15>:
.globl vector15
vector15:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $15
80106bad:	6a 0f                	push   $0xf
  jmp alltraps
80106baf:	e9 b8 f7 ff ff       	jmp    8010636c <alltraps>

80106bb4 <vector16>:
.globl vector16
vector16:
  pushl $0
80106bb4:	6a 00                	push   $0x0
  pushl $16
80106bb6:	6a 10                	push   $0x10
  jmp alltraps
80106bb8:	e9 af f7 ff ff       	jmp    8010636c <alltraps>

80106bbd <vector17>:
.globl vector17
vector17:
  pushl $17
80106bbd:	6a 11                	push   $0x11
  jmp alltraps
80106bbf:	e9 a8 f7 ff ff       	jmp    8010636c <alltraps>

80106bc4 <vector18>:
.globl vector18
vector18:
  pushl $0
80106bc4:	6a 00                	push   $0x0
  pushl $18
80106bc6:	6a 12                	push   $0x12
  jmp alltraps
80106bc8:	e9 9f f7 ff ff       	jmp    8010636c <alltraps>

80106bcd <vector19>:
.globl vector19
vector19:
  pushl $0
80106bcd:	6a 00                	push   $0x0
  pushl $19
80106bcf:	6a 13                	push   $0x13
  jmp alltraps
80106bd1:	e9 96 f7 ff ff       	jmp    8010636c <alltraps>

80106bd6 <vector20>:
.globl vector20
vector20:
  pushl $0
80106bd6:	6a 00                	push   $0x0
  pushl $20
80106bd8:	6a 14                	push   $0x14
  jmp alltraps
80106bda:	e9 8d f7 ff ff       	jmp    8010636c <alltraps>

80106bdf <vector21>:
.globl vector21
vector21:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $21
80106be1:	6a 15                	push   $0x15
  jmp alltraps
80106be3:	e9 84 f7 ff ff       	jmp    8010636c <alltraps>

80106be8 <vector22>:
.globl vector22
vector22:
  pushl $0
80106be8:	6a 00                	push   $0x0
  pushl $22
80106bea:	6a 16                	push   $0x16
  jmp alltraps
80106bec:	e9 7b f7 ff ff       	jmp    8010636c <alltraps>

80106bf1 <vector23>:
.globl vector23
vector23:
  pushl $0
80106bf1:	6a 00                	push   $0x0
  pushl $23
80106bf3:	6a 17                	push   $0x17
  jmp alltraps
80106bf5:	e9 72 f7 ff ff       	jmp    8010636c <alltraps>

80106bfa <vector24>:
.globl vector24
vector24:
  pushl $0
80106bfa:	6a 00                	push   $0x0
  pushl $24
80106bfc:	6a 18                	push   $0x18
  jmp alltraps
80106bfe:	e9 69 f7 ff ff       	jmp    8010636c <alltraps>

80106c03 <vector25>:
.globl vector25
vector25:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $25
80106c05:	6a 19                	push   $0x19
  jmp alltraps
80106c07:	e9 60 f7 ff ff       	jmp    8010636c <alltraps>

80106c0c <vector26>:
.globl vector26
vector26:
  pushl $0
80106c0c:	6a 00                	push   $0x0
  pushl $26
80106c0e:	6a 1a                	push   $0x1a
  jmp alltraps
80106c10:	e9 57 f7 ff ff       	jmp    8010636c <alltraps>

80106c15 <vector27>:
.globl vector27
vector27:
  pushl $0
80106c15:	6a 00                	push   $0x0
  pushl $27
80106c17:	6a 1b                	push   $0x1b
  jmp alltraps
80106c19:	e9 4e f7 ff ff       	jmp    8010636c <alltraps>

80106c1e <vector28>:
.globl vector28
vector28:
  pushl $0
80106c1e:	6a 00                	push   $0x0
  pushl $28
80106c20:	6a 1c                	push   $0x1c
  jmp alltraps
80106c22:	e9 45 f7 ff ff       	jmp    8010636c <alltraps>

80106c27 <vector29>:
.globl vector29
vector29:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $29
80106c29:	6a 1d                	push   $0x1d
  jmp alltraps
80106c2b:	e9 3c f7 ff ff       	jmp    8010636c <alltraps>

80106c30 <vector30>:
.globl vector30
vector30:
  pushl $0
80106c30:	6a 00                	push   $0x0
  pushl $30
80106c32:	6a 1e                	push   $0x1e
  jmp alltraps
80106c34:	e9 33 f7 ff ff       	jmp    8010636c <alltraps>

80106c39 <vector31>:
.globl vector31
vector31:
  pushl $0
80106c39:	6a 00                	push   $0x0
  pushl $31
80106c3b:	6a 1f                	push   $0x1f
  jmp alltraps
80106c3d:	e9 2a f7 ff ff       	jmp    8010636c <alltraps>

80106c42 <vector32>:
.globl vector32
vector32:
  pushl $0
80106c42:	6a 00                	push   $0x0
  pushl $32
80106c44:	6a 20                	push   $0x20
  jmp alltraps
80106c46:	e9 21 f7 ff ff       	jmp    8010636c <alltraps>

80106c4b <vector33>:
.globl vector33
vector33:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $33
80106c4d:	6a 21                	push   $0x21
  jmp alltraps
80106c4f:	e9 18 f7 ff ff       	jmp    8010636c <alltraps>

80106c54 <vector34>:
.globl vector34
vector34:
  pushl $0
80106c54:	6a 00                	push   $0x0
  pushl $34
80106c56:	6a 22                	push   $0x22
  jmp alltraps
80106c58:	e9 0f f7 ff ff       	jmp    8010636c <alltraps>

80106c5d <vector35>:
.globl vector35
vector35:
  pushl $0
80106c5d:	6a 00                	push   $0x0
  pushl $35
80106c5f:	6a 23                	push   $0x23
  jmp alltraps
80106c61:	e9 06 f7 ff ff       	jmp    8010636c <alltraps>

80106c66 <vector36>:
.globl vector36
vector36:
  pushl $0
80106c66:	6a 00                	push   $0x0
  pushl $36
80106c68:	6a 24                	push   $0x24
  jmp alltraps
80106c6a:	e9 fd f6 ff ff       	jmp    8010636c <alltraps>

80106c6f <vector37>:
.globl vector37
vector37:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $37
80106c71:	6a 25                	push   $0x25
  jmp alltraps
80106c73:	e9 f4 f6 ff ff       	jmp    8010636c <alltraps>

80106c78 <vector38>:
.globl vector38
vector38:
  pushl $0
80106c78:	6a 00                	push   $0x0
  pushl $38
80106c7a:	6a 26                	push   $0x26
  jmp alltraps
80106c7c:	e9 eb f6 ff ff       	jmp    8010636c <alltraps>

80106c81 <vector39>:
.globl vector39
vector39:
  pushl $0
80106c81:	6a 00                	push   $0x0
  pushl $39
80106c83:	6a 27                	push   $0x27
  jmp alltraps
80106c85:	e9 e2 f6 ff ff       	jmp    8010636c <alltraps>

80106c8a <vector40>:
.globl vector40
vector40:
  pushl $0
80106c8a:	6a 00                	push   $0x0
  pushl $40
80106c8c:	6a 28                	push   $0x28
  jmp alltraps
80106c8e:	e9 d9 f6 ff ff       	jmp    8010636c <alltraps>

80106c93 <vector41>:
.globl vector41
vector41:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $41
80106c95:	6a 29                	push   $0x29
  jmp alltraps
80106c97:	e9 d0 f6 ff ff       	jmp    8010636c <alltraps>

80106c9c <vector42>:
.globl vector42
vector42:
  pushl $0
80106c9c:	6a 00                	push   $0x0
  pushl $42
80106c9e:	6a 2a                	push   $0x2a
  jmp alltraps
80106ca0:	e9 c7 f6 ff ff       	jmp    8010636c <alltraps>

80106ca5 <vector43>:
.globl vector43
vector43:
  pushl $0
80106ca5:	6a 00                	push   $0x0
  pushl $43
80106ca7:	6a 2b                	push   $0x2b
  jmp alltraps
80106ca9:	e9 be f6 ff ff       	jmp    8010636c <alltraps>

80106cae <vector44>:
.globl vector44
vector44:
  pushl $0
80106cae:	6a 00                	push   $0x0
  pushl $44
80106cb0:	6a 2c                	push   $0x2c
  jmp alltraps
80106cb2:	e9 b5 f6 ff ff       	jmp    8010636c <alltraps>

80106cb7 <vector45>:
.globl vector45
vector45:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $45
80106cb9:	6a 2d                	push   $0x2d
  jmp alltraps
80106cbb:	e9 ac f6 ff ff       	jmp    8010636c <alltraps>

80106cc0 <vector46>:
.globl vector46
vector46:
  pushl $0
80106cc0:	6a 00                	push   $0x0
  pushl $46
80106cc2:	6a 2e                	push   $0x2e
  jmp alltraps
80106cc4:	e9 a3 f6 ff ff       	jmp    8010636c <alltraps>

80106cc9 <vector47>:
.globl vector47
vector47:
  pushl $0
80106cc9:	6a 00                	push   $0x0
  pushl $47
80106ccb:	6a 2f                	push   $0x2f
  jmp alltraps
80106ccd:	e9 9a f6 ff ff       	jmp    8010636c <alltraps>

80106cd2 <vector48>:
.globl vector48
vector48:
  pushl $0
80106cd2:	6a 00                	push   $0x0
  pushl $48
80106cd4:	6a 30                	push   $0x30
  jmp alltraps
80106cd6:	e9 91 f6 ff ff       	jmp    8010636c <alltraps>

80106cdb <vector49>:
.globl vector49
vector49:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $49
80106cdd:	6a 31                	push   $0x31
  jmp alltraps
80106cdf:	e9 88 f6 ff ff       	jmp    8010636c <alltraps>

80106ce4 <vector50>:
.globl vector50
vector50:
  pushl $0
80106ce4:	6a 00                	push   $0x0
  pushl $50
80106ce6:	6a 32                	push   $0x32
  jmp alltraps
80106ce8:	e9 7f f6 ff ff       	jmp    8010636c <alltraps>

80106ced <vector51>:
.globl vector51
vector51:
  pushl $0
80106ced:	6a 00                	push   $0x0
  pushl $51
80106cef:	6a 33                	push   $0x33
  jmp alltraps
80106cf1:	e9 76 f6 ff ff       	jmp    8010636c <alltraps>

80106cf6 <vector52>:
.globl vector52
vector52:
  pushl $0
80106cf6:	6a 00                	push   $0x0
  pushl $52
80106cf8:	6a 34                	push   $0x34
  jmp alltraps
80106cfa:	e9 6d f6 ff ff       	jmp    8010636c <alltraps>

80106cff <vector53>:
.globl vector53
vector53:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $53
80106d01:	6a 35                	push   $0x35
  jmp alltraps
80106d03:	e9 64 f6 ff ff       	jmp    8010636c <alltraps>

80106d08 <vector54>:
.globl vector54
vector54:
  pushl $0
80106d08:	6a 00                	push   $0x0
  pushl $54
80106d0a:	6a 36                	push   $0x36
  jmp alltraps
80106d0c:	e9 5b f6 ff ff       	jmp    8010636c <alltraps>

80106d11 <vector55>:
.globl vector55
vector55:
  pushl $0
80106d11:	6a 00                	push   $0x0
  pushl $55
80106d13:	6a 37                	push   $0x37
  jmp alltraps
80106d15:	e9 52 f6 ff ff       	jmp    8010636c <alltraps>

80106d1a <vector56>:
.globl vector56
vector56:
  pushl $0
80106d1a:	6a 00                	push   $0x0
  pushl $56
80106d1c:	6a 38                	push   $0x38
  jmp alltraps
80106d1e:	e9 49 f6 ff ff       	jmp    8010636c <alltraps>

80106d23 <vector57>:
.globl vector57
vector57:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $57
80106d25:	6a 39                	push   $0x39
  jmp alltraps
80106d27:	e9 40 f6 ff ff       	jmp    8010636c <alltraps>

80106d2c <vector58>:
.globl vector58
vector58:
  pushl $0
80106d2c:	6a 00                	push   $0x0
  pushl $58
80106d2e:	6a 3a                	push   $0x3a
  jmp alltraps
80106d30:	e9 37 f6 ff ff       	jmp    8010636c <alltraps>

80106d35 <vector59>:
.globl vector59
vector59:
  pushl $0
80106d35:	6a 00                	push   $0x0
  pushl $59
80106d37:	6a 3b                	push   $0x3b
  jmp alltraps
80106d39:	e9 2e f6 ff ff       	jmp    8010636c <alltraps>

80106d3e <vector60>:
.globl vector60
vector60:
  pushl $0
80106d3e:	6a 00                	push   $0x0
  pushl $60
80106d40:	6a 3c                	push   $0x3c
  jmp alltraps
80106d42:	e9 25 f6 ff ff       	jmp    8010636c <alltraps>

80106d47 <vector61>:
.globl vector61
vector61:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $61
80106d49:	6a 3d                	push   $0x3d
  jmp alltraps
80106d4b:	e9 1c f6 ff ff       	jmp    8010636c <alltraps>

80106d50 <vector62>:
.globl vector62
vector62:
  pushl $0
80106d50:	6a 00                	push   $0x0
  pushl $62
80106d52:	6a 3e                	push   $0x3e
  jmp alltraps
80106d54:	e9 13 f6 ff ff       	jmp    8010636c <alltraps>

80106d59 <vector63>:
.globl vector63
vector63:
  pushl $0
80106d59:	6a 00                	push   $0x0
  pushl $63
80106d5b:	6a 3f                	push   $0x3f
  jmp alltraps
80106d5d:	e9 0a f6 ff ff       	jmp    8010636c <alltraps>

80106d62 <vector64>:
.globl vector64
vector64:
  pushl $0
80106d62:	6a 00                	push   $0x0
  pushl $64
80106d64:	6a 40                	push   $0x40
  jmp alltraps
80106d66:	e9 01 f6 ff ff       	jmp    8010636c <alltraps>

80106d6b <vector65>:
.globl vector65
vector65:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $65
80106d6d:	6a 41                	push   $0x41
  jmp alltraps
80106d6f:	e9 f8 f5 ff ff       	jmp    8010636c <alltraps>

80106d74 <vector66>:
.globl vector66
vector66:
  pushl $0
80106d74:	6a 00                	push   $0x0
  pushl $66
80106d76:	6a 42                	push   $0x42
  jmp alltraps
80106d78:	e9 ef f5 ff ff       	jmp    8010636c <alltraps>

80106d7d <vector67>:
.globl vector67
vector67:
  pushl $0
80106d7d:	6a 00                	push   $0x0
  pushl $67
80106d7f:	6a 43                	push   $0x43
  jmp alltraps
80106d81:	e9 e6 f5 ff ff       	jmp    8010636c <alltraps>

80106d86 <vector68>:
.globl vector68
vector68:
  pushl $0
80106d86:	6a 00                	push   $0x0
  pushl $68
80106d88:	6a 44                	push   $0x44
  jmp alltraps
80106d8a:	e9 dd f5 ff ff       	jmp    8010636c <alltraps>

80106d8f <vector69>:
.globl vector69
vector69:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $69
80106d91:	6a 45                	push   $0x45
  jmp alltraps
80106d93:	e9 d4 f5 ff ff       	jmp    8010636c <alltraps>

80106d98 <vector70>:
.globl vector70
vector70:
  pushl $0
80106d98:	6a 00                	push   $0x0
  pushl $70
80106d9a:	6a 46                	push   $0x46
  jmp alltraps
80106d9c:	e9 cb f5 ff ff       	jmp    8010636c <alltraps>

80106da1 <vector71>:
.globl vector71
vector71:
  pushl $0
80106da1:	6a 00                	push   $0x0
  pushl $71
80106da3:	6a 47                	push   $0x47
  jmp alltraps
80106da5:	e9 c2 f5 ff ff       	jmp    8010636c <alltraps>

80106daa <vector72>:
.globl vector72
vector72:
  pushl $0
80106daa:	6a 00                	push   $0x0
  pushl $72
80106dac:	6a 48                	push   $0x48
  jmp alltraps
80106dae:	e9 b9 f5 ff ff       	jmp    8010636c <alltraps>

80106db3 <vector73>:
.globl vector73
vector73:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $73
80106db5:	6a 49                	push   $0x49
  jmp alltraps
80106db7:	e9 b0 f5 ff ff       	jmp    8010636c <alltraps>

80106dbc <vector74>:
.globl vector74
vector74:
  pushl $0
80106dbc:	6a 00                	push   $0x0
  pushl $74
80106dbe:	6a 4a                	push   $0x4a
  jmp alltraps
80106dc0:	e9 a7 f5 ff ff       	jmp    8010636c <alltraps>

80106dc5 <vector75>:
.globl vector75
vector75:
  pushl $0
80106dc5:	6a 00                	push   $0x0
  pushl $75
80106dc7:	6a 4b                	push   $0x4b
  jmp alltraps
80106dc9:	e9 9e f5 ff ff       	jmp    8010636c <alltraps>

80106dce <vector76>:
.globl vector76
vector76:
  pushl $0
80106dce:	6a 00                	push   $0x0
  pushl $76
80106dd0:	6a 4c                	push   $0x4c
  jmp alltraps
80106dd2:	e9 95 f5 ff ff       	jmp    8010636c <alltraps>

80106dd7 <vector77>:
.globl vector77
vector77:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $77
80106dd9:	6a 4d                	push   $0x4d
  jmp alltraps
80106ddb:	e9 8c f5 ff ff       	jmp    8010636c <alltraps>

80106de0 <vector78>:
.globl vector78
vector78:
  pushl $0
80106de0:	6a 00                	push   $0x0
  pushl $78
80106de2:	6a 4e                	push   $0x4e
  jmp alltraps
80106de4:	e9 83 f5 ff ff       	jmp    8010636c <alltraps>

80106de9 <vector79>:
.globl vector79
vector79:
  pushl $0
80106de9:	6a 00                	push   $0x0
  pushl $79
80106deb:	6a 4f                	push   $0x4f
  jmp alltraps
80106ded:	e9 7a f5 ff ff       	jmp    8010636c <alltraps>

80106df2 <vector80>:
.globl vector80
vector80:
  pushl $0
80106df2:	6a 00                	push   $0x0
  pushl $80
80106df4:	6a 50                	push   $0x50
  jmp alltraps
80106df6:	e9 71 f5 ff ff       	jmp    8010636c <alltraps>

80106dfb <vector81>:
.globl vector81
vector81:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $81
80106dfd:	6a 51                	push   $0x51
  jmp alltraps
80106dff:	e9 68 f5 ff ff       	jmp    8010636c <alltraps>

80106e04 <vector82>:
.globl vector82
vector82:
  pushl $0
80106e04:	6a 00                	push   $0x0
  pushl $82
80106e06:	6a 52                	push   $0x52
  jmp alltraps
80106e08:	e9 5f f5 ff ff       	jmp    8010636c <alltraps>

80106e0d <vector83>:
.globl vector83
vector83:
  pushl $0
80106e0d:	6a 00                	push   $0x0
  pushl $83
80106e0f:	6a 53                	push   $0x53
  jmp alltraps
80106e11:	e9 56 f5 ff ff       	jmp    8010636c <alltraps>

80106e16 <vector84>:
.globl vector84
vector84:
  pushl $0
80106e16:	6a 00                	push   $0x0
  pushl $84
80106e18:	6a 54                	push   $0x54
  jmp alltraps
80106e1a:	e9 4d f5 ff ff       	jmp    8010636c <alltraps>

80106e1f <vector85>:
.globl vector85
vector85:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $85
80106e21:	6a 55                	push   $0x55
  jmp alltraps
80106e23:	e9 44 f5 ff ff       	jmp    8010636c <alltraps>

80106e28 <vector86>:
.globl vector86
vector86:
  pushl $0
80106e28:	6a 00                	push   $0x0
  pushl $86
80106e2a:	6a 56                	push   $0x56
  jmp alltraps
80106e2c:	e9 3b f5 ff ff       	jmp    8010636c <alltraps>

80106e31 <vector87>:
.globl vector87
vector87:
  pushl $0
80106e31:	6a 00                	push   $0x0
  pushl $87
80106e33:	6a 57                	push   $0x57
  jmp alltraps
80106e35:	e9 32 f5 ff ff       	jmp    8010636c <alltraps>

80106e3a <vector88>:
.globl vector88
vector88:
  pushl $0
80106e3a:	6a 00                	push   $0x0
  pushl $88
80106e3c:	6a 58                	push   $0x58
  jmp alltraps
80106e3e:	e9 29 f5 ff ff       	jmp    8010636c <alltraps>

80106e43 <vector89>:
.globl vector89
vector89:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $89
80106e45:	6a 59                	push   $0x59
  jmp alltraps
80106e47:	e9 20 f5 ff ff       	jmp    8010636c <alltraps>

80106e4c <vector90>:
.globl vector90
vector90:
  pushl $0
80106e4c:	6a 00                	push   $0x0
  pushl $90
80106e4e:	6a 5a                	push   $0x5a
  jmp alltraps
80106e50:	e9 17 f5 ff ff       	jmp    8010636c <alltraps>

80106e55 <vector91>:
.globl vector91
vector91:
  pushl $0
80106e55:	6a 00                	push   $0x0
  pushl $91
80106e57:	6a 5b                	push   $0x5b
  jmp alltraps
80106e59:	e9 0e f5 ff ff       	jmp    8010636c <alltraps>

80106e5e <vector92>:
.globl vector92
vector92:
  pushl $0
80106e5e:	6a 00                	push   $0x0
  pushl $92
80106e60:	6a 5c                	push   $0x5c
  jmp alltraps
80106e62:	e9 05 f5 ff ff       	jmp    8010636c <alltraps>

80106e67 <vector93>:
.globl vector93
vector93:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $93
80106e69:	6a 5d                	push   $0x5d
  jmp alltraps
80106e6b:	e9 fc f4 ff ff       	jmp    8010636c <alltraps>

80106e70 <vector94>:
.globl vector94
vector94:
  pushl $0
80106e70:	6a 00                	push   $0x0
  pushl $94
80106e72:	6a 5e                	push   $0x5e
  jmp alltraps
80106e74:	e9 f3 f4 ff ff       	jmp    8010636c <alltraps>

80106e79 <vector95>:
.globl vector95
vector95:
  pushl $0
80106e79:	6a 00                	push   $0x0
  pushl $95
80106e7b:	6a 5f                	push   $0x5f
  jmp alltraps
80106e7d:	e9 ea f4 ff ff       	jmp    8010636c <alltraps>

80106e82 <vector96>:
.globl vector96
vector96:
  pushl $0
80106e82:	6a 00                	push   $0x0
  pushl $96
80106e84:	6a 60                	push   $0x60
  jmp alltraps
80106e86:	e9 e1 f4 ff ff       	jmp    8010636c <alltraps>

80106e8b <vector97>:
.globl vector97
vector97:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $97
80106e8d:	6a 61                	push   $0x61
  jmp alltraps
80106e8f:	e9 d8 f4 ff ff       	jmp    8010636c <alltraps>

80106e94 <vector98>:
.globl vector98
vector98:
  pushl $0
80106e94:	6a 00                	push   $0x0
  pushl $98
80106e96:	6a 62                	push   $0x62
  jmp alltraps
80106e98:	e9 cf f4 ff ff       	jmp    8010636c <alltraps>

80106e9d <vector99>:
.globl vector99
vector99:
  pushl $0
80106e9d:	6a 00                	push   $0x0
  pushl $99
80106e9f:	6a 63                	push   $0x63
  jmp alltraps
80106ea1:	e9 c6 f4 ff ff       	jmp    8010636c <alltraps>

80106ea6 <vector100>:
.globl vector100
vector100:
  pushl $0
80106ea6:	6a 00                	push   $0x0
  pushl $100
80106ea8:	6a 64                	push   $0x64
  jmp alltraps
80106eaa:	e9 bd f4 ff ff       	jmp    8010636c <alltraps>

80106eaf <vector101>:
.globl vector101
vector101:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $101
80106eb1:	6a 65                	push   $0x65
  jmp alltraps
80106eb3:	e9 b4 f4 ff ff       	jmp    8010636c <alltraps>

80106eb8 <vector102>:
.globl vector102
vector102:
  pushl $0
80106eb8:	6a 00                	push   $0x0
  pushl $102
80106eba:	6a 66                	push   $0x66
  jmp alltraps
80106ebc:	e9 ab f4 ff ff       	jmp    8010636c <alltraps>

80106ec1 <vector103>:
.globl vector103
vector103:
  pushl $0
80106ec1:	6a 00                	push   $0x0
  pushl $103
80106ec3:	6a 67                	push   $0x67
  jmp alltraps
80106ec5:	e9 a2 f4 ff ff       	jmp    8010636c <alltraps>

80106eca <vector104>:
.globl vector104
vector104:
  pushl $0
80106eca:	6a 00                	push   $0x0
  pushl $104
80106ecc:	6a 68                	push   $0x68
  jmp alltraps
80106ece:	e9 99 f4 ff ff       	jmp    8010636c <alltraps>

80106ed3 <vector105>:
.globl vector105
vector105:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $105
80106ed5:	6a 69                	push   $0x69
  jmp alltraps
80106ed7:	e9 90 f4 ff ff       	jmp    8010636c <alltraps>

80106edc <vector106>:
.globl vector106
vector106:
  pushl $0
80106edc:	6a 00                	push   $0x0
  pushl $106
80106ede:	6a 6a                	push   $0x6a
  jmp alltraps
80106ee0:	e9 87 f4 ff ff       	jmp    8010636c <alltraps>

80106ee5 <vector107>:
.globl vector107
vector107:
  pushl $0
80106ee5:	6a 00                	push   $0x0
  pushl $107
80106ee7:	6a 6b                	push   $0x6b
  jmp alltraps
80106ee9:	e9 7e f4 ff ff       	jmp    8010636c <alltraps>

80106eee <vector108>:
.globl vector108
vector108:
  pushl $0
80106eee:	6a 00                	push   $0x0
  pushl $108
80106ef0:	6a 6c                	push   $0x6c
  jmp alltraps
80106ef2:	e9 75 f4 ff ff       	jmp    8010636c <alltraps>

80106ef7 <vector109>:
.globl vector109
vector109:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $109
80106ef9:	6a 6d                	push   $0x6d
  jmp alltraps
80106efb:	e9 6c f4 ff ff       	jmp    8010636c <alltraps>

80106f00 <vector110>:
.globl vector110
vector110:
  pushl $0
80106f00:	6a 00                	push   $0x0
  pushl $110
80106f02:	6a 6e                	push   $0x6e
  jmp alltraps
80106f04:	e9 63 f4 ff ff       	jmp    8010636c <alltraps>

80106f09 <vector111>:
.globl vector111
vector111:
  pushl $0
80106f09:	6a 00                	push   $0x0
  pushl $111
80106f0b:	6a 6f                	push   $0x6f
  jmp alltraps
80106f0d:	e9 5a f4 ff ff       	jmp    8010636c <alltraps>

80106f12 <vector112>:
.globl vector112
vector112:
  pushl $0
80106f12:	6a 00                	push   $0x0
  pushl $112
80106f14:	6a 70                	push   $0x70
  jmp alltraps
80106f16:	e9 51 f4 ff ff       	jmp    8010636c <alltraps>

80106f1b <vector113>:
.globl vector113
vector113:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $113
80106f1d:	6a 71                	push   $0x71
  jmp alltraps
80106f1f:	e9 48 f4 ff ff       	jmp    8010636c <alltraps>

80106f24 <vector114>:
.globl vector114
vector114:
  pushl $0
80106f24:	6a 00                	push   $0x0
  pushl $114
80106f26:	6a 72                	push   $0x72
  jmp alltraps
80106f28:	e9 3f f4 ff ff       	jmp    8010636c <alltraps>

80106f2d <vector115>:
.globl vector115
vector115:
  pushl $0
80106f2d:	6a 00                	push   $0x0
  pushl $115
80106f2f:	6a 73                	push   $0x73
  jmp alltraps
80106f31:	e9 36 f4 ff ff       	jmp    8010636c <alltraps>

80106f36 <vector116>:
.globl vector116
vector116:
  pushl $0
80106f36:	6a 00                	push   $0x0
  pushl $116
80106f38:	6a 74                	push   $0x74
  jmp alltraps
80106f3a:	e9 2d f4 ff ff       	jmp    8010636c <alltraps>

80106f3f <vector117>:
.globl vector117
vector117:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $117
80106f41:	6a 75                	push   $0x75
  jmp alltraps
80106f43:	e9 24 f4 ff ff       	jmp    8010636c <alltraps>

80106f48 <vector118>:
.globl vector118
vector118:
  pushl $0
80106f48:	6a 00                	push   $0x0
  pushl $118
80106f4a:	6a 76                	push   $0x76
  jmp alltraps
80106f4c:	e9 1b f4 ff ff       	jmp    8010636c <alltraps>

80106f51 <vector119>:
.globl vector119
vector119:
  pushl $0
80106f51:	6a 00                	push   $0x0
  pushl $119
80106f53:	6a 77                	push   $0x77
  jmp alltraps
80106f55:	e9 12 f4 ff ff       	jmp    8010636c <alltraps>

80106f5a <vector120>:
.globl vector120
vector120:
  pushl $0
80106f5a:	6a 00                	push   $0x0
  pushl $120
80106f5c:	6a 78                	push   $0x78
  jmp alltraps
80106f5e:	e9 09 f4 ff ff       	jmp    8010636c <alltraps>

80106f63 <vector121>:
.globl vector121
vector121:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $121
80106f65:	6a 79                	push   $0x79
  jmp alltraps
80106f67:	e9 00 f4 ff ff       	jmp    8010636c <alltraps>

80106f6c <vector122>:
.globl vector122
vector122:
  pushl $0
80106f6c:	6a 00                	push   $0x0
  pushl $122
80106f6e:	6a 7a                	push   $0x7a
  jmp alltraps
80106f70:	e9 f7 f3 ff ff       	jmp    8010636c <alltraps>

80106f75 <vector123>:
.globl vector123
vector123:
  pushl $0
80106f75:	6a 00                	push   $0x0
  pushl $123
80106f77:	6a 7b                	push   $0x7b
  jmp alltraps
80106f79:	e9 ee f3 ff ff       	jmp    8010636c <alltraps>

80106f7e <vector124>:
.globl vector124
vector124:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $124
80106f80:	6a 7c                	push   $0x7c
  jmp alltraps
80106f82:	e9 e5 f3 ff ff       	jmp    8010636c <alltraps>

80106f87 <vector125>:
.globl vector125
vector125:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $125
80106f89:	6a 7d                	push   $0x7d
  jmp alltraps
80106f8b:	e9 dc f3 ff ff       	jmp    8010636c <alltraps>

80106f90 <vector126>:
.globl vector126
vector126:
  pushl $0
80106f90:	6a 00                	push   $0x0
  pushl $126
80106f92:	6a 7e                	push   $0x7e
  jmp alltraps
80106f94:	e9 d3 f3 ff ff       	jmp    8010636c <alltraps>

80106f99 <vector127>:
.globl vector127
vector127:
  pushl $0
80106f99:	6a 00                	push   $0x0
  pushl $127
80106f9b:	6a 7f                	push   $0x7f
  jmp alltraps
80106f9d:	e9 ca f3 ff ff       	jmp    8010636c <alltraps>

80106fa2 <vector128>:
.globl vector128
vector128:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $128
80106fa4:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106fa9:	e9 be f3 ff ff       	jmp    8010636c <alltraps>

80106fae <vector129>:
.globl vector129
vector129:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $129
80106fb0:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106fb5:	e9 b2 f3 ff ff       	jmp    8010636c <alltraps>

80106fba <vector130>:
.globl vector130
vector130:
  pushl $0
80106fba:	6a 00                	push   $0x0
  pushl $130
80106fbc:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106fc1:	e9 a6 f3 ff ff       	jmp    8010636c <alltraps>

80106fc6 <vector131>:
.globl vector131
vector131:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $131
80106fc8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106fcd:	e9 9a f3 ff ff       	jmp    8010636c <alltraps>

80106fd2 <vector132>:
.globl vector132
vector132:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $132
80106fd4:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106fd9:	e9 8e f3 ff ff       	jmp    8010636c <alltraps>

80106fde <vector133>:
.globl vector133
vector133:
  pushl $0
80106fde:	6a 00                	push   $0x0
  pushl $133
80106fe0:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106fe5:	e9 82 f3 ff ff       	jmp    8010636c <alltraps>

80106fea <vector134>:
.globl vector134
vector134:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $134
80106fec:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ff1:	e9 76 f3 ff ff       	jmp    8010636c <alltraps>

80106ff6 <vector135>:
.globl vector135
vector135:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $135
80106ff8:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ffd:	e9 6a f3 ff ff       	jmp    8010636c <alltraps>

80107002 <vector136>:
.globl vector136
vector136:
  pushl $0
80107002:	6a 00                	push   $0x0
  pushl $136
80107004:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107009:	e9 5e f3 ff ff       	jmp    8010636c <alltraps>

8010700e <vector137>:
.globl vector137
vector137:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $137
80107010:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107015:	e9 52 f3 ff ff       	jmp    8010636c <alltraps>

8010701a <vector138>:
.globl vector138
vector138:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $138
8010701c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107021:	e9 46 f3 ff ff       	jmp    8010636c <alltraps>

80107026 <vector139>:
.globl vector139
vector139:
  pushl $0
80107026:	6a 00                	push   $0x0
  pushl $139
80107028:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010702d:	e9 3a f3 ff ff       	jmp    8010636c <alltraps>

80107032 <vector140>:
.globl vector140
vector140:
  pushl $0
80107032:	6a 00                	push   $0x0
  pushl $140
80107034:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107039:	e9 2e f3 ff ff       	jmp    8010636c <alltraps>

8010703e <vector141>:
.globl vector141
vector141:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $141
80107040:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107045:	e9 22 f3 ff ff       	jmp    8010636c <alltraps>

8010704a <vector142>:
.globl vector142
vector142:
  pushl $0
8010704a:	6a 00                	push   $0x0
  pushl $142
8010704c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107051:	e9 16 f3 ff ff       	jmp    8010636c <alltraps>

80107056 <vector143>:
.globl vector143
vector143:
  pushl $0
80107056:	6a 00                	push   $0x0
  pushl $143
80107058:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010705d:	e9 0a f3 ff ff       	jmp    8010636c <alltraps>

80107062 <vector144>:
.globl vector144
vector144:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $144
80107064:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107069:	e9 fe f2 ff ff       	jmp    8010636c <alltraps>

8010706e <vector145>:
.globl vector145
vector145:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $145
80107070:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107075:	e9 f2 f2 ff ff       	jmp    8010636c <alltraps>

8010707a <vector146>:
.globl vector146
vector146:
  pushl $0
8010707a:	6a 00                	push   $0x0
  pushl $146
8010707c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107081:	e9 e6 f2 ff ff       	jmp    8010636c <alltraps>

80107086 <vector147>:
.globl vector147
vector147:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $147
80107088:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010708d:	e9 da f2 ff ff       	jmp    8010636c <alltraps>

80107092 <vector148>:
.globl vector148
vector148:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $148
80107094:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107099:	e9 ce f2 ff ff       	jmp    8010636c <alltraps>

8010709e <vector149>:
.globl vector149
vector149:
  pushl $0
8010709e:	6a 00                	push   $0x0
  pushl $149
801070a0:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801070a5:	e9 c2 f2 ff ff       	jmp    8010636c <alltraps>

801070aa <vector150>:
.globl vector150
vector150:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $150
801070ac:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801070b1:	e9 b6 f2 ff ff       	jmp    8010636c <alltraps>

801070b6 <vector151>:
.globl vector151
vector151:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $151
801070b8:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801070bd:	e9 aa f2 ff ff       	jmp    8010636c <alltraps>

801070c2 <vector152>:
.globl vector152
vector152:
  pushl $0
801070c2:	6a 00                	push   $0x0
  pushl $152
801070c4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801070c9:	e9 9e f2 ff ff       	jmp    8010636c <alltraps>

801070ce <vector153>:
.globl vector153
vector153:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $153
801070d0:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801070d5:	e9 92 f2 ff ff       	jmp    8010636c <alltraps>

801070da <vector154>:
.globl vector154
vector154:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $154
801070dc:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801070e1:	e9 86 f2 ff ff       	jmp    8010636c <alltraps>

801070e6 <vector155>:
.globl vector155
vector155:
  pushl $0
801070e6:	6a 00                	push   $0x0
  pushl $155
801070e8:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801070ed:	e9 7a f2 ff ff       	jmp    8010636c <alltraps>

801070f2 <vector156>:
.globl vector156
vector156:
  pushl $0
801070f2:	6a 00                	push   $0x0
  pushl $156
801070f4:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801070f9:	e9 6e f2 ff ff       	jmp    8010636c <alltraps>

801070fe <vector157>:
.globl vector157
vector157:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $157
80107100:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107105:	e9 62 f2 ff ff       	jmp    8010636c <alltraps>

8010710a <vector158>:
.globl vector158
vector158:
  pushl $0
8010710a:	6a 00                	push   $0x0
  pushl $158
8010710c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107111:	e9 56 f2 ff ff       	jmp    8010636c <alltraps>

80107116 <vector159>:
.globl vector159
vector159:
  pushl $0
80107116:	6a 00                	push   $0x0
  pushl $159
80107118:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010711d:	e9 4a f2 ff ff       	jmp    8010636c <alltraps>

80107122 <vector160>:
.globl vector160
vector160:
  pushl $0
80107122:	6a 00                	push   $0x0
  pushl $160
80107124:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107129:	e9 3e f2 ff ff       	jmp    8010636c <alltraps>

8010712e <vector161>:
.globl vector161
vector161:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $161
80107130:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107135:	e9 32 f2 ff ff       	jmp    8010636c <alltraps>

8010713a <vector162>:
.globl vector162
vector162:
  pushl $0
8010713a:	6a 00                	push   $0x0
  pushl $162
8010713c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107141:	e9 26 f2 ff ff       	jmp    8010636c <alltraps>

80107146 <vector163>:
.globl vector163
vector163:
  pushl $0
80107146:	6a 00                	push   $0x0
  pushl $163
80107148:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010714d:	e9 1a f2 ff ff       	jmp    8010636c <alltraps>

80107152 <vector164>:
.globl vector164
vector164:
  pushl $0
80107152:	6a 00                	push   $0x0
  pushl $164
80107154:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107159:	e9 0e f2 ff ff       	jmp    8010636c <alltraps>

8010715e <vector165>:
.globl vector165
vector165:
  pushl $0
8010715e:	6a 00                	push   $0x0
  pushl $165
80107160:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107165:	e9 02 f2 ff ff       	jmp    8010636c <alltraps>

8010716a <vector166>:
.globl vector166
vector166:
  pushl $0
8010716a:	6a 00                	push   $0x0
  pushl $166
8010716c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107171:	e9 f6 f1 ff ff       	jmp    8010636c <alltraps>

80107176 <vector167>:
.globl vector167
vector167:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $167
80107178:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010717d:	e9 ea f1 ff ff       	jmp    8010636c <alltraps>

80107182 <vector168>:
.globl vector168
vector168:
  pushl $0
80107182:	6a 00                	push   $0x0
  pushl $168
80107184:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107189:	e9 de f1 ff ff       	jmp    8010636c <alltraps>

8010718e <vector169>:
.globl vector169
vector169:
  pushl $0
8010718e:	6a 00                	push   $0x0
  pushl $169
80107190:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107195:	e9 d2 f1 ff ff       	jmp    8010636c <alltraps>

8010719a <vector170>:
.globl vector170
vector170:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $170
8010719c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801071a1:	e9 c6 f1 ff ff       	jmp    8010636c <alltraps>

801071a6 <vector171>:
.globl vector171
vector171:
  pushl $0
801071a6:	6a 00                	push   $0x0
  pushl $171
801071a8:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801071ad:	e9 ba f1 ff ff       	jmp    8010636c <alltraps>

801071b2 <vector172>:
.globl vector172
vector172:
  pushl $0
801071b2:	6a 00                	push   $0x0
  pushl $172
801071b4:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801071b9:	e9 ae f1 ff ff       	jmp    8010636c <alltraps>

801071be <vector173>:
.globl vector173
vector173:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $173
801071c0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801071c5:	e9 a2 f1 ff ff       	jmp    8010636c <alltraps>

801071ca <vector174>:
.globl vector174
vector174:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $174
801071cc:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801071d1:	e9 96 f1 ff ff       	jmp    8010636c <alltraps>

801071d6 <vector175>:
.globl vector175
vector175:
  pushl $0
801071d6:	6a 00                	push   $0x0
  pushl $175
801071d8:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801071dd:	e9 8a f1 ff ff       	jmp    8010636c <alltraps>

801071e2 <vector176>:
.globl vector176
vector176:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $176
801071e4:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801071e9:	e9 7e f1 ff ff       	jmp    8010636c <alltraps>

801071ee <vector177>:
.globl vector177
vector177:
  pushl $0
801071ee:	6a 00                	push   $0x0
  pushl $177
801071f0:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801071f5:	e9 72 f1 ff ff       	jmp    8010636c <alltraps>

801071fa <vector178>:
.globl vector178
vector178:
  pushl $0
801071fa:	6a 00                	push   $0x0
  pushl $178
801071fc:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107201:	e9 66 f1 ff ff       	jmp    8010636c <alltraps>

80107206 <vector179>:
.globl vector179
vector179:
  pushl $0
80107206:	6a 00                	push   $0x0
  pushl $179
80107208:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010720d:	e9 5a f1 ff ff       	jmp    8010636c <alltraps>

80107212 <vector180>:
.globl vector180
vector180:
  pushl $0
80107212:	6a 00                	push   $0x0
  pushl $180
80107214:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107219:	e9 4e f1 ff ff       	jmp    8010636c <alltraps>

8010721e <vector181>:
.globl vector181
vector181:
  pushl $0
8010721e:	6a 00                	push   $0x0
  pushl $181
80107220:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107225:	e9 42 f1 ff ff       	jmp    8010636c <alltraps>

8010722a <vector182>:
.globl vector182
vector182:
  pushl $0
8010722a:	6a 00                	push   $0x0
  pushl $182
8010722c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107231:	e9 36 f1 ff ff       	jmp    8010636c <alltraps>

80107236 <vector183>:
.globl vector183
vector183:
  pushl $0
80107236:	6a 00                	push   $0x0
  pushl $183
80107238:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010723d:	e9 2a f1 ff ff       	jmp    8010636c <alltraps>

80107242 <vector184>:
.globl vector184
vector184:
  pushl $0
80107242:	6a 00                	push   $0x0
  pushl $184
80107244:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107249:	e9 1e f1 ff ff       	jmp    8010636c <alltraps>

8010724e <vector185>:
.globl vector185
vector185:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $185
80107250:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107255:	e9 12 f1 ff ff       	jmp    8010636c <alltraps>

8010725a <vector186>:
.globl vector186
vector186:
  pushl $0
8010725a:	6a 00                	push   $0x0
  pushl $186
8010725c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107261:	e9 06 f1 ff ff       	jmp    8010636c <alltraps>

80107266 <vector187>:
.globl vector187
vector187:
  pushl $0
80107266:	6a 00                	push   $0x0
  pushl $187
80107268:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010726d:	e9 fa f0 ff ff       	jmp    8010636c <alltraps>

80107272 <vector188>:
.globl vector188
vector188:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $188
80107274:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107279:	e9 ee f0 ff ff       	jmp    8010636c <alltraps>

8010727e <vector189>:
.globl vector189
vector189:
  pushl $0
8010727e:	6a 00                	push   $0x0
  pushl $189
80107280:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107285:	e9 e2 f0 ff ff       	jmp    8010636c <alltraps>

8010728a <vector190>:
.globl vector190
vector190:
  pushl $0
8010728a:	6a 00                	push   $0x0
  pushl $190
8010728c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107291:	e9 d6 f0 ff ff       	jmp    8010636c <alltraps>

80107296 <vector191>:
.globl vector191
vector191:
  pushl $0
80107296:	6a 00                	push   $0x0
  pushl $191
80107298:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010729d:	e9 ca f0 ff ff       	jmp    8010636c <alltraps>

801072a2 <vector192>:
.globl vector192
vector192:
  pushl $0
801072a2:	6a 00                	push   $0x0
  pushl $192
801072a4:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801072a9:	e9 be f0 ff ff       	jmp    8010636c <alltraps>

801072ae <vector193>:
.globl vector193
vector193:
  pushl $0
801072ae:	6a 00                	push   $0x0
  pushl $193
801072b0:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801072b5:	e9 b2 f0 ff ff       	jmp    8010636c <alltraps>

801072ba <vector194>:
.globl vector194
vector194:
  pushl $0
801072ba:	6a 00                	push   $0x0
  pushl $194
801072bc:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801072c1:	e9 a6 f0 ff ff       	jmp    8010636c <alltraps>

801072c6 <vector195>:
.globl vector195
vector195:
  pushl $0
801072c6:	6a 00                	push   $0x0
  pushl $195
801072c8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801072cd:	e9 9a f0 ff ff       	jmp    8010636c <alltraps>

801072d2 <vector196>:
.globl vector196
vector196:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $196
801072d4:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801072d9:	e9 8e f0 ff ff       	jmp    8010636c <alltraps>

801072de <vector197>:
.globl vector197
vector197:
  pushl $0
801072de:	6a 00                	push   $0x0
  pushl $197
801072e0:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801072e5:	e9 82 f0 ff ff       	jmp    8010636c <alltraps>

801072ea <vector198>:
.globl vector198
vector198:
  pushl $0
801072ea:	6a 00                	push   $0x0
  pushl $198
801072ec:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801072f1:	e9 76 f0 ff ff       	jmp    8010636c <alltraps>

801072f6 <vector199>:
.globl vector199
vector199:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $199
801072f8:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801072fd:	e9 6a f0 ff ff       	jmp    8010636c <alltraps>

80107302 <vector200>:
.globl vector200
vector200:
  pushl $0
80107302:	6a 00                	push   $0x0
  pushl $200
80107304:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107309:	e9 5e f0 ff ff       	jmp    8010636c <alltraps>

8010730e <vector201>:
.globl vector201
vector201:
  pushl $0
8010730e:	6a 00                	push   $0x0
  pushl $201
80107310:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107315:	e9 52 f0 ff ff       	jmp    8010636c <alltraps>

8010731a <vector202>:
.globl vector202
vector202:
  pushl $0
8010731a:	6a 00                	push   $0x0
  pushl $202
8010731c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107321:	e9 46 f0 ff ff       	jmp    8010636c <alltraps>

80107326 <vector203>:
.globl vector203
vector203:
  pushl $0
80107326:	6a 00                	push   $0x0
  pushl $203
80107328:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010732d:	e9 3a f0 ff ff       	jmp    8010636c <alltraps>

80107332 <vector204>:
.globl vector204
vector204:
  pushl $0
80107332:	6a 00                	push   $0x0
  pushl $204
80107334:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107339:	e9 2e f0 ff ff       	jmp    8010636c <alltraps>

8010733e <vector205>:
.globl vector205
vector205:
  pushl $0
8010733e:	6a 00                	push   $0x0
  pushl $205
80107340:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107345:	e9 22 f0 ff ff       	jmp    8010636c <alltraps>

8010734a <vector206>:
.globl vector206
vector206:
  pushl $0
8010734a:	6a 00                	push   $0x0
  pushl $206
8010734c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107351:	e9 16 f0 ff ff       	jmp    8010636c <alltraps>

80107356 <vector207>:
.globl vector207
vector207:
  pushl $0
80107356:	6a 00                	push   $0x0
  pushl $207
80107358:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010735d:	e9 0a f0 ff ff       	jmp    8010636c <alltraps>

80107362 <vector208>:
.globl vector208
vector208:
  pushl $0
80107362:	6a 00                	push   $0x0
  pushl $208
80107364:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107369:	e9 fe ef ff ff       	jmp    8010636c <alltraps>

8010736e <vector209>:
.globl vector209
vector209:
  pushl $0
8010736e:	6a 00                	push   $0x0
  pushl $209
80107370:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107375:	e9 f2 ef ff ff       	jmp    8010636c <alltraps>

8010737a <vector210>:
.globl vector210
vector210:
  pushl $0
8010737a:	6a 00                	push   $0x0
  pushl $210
8010737c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107381:	e9 e6 ef ff ff       	jmp    8010636c <alltraps>

80107386 <vector211>:
.globl vector211
vector211:
  pushl $0
80107386:	6a 00                	push   $0x0
  pushl $211
80107388:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010738d:	e9 da ef ff ff       	jmp    8010636c <alltraps>

80107392 <vector212>:
.globl vector212
vector212:
  pushl $0
80107392:	6a 00                	push   $0x0
  pushl $212
80107394:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107399:	e9 ce ef ff ff       	jmp    8010636c <alltraps>

8010739e <vector213>:
.globl vector213
vector213:
  pushl $0
8010739e:	6a 00                	push   $0x0
  pushl $213
801073a0:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801073a5:	e9 c2 ef ff ff       	jmp    8010636c <alltraps>

801073aa <vector214>:
.globl vector214
vector214:
  pushl $0
801073aa:	6a 00                	push   $0x0
  pushl $214
801073ac:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801073b1:	e9 b6 ef ff ff       	jmp    8010636c <alltraps>

801073b6 <vector215>:
.globl vector215
vector215:
  pushl $0
801073b6:	6a 00                	push   $0x0
  pushl $215
801073b8:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801073bd:	e9 aa ef ff ff       	jmp    8010636c <alltraps>

801073c2 <vector216>:
.globl vector216
vector216:
  pushl $0
801073c2:	6a 00                	push   $0x0
  pushl $216
801073c4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801073c9:	e9 9e ef ff ff       	jmp    8010636c <alltraps>

801073ce <vector217>:
.globl vector217
vector217:
  pushl $0
801073ce:	6a 00                	push   $0x0
  pushl $217
801073d0:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801073d5:	e9 92 ef ff ff       	jmp    8010636c <alltraps>

801073da <vector218>:
.globl vector218
vector218:
  pushl $0
801073da:	6a 00                	push   $0x0
  pushl $218
801073dc:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801073e1:	e9 86 ef ff ff       	jmp    8010636c <alltraps>

801073e6 <vector219>:
.globl vector219
vector219:
  pushl $0
801073e6:	6a 00                	push   $0x0
  pushl $219
801073e8:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801073ed:	e9 7a ef ff ff       	jmp    8010636c <alltraps>

801073f2 <vector220>:
.globl vector220
vector220:
  pushl $0
801073f2:	6a 00                	push   $0x0
  pushl $220
801073f4:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801073f9:	e9 6e ef ff ff       	jmp    8010636c <alltraps>

801073fe <vector221>:
.globl vector221
vector221:
  pushl $0
801073fe:	6a 00                	push   $0x0
  pushl $221
80107400:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107405:	e9 62 ef ff ff       	jmp    8010636c <alltraps>

8010740a <vector222>:
.globl vector222
vector222:
  pushl $0
8010740a:	6a 00                	push   $0x0
  pushl $222
8010740c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107411:	e9 56 ef ff ff       	jmp    8010636c <alltraps>

80107416 <vector223>:
.globl vector223
vector223:
  pushl $0
80107416:	6a 00                	push   $0x0
  pushl $223
80107418:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010741d:	e9 4a ef ff ff       	jmp    8010636c <alltraps>

80107422 <vector224>:
.globl vector224
vector224:
  pushl $0
80107422:	6a 00                	push   $0x0
  pushl $224
80107424:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107429:	e9 3e ef ff ff       	jmp    8010636c <alltraps>

8010742e <vector225>:
.globl vector225
vector225:
  pushl $0
8010742e:	6a 00                	push   $0x0
  pushl $225
80107430:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107435:	e9 32 ef ff ff       	jmp    8010636c <alltraps>

8010743a <vector226>:
.globl vector226
vector226:
  pushl $0
8010743a:	6a 00                	push   $0x0
  pushl $226
8010743c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107441:	e9 26 ef ff ff       	jmp    8010636c <alltraps>

80107446 <vector227>:
.globl vector227
vector227:
  pushl $0
80107446:	6a 00                	push   $0x0
  pushl $227
80107448:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010744d:	e9 1a ef ff ff       	jmp    8010636c <alltraps>

80107452 <vector228>:
.globl vector228
vector228:
  pushl $0
80107452:	6a 00                	push   $0x0
  pushl $228
80107454:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107459:	e9 0e ef ff ff       	jmp    8010636c <alltraps>

8010745e <vector229>:
.globl vector229
vector229:
  pushl $0
8010745e:	6a 00                	push   $0x0
  pushl $229
80107460:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107465:	e9 02 ef ff ff       	jmp    8010636c <alltraps>

8010746a <vector230>:
.globl vector230
vector230:
  pushl $0
8010746a:	6a 00                	push   $0x0
  pushl $230
8010746c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107471:	e9 f6 ee ff ff       	jmp    8010636c <alltraps>

80107476 <vector231>:
.globl vector231
vector231:
  pushl $0
80107476:	6a 00                	push   $0x0
  pushl $231
80107478:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010747d:	e9 ea ee ff ff       	jmp    8010636c <alltraps>

80107482 <vector232>:
.globl vector232
vector232:
  pushl $0
80107482:	6a 00                	push   $0x0
  pushl $232
80107484:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107489:	e9 de ee ff ff       	jmp    8010636c <alltraps>

8010748e <vector233>:
.globl vector233
vector233:
  pushl $0
8010748e:	6a 00                	push   $0x0
  pushl $233
80107490:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107495:	e9 d2 ee ff ff       	jmp    8010636c <alltraps>

8010749a <vector234>:
.globl vector234
vector234:
  pushl $0
8010749a:	6a 00                	push   $0x0
  pushl $234
8010749c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801074a1:	e9 c6 ee ff ff       	jmp    8010636c <alltraps>

801074a6 <vector235>:
.globl vector235
vector235:
  pushl $0
801074a6:	6a 00                	push   $0x0
  pushl $235
801074a8:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801074ad:	e9 ba ee ff ff       	jmp    8010636c <alltraps>

801074b2 <vector236>:
.globl vector236
vector236:
  pushl $0
801074b2:	6a 00                	push   $0x0
  pushl $236
801074b4:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801074b9:	e9 ae ee ff ff       	jmp    8010636c <alltraps>

801074be <vector237>:
.globl vector237
vector237:
  pushl $0
801074be:	6a 00                	push   $0x0
  pushl $237
801074c0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801074c5:	e9 a2 ee ff ff       	jmp    8010636c <alltraps>

801074ca <vector238>:
.globl vector238
vector238:
  pushl $0
801074ca:	6a 00                	push   $0x0
  pushl $238
801074cc:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801074d1:	e9 96 ee ff ff       	jmp    8010636c <alltraps>

801074d6 <vector239>:
.globl vector239
vector239:
  pushl $0
801074d6:	6a 00                	push   $0x0
  pushl $239
801074d8:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801074dd:	e9 8a ee ff ff       	jmp    8010636c <alltraps>

801074e2 <vector240>:
.globl vector240
vector240:
  pushl $0
801074e2:	6a 00                	push   $0x0
  pushl $240
801074e4:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801074e9:	e9 7e ee ff ff       	jmp    8010636c <alltraps>

801074ee <vector241>:
.globl vector241
vector241:
  pushl $0
801074ee:	6a 00                	push   $0x0
  pushl $241
801074f0:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801074f5:	e9 72 ee ff ff       	jmp    8010636c <alltraps>

801074fa <vector242>:
.globl vector242
vector242:
  pushl $0
801074fa:	6a 00                	push   $0x0
  pushl $242
801074fc:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107501:	e9 66 ee ff ff       	jmp    8010636c <alltraps>

80107506 <vector243>:
.globl vector243
vector243:
  pushl $0
80107506:	6a 00                	push   $0x0
  pushl $243
80107508:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010750d:	e9 5a ee ff ff       	jmp    8010636c <alltraps>

80107512 <vector244>:
.globl vector244
vector244:
  pushl $0
80107512:	6a 00                	push   $0x0
  pushl $244
80107514:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107519:	e9 4e ee ff ff       	jmp    8010636c <alltraps>

8010751e <vector245>:
.globl vector245
vector245:
  pushl $0
8010751e:	6a 00                	push   $0x0
  pushl $245
80107520:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107525:	e9 42 ee ff ff       	jmp    8010636c <alltraps>

8010752a <vector246>:
.globl vector246
vector246:
  pushl $0
8010752a:	6a 00                	push   $0x0
  pushl $246
8010752c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107531:	e9 36 ee ff ff       	jmp    8010636c <alltraps>

80107536 <vector247>:
.globl vector247
vector247:
  pushl $0
80107536:	6a 00                	push   $0x0
  pushl $247
80107538:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010753d:	e9 2a ee ff ff       	jmp    8010636c <alltraps>

80107542 <vector248>:
.globl vector248
vector248:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $248
80107544:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107549:	e9 1e ee ff ff       	jmp    8010636c <alltraps>

8010754e <vector249>:
.globl vector249
vector249:
  pushl $0
8010754e:	6a 00                	push   $0x0
  pushl $249
80107550:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107555:	e9 12 ee ff ff       	jmp    8010636c <alltraps>

8010755a <vector250>:
.globl vector250
vector250:
  pushl $0
8010755a:	6a 00                	push   $0x0
  pushl $250
8010755c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107561:	e9 06 ee ff ff       	jmp    8010636c <alltraps>

80107566 <vector251>:
.globl vector251
vector251:
  pushl $0
80107566:	6a 00                	push   $0x0
  pushl $251
80107568:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010756d:	e9 fa ed ff ff       	jmp    8010636c <alltraps>

80107572 <vector252>:
.globl vector252
vector252:
  pushl $0
80107572:	6a 00                	push   $0x0
  pushl $252
80107574:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107579:	e9 ee ed ff ff       	jmp    8010636c <alltraps>

8010757e <vector253>:
.globl vector253
vector253:
  pushl $0
8010757e:	6a 00                	push   $0x0
  pushl $253
80107580:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107585:	e9 e2 ed ff ff       	jmp    8010636c <alltraps>

8010758a <vector254>:
.globl vector254
vector254:
  pushl $0
8010758a:	6a 00                	push   $0x0
  pushl $254
8010758c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107591:	e9 d6 ed ff ff       	jmp    8010636c <alltraps>

80107596 <vector255>:
.globl vector255
vector255:
  pushl $0
80107596:	6a 00                	push   $0x0
  pushl $255
80107598:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010759d:	e9 ca ed ff ff       	jmp    8010636c <alltraps>
801075a2:	66 90                	xchg   %ax,%ax

801075a4 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801075a4:	55                   	push   %ebp
801075a5:	89 e5                	mov    %esp,%ebp
801075a7:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801075aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801075ad:	83 e8 01             	sub    $0x1,%eax
801075b0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801075b4:	8b 45 08             	mov    0x8(%ebp),%eax
801075b7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801075bb:	8b 45 08             	mov    0x8(%ebp),%eax
801075be:	c1 e8 10             	shr    $0x10,%eax
801075c1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801075c5:	8d 45 fa             	lea    -0x6(%ebp),%eax
801075c8:	0f 01 10             	lgdtl  (%eax)
}
801075cb:	c9                   	leave  
801075cc:	c3                   	ret    

801075cd <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801075cd:	55                   	push   %ebp
801075ce:	89 e5                	mov    %esp,%ebp
801075d0:	83 ec 04             	sub    $0x4,%esp
801075d3:	8b 45 08             	mov    0x8(%ebp),%eax
801075d6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801075da:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801075de:	0f 00 d8             	ltr    %ax
}
801075e1:	c9                   	leave  
801075e2:	c3                   	ret    

801075e3 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801075e3:	55                   	push   %ebp
801075e4:	89 e5                	mov    %esp,%ebp
801075e6:	83 ec 04             	sub    $0x4,%esp
801075e9:	8b 45 08             	mov    0x8(%ebp),%eax
801075ec:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801075f0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801075f4:	8e e8                	mov    %eax,%gs
}
801075f6:	c9                   	leave  
801075f7:	c3                   	ret    

801075f8 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801075f8:	55                   	push   %ebp
801075f9:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801075fb:	8b 45 08             	mov    0x8(%ebp),%eax
801075fe:	0f 22 d8             	mov    %eax,%cr3
}
80107601:	5d                   	pop    %ebp
80107602:	c3                   	ret    

80107603 <v2p>:
80107603:	55                   	push   %ebp
80107604:	89 e5                	mov    %esp,%ebp
80107606:	8b 45 08             	mov    0x8(%ebp),%eax
80107609:	05 00 00 00 80       	add    $0x80000000,%eax
8010760e:	5d                   	pop    %ebp
8010760f:	c3                   	ret    

80107610 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	8b 45 08             	mov    0x8(%ebp),%eax
80107616:	05 00 00 00 80       	add    $0x80000000,%eax
8010761b:	5d                   	pop    %ebp
8010761c:	c3                   	ret    

8010761d <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010761d:	55                   	push   %ebp
8010761e:	89 e5                	mov    %esp,%ebp
80107620:	53                   	push   %ebx
80107621:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107624:	e8 e8 b9 ff ff       	call   80103011 <cpunum>
80107629:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010762f:	05 20 f9 10 80       	add    $0x8010f920,%eax
80107634:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010763a:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107640:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107643:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107649:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010764c:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107650:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107653:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107657:	83 e2 f0             	and    $0xfffffff0,%edx
8010765a:	83 ca 0a             	or     $0xa,%edx
8010765d:	88 50 7d             	mov    %dl,0x7d(%eax)
80107660:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107663:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107667:	83 ca 10             	or     $0x10,%edx
8010766a:	88 50 7d             	mov    %dl,0x7d(%eax)
8010766d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107670:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107674:	83 e2 9f             	and    $0xffffff9f,%edx
80107677:	88 50 7d             	mov    %dl,0x7d(%eax)
8010767a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010767d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107681:	83 ca 80             	or     $0xffffff80,%edx
80107684:	88 50 7d             	mov    %dl,0x7d(%eax)
80107687:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010768a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010768e:	83 ca 0f             	or     $0xf,%edx
80107691:	88 50 7e             	mov    %dl,0x7e(%eax)
80107694:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107697:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010769b:	83 e2 ef             	and    $0xffffffef,%edx
8010769e:	88 50 7e             	mov    %dl,0x7e(%eax)
801076a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a4:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076a8:	83 e2 df             	and    $0xffffffdf,%edx
801076ab:	88 50 7e             	mov    %dl,0x7e(%eax)
801076ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b1:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076b5:	83 ca 40             	or     $0x40,%edx
801076b8:	88 50 7e             	mov    %dl,0x7e(%eax)
801076bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076be:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076c2:	83 ca 80             	or     $0xffffff80,%edx
801076c5:	88 50 7e             	mov    %dl,0x7e(%eax)
801076c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076cb:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801076cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d2:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801076d9:	ff ff 
801076db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076de:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801076e5:	00 00 
801076e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ea:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801076f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f4:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801076fb:	83 e2 f0             	and    $0xfffffff0,%edx
801076fe:	83 ca 02             	or     $0x2,%edx
80107701:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107707:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010770a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107711:	83 ca 10             	or     $0x10,%edx
80107714:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010771a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010771d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107724:	83 e2 9f             	and    $0xffffff9f,%edx
80107727:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010772d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107730:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107737:	83 ca 80             	or     $0xffffff80,%edx
8010773a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107740:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107743:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010774a:	83 ca 0f             	or     $0xf,%edx
8010774d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107756:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010775d:	83 e2 ef             	and    $0xffffffef,%edx
80107760:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107769:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107770:	83 e2 df             	and    $0xffffffdf,%edx
80107773:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010777c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107783:	83 ca 40             	or     $0x40,%edx
80107786:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010778c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010778f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107796:	83 ca 80             	or     $0xffffff80,%edx
80107799:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010779f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a2:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801077a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ac:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801077b3:	ff ff 
801077b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b8:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801077bf:	00 00 
801077c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c4:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801077cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ce:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801077d5:	83 e2 f0             	and    $0xfffffff0,%edx
801077d8:	83 ca 0a             	or     $0xa,%edx
801077db:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801077e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e4:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801077eb:	83 ca 10             	or     $0x10,%edx
801077ee:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801077f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f7:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801077fe:	83 ca 60             	or     $0x60,%edx
80107801:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107811:	83 ca 80             	or     $0xffffff80,%edx
80107814:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010781a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010781d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107824:	83 ca 0f             	or     $0xf,%edx
80107827:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010782d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107830:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107837:	83 e2 ef             	and    $0xffffffef,%edx
8010783a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107840:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107843:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010784a:	83 e2 df             	and    $0xffffffdf,%edx
8010784d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107853:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107856:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010785d:	83 ca 40             	or     $0x40,%edx
80107860:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107869:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107870:	83 ca 80             	or     $0xffffff80,%edx
80107873:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107879:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787c:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107883:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107886:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
8010788d:	ff ff 
8010788f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107892:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107899:	00 00 
8010789b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010789e:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801078a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801078af:	83 e2 f0             	and    $0xfffffff0,%edx
801078b2:	83 ca 02             	or     $0x2,%edx
801078b5:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801078bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078be:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801078c5:	83 ca 10             	or     $0x10,%edx
801078c8:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801078ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d1:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801078d8:	83 ca 60             	or     $0x60,%edx
801078db:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801078e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e4:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801078eb:	83 ca 80             	or     $0xffffff80,%edx
801078ee:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801078f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f7:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801078fe:	83 ca 0f             	or     $0xf,%edx
80107901:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010790a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107911:	83 e2 ef             	and    $0xffffffef,%edx
80107914:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010791a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791d:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107924:	83 e2 df             	and    $0xffffffdf,%edx
80107927:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010792d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107930:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107937:	83 ca 40             	or     $0x40,%edx
8010793a:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107940:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107943:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010794a:	83 ca 80             	or     $0xffffff80,%edx
8010794d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107953:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107956:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010795d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107960:	05 b4 00 00 00       	add    $0xb4,%eax
80107965:	89 c3                	mov    %eax,%ebx
80107967:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796a:	05 b4 00 00 00       	add    $0xb4,%eax
8010796f:	c1 e8 10             	shr    $0x10,%eax
80107972:	89 c1                	mov    %eax,%ecx
80107974:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107977:	05 b4 00 00 00       	add    $0xb4,%eax
8010797c:	c1 e8 18             	shr    $0x18,%eax
8010797f:	89 c2                	mov    %eax,%edx
80107981:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107984:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010798b:	00 00 
8010798d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107990:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107997:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010799a:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801079a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a3:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801079aa:	83 e1 f0             	and    $0xfffffff0,%ecx
801079ad:	83 c9 02             	or     $0x2,%ecx
801079b0:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801079b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b9:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801079c0:	83 c9 10             	or     $0x10,%ecx
801079c3:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801079c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079cc:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801079d3:	83 e1 9f             	and    $0xffffff9f,%ecx
801079d6:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801079dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079df:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801079e6:	83 c9 80             	or     $0xffffff80,%ecx
801079e9:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801079ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f2:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801079f9:	83 e1 f0             	and    $0xfffffff0,%ecx
801079fc:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a05:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107a0c:	83 e1 ef             	and    $0xffffffef,%ecx
80107a0f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a18:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107a1f:	83 e1 df             	and    $0xffffffdf,%ecx
80107a22:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2b:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107a32:	83 c9 40             	or     $0x40,%ecx
80107a35:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a3e:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107a45:	83 c9 80             	or     $0xffffff80,%ecx
80107a48:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a51:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a5a:	83 c0 70             	add    $0x70,%eax
80107a5d:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107a64:	00 
80107a65:	89 04 24             	mov    %eax,(%esp)
80107a68:	e8 37 fb ff ff       	call   801075a4 <lgdt>
  loadgs(SEG_KCPU << 3);
80107a6d:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107a74:	e8 6a fb ff ff       	call   801075e3 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a7c:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107a82:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107a89:	00 00 00 00 
}
80107a8d:	83 c4 24             	add    $0x24,%esp
80107a90:	5b                   	pop    %ebx
80107a91:	5d                   	pop    %ebp
80107a92:	c3                   	ret    

80107a93 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107a93:	55                   	push   %ebp
80107a94:	89 e5                	mov    %esp,%ebp
80107a96:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107a99:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a9c:	c1 e8 16             	shr    $0x16,%eax
80107a9f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107aa6:	8b 45 08             	mov    0x8(%ebp),%eax
80107aa9:	01 d0                	add    %edx,%eax
80107aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ab1:	8b 00                	mov    (%eax),%eax
80107ab3:	83 e0 01             	and    $0x1,%eax
80107ab6:	85 c0                	test   %eax,%eax
80107ab8:	74 17                	je     80107ad1 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107abd:	8b 00                	mov    (%eax),%eax
80107abf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ac4:	89 04 24             	mov    %eax,(%esp)
80107ac7:	e8 44 fb ff ff       	call   80107610 <p2v>
80107acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107acf:	eb 4b                	jmp    80107b1c <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107ad1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107ad5:	74 0e                	je     80107ae5 <walkpgdir+0x52>
80107ad7:	e8 a3 b1 ff ff       	call   80102c7f <kalloc>
80107adc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107adf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ae3:	75 07                	jne    80107aec <walkpgdir+0x59>
      return 0;
80107ae5:	b8 00 00 00 00       	mov    $0x0,%eax
80107aea:	eb 47                	jmp    80107b33 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107aec:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107af3:	00 
80107af4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107afb:	00 
80107afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aff:	89 04 24             	mov    %eax,(%esp)
80107b02:	e8 97 d3 ff ff       	call   80104e9e <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0a:	89 04 24             	mov    %eax,(%esp)
80107b0d:	e8 f1 fa ff ff       	call   80107603 <v2p>
80107b12:	89 c2                	mov    %eax,%edx
80107b14:	83 ca 07             	or     $0x7,%edx
80107b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b1a:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b1f:	c1 e8 0c             	shr    $0xc,%eax
80107b22:	25 ff 03 00 00       	and    $0x3ff,%eax
80107b27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b31:	01 d0                	add    %edx,%eax
}
80107b33:	c9                   	leave  
80107b34:	c3                   	ret    

80107b35 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107b35:	55                   	push   %ebp
80107b36:	89 e5                	mov    %esp,%ebp
80107b38:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b3e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107b46:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b49:	8b 45 10             	mov    0x10(%ebp),%eax
80107b4c:	01 d0                	add    %edx,%eax
80107b4e:	83 e8 01             	sub    $0x1,%eax
80107b51:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107b59:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107b60:	00 
80107b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b64:	89 44 24 04          	mov    %eax,0x4(%esp)
80107b68:	8b 45 08             	mov    0x8(%ebp),%eax
80107b6b:	89 04 24             	mov    %eax,(%esp)
80107b6e:	e8 20 ff ff ff       	call   80107a93 <walkpgdir>
80107b73:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107b76:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107b7a:	75 07                	jne    80107b83 <mappages+0x4e>
      return -1;
80107b7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b81:	eb 46                	jmp    80107bc9 <mappages+0x94>
    if(*pte & PTE_P)
80107b83:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b86:	8b 00                	mov    (%eax),%eax
80107b88:	83 e0 01             	and    $0x1,%eax
80107b8b:	85 c0                	test   %eax,%eax
80107b8d:	74 0c                	je     80107b9b <mappages+0x66>
      panic("remap");
80107b8f:	c7 04 24 28 8a 10 80 	movl   $0x80108a28,(%esp)
80107b96:	e8 ab 89 ff ff       	call   80100546 <panic>
    *pte = pa | perm | PTE_P;
80107b9b:	8b 45 18             	mov    0x18(%ebp),%eax
80107b9e:	0b 45 14             	or     0x14(%ebp),%eax
80107ba1:	89 c2                	mov    %eax,%edx
80107ba3:	83 ca 01             	or     $0x1,%edx
80107ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ba9:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107bb1:	74 10                	je     80107bc3 <mappages+0x8e>
      break;
    a += PGSIZE;
80107bb3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107bba:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107bc1:	eb 96                	jmp    80107b59 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107bc3:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107bc9:	c9                   	leave  
80107bca:	c3                   	ret    

80107bcb <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107bcb:	55                   	push   %ebp
80107bcc:	89 e5                	mov    %esp,%ebp
80107bce:	53                   	push   %ebx
80107bcf:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107bd2:	e8 a8 b0 ff ff       	call   80102c7f <kalloc>
80107bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107bda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107bde:	75 0a                	jne    80107bea <setupkvm+0x1f>
    return 0;
80107be0:	b8 00 00 00 00       	mov    $0x0,%eax
80107be5:	e9 98 00 00 00       	jmp    80107c82 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107bea:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107bf1:	00 
80107bf2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107bf9:	00 
80107bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bfd:	89 04 24             	mov    %eax,(%esp)
80107c00:	e8 99 d2 ff ff       	call   80104e9e <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107c05:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107c0c:	e8 ff f9 ff ff       	call   80107610 <p2v>
80107c11:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107c16:	76 0c                	jbe    80107c24 <setupkvm+0x59>
    panic("PHYSTOP too high");
80107c18:	c7 04 24 2e 8a 10 80 	movl   $0x80108a2e,(%esp)
80107c1f:	e8 22 89 ff ff       	call   80100546 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c24:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107c2b:	eb 49                	jmp    80107c76 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
80107c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107c30:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80107c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107c36:	8b 50 04             	mov    0x4(%eax),%edx
80107c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c3c:	8b 58 08             	mov    0x8(%eax),%ebx
80107c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c42:	8b 40 04             	mov    0x4(%eax),%eax
80107c45:	29 c3                	sub    %eax,%ebx
80107c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c4a:	8b 00                	mov    (%eax),%eax
80107c4c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107c50:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107c54:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107c58:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c5f:	89 04 24             	mov    %eax,(%esp)
80107c62:	e8 ce fe ff ff       	call   80107b35 <mappages>
80107c67:	85 c0                	test   %eax,%eax
80107c69:	79 07                	jns    80107c72 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107c6b:	b8 00 00 00 00       	mov    $0x0,%eax
80107c70:	eb 10                	jmp    80107c82 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c72:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107c76:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107c7d:	72 ae                	jb     80107c2d <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107c82:	83 c4 34             	add    $0x34,%esp
80107c85:	5b                   	pop    %ebx
80107c86:	5d                   	pop    %ebp
80107c87:	c3                   	ret    

80107c88 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107c88:	55                   	push   %ebp
80107c89:	89 e5                	mov    %esp,%ebp
80107c8b:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107c8e:	e8 38 ff ff ff       	call   80107bcb <setupkvm>
80107c93:	a3 f8 29 11 80       	mov    %eax,0x801129f8
  switchkvm();
80107c98:	e8 02 00 00 00       	call   80107c9f <switchkvm>
}
80107c9d:	c9                   	leave  
80107c9e:	c3                   	ret    

80107c9f <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107c9f:	55                   	push   %ebp
80107ca0:	89 e5                	mov    %esp,%ebp
80107ca2:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107ca5:	a1 f8 29 11 80       	mov    0x801129f8,%eax
80107caa:	89 04 24             	mov    %eax,(%esp)
80107cad:	e8 51 f9 ff ff       	call   80107603 <v2p>
80107cb2:	89 04 24             	mov    %eax,(%esp)
80107cb5:	e8 3e f9 ff ff       	call   801075f8 <lcr3>
}
80107cba:	c9                   	leave  
80107cbb:	c3                   	ret    

80107cbc <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107cbc:	55                   	push   %ebp
80107cbd:	89 e5                	mov    %esp,%ebp
80107cbf:	53                   	push   %ebx
80107cc0:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107cc3:	e8 cf d0 ff ff       	call   80104d97 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107cc8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107cce:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107cd5:	83 c2 08             	add    $0x8,%edx
80107cd8:	89 d3                	mov    %edx,%ebx
80107cda:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107ce1:	83 c2 08             	add    $0x8,%edx
80107ce4:	c1 ea 10             	shr    $0x10,%edx
80107ce7:	89 d1                	mov    %edx,%ecx
80107ce9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107cf0:	83 c2 08             	add    $0x8,%edx
80107cf3:	c1 ea 18             	shr    $0x18,%edx
80107cf6:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107cfd:	67 00 
80107cff:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107d06:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107d0c:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107d13:	83 e1 f0             	and    $0xfffffff0,%ecx
80107d16:	83 c9 09             	or     $0x9,%ecx
80107d19:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107d1f:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107d26:	83 c9 10             	or     $0x10,%ecx
80107d29:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107d2f:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107d36:	83 e1 9f             	and    $0xffffff9f,%ecx
80107d39:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107d3f:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107d46:	83 c9 80             	or     $0xffffff80,%ecx
80107d49:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107d4f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107d56:	83 e1 f0             	and    $0xfffffff0,%ecx
80107d59:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107d5f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107d66:	83 e1 ef             	and    $0xffffffef,%ecx
80107d69:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107d6f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107d76:	83 e1 df             	and    $0xffffffdf,%ecx
80107d79:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107d7f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107d86:	83 c9 40             	or     $0x40,%ecx
80107d89:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107d8f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107d96:	83 e1 7f             	and    $0x7f,%ecx
80107d99:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107d9f:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107da5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107dab:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107db2:	83 e2 ef             	and    $0xffffffef,%edx
80107db5:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107dbb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107dc1:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107dc7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107dcd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107dd4:	8b 52 08             	mov    0x8(%edx),%edx
80107dd7:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107ddd:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107de0:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107de7:	e8 e1 f7 ff ff       	call   801075cd <ltr>
  if(p->pgdir == 0)
80107dec:	8b 45 08             	mov    0x8(%ebp),%eax
80107def:	8b 40 04             	mov    0x4(%eax),%eax
80107df2:	85 c0                	test   %eax,%eax
80107df4:	75 0c                	jne    80107e02 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107df6:	c7 04 24 3f 8a 10 80 	movl   $0x80108a3f,(%esp)
80107dfd:	e8 44 87 ff ff       	call   80100546 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107e02:	8b 45 08             	mov    0x8(%ebp),%eax
80107e05:	8b 40 04             	mov    0x4(%eax),%eax
80107e08:	89 04 24             	mov    %eax,(%esp)
80107e0b:	e8 f3 f7 ff ff       	call   80107603 <v2p>
80107e10:	89 04 24             	mov    %eax,(%esp)
80107e13:	e8 e0 f7 ff ff       	call   801075f8 <lcr3>
  popcli();
80107e18:	e8 c2 cf ff ff       	call   80104ddf <popcli>
}
80107e1d:	83 c4 14             	add    $0x14,%esp
80107e20:	5b                   	pop    %ebx
80107e21:	5d                   	pop    %ebp
80107e22:	c3                   	ret    

80107e23 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107e23:	55                   	push   %ebp
80107e24:	89 e5                	mov    %esp,%ebp
80107e26:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107e29:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107e30:	76 0c                	jbe    80107e3e <inituvm+0x1b>
    panic("inituvm: more than a page");
80107e32:	c7 04 24 53 8a 10 80 	movl   $0x80108a53,(%esp)
80107e39:	e8 08 87 ff ff       	call   80100546 <panic>
  mem = kalloc();
80107e3e:	e8 3c ae ff ff       	call   80102c7f <kalloc>
80107e43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107e46:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e4d:	00 
80107e4e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107e55:	00 
80107e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e59:	89 04 24             	mov    %eax,(%esp)
80107e5c:	e8 3d d0 ff ff       	call   80104e9e <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e64:	89 04 24             	mov    %eax,(%esp)
80107e67:	e8 97 f7 ff ff       	call   80107603 <v2p>
80107e6c:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107e73:	00 
80107e74:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107e78:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e7f:	00 
80107e80:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107e87:	00 
80107e88:	8b 45 08             	mov    0x8(%ebp),%eax
80107e8b:	89 04 24             	mov    %eax,(%esp)
80107e8e:	e8 a2 fc ff ff       	call   80107b35 <mappages>
  memmove(mem, init, sz);
80107e93:	8b 45 10             	mov    0x10(%ebp),%eax
80107e96:	89 44 24 08          	mov    %eax,0x8(%esp)
80107e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea4:	89 04 24             	mov    %eax,(%esp)
80107ea7:	e8 c5 d0 ff ff       	call   80104f71 <memmove>
}
80107eac:	c9                   	leave  
80107ead:	c3                   	ret    

80107eae <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107eae:	55                   	push   %ebp
80107eaf:	89 e5                	mov    %esp,%ebp
80107eb1:	53                   	push   %ebx
80107eb2:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107eb8:	25 ff 0f 00 00       	and    $0xfff,%eax
80107ebd:	85 c0                	test   %eax,%eax
80107ebf:	74 0c                	je     80107ecd <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107ec1:	c7 04 24 70 8a 10 80 	movl   $0x80108a70,(%esp)
80107ec8:	e8 79 86 ff ff       	call   80100546 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107ecd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ed4:	e9 ad 00 00 00       	jmp    80107f86 <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107edc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107edf:	01 d0                	add    %edx,%eax
80107ee1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107ee8:	00 
80107ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
80107eed:	8b 45 08             	mov    0x8(%ebp),%eax
80107ef0:	89 04 24             	mov    %eax,(%esp)
80107ef3:	e8 9b fb ff ff       	call   80107a93 <walkpgdir>
80107ef8:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107efb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107eff:	75 0c                	jne    80107f0d <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80107f01:	c7 04 24 93 8a 10 80 	movl   $0x80108a93,(%esp)
80107f08:	e8 39 86 ff ff       	call   80100546 <panic>
    pa = PTE_ADDR(*pte);
80107f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f10:	8b 00                	mov    (%eax),%eax
80107f12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f17:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1d:	8b 55 18             	mov    0x18(%ebp),%edx
80107f20:	89 d1                	mov    %edx,%ecx
80107f22:	29 c1                	sub    %eax,%ecx
80107f24:	89 c8                	mov    %ecx,%eax
80107f26:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107f2b:	77 11                	ja     80107f3e <loaduvm+0x90>
      n = sz - i;
80107f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f30:	8b 55 18             	mov    0x18(%ebp),%edx
80107f33:	89 d1                	mov    %edx,%ecx
80107f35:	29 c1                	sub    %eax,%ecx
80107f37:	89 c8                	mov    %ecx,%eax
80107f39:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107f3c:	eb 07                	jmp    80107f45 <loaduvm+0x97>
    else
      n = PGSIZE;
80107f3e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f48:	8b 55 14             	mov    0x14(%ebp),%edx
80107f4b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107f4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f51:	89 04 24             	mov    %eax,(%esp)
80107f54:	e8 b7 f6 ff ff       	call   80107610 <p2v>
80107f59:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107f5c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107f60:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107f64:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f68:	8b 45 10             	mov    0x10(%ebp),%eax
80107f6b:	89 04 24             	mov    %eax,(%esp)
80107f6e:	e8 63 9f ff ff       	call   80101ed6 <readi>
80107f73:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107f76:	74 07                	je     80107f7f <loaduvm+0xd1>
      return -1;
80107f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f7d:	eb 18                	jmp    80107f97 <loaduvm+0xe9>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107f7f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f89:	3b 45 18             	cmp    0x18(%ebp),%eax
80107f8c:	0f 82 47 ff ff ff    	jb     80107ed9 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107f92:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f97:	83 c4 24             	add    $0x24,%esp
80107f9a:	5b                   	pop    %ebx
80107f9b:	5d                   	pop    %ebp
80107f9c:	c3                   	ret    

80107f9d <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107f9d:	55                   	push   %ebp
80107f9e:	89 e5                	mov    %esp,%ebp
80107fa0:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107fa3:	8b 45 10             	mov    0x10(%ebp),%eax
80107fa6:	85 c0                	test   %eax,%eax
80107fa8:	79 0a                	jns    80107fb4 <allocuvm+0x17>
    return 0;
80107faa:	b8 00 00 00 00       	mov    $0x0,%eax
80107faf:	e9 c1 00 00 00       	jmp    80108075 <allocuvm+0xd8>
  if(newsz < oldsz)
80107fb4:	8b 45 10             	mov    0x10(%ebp),%eax
80107fb7:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107fba:	73 08                	jae    80107fc4 <allocuvm+0x27>
    return oldsz;
80107fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fbf:	e9 b1 00 00 00       	jmp    80108075 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80107fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fc7:	05 ff 0f 00 00       	add    $0xfff,%eax
80107fcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107fd4:	e9 8d 00 00 00       	jmp    80108066 <allocuvm+0xc9>
    mem = kalloc();
80107fd9:	e8 a1 ac ff ff       	call   80102c7f <kalloc>
80107fde:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107fe1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107fe5:	75 2c                	jne    80108013 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80107fe7:	c7 04 24 b1 8a 10 80 	movl   $0x80108ab1,(%esp)
80107fee:	e8 b7 83 ff ff       	call   801003aa <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ff6:	89 44 24 08          	mov    %eax,0x8(%esp)
80107ffa:	8b 45 10             	mov    0x10(%ebp),%eax
80107ffd:	89 44 24 04          	mov    %eax,0x4(%esp)
80108001:	8b 45 08             	mov    0x8(%ebp),%eax
80108004:	89 04 24             	mov    %eax,(%esp)
80108007:	e8 6b 00 00 00       	call   80108077 <deallocuvm>
      return 0;
8010800c:	b8 00 00 00 00       	mov    $0x0,%eax
80108011:	eb 62                	jmp    80108075 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108013:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010801a:	00 
8010801b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108022:	00 
80108023:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108026:	89 04 24             	mov    %eax,(%esp)
80108029:	e8 70 ce ff ff       	call   80104e9e <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010802e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108031:	89 04 24             	mov    %eax,(%esp)
80108034:	e8 ca f5 ff ff       	call   80107603 <v2p>
80108039:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010803c:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108043:	00 
80108044:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108048:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010804f:	00 
80108050:	89 54 24 04          	mov    %edx,0x4(%esp)
80108054:	8b 45 08             	mov    0x8(%ebp),%eax
80108057:	89 04 24             	mov    %eax,(%esp)
8010805a:	e8 d6 fa ff ff       	call   80107b35 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010805f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108066:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108069:	3b 45 10             	cmp    0x10(%ebp),%eax
8010806c:	0f 82 67 ff ff ff    	jb     80107fd9 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108072:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108075:	c9                   	leave  
80108076:	c3                   	ret    

80108077 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108077:	55                   	push   %ebp
80108078:	89 e5                	mov    %esp,%ebp
8010807a:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010807d:	8b 45 10             	mov    0x10(%ebp),%eax
80108080:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108083:	72 08                	jb     8010808d <deallocuvm+0x16>
    return oldsz;
80108085:	8b 45 0c             	mov    0xc(%ebp),%eax
80108088:	e9 a4 00 00 00       	jmp    80108131 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
8010808d:	8b 45 10             	mov    0x10(%ebp),%eax
80108090:	05 ff 0f 00 00       	add    $0xfff,%eax
80108095:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010809a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010809d:	e9 80 00 00 00       	jmp    80108122 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
801080a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801080ac:	00 
801080ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801080b1:	8b 45 08             	mov    0x8(%ebp),%eax
801080b4:	89 04 24             	mov    %eax,(%esp)
801080b7:	e8 d7 f9 ff ff       	call   80107a93 <walkpgdir>
801080bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801080bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801080c3:	75 09                	jne    801080ce <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
801080c5:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801080cc:	eb 4d                	jmp    8010811b <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
801080ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080d1:	8b 00                	mov    (%eax),%eax
801080d3:	83 e0 01             	and    $0x1,%eax
801080d6:	85 c0                	test   %eax,%eax
801080d8:	74 41                	je     8010811b <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
801080da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080dd:	8b 00                	mov    (%eax),%eax
801080df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801080e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801080eb:	75 0c                	jne    801080f9 <deallocuvm+0x82>
        panic("kfree");
801080ed:	c7 04 24 c9 8a 10 80 	movl   $0x80108ac9,(%esp)
801080f4:	e8 4d 84 ff ff       	call   80100546 <panic>
      char *v = p2v(pa);
801080f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080fc:	89 04 24             	mov    %eax,(%esp)
801080ff:	e8 0c f5 ff ff       	call   80107610 <p2v>
80108104:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108107:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010810a:	89 04 24             	mov    %eax,(%esp)
8010810d:	e8 d4 aa ff ff       	call   80102be6 <kfree>
      *pte = 0;
80108112:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108115:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010811b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108122:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108125:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108128:	0f 82 74 ff ff ff    	jb     801080a2 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010812e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108131:	c9                   	leave  
80108132:	c3                   	ret    

80108133 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108133:	55                   	push   %ebp
80108134:	89 e5                	mov    %esp,%ebp
80108136:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108139:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010813d:	75 0c                	jne    8010814b <freevm+0x18>
    panic("freevm: no pgdir");
8010813f:	c7 04 24 cf 8a 10 80 	movl   $0x80108acf,(%esp)
80108146:	e8 fb 83 ff ff       	call   80100546 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010814b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108152:	00 
80108153:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
8010815a:	80 
8010815b:	8b 45 08             	mov    0x8(%ebp),%eax
8010815e:	89 04 24             	mov    %eax,(%esp)
80108161:	e8 11 ff ff ff       	call   80108077 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108166:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010816d:	eb 48                	jmp    801081b7 <freevm+0x84>
    if(pgdir[i] & PTE_P){
8010816f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108172:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108179:	8b 45 08             	mov    0x8(%ebp),%eax
8010817c:	01 d0                	add    %edx,%eax
8010817e:	8b 00                	mov    (%eax),%eax
80108180:	83 e0 01             	and    $0x1,%eax
80108183:	85 c0                	test   %eax,%eax
80108185:	74 2c                	je     801081b3 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108191:	8b 45 08             	mov    0x8(%ebp),%eax
80108194:	01 d0                	add    %edx,%eax
80108196:	8b 00                	mov    (%eax),%eax
80108198:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010819d:	89 04 24             	mov    %eax,(%esp)
801081a0:	e8 6b f4 ff ff       	call   80107610 <p2v>
801081a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801081a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081ab:	89 04 24             	mov    %eax,(%esp)
801081ae:	e8 33 aa ff ff       	call   80102be6 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801081b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801081b7:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801081be:	76 af                	jbe    8010816f <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801081c0:	8b 45 08             	mov    0x8(%ebp),%eax
801081c3:	89 04 24             	mov    %eax,(%esp)
801081c6:	e8 1b aa ff ff       	call   80102be6 <kfree>
}
801081cb:	c9                   	leave  
801081cc:	c3                   	ret    

801081cd <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801081cd:	55                   	push   %ebp
801081ce:	89 e5                	mov    %esp,%ebp
801081d0:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801081d3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801081da:	00 
801081db:	8b 45 0c             	mov    0xc(%ebp),%eax
801081de:	89 44 24 04          	mov    %eax,0x4(%esp)
801081e2:	8b 45 08             	mov    0x8(%ebp),%eax
801081e5:	89 04 24             	mov    %eax,(%esp)
801081e8:	e8 a6 f8 ff ff       	call   80107a93 <walkpgdir>
801081ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801081f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801081f4:	75 0c                	jne    80108202 <clearpteu+0x35>
    panic("clearpteu");
801081f6:	c7 04 24 e0 8a 10 80 	movl   $0x80108ae0,(%esp)
801081fd:	e8 44 83 ff ff       	call   80100546 <panic>
  *pte &= ~PTE_U;
80108202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108205:	8b 00                	mov    (%eax),%eax
80108207:	89 c2                	mov    %eax,%edx
80108209:	83 e2 fb             	and    $0xfffffffb,%edx
8010820c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820f:	89 10                	mov    %edx,(%eax)
}
80108211:	c9                   	leave  
80108212:	c3                   	ret    

80108213 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108213:	55                   	push   %ebp
80108214:	89 e5                	mov    %esp,%ebp
80108216:	53                   	push   %ebx
80108217:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010821a:	e8 ac f9 ff ff       	call   80107bcb <setupkvm>
8010821f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108222:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108226:	75 0a                	jne    80108232 <copyuvm+0x1f>
    return 0;
80108228:	b8 00 00 00 00       	mov    $0x0,%eax
8010822d:	e9 fd 00 00 00       	jmp    8010832f <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108232:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108239:	e9 cc 00 00 00       	jmp    8010830a <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010823e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108241:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108248:	00 
80108249:	89 44 24 04          	mov    %eax,0x4(%esp)
8010824d:	8b 45 08             	mov    0x8(%ebp),%eax
80108250:	89 04 24             	mov    %eax,(%esp)
80108253:	e8 3b f8 ff ff       	call   80107a93 <walkpgdir>
80108258:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010825b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010825f:	75 0c                	jne    8010826d <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108261:	c7 04 24 ea 8a 10 80 	movl   $0x80108aea,(%esp)
80108268:	e8 d9 82 ff ff       	call   80100546 <panic>
    if(!(*pte & PTE_P))
8010826d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108270:	8b 00                	mov    (%eax),%eax
80108272:	83 e0 01             	and    $0x1,%eax
80108275:	85 c0                	test   %eax,%eax
80108277:	75 0c                	jne    80108285 <copyuvm+0x72>
      panic("copyuvm: page not present");
80108279:	c7 04 24 04 8b 10 80 	movl   $0x80108b04,(%esp)
80108280:	e8 c1 82 ff ff       	call   80100546 <panic>
    pa = PTE_ADDR(*pte);
80108285:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108288:	8b 00                	mov    (%eax),%eax
8010828a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010828f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108292:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108295:	8b 00                	mov    (%eax),%eax
80108297:	25 ff 0f 00 00       	and    $0xfff,%eax
8010829c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010829f:	e8 db a9 ff ff       	call   80102c7f <kalloc>
801082a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801082a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801082ab:	74 6e                	je     8010831b <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801082ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
801082b0:	89 04 24             	mov    %eax,(%esp)
801082b3:	e8 58 f3 ff ff       	call   80107610 <p2v>
801082b8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801082bf:	00 
801082c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801082c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082c7:	89 04 24             	mov    %eax,(%esp)
801082ca:	e8 a2 cc ff ff       	call   80104f71 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801082cf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801082d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082d5:	89 04 24             	mov    %eax,(%esp)
801082d8:	e8 26 f3 ff ff       	call   80107603 <v2p>
801082dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082e0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801082e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
801082e8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801082ef:	00 
801082f0:	89 54 24 04          	mov    %edx,0x4(%esp)
801082f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082f7:	89 04 24             	mov    %eax,(%esp)
801082fa:	e8 36 f8 ff ff       	call   80107b35 <mappages>
801082ff:	85 c0                	test   %eax,%eax
80108301:	78 1b                	js     8010831e <copyuvm+0x10b>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108303:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010830a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010830d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108310:	0f 82 28 ff ff ff    	jb     8010823e <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108316:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108319:	eb 14                	jmp    8010832f <copyuvm+0x11c>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
8010831b:	90                   	nop
8010831c:	eb 01                	jmp    8010831f <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
8010831e:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010831f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108322:	89 04 24             	mov    %eax,(%esp)
80108325:	e8 09 fe ff ff       	call   80108133 <freevm>
  return 0;
8010832a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010832f:	83 c4 44             	add    $0x44,%esp
80108332:	5b                   	pop    %ebx
80108333:	5d                   	pop    %ebp
80108334:	c3                   	ret    

80108335 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108335:	55                   	push   %ebp
80108336:	89 e5                	mov    %esp,%ebp
80108338:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010833b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108342:	00 
80108343:	8b 45 0c             	mov    0xc(%ebp),%eax
80108346:	89 44 24 04          	mov    %eax,0x4(%esp)
8010834a:	8b 45 08             	mov    0x8(%ebp),%eax
8010834d:	89 04 24             	mov    %eax,(%esp)
80108350:	e8 3e f7 ff ff       	call   80107a93 <walkpgdir>
80108355:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835b:	8b 00                	mov    (%eax),%eax
8010835d:	83 e0 01             	and    $0x1,%eax
80108360:	85 c0                	test   %eax,%eax
80108362:	75 07                	jne    8010836b <uva2ka+0x36>
    return 0;
80108364:	b8 00 00 00 00       	mov    $0x0,%eax
80108369:	eb 25                	jmp    80108390 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
8010836b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836e:	8b 00                	mov    (%eax),%eax
80108370:	83 e0 04             	and    $0x4,%eax
80108373:	85 c0                	test   %eax,%eax
80108375:	75 07                	jne    8010837e <uva2ka+0x49>
    return 0;
80108377:	b8 00 00 00 00       	mov    $0x0,%eax
8010837c:	eb 12                	jmp    80108390 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
8010837e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108381:	8b 00                	mov    (%eax),%eax
80108383:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108388:	89 04 24             	mov    %eax,(%esp)
8010838b:	e8 80 f2 ff ff       	call   80107610 <p2v>
}
80108390:	c9                   	leave  
80108391:	c3                   	ret    

80108392 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108392:	55                   	push   %ebp
80108393:	89 e5                	mov    %esp,%ebp
80108395:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108398:	8b 45 10             	mov    0x10(%ebp),%eax
8010839b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010839e:	e9 89 00 00 00       	jmp    8010842c <copyout+0x9a>
    va0 = (uint)PGROUNDDOWN(va);
801083a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801083a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801083ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801083b5:	8b 45 08             	mov    0x8(%ebp),%eax
801083b8:	89 04 24             	mov    %eax,(%esp)
801083bb:	e8 75 ff ff ff       	call   80108335 <uva2ka>
801083c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801083c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801083c7:	75 07                	jne    801083d0 <copyout+0x3e>
      return -1;
801083c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801083ce:	eb 6b                	jmp    8010843b <copyout+0xa9>
    n = PGSIZE - (va - va0);
801083d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801083d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801083d6:	89 d1                	mov    %edx,%ecx
801083d8:	29 c1                	sub    %eax,%ecx
801083da:	89 c8                	mov    %ecx,%eax
801083dc:	05 00 10 00 00       	add    $0x1000,%eax
801083e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801083e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083e7:	3b 45 14             	cmp    0x14(%ebp),%eax
801083ea:	76 06                	jbe    801083f2 <copyout+0x60>
      n = len;
801083ec:	8b 45 14             	mov    0x14(%ebp),%eax
801083ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801083f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083f5:	8b 55 0c             	mov    0xc(%ebp),%edx
801083f8:	29 c2                	sub    %eax,%edx
801083fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801083fd:	01 c2                	add    %eax,%edx
801083ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108402:	89 44 24 08          	mov    %eax,0x8(%esp)
80108406:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108409:	89 44 24 04          	mov    %eax,0x4(%esp)
8010840d:	89 14 24             	mov    %edx,(%esp)
80108410:	e8 5c cb ff ff       	call   80104f71 <memmove>
    len -= n;
80108415:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108418:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010841b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010841e:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108421:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108424:	05 00 10 00 00       	add    $0x1000,%eax
80108429:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010842c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108430:	0f 85 6d ff ff ff    	jne    801083a3 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108436:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010843b:	c9                   	leave  
8010843c:	c3                   	ret    
