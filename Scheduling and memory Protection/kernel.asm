
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc d0 56 11 80       	mov    $0x801156d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 30 10 80       	mov    $0x80103070,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 74 10 80       	push   $0x801074e0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 c5 44 00 00       	call   80104520 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 74 10 80       	push   $0x801074e7
80100097:	50                   	push   %eax
80100098:	e8 53 43 00 00       	call   801043f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 07 46 00 00       	call   801046f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 29 45 00 00       	call   80104690 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 42 00 00       	call   80104430 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 21 00 00       	call   801022f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ee 74 10 80       	push   $0x801074ee
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 0d 43 00 00       	call   801044d0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 17 21 00 00       	jmp    801022f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 74 10 80       	push   $0x801074ff
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 cc 42 00 00       	call   801044d0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 7c 42 00 00       	call   80104490 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 d0 44 00 00       	call   801046f0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 1f 44 00 00       	jmp    80104690 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 75 10 80       	push   $0x80107506
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 d7 15 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 4b 44 00 00       	call   801046f0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 1e 3e 00 00       	call   801040f0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 b9 36 00 00       	call   801039a0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 95 43 00 00       	call   80104690 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 8c 14 00 00       	call   80101790 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 3f 43 00 00       	call   80104690 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 36 14 00 00       	call   80101790 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 25 00 00       	call   80102900 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 75 10 80       	push   $0x8010750d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 47 7e 10 80 	movl   $0x80107e47,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 73 41 00 00       	call   80104540 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 75 10 80       	push   $0x80107521
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 21 5a 00 00       	call   80105e40 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 36 59 00 00       	call   80105e40 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 2a 59 00 00       	call   80105e40 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 1e 59 00 00       	call   80105e40 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 fa 42 00 00       	call   80104850 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 45 42 00 00       	call   801047b0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 25 75 10 80       	push   $0x80107525
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 cc 12 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005ab:	e8 40 41 00 00       	call   801046f0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ef 10 80       	push   $0x8010ef20
801005e4:	e8 a7 40 00 00       	call   80104690 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 9e 11 00 00       	call   80101790 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 50 75 10 80 	movzbl -0x7fef8ab0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 03 3f 00 00       	call   801046f0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 38 75 10 80       	mov    $0x80107538,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ef 10 80       	push   $0x8010ef20
8010085b:	e8 30 3e 00 00       	call   80104690 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 3f 75 10 80       	push   $0x8010753f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ef 10 80       	push   $0x8010ef20
80100893:	e8 58 3e 00 00       	call   801046f0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100945:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
8010096c:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100985:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100999:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009b7:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ef 10 80       	push   $0x8010ef20
801009d0:	e8 bb 3c 00 00       	call   80104690 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 7d 38 00 00       	jmp    80104290 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a3f:	68 00 ef 10 80       	push   $0x8010ef00
80100a44:	e8 67 37 00 00       	call   801041b0 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 48 75 10 80       	push   $0x80107548
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 ab 3a 00 00       	call   80104520 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 90 	movl   $0x80100590,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 f2 19 00 00       	call   80102490 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 df 2e 00 00       	call   801039a0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 a4 22 00 00       	call   80102d70 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 d9 15 00 00       	call   801020b0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 a3 0c 00 00       	call   80101790 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 a2 0f 00 00       	call   80101aa0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 11 0f 00 00       	call   80101a20 <iunlockput>
    end_op();
80100b0f:	e8 cc 22 00 00       	call   80102de0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 97 64 00 00       	call   80106fd0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = PGSIZE;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x1000,-0x110(%ebp)
80100b5e:	10 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 48 62 00 00       	call   80106df0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 22 61 00 00       	call   80106d00 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 9a 0e 00 00       	call   80101aa0 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 30 63 00 00       	call   80106f50 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 cf 0d 00 00       	call   80101a20 <iunlockput>
  end_op();
80100c51:	e8 8a 21 00 00       	call   80102de0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 89 61 00 00       	call   80106df0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 e8 63 00 00       	call   80107070 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 d8 3c 00 00       	call   801049b0 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 c4 3c 00 00       	call   801049b0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 43 65 00 00       	call   80107240 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 3a 62 00 00       	call   80106f50 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 d8 64 00 00       	call   80107240 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 ca 3b 00 00       	call   80104970 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 9e 5d 00 00       	call   80106b70 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 76 61 00 00       	call   80106f50 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 f7 1f 00 00       	call   80102de0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 61 75 10 80       	push   $0x80107561
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 30 00 00       	mov    $0x3000,%esi
80100e08:	bf 00 10 00 00       	mov    $0x1000,%edi
80100e0d:	e9 36 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e12:	66 90                	xchg   %ax,%ax
80100e14:	66 90                	xchg   %ax,%ax
80100e16:	66 90                	xchg   %ax,%ax
80100e18:	66 90                	xchg   %ax,%ax
80100e1a:	66 90                	xchg   %ax,%ax
80100e1c:	66 90                	xchg   %ax,%ax
80100e1e:	66 90                	xchg   %ax,%ax

80100e20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e26:	68 6d 75 10 80       	push   $0x8010756d
80100e2b:	68 60 ef 10 80       	push   $0x8010ef60
80100e30:	e8 eb 36 00 00       	call   80104520 <initlock>
}
80100e35:	83 c4 10             	add    $0x10,%esp
80100e38:	c9                   	leave  
80100e39:	c3                   	ret    
80100e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e44:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e49:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e4c:	68 60 ef 10 80       	push   $0x8010ef60
80100e51:	e8 9a 38 00 00       	call   801046f0 <acquire>
80100e56:	83 c4 10             	add    $0x10,%esp
80100e59:	eb 10                	jmp    80100e6b <filealloc+0x2b>
80100e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e5f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e60:	83 c3 18             	add    $0x18,%ebx
80100e63:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100e69:	74 25                	je     80100e90 <filealloc+0x50>
    if(f->ref == 0){
80100e6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e6e:	85 c0                	test   %eax,%eax
80100e70:	75 ee                	jne    80100e60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e72:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e7c:	68 60 ef 10 80       	push   $0x8010ef60
80100e81:	e8 0a 38 00 00       	call   80104690 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e86:	89 d8                	mov    %ebx,%eax
      return f;
80100e88:	83 c4 10             	add    $0x10,%esp
}
80100e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e8e:	c9                   	leave  
80100e8f:	c3                   	ret    
  release(&ftable.lock);
80100e90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e93:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e95:	68 60 ef 10 80       	push   $0x8010ef60
80100e9a:	e8 f1 37 00 00       	call   80104690 <release>
}
80100e9f:	89 d8                	mov    %ebx,%eax
  return 0;
80100ea1:	83 c4 10             	add    $0x10,%esp
}
80100ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea7:	c9                   	leave  
80100ea8:	c3                   	ret    
80100ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100eb0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	53                   	push   %ebx
80100eb4:	83 ec 10             	sub    $0x10,%esp
80100eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eba:	68 60 ef 10 80       	push   $0x8010ef60
80100ebf:	e8 2c 38 00 00       	call   801046f0 <acquire>
  if(f->ref < 1)
80100ec4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ec7:	83 c4 10             	add    $0x10,%esp
80100eca:	85 c0                	test   %eax,%eax
80100ecc:	7e 1a                	jle    80100ee8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ece:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ed1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ed4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ed7:	68 60 ef 10 80       	push   $0x8010ef60
80100edc:	e8 af 37 00 00       	call   80104690 <release>
  return f;
}
80100ee1:	89 d8                	mov    %ebx,%eax
80100ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee6:	c9                   	leave  
80100ee7:	c3                   	ret    
    panic("filedup");
80100ee8:	83 ec 0c             	sub    $0xc,%esp
80100eeb:	68 74 75 10 80       	push   $0x80107574
80100ef0:	e8 8b f4 ff ff       	call   80100380 <panic>
80100ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	57                   	push   %edi
80100f04:	56                   	push   %esi
80100f05:	53                   	push   %ebx
80100f06:	83 ec 28             	sub    $0x28,%esp
80100f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f0c:	68 60 ef 10 80       	push   $0x8010ef60
80100f11:	e8 da 37 00 00       	call   801046f0 <acquire>
  if(f->ref < 1)
80100f16:	8b 53 04             	mov    0x4(%ebx),%edx
80100f19:	83 c4 10             	add    $0x10,%esp
80100f1c:	85 d2                	test   %edx,%edx
80100f1e:	0f 8e a5 00 00 00    	jle    80100fc9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f24:	83 ea 01             	sub    $0x1,%edx
80100f27:	89 53 04             	mov    %edx,0x4(%ebx)
80100f2a:	75 44                	jne    80100f70 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f2c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f30:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f33:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f35:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f3b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f3e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f41:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f44:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80100f49:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f4c:	e8 3f 37 00 00       	call   80104690 <release>

  if(ff.type == FD_PIPE)
80100f51:	83 c4 10             	add    $0x10,%esp
80100f54:	83 ff 01             	cmp    $0x1,%edi
80100f57:	74 57                	je     80100fb0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f59:	83 ff 02             	cmp    $0x2,%edi
80100f5c:	74 2a                	je     80100f88 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f61:	5b                   	pop    %ebx
80100f62:	5e                   	pop    %esi
80100f63:	5f                   	pop    %edi
80100f64:	5d                   	pop    %ebp
80100f65:	c3                   	ret    
80100f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f70:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7a:	5b                   	pop    %ebx
80100f7b:	5e                   	pop    %esi
80100f7c:	5f                   	pop    %edi
80100f7d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f7e:	e9 0d 37 00 00       	jmp    80104690 <release>
80100f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f87:	90                   	nop
    begin_op();
80100f88:	e8 e3 1d 00 00       	call   80102d70 <begin_op>
    iput(ff.ip);
80100f8d:	83 ec 0c             	sub    $0xc,%esp
80100f90:	ff 75 e0             	push   -0x20(%ebp)
80100f93:	e8 28 09 00 00       	call   801018c0 <iput>
    end_op();
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9e:	5b                   	pop    %ebx
80100f9f:	5e                   	pop    %esi
80100fa0:	5f                   	pop    %edi
80100fa1:	5d                   	pop    %ebp
    end_op();
80100fa2:	e9 39 1e 00 00       	jmp    80102de0 <end_op>
80100fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fb0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fb4:	83 ec 08             	sub    $0x8,%esp
80100fb7:	53                   	push   %ebx
80100fb8:	56                   	push   %esi
80100fb9:	e8 82 25 00 00       	call   80103540 <pipeclose>
80100fbe:	83 c4 10             	add    $0x10,%esp
}
80100fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc4:	5b                   	pop    %ebx
80100fc5:	5e                   	pop    %esi
80100fc6:	5f                   	pop    %edi
80100fc7:	5d                   	pop    %ebp
80100fc8:	c3                   	ret    
    panic("fileclose");
80100fc9:	83 ec 0c             	sub    $0xc,%esp
80100fcc:	68 7c 75 10 80       	push   $0x8010757c
80100fd1:	e8 aa f3 ff ff       	call   80100380 <panic>
80100fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fdd:	8d 76 00             	lea    0x0(%esi),%esi

80100fe0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	53                   	push   %ebx
80100fe4:	83 ec 04             	sub    $0x4,%esp
80100fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fed:	75 31                	jne    80101020 <filestat+0x40>
    ilock(f->ip);
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	ff 73 10             	push   0x10(%ebx)
80100ff5:	e8 96 07 00 00       	call   80101790 <ilock>
    stati(f->ip, st);
80100ffa:	58                   	pop    %eax
80100ffb:	5a                   	pop    %edx
80100ffc:	ff 75 0c             	push   0xc(%ebp)
80100fff:	ff 73 10             	push   0x10(%ebx)
80101002:	e8 69 0a 00 00       	call   80101a70 <stati>
    iunlock(f->ip);
80101007:	59                   	pop    %ecx
80101008:	ff 73 10             	push   0x10(%ebx)
8010100b:	e8 60 08 00 00       	call   80101870 <iunlock>
    return 0;
  }
  return -1;
}
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101013:	83 c4 10             	add    $0x10,%esp
80101016:	31 c0                	xor    %eax,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101023:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101030 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 0c             	sub    $0xc,%esp
80101039:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010103c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010103f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101042:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101046:	74 60                	je     801010a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101048:	8b 03                	mov    (%ebx),%eax
8010104a:	83 f8 01             	cmp    $0x1,%eax
8010104d:	74 41                	je     80101090 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104f:	83 f8 02             	cmp    $0x2,%eax
80101052:	75 5b                	jne    801010af <fileread+0x7f>
    ilock(f->ip);
80101054:	83 ec 0c             	sub    $0xc,%esp
80101057:	ff 73 10             	push   0x10(%ebx)
8010105a:	e8 31 07 00 00       	call   80101790 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010105f:	57                   	push   %edi
80101060:	ff 73 14             	push   0x14(%ebx)
80101063:	56                   	push   %esi
80101064:	ff 73 10             	push   0x10(%ebx)
80101067:	e8 34 0a 00 00       	call   80101aa0 <readi>
8010106c:	83 c4 20             	add    $0x20,%esp
8010106f:	89 c6                	mov    %eax,%esi
80101071:	85 c0                	test   %eax,%eax
80101073:	7e 03                	jle    80101078 <fileread+0x48>
      f->off += r;
80101075:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	ff 73 10             	push   0x10(%ebx)
8010107e:	e8 ed 07 00 00       	call   80101870 <iunlock>
    return r;
80101083:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	89 f0                	mov    %esi,%eax
8010108b:	5b                   	pop    %ebx
8010108c:	5e                   	pop    %esi
8010108d:	5f                   	pop    %edi
8010108e:	5d                   	pop    %ebp
8010108f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101090:	8b 43 0c             	mov    0xc(%ebx),%eax
80101093:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	5b                   	pop    %ebx
8010109a:	5e                   	pop    %esi
8010109b:	5f                   	pop    %edi
8010109c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010109d:	e9 3e 26 00 00       	jmp    801036e0 <piperead>
801010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ad:	eb d7                	jmp    80101086 <fileread+0x56>
  panic("fileread");
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 86 75 10 80       	push   $0x80107586
801010b7:	e8 c4 f2 ff ff       	call   80100380 <panic>
801010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	57                   	push   %edi
801010c4:	56                   	push   %esi
801010c5:	53                   	push   %ebx
801010c6:	83 ec 1c             	sub    $0x1c,%esp
801010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010d5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010dc:	0f 84 bd 00 00 00    	je     8010119f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010e2:	8b 03                	mov    (%ebx),%eax
801010e4:	83 f8 01             	cmp    $0x1,%eax
801010e7:	0f 84 bf 00 00 00    	je     801011ac <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ed:	83 f8 02             	cmp    $0x2,%eax
801010f0:	0f 85 c8 00 00 00    	jne    801011be <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010f9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010fb:	85 c0                	test   %eax,%eax
801010fd:	7f 30                	jg     8010112f <filewrite+0x6f>
801010ff:	e9 94 00 00 00       	jmp    80101198 <filewrite+0xd8>
80101104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101108:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101111:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101114:	e8 57 07 00 00       	call   80101870 <iunlock>
      end_op();
80101119:	e8 c2 1c 00 00       	call   80102de0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010111e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101121:	83 c4 10             	add    $0x10,%esp
80101124:	39 c7                	cmp    %eax,%edi
80101126:	75 5c                	jne    80101184 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101128:	01 fe                	add    %edi,%esi
    while(i < n){
8010112a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010112d:	7e 69                	jle    80101198 <filewrite+0xd8>
      int n1 = n - i;
8010112f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101132:	b8 00 06 00 00       	mov    $0x600,%eax
80101137:	29 f7                	sub    %esi,%edi
80101139:	39 c7                	cmp    %eax,%edi
8010113b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010113e:	e8 2d 1c 00 00       	call   80102d70 <begin_op>
      ilock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 73 10             	push   0x10(%ebx)
80101149:	e8 42 06 00 00       	call   80101790 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010114e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101151:	57                   	push   %edi
80101152:	ff 73 14             	push   0x14(%ebx)
80101155:	01 f0                	add    %esi,%eax
80101157:	50                   	push   %eax
80101158:	ff 73 10             	push   0x10(%ebx)
8010115b:	e8 40 0a 00 00       	call   80101ba0 <writei>
80101160:	83 c4 20             	add    $0x20,%esp
80101163:	85 c0                	test   %eax,%eax
80101165:	7f a1                	jg     80101108 <filewrite+0x48>
      iunlock(f->ip);
80101167:	83 ec 0c             	sub    $0xc,%esp
8010116a:	ff 73 10             	push   0x10(%ebx)
8010116d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101170:	e8 fb 06 00 00       	call   80101870 <iunlock>
      end_op();
80101175:	e8 66 1c 00 00       	call   80102de0 <end_op>
      if(r < 0)
8010117a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010117d:	83 c4 10             	add    $0x10,%esp
80101180:	85 c0                	test   %eax,%eax
80101182:	75 1b                	jne    8010119f <filewrite+0xdf>
        panic("short filewrite");
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	68 8f 75 10 80       	push   $0x8010758f
8010118c:	e8 ef f1 ff ff       	call   80100380 <panic>
80101191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101198:	89 f0                	mov    %esi,%eax
8010119a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010119d:	74 05                	je     801011a4 <filewrite+0xe4>
8010119f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a7:	5b                   	pop    %ebx
801011a8:	5e                   	pop    %esi
801011a9:	5f                   	pop    %edi
801011aa:	5d                   	pop    %ebp
801011ab:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011ac:	8b 43 0c             	mov    0xc(%ebx),%eax
801011af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	5b                   	pop    %ebx
801011b6:	5e                   	pop    %esi
801011b7:	5f                   	pop    %edi
801011b8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011b9:	e9 22 24 00 00       	jmp    801035e0 <pipewrite>
  panic("filewrite");
801011be:	83 ec 0c             	sub    $0xc,%esp
801011c1:	68 95 75 10 80       	push   $0x80107595
801011c6:	e8 b5 f1 ff ff       	call   80100380 <panic>
801011cb:	66 90                	xchg   %ax,%ax
801011cd:	66 90                	xchg   %ax,%ax
801011cf:	90                   	nop

801011d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011d0:	55                   	push   %ebp
801011d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011d3:	89 d0                	mov    %edx,%eax
801011d5:	c1 e8 0c             	shr    $0xc,%eax
801011d8:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
801011de:	89 e5                	mov    %esp,%ebp
801011e0:	56                   	push   %esi
801011e1:	53                   	push   %ebx
801011e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	50                   	push   %eax
801011e8:	51                   	push   %ecx
801011e9:	e8 e2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011f0:	c1 fb 03             	sar    $0x3,%ebx
801011f3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011f6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011f8:	83 e1 07             	and    $0x7,%ecx
801011fb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101200:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101206:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101208:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010120d:	85 c1                	test   %eax,%ecx
8010120f:	74 23                	je     80101234 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101211:	f7 d0                	not    %eax
  log_write(bp);
80101213:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101216:	21 c8                	and    %ecx,%eax
80101218:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010121c:	56                   	push   %esi
8010121d:	e8 2e 1d 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101222:	89 34 24             	mov    %esi,(%esp)
80101225:	e8 c6 ef ff ff       	call   801001f0 <brelse>
}
8010122a:	83 c4 10             	add    $0x10,%esp
8010122d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101230:	5b                   	pop    %ebx
80101231:	5e                   	pop    %esi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
    panic("freeing free block");
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	68 9f 75 10 80       	push   $0x8010759f
8010123c:	e8 3f f1 ff ff       	call   80100380 <panic>
80101241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010124f:	90                   	nop

80101250 <balloc>:
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010125f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 87 00 00 00    	je     801012f1 <balloc+0xa1>
8010126a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101271:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101274:	83 ec 08             	sub    $0x8,%esp
80101277:	89 f0                	mov    %esi,%eax
80101279:	c1 f8 0c             	sar    $0xc,%eax
8010127c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101282:	50                   	push   %eax
80101283:	ff 75 d8             	push   -0x28(%ebp)
80101286:	e8 45 ee ff ff       	call   801000d0 <bread>
8010128b:	83 c4 10             	add    $0x10,%esp
8010128e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101291:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101296:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101299:	31 c0                	xor    %eax,%eax
8010129b:	eb 2f                	jmp    801012cc <balloc+0x7c>
8010129d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
801012a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012b9:	89 fa                	mov    %edi,%edx
801012bb:	85 df                	test   %ebx,%edi
801012bd:	74 41                	je     80101300 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 05                	je     801012d1 <balloc+0x81>
801012cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012cf:	77 cf                	ja     801012a0 <balloc+0x50>
    brelse(bp);
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	ff 75 e4             	push   -0x1c(%ebp)
801012d7:	e8 14 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012e9:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
801012ef:	77 80                	ja     80101271 <balloc+0x21>
  panic("balloc: out of blocks");
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 b2 75 10 80       	push   $0x801075b2
801012f9:	e8 82 f0 ff ff       	call   80100380 <panic>
801012fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101303:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101306:	09 da                	or     %ebx,%edx
80101308:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010130c:	57                   	push   %edi
8010130d:	e8 3e 1c 00 00       	call   80102f50 <log_write>
        brelse(bp);
80101312:	89 3c 24             	mov    %edi,(%esp)
80101315:	e8 d6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010131a:	58                   	pop    %eax
8010131b:	5a                   	pop    %edx
8010131c:	56                   	push   %esi
8010131d:	ff 75 d8             	push   -0x28(%ebp)
80101320:	e8 ab ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101325:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101328:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010132a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010132d:	68 00 02 00 00       	push   $0x200
80101332:	6a 00                	push   $0x0
80101334:	50                   	push   %eax
80101335:	e8 76 34 00 00       	call   801047b0 <memset>
  log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 0e 1c 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 a6 ee ff ff       	call   801001f0 <brelse>
}
8010134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134d:	89 f0                	mov    %esi,%eax
8010134f:	5b                   	pop    %ebx
80101350:	5e                   	pop    %esi
80101351:	5f                   	pop    %edi
80101352:	5d                   	pop    %ebp
80101353:	c3                   	ret    
80101354:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010135f:	90                   	nop

80101360 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	89 c7                	mov    %eax,%edi
80101366:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101367:	31 f6                	xor    %esi,%esi
{
80101369:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010136f:	83 ec 28             	sub    $0x28,%esp
80101372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101375:	68 60 f9 10 80       	push   $0x8010f960
8010137a:	e8 71 33 00 00       	call   801046f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101382:	83 c4 10             	add    $0x10,%esp
80101385:	eb 1b                	jmp    801013a2 <iget+0x42>
80101387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 3b                	cmp    %edi,(%ebx)
80101392:	74 6c                	je     80101400 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101394:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010139a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013a0:	73 26                	jae    801013c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a2:	8b 43 08             	mov    0x8(%ebx),%eax
801013a5:	85 c0                	test   %eax,%eax
801013a7:	7f e7                	jg     80101390 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a9:	85 f6                	test   %esi,%esi
801013ab:	75 e7                	jne    80101394 <iget+0x34>
801013ad:	85 c0                	test   %eax,%eax
801013af:	75 76                	jne    80101427 <iget+0xc7>
801013b1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013b9:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013bf:	72 e1                	jb     801013a2 <iget+0x42>
801013c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c8:	85 f6                	test   %esi,%esi
801013ca:	74 79                	je     80101445 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013e2:	68 60 f9 10 80       	push   $0x8010f960
801013e7:	e8 a4 32 00 00       	call   80104690 <release>

  return ip;
801013ec:	83 c4 10             	add    $0x10,%esp
}
801013ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f2:	89 f0                	mov    %esi,%eax
801013f4:	5b                   	pop    %ebx
801013f5:	5e                   	pop    %esi
801013f6:	5f                   	pop    %edi
801013f7:	5d                   	pop    %ebp
801013f8:	c3                   	ret    
801013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 53 04             	cmp    %edx,0x4(%ebx)
80101403:	75 8f                	jne    80101394 <iget+0x34>
      release(&icache.lock);
80101405:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101408:	83 c0 01             	add    $0x1,%eax
      return ip;
8010140b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010140d:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
80101412:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101415:	e8 76 32 00 00       	call   80104690 <release>
      return ip;
8010141a:	83 c4 10             	add    $0x10,%esp
}
8010141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101420:	89 f0                	mov    %esi,%eax
80101422:	5b                   	pop    %ebx
80101423:	5e                   	pop    %esi
80101424:	5f                   	pop    %edi
80101425:	5d                   	pop    %ebp
80101426:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101427:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010142d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101433:	73 10                	jae    80101445 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101435:	8b 43 08             	mov    0x8(%ebx),%eax
80101438:	85 c0                	test   %eax,%eax
8010143a:	0f 8f 50 ff ff ff    	jg     80101390 <iget+0x30>
80101440:	e9 68 ff ff ff       	jmp    801013ad <iget+0x4d>
    panic("iget: no inodes");
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	68 c8 75 10 80       	push   $0x801075c8
8010144d:	e8 2e ef ff ff       	call   80100380 <panic>
80101452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101460 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	57                   	push   %edi
80101464:	56                   	push   %esi
80101465:	89 c6                	mov    %eax,%esi
80101467:	53                   	push   %ebx
80101468:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010146b:	83 fa 0b             	cmp    $0xb,%edx
8010146e:	0f 86 8c 00 00 00    	jbe    80101500 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101474:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101477:	83 fb 7f             	cmp    $0x7f,%ebx
8010147a:	0f 87 a2 00 00 00    	ja     80101522 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101480:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101486:	85 c0                	test   %eax,%eax
80101488:	74 5e                	je     801014e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010148a:	83 ec 08             	sub    $0x8,%esp
8010148d:	50                   	push   %eax
8010148e:	ff 36                	push   (%esi)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101495:	83 c4 10             	add    $0x10,%esp
80101498:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010149c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010149e:	8b 3b                	mov    (%ebx),%edi
801014a0:	85 ff                	test   %edi,%edi
801014a2:	74 1c                	je     801014c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014a4:	83 ec 0c             	sub    $0xc,%esp
801014a7:	52                   	push   %edx
801014a8:	e8 43 ed ff ff       	call   801001f0 <brelse>
801014ad:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b3:	89 f8                	mov    %edi,%eax
801014b5:	5b                   	pop    %ebx
801014b6:	5e                   	pop    %esi
801014b7:	5f                   	pop    %edi
801014b8:	5d                   	pop    %ebp
801014b9:	c3                   	ret    
801014ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014c3:	8b 06                	mov    (%esi),%eax
801014c5:	e8 86 fd ff ff       	call   80101250 <balloc>
      log_write(bp);
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014d0:	89 03                	mov    %eax,(%ebx)
801014d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014d4:	52                   	push   %edx
801014d5:	e8 76 1a 00 00       	call   80102f50 <log_write>
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 c4 10             	add    $0x10,%esp
801014e0:	eb c2                	jmp    801014a4 <bmap+0x44>
801014e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014e8:	8b 06                	mov    (%esi),%eax
801014ea:	e8 61 fd ff ff       	call   80101250 <balloc>
801014ef:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014f5:	eb 93                	jmp    8010148a <bmap+0x2a>
801014f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fe:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101500:	8d 5a 14             	lea    0x14(%edx),%ebx
80101503:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101507:	85 ff                	test   %edi,%edi
80101509:	75 a5                	jne    801014b0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010150b:	8b 00                	mov    (%eax),%eax
8010150d:	e8 3e fd ff ff       	call   80101250 <balloc>
80101512:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101516:	89 c7                	mov    %eax,%edi
}
80101518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010151b:	5b                   	pop    %ebx
8010151c:	89 f8                	mov    %edi,%eax
8010151e:	5e                   	pop    %esi
8010151f:	5f                   	pop    %edi
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
  panic("bmap: out of range");
80101522:	83 ec 0c             	sub    $0xc,%esp
80101525:	68 d8 75 10 80       	push   $0x801075d8
8010152a:	e8 51 ee ff ff       	call   80100380 <panic>
8010152f:	90                   	nop

80101530 <readsb>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	56                   	push   %esi
80101534:	53                   	push   %ebx
80101535:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101538:	83 ec 08             	sub    $0x8,%esp
8010153b:	6a 01                	push   $0x1
8010153d:	ff 75 08             	push   0x8(%ebp)
80101540:	e8 8b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101545:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101548:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010154a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010154d:	6a 1c                	push   $0x1c
8010154f:	50                   	push   %eax
80101550:	56                   	push   %esi
80101551:	e8 fa 32 00 00       	call   80104850 <memmove>
  brelse(bp);
80101556:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101559:	83 c4 10             	add    $0x10,%esp
}
8010155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010155f:	5b                   	pop    %ebx
80101560:	5e                   	pop    %esi
80101561:	5d                   	pop    %ebp
  brelse(bp);
80101562:	e9 89 ec ff ff       	jmp    801001f0 <brelse>
80101567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010156e:	66 90                	xchg   %ax,%ax

80101570 <iinit>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	53                   	push   %ebx
80101574:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101579:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010157c:	68 eb 75 10 80       	push   $0x801075eb
80101581:	68 60 f9 10 80       	push   $0x8010f960
80101586:	e8 95 2f 00 00       	call   80104520 <initlock>
  for(i = 0; i < NINODE; i++) {
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101590:	83 ec 08             	sub    $0x8,%esp
80101593:	68 f2 75 10 80       	push   $0x801075f2
80101598:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101599:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010159f:	e8 4c 2e 00 00       	call   801043f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015a4:	83 c4 10             	add    $0x10,%esp
801015a7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801015ad:	75 e1                	jne    80101590 <iinit+0x20>
  bp = bread(dev, 1);
801015af:	83 ec 08             	sub    $0x8,%esp
801015b2:	6a 01                	push   $0x1
801015b4:	ff 75 08             	push   0x8(%ebp)
801015b7:	e8 14 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015bc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015bf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015c1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015c4:	6a 1c                	push   $0x1c
801015c6:	50                   	push   %eax
801015c7:	68 b4 15 11 80       	push   $0x801115b4
801015cc:	e8 7f 32 00 00       	call   80104850 <memmove>
  brelse(bp);
801015d1:	89 1c 24             	mov    %ebx,(%esp)
801015d4:	e8 17 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015d9:	ff 35 cc 15 11 80    	push   0x801115cc
801015df:	ff 35 c8 15 11 80    	push   0x801115c8
801015e5:	ff 35 c4 15 11 80    	push   0x801115c4
801015eb:	ff 35 c0 15 11 80    	push   0x801115c0
801015f1:	ff 35 bc 15 11 80    	push   0x801115bc
801015f7:	ff 35 b8 15 11 80    	push   0x801115b8
801015fd:	ff 35 b4 15 11 80    	push   0x801115b4
80101603:	68 58 76 10 80       	push   $0x80107658
80101608:	e8 93 f0 ff ff       	call   801006a0 <cprintf>
}
8010160d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101610:	83 c4 30             	add    $0x30,%esp
80101613:	c9                   	leave  
80101614:	c3                   	ret    
80101615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101620 <ialloc>:
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	57                   	push   %edi
80101624:	56                   	push   %esi
80101625:	53                   	push   %ebx
80101626:	83 ec 1c             	sub    $0x1c,%esp
80101629:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101633:	8b 75 08             	mov    0x8(%ebp),%esi
80101636:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101639:	0f 86 91 00 00 00    	jbe    801016d0 <ialloc+0xb0>
8010163f:	bf 01 00 00 00       	mov    $0x1,%edi
80101644:	eb 21                	jmp    80101667 <ialloc+0x47>
80101646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010164d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101650:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101653:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101656:	53                   	push   %ebx
80101657:	e8 94 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010165c:	83 c4 10             	add    $0x10,%esp
8010165f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101665:	73 69                	jae    801016d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101667:	89 f8                	mov    %edi,%eax
80101669:	83 ec 08             	sub    $0x8,%esp
8010166c:	c1 e8 03             	shr    $0x3,%eax
8010166f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101675:	50                   	push   %eax
80101676:	56                   	push   %esi
80101677:	e8 54 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010167c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010167f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101681:	89 f8                	mov    %edi,%eax
80101683:	83 e0 07             	and    $0x7,%eax
80101686:	c1 e0 06             	shl    $0x6,%eax
80101689:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010168d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101691:	75 bd                	jne    80101650 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101693:	83 ec 04             	sub    $0x4,%esp
80101696:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101699:	6a 40                	push   $0x40
8010169b:	6a 00                	push   $0x0
8010169d:	51                   	push   %ecx
8010169e:	e8 0d 31 00 00       	call   801047b0 <memset>
      dip->type = type;
801016a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ad:	89 1c 24             	mov    %ebx,(%esp)
801016b0:	e8 9b 18 00 00       	call   80102f50 <log_write>
      brelse(bp);
801016b5:	89 1c 24             	mov    %ebx,(%esp)
801016b8:	e8 33 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016bd:	83 c4 10             	add    $0x10,%esp
}
801016c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016c3:	89 fa                	mov    %edi,%edx
}
801016c5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016c6:	89 f0                	mov    %esi,%eax
}
801016c8:	5e                   	pop    %esi
801016c9:	5f                   	pop    %edi
801016ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801016cb:	e9 90 fc ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	68 f8 75 10 80       	push   $0x801075f8
801016d8:	e8 a3 ec ff ff       	call   80100380 <panic>
801016dd:	8d 76 00             	lea    0x0(%esi),%esi

801016e0 <iupdate>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	56                   	push   %esi
801016e4:	53                   	push   %ebx
801016e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016eb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ee:	83 ec 08             	sub    $0x8,%esp
801016f1:	c1 e8 03             	shr    $0x3,%eax
801016f4:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016fa:	50                   	push   %eax
801016fb:	ff 73 a4             	push   -0x5c(%ebx)
801016fe:	e8 cd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101703:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101707:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010170f:	83 e0 07             	and    $0x7,%eax
80101712:	c1 e0 06             	shl    $0x6,%eax
80101715:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101719:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010171c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101720:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101723:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101727:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010172b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010172f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101733:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101737:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010173a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173d:	6a 34                	push   $0x34
8010173f:	53                   	push   %ebx
80101740:	50                   	push   %eax
80101741:	e8 0a 31 00 00       	call   80104850 <memmove>
  log_write(bp);
80101746:	89 34 24             	mov    %esi,(%esp)
80101749:	e8 02 18 00 00       	call   80102f50 <log_write>
  brelse(bp);
8010174e:	89 75 08             	mov    %esi,0x8(%ebp)
80101751:	83 c4 10             	add    $0x10,%esp
}
80101754:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101757:	5b                   	pop    %ebx
80101758:	5e                   	pop    %esi
80101759:	5d                   	pop    %ebp
  brelse(bp);
8010175a:	e9 91 ea ff ff       	jmp    801001f0 <brelse>
8010175f:	90                   	nop

80101760 <idup>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	53                   	push   %ebx
80101764:	83 ec 10             	sub    $0x10,%esp
80101767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010176a:	68 60 f9 10 80       	push   $0x8010f960
8010176f:	e8 7c 2f 00 00       	call   801046f0 <acquire>
  ip->ref++;
80101774:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101778:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010177f:	e8 0c 2f 00 00       	call   80104690 <release>
}
80101784:	89 d8                	mov    %ebx,%eax
80101786:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101789:	c9                   	leave  
8010178a:	c3                   	ret    
8010178b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010178f:	90                   	nop

80101790 <ilock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101798:	85 db                	test   %ebx,%ebx
8010179a:	0f 84 b7 00 00 00    	je     80101857 <ilock+0xc7>
801017a0:	8b 53 08             	mov    0x8(%ebx),%edx
801017a3:	85 d2                	test   %edx,%edx
801017a5:	0f 8e ac 00 00 00    	jle    80101857 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017ab:	83 ec 0c             	sub    $0xc,%esp
801017ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801017b1:	50                   	push   %eax
801017b2:	e8 79 2c 00 00       	call   80104430 <acquiresleep>
  if(ip->valid == 0){
801017b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ba:	83 c4 10             	add    $0x10,%esp
801017bd:	85 c0                	test   %eax,%eax
801017bf:	74 0f                	je     801017d0 <ilock+0x40>
}
801017c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017c4:	5b                   	pop    %ebx
801017c5:	5e                   	pop    %esi
801017c6:	5d                   	pop    %ebp
801017c7:	c3                   	ret    
801017c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017cf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017d0:	8b 43 04             	mov    0x4(%ebx),%eax
801017d3:	83 ec 08             	sub    $0x8,%esp
801017d6:	c1 e8 03             	shr    $0x3,%eax
801017d9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017df:	50                   	push   %eax
801017e0:	ff 33                	push   (%ebx)
801017e2:	e8 e9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017e7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ec:	8b 43 04             	mov    0x4(%ebx),%eax
801017ef:	83 e0 07             	and    $0x7,%eax
801017f2:	c1 e0 06             	shl    $0x6,%eax
801017f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101803:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101807:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010180b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010180f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101813:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101817:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010181b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010181e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101821:	6a 34                	push   $0x34
80101823:	50                   	push   %eax
80101824:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101827:	50                   	push   %eax
80101828:	e8 23 30 00 00       	call   80104850 <memmove>
    brelse(bp);
8010182d:	89 34 24             	mov    %esi,(%esp)
80101830:	e8 bb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101835:	83 c4 10             	add    $0x10,%esp
80101838:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010183d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101844:	0f 85 77 ff ff ff    	jne    801017c1 <ilock+0x31>
      panic("ilock: no type");
8010184a:	83 ec 0c             	sub    $0xc,%esp
8010184d:	68 10 76 10 80       	push   $0x80107610
80101852:	e8 29 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 0a 76 10 80       	push   $0x8010760a
8010185f:	e8 1c eb ff ff       	call   80100380 <panic>
80101864:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010186b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010186f:	90                   	nop

80101870 <iunlock>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101878:	85 db                	test   %ebx,%ebx
8010187a:	74 28                	je     801018a4 <iunlock+0x34>
8010187c:	83 ec 0c             	sub    $0xc,%esp
8010187f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101882:	56                   	push   %esi
80101883:	e8 48 2c 00 00       	call   801044d0 <holdingsleep>
80101888:	83 c4 10             	add    $0x10,%esp
8010188b:	85 c0                	test   %eax,%eax
8010188d:	74 15                	je     801018a4 <iunlock+0x34>
8010188f:	8b 43 08             	mov    0x8(%ebx),%eax
80101892:	85 c0                	test   %eax,%eax
80101894:	7e 0e                	jle    801018a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101896:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101899:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010189c:	5b                   	pop    %ebx
8010189d:	5e                   	pop    %esi
8010189e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010189f:	e9 ec 2b 00 00       	jmp    80104490 <releasesleep>
    panic("iunlock");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 1f 76 10 80       	push   $0x8010761f
801018ac:	e8 cf ea ff ff       	call   80100380 <panic>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018bf:	90                   	nop

801018c0 <iput>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	57                   	push   %edi
801018c4:	56                   	push   %esi
801018c5:	53                   	push   %ebx
801018c6:	83 ec 28             	sub    $0x28,%esp
801018c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018cf:	57                   	push   %edi
801018d0:	e8 5b 2b 00 00       	call   80104430 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018d8:	83 c4 10             	add    $0x10,%esp
801018db:	85 d2                	test   %edx,%edx
801018dd:	74 07                	je     801018e6 <iput+0x26>
801018df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018e4:	74 32                	je     80101918 <iput+0x58>
  releasesleep(&ip->lock);
801018e6:	83 ec 0c             	sub    $0xc,%esp
801018e9:	57                   	push   %edi
801018ea:	e8 a1 2b 00 00       	call   80104490 <releasesleep>
  acquire(&icache.lock);
801018ef:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801018f6:	e8 f5 2d 00 00       	call   801046f0 <acquire>
  ip->ref--;
801018fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ff:	83 c4 10             	add    $0x10,%esp
80101902:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101909:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010190c:	5b                   	pop    %ebx
8010190d:	5e                   	pop    %esi
8010190e:	5f                   	pop    %edi
8010190f:	5d                   	pop    %ebp
  release(&icache.lock);
80101910:	e9 7b 2d 00 00       	jmp    80104690 <release>
80101915:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101918:	83 ec 0c             	sub    $0xc,%esp
8010191b:	68 60 f9 10 80       	push   $0x8010f960
80101920:	e8 cb 2d 00 00       	call   801046f0 <acquire>
    int r = ip->ref;
80101925:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101928:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010192f:	e8 5c 2d 00 00       	call   80104690 <release>
    if(r == 1){
80101934:	83 c4 10             	add    $0x10,%esp
80101937:	83 fe 01             	cmp    $0x1,%esi
8010193a:	75 aa                	jne    801018e6 <iput+0x26>
8010193c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101942:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101945:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101948:	89 cf                	mov    %ecx,%edi
8010194a:	eb 0b                	jmp    80101957 <iput+0x97>
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101950:	83 c6 04             	add    $0x4,%esi
80101953:	39 fe                	cmp    %edi,%esi
80101955:	74 19                	je     80101970 <iput+0xb0>
    if(ip->addrs[i]){
80101957:	8b 16                	mov    (%esi),%edx
80101959:	85 d2                	test   %edx,%edx
8010195b:	74 f3                	je     80101950 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010195d:	8b 03                	mov    (%ebx),%eax
8010195f:	e8 6c f8 ff ff       	call   801011d0 <bfree>
      ip->addrs[i] = 0;
80101964:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010196a:	eb e4                	jmp    80101950 <iput+0x90>
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101970:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101976:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101979:	85 c0                	test   %eax,%eax
8010197b:	75 2d                	jne    801019aa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010197d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101980:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101987:	53                   	push   %ebx
80101988:	e8 53 fd ff ff       	call   801016e0 <iupdate>
      ip->type = 0;
8010198d:	31 c0                	xor    %eax,%eax
8010198f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101993:	89 1c 24             	mov    %ebx,(%esp)
80101996:	e8 45 fd ff ff       	call   801016e0 <iupdate>
      ip->valid = 0;
8010199b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019a2:	83 c4 10             	add    $0x10,%esp
801019a5:	e9 3c ff ff ff       	jmp    801018e6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019aa:	83 ec 08             	sub    $0x8,%esp
801019ad:	50                   	push   %eax
801019ae:	ff 33                	push   (%ebx)
801019b0:	e8 1b e7 ff ff       	call   801000d0 <bread>
801019b5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019c4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019c7:	89 cf                	mov    %ecx,%edi
801019c9:	eb 0c                	jmp    801019d7 <iput+0x117>
801019cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019cf:	90                   	nop
801019d0:	83 c6 04             	add    $0x4,%esi
801019d3:	39 f7                	cmp    %esi,%edi
801019d5:	74 0f                	je     801019e6 <iput+0x126>
      if(a[j])
801019d7:	8b 16                	mov    (%esi),%edx
801019d9:	85 d2                	test   %edx,%edx
801019db:	74 f3                	je     801019d0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019dd:	8b 03                	mov    (%ebx),%eax
801019df:	e8 ec f7 ff ff       	call   801011d0 <bfree>
801019e4:	eb ea                	jmp    801019d0 <iput+0x110>
    brelse(bp);
801019e6:	83 ec 0c             	sub    $0xc,%esp
801019e9:	ff 75 e4             	push   -0x1c(%ebp)
801019ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019ef:	e8 fc e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019f4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019fa:	8b 03                	mov    (%ebx),%eax
801019fc:	e8 cf f7 ff ff       	call   801011d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a01:	83 c4 10             	add    $0x10,%esp
80101a04:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a0b:	00 00 00 
80101a0e:	e9 6a ff ff ff       	jmp    8010197d <iput+0xbd>
80101a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a20 <iunlockput>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a28:	85 db                	test   %ebx,%ebx
80101a2a:	74 34                	je     80101a60 <iunlockput+0x40>
80101a2c:	83 ec 0c             	sub    $0xc,%esp
80101a2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a32:	56                   	push   %esi
80101a33:	e8 98 2a 00 00       	call   801044d0 <holdingsleep>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	74 21                	je     80101a60 <iunlockput+0x40>
80101a3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a42:	85 c0                	test   %eax,%eax
80101a44:	7e 1a                	jle    80101a60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	56                   	push   %esi
80101a4a:	e8 41 2a 00 00       	call   80104490 <releasesleep>
  iput(ip);
80101a4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a52:	83 c4 10             	add    $0x10,%esp
}
80101a55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a58:	5b                   	pop    %ebx
80101a59:	5e                   	pop    %esi
80101a5a:	5d                   	pop    %ebp
  iput(ip);
80101a5b:	e9 60 fe ff ff       	jmp    801018c0 <iput>
    panic("iunlock");
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	68 1f 76 10 80       	push   $0x8010761f
80101a68:	e8 13 e9 ff ff       	call   80100380 <panic>
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi

80101a70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	8b 55 08             	mov    0x8(%ebp),%edx
80101a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a79:	8b 0a                	mov    (%edx),%ecx
80101a7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a93:	8b 52 58             	mov    0x58(%edx),%edx
80101a96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a99:	5d                   	pop    %ebp
80101a9a:	c3                   	ret    
80101a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a9f:	90                   	nop

80101aa0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101aac:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaf:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ab5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101abd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ac0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 a7 00 00 00    	je     80101b70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	8b 40 58             	mov    0x58(%eax),%eax
80101acf:	39 c6                	cmp    %eax,%esi
80101ad1:	0f 87 ba 00 00 00    	ja     80101b91 <readi+0xf1>
80101ad7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ada:	31 c9                	xor    %ecx,%ecx
80101adc:	89 da                	mov    %ebx,%edx
80101ade:	01 f2                	add    %esi,%edx
80101ae0:	0f 92 c1             	setb   %cl
80101ae3:	89 cf                	mov    %ecx,%edi
80101ae5:	0f 82 a6 00 00 00    	jb     80101b91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aeb:	89 c1                	mov    %eax,%ecx
80101aed:	29 f1                	sub    %esi,%ecx
80101aef:	39 d0                	cmp    %edx,%eax
80101af1:	0f 43 cb             	cmovae %ebx,%ecx
80101af4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101af7:	85 c9                	test   %ecx,%ecx
80101af9:	74 67                	je     80101b62 <readi+0xc2>
80101afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 d8                	mov    %ebx,%eax
80101b0a:	e8 51 f9 ff ff       	call   80101460 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 33                	push   (%ebx)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b1d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b22:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b24:	89 f0                	mov    %esi,%eax
80101b26:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b2b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b30:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b32:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b36:	39 d9                	cmp    %ebx,%ecx
80101b38:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3b:	83 c4 0c             	add    $0xc,%esp
80101b3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b3f:	01 df                	add    %ebx,%edi
80101b41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b43:	50                   	push   %eax
80101b44:	ff 75 e0             	push   -0x20(%ebp)
80101b47:	e8 04 2d 00 00       	call   80104850 <memmove>
    brelse(bp);
80101b4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b4f:	89 14 24             	mov    %edx,(%esp)
80101b52:	e8 99 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b5a:	83 c4 10             	add    $0x10,%esp
80101b5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b60:	77 9e                	ja     80101b00 <readi+0x60>
  }
  return n;
80101b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b68:	5b                   	pop    %ebx
80101b69:	5e                   	pop    %esi
80101b6a:	5f                   	pop    %edi
80101b6b:	5d                   	pop    %ebp
80101b6c:	c3                   	ret    
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 17                	ja     80101b91 <readi+0xf1>
80101b7a:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 0c                	je     80101b91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b8f:	ff e0                	jmp    *%eax
      return -1;
80101b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b96:	eb cd                	jmp    80101b65 <readi+0xc5>
80101b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop

80101ba0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101baf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bc3:	0f 84 b7 00 00 00    	je     80101c80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bcf:	0f 87 e7 00 00 00    	ja     80101cbc <writei+0x11c>
80101bd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bd8:	31 d2                	xor    %edx,%edx
80101bda:	89 f8                	mov    %edi,%eax
80101bdc:	01 f0                	add    %esi,%eax
80101bde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101be1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101be6:	0f 87 d0 00 00 00    	ja     80101cbc <writei+0x11c>
80101bec:	85 d2                	test   %edx,%edx
80101bee:	0f 85 c8 00 00 00    	jne    80101cbc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bfb:	85 ff                	test   %edi,%edi
80101bfd:	74 72                	je     80101c71 <writei+0xd1>
80101bff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 f8                	mov    %edi,%eax
80101c0a:	e8 51 f8 ff ff       	call   80101460 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 37                	push   (%edi)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c22:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c25:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	89 f0                	mov    %esi,%eax
80101c29:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c2e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c30:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c34:	39 d9                	cmp    %ebx,%ecx
80101c36:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c39:	83 c4 0c             	add    $0xc,%esp
80101c3c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c3d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c3f:	ff 75 dc             	push   -0x24(%ebp)
80101c42:	50                   	push   %eax
80101c43:	e8 08 2c 00 00       	call   80104850 <memmove>
    log_write(bp);
80101c48:	89 3c 24             	mov    %edi,(%esp)
80101c4b:	e8 00 13 00 00       	call   80102f50 <log_write>
    brelse(bp);
80101c50:	89 3c 24             	mov    %edi,(%esp)
80101c53:	e8 98 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c61:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c67:	77 97                	ja     80101c00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c6f:	77 37                	ja     80101ca8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c77:	5b                   	pop    %ebx
80101c78:	5e                   	pop    %esi
80101c79:	5f                   	pop    %edi
80101c7a:	5d                   	pop    %ebp
80101c7b:	c3                   	ret    
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c84:	66 83 f8 09          	cmp    $0x9,%ax
80101c88:	77 32                	ja     80101cbc <writei+0x11c>
80101c8a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101c91:	85 c0                	test   %eax,%eax
80101c93:	74 27                	je     80101cbc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c95:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9b:	5b                   	pop    %ebx
80101c9c:	5e                   	pop    %esi
80101c9d:	5f                   	pop    %edi
80101c9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c9f:	ff e0                	jmp    *%eax
80101ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ca8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cb1:	50                   	push   %eax
80101cb2:	e8 29 fa ff ff       	call   801016e0 <iupdate>
80101cb7:	83 c4 10             	add    $0x10,%esp
80101cba:	eb b5                	jmp    80101c71 <writei+0xd1>
      return -1;
80101cbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cc1:	eb b1                	jmp    80101c74 <writei+0xd4>
80101cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 dd 2b 00 00       	call   801048c0 <strncmp>
}
80101ce3:	c9                   	leave  
80101ce4:	c3                   	ret    
80101ce5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d17:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 7e fd ff ff       	call   80101aa0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 7e 2b 00 00       	call   801048c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret    
80101d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d5f:	90                   	nop
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 e9 f5 ff ff       	call   80101360 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret    
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 39 76 10 80       	push   $0x80107639
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 27 76 10 80       	push   $0x80107627
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 64 01 00 00    	je     80101f1e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 e1 1b 00 00       	call   801039a0 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 f9 10 80       	push   $0x8010f960
80101dca:	e8 21 29 00 00       	call   801046f0 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101dda:	e8 b1 28 00 00       	call   80104690 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
    path++;
80101e32:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 14 2a 00 00       	call   80104850 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 37 f9 ff ff       	call   80101790 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 cd 00 00 00    	jne    80101f34 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 22 01 00 00    	je     80101f99 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e88:	83 c4 10             	add    $0x10,%esp
80101e8b:	89 c7                	mov    %eax,%edi
80101e8d:	85 c0                	test   %eax,%eax
80101e8f:	0f 84 e1 00 00 00    	je     80101f76 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e9b:	52                   	push   %edx
80101e9c:	e8 2f 26 00 00       	call   801044d0 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 30 01 00 00    	je     80101fdc <namex+0x23c>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e 25 01 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101eb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	52                   	push   %edx
80101ebe:	e8 cd 25 00 00       	call   80104490 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
80101ec6:	89 fe                	mov    %edi,%esi
80101ec8:	e8 f3 f9 ff ff       	call   801018c0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101edb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 60 29 00 00       	call   80104850 <memmove>
    name[len] = 0;
80101ef0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 02 00             	movb   $0x0,(%edx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 be 00 00 00    	jne    80101fc9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f1e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f23:	b8 01 00 00 00       	mov    $0x1,%eax
80101f28:	e8 33 f4 ff ff       	call   80101360 <iget>
80101f2d:	89 c6                	mov    %eax,%esi
80101f2f:	e9 b7 fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f34:	83 ec 0c             	sub    $0xc,%esp
80101f37:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f3a:	53                   	push   %ebx
80101f3b:	e8 90 25 00 00       	call   801044d0 <holdingsleep>
80101f40:	83 c4 10             	add    $0x10,%esp
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 84 91 00 00 00    	je     80101fdc <namex+0x23c>
80101f4b:	8b 46 08             	mov    0x8(%esi),%eax
80101f4e:	85 c0                	test   %eax,%eax
80101f50:	0f 8e 86 00 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f56:	83 ec 0c             	sub    $0xc,%esp
80101f59:	53                   	push   %ebx
80101f5a:	e8 31 25 00 00       	call   80104490 <releasesleep>
  iput(ip);
80101f5f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f62:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f64:	e8 57 f9 ff ff       	call   801018c0 <iput>
      return 0;
80101f69:	83 c4 10             	add    $0x10,%esp
}
80101f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6f:	89 f0                	mov    %esi,%eax
80101f71:	5b                   	pop    %ebx
80101f72:	5e                   	pop    %esi
80101f73:	5f                   	pop    %edi
80101f74:	5d                   	pop    %ebp
80101f75:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f76:	83 ec 0c             	sub    $0xc,%esp
80101f79:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f7c:	52                   	push   %edx
80101f7d:	e8 4e 25 00 00       	call   801044d0 <holdingsleep>
80101f82:	83 c4 10             	add    $0x10,%esp
80101f85:	85 c0                	test   %eax,%eax
80101f87:	74 53                	je     80101fdc <namex+0x23c>
80101f89:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f8c:	85 c9                	test   %ecx,%ecx
80101f8e:	7e 4c                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f93:	83 ec 0c             	sub    $0xc,%esp
80101f96:	52                   	push   %edx
80101f97:	eb c1                	jmp    80101f5a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f99:	83 ec 0c             	sub    $0xc,%esp
80101f9c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f9f:	53                   	push   %ebx
80101fa0:	e8 2b 25 00 00       	call   801044d0 <holdingsleep>
80101fa5:	83 c4 10             	add    $0x10,%esp
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	74 30                	je     80101fdc <namex+0x23c>
80101fac:	8b 7e 08             	mov    0x8(%esi),%edi
80101faf:	85 ff                	test   %edi,%edi
80101fb1:	7e 29                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb3:	83 ec 0c             	sub    $0xc,%esp
80101fb6:	53                   	push   %ebx
80101fb7:	e8 d4 24 00 00       	call   80104490 <releasesleep>
}
80101fbc:	83 c4 10             	add    $0x10,%esp
}
80101fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc2:	89 f0                	mov    %esi,%eax
80101fc4:	5b                   	pop    %ebx
80101fc5:	5e                   	pop    %esi
80101fc6:	5f                   	pop    %edi
80101fc7:	5d                   	pop    %ebp
80101fc8:	c3                   	ret    
    iput(ip);
80101fc9:	83 ec 0c             	sub    $0xc,%esp
80101fcc:	56                   	push   %esi
    return 0;
80101fcd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fcf:	e8 ec f8 ff ff       	call   801018c0 <iput>
    return 0;
80101fd4:	83 c4 10             	add    $0x10,%esp
80101fd7:	e9 2f ff ff ff       	jmp    80101f0b <namex+0x16b>
    panic("iunlock");
80101fdc:	83 ec 0c             	sub    $0xc,%esp
80101fdf:	68 1f 76 10 80       	push   $0x8010761f
80101fe4:	e8 97 e3 ff ff       	call   80100380 <panic>
80101fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ff0 <dirlink>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 20             	sub    $0x20,%esp
80101ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ffc:	6a 00                	push   $0x0
80101ffe:	ff 75 0c             	push   0xc(%ebp)
80102001:	53                   	push   %ebx
80102002:	e8 e9 fc ff ff       	call   80101cf0 <dirlookup>
80102007:	83 c4 10             	add    $0x10,%esp
8010200a:	85 c0                	test   %eax,%eax
8010200c:	75 67                	jne    80102075 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010200e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102011:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102014:	85 ff                	test   %edi,%edi
80102016:	74 29                	je     80102041 <dirlink+0x51>
80102018:	31 ff                	xor    %edi,%edi
8010201a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010201d:	eb 09                	jmp    80102028 <dirlink+0x38>
8010201f:	90                   	nop
80102020:	83 c7 10             	add    $0x10,%edi
80102023:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102026:	73 19                	jae    80102041 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102028:	6a 10                	push   $0x10
8010202a:	57                   	push   %edi
8010202b:	56                   	push   %esi
8010202c:	53                   	push   %ebx
8010202d:	e8 6e fa ff ff       	call   80101aa0 <readi>
80102032:	83 c4 10             	add    $0x10,%esp
80102035:	83 f8 10             	cmp    $0x10,%eax
80102038:	75 4e                	jne    80102088 <dirlink+0x98>
    if(de.inum == 0)
8010203a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010203f:	75 df                	jne    80102020 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102041:	83 ec 04             	sub    $0x4,%esp
80102044:	8d 45 da             	lea    -0x26(%ebp),%eax
80102047:	6a 0e                	push   $0xe
80102049:	ff 75 0c             	push   0xc(%ebp)
8010204c:	50                   	push   %eax
8010204d:	e8 be 28 00 00       	call   80104910 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102052:	6a 10                	push   $0x10
  de.inum = inum;
80102054:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102057:	57                   	push   %edi
80102058:	56                   	push   %esi
80102059:	53                   	push   %ebx
  de.inum = inum;
8010205a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010205e:	e8 3d fb ff ff       	call   80101ba0 <writei>
80102063:	83 c4 20             	add    $0x20,%esp
80102066:	83 f8 10             	cmp    $0x10,%eax
80102069:	75 2a                	jne    80102095 <dirlink+0xa5>
  return 0;
8010206b:	31 c0                	xor    %eax,%eax
}
8010206d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102070:	5b                   	pop    %ebx
80102071:	5e                   	pop    %esi
80102072:	5f                   	pop    %edi
80102073:	5d                   	pop    %ebp
80102074:	c3                   	ret    
    iput(ip);
80102075:	83 ec 0c             	sub    $0xc,%esp
80102078:	50                   	push   %eax
80102079:	e8 42 f8 ff ff       	call   801018c0 <iput>
    return -1;
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102086:	eb e5                	jmp    8010206d <dirlink+0x7d>
      panic("dirlink read");
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	68 48 76 10 80       	push   $0x80107648
80102090:	e8 eb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 2e 7c 10 80       	push   $0x80107c2e
8010209d:	e8 de e2 ff ff       	call   80100380 <panic>
801020a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020b0 <namei>:

struct inode*
namei(char *path)
{
801020b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020b1:	31 d2                	xor    %edx,%edx
{
801020b3:	89 e5                	mov    %esp,%ebp
801020b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020be:	e8 dd fc ff ff       	call   80101da0 <namex>
}
801020c3:	c9                   	leave  
801020c4:	c3                   	ret    
801020c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020d0:	55                   	push   %ebp
  return namex(path, 1, name);
801020d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020df:	e9 bc fc ff ff       	jmp    80101da0 <namex>
801020e4:	66 90                	xchg   %ax,%ax
801020e6:	66 90                	xchg   %ax,%ax
801020e8:	66 90                	xchg   %ax,%ax
801020ea:	66 90                	xchg   %ax,%ax
801020ec:	66 90                	xchg   %ax,%ax
801020ee:	66 90                	xchg   %ax,%ax

801020f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020f9:	85 c0                	test   %eax,%eax
801020fb:	0f 84 b4 00 00 00    	je     801021b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102101:	8b 70 08             	mov    0x8(%eax),%esi
80102104:	89 c3                	mov    %eax,%ebx
80102106:	81 fe 1f 4e 00 00    	cmp    $0x4e1f,%esi
8010210c:	0f 87 96 00 00 00    	ja     801021a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102112:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211e:	66 90                	xchg   %ax,%ax
80102120:	89 ca                	mov    %ecx,%edx
80102122:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102123:	83 e0 c0             	and    $0xffffffc0,%eax
80102126:	3c 40                	cmp    $0x40,%al
80102128:	75 f6                	jne    80102120 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010212a:	31 ff                	xor    %edi,%edi
8010212c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102131:	89 f8                	mov    %edi,%eax
80102133:	ee                   	out    %al,(%dx)
80102134:	b8 01 00 00 00       	mov    $0x1,%eax
80102139:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010213e:	ee                   	out    %al,(%dx)
8010213f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102144:	89 f0                	mov    %esi,%eax
80102146:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102147:	89 f0                	mov    %esi,%eax
80102149:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010214e:	c1 f8 08             	sar    $0x8,%eax
80102151:	ee                   	out    %al,(%dx)
80102152:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102157:	89 f8                	mov    %edi,%eax
80102159:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010215a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010215e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102163:	c1 e0 04             	shl    $0x4,%eax
80102166:	83 e0 10             	and    $0x10,%eax
80102169:	83 c8 e0             	or     $0xffffffe0,%eax
8010216c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010216d:	f6 03 04             	testb  $0x4,(%ebx)
80102170:	75 16                	jne    80102188 <idestart+0x98>
80102172:	b8 20 00 00 00       	mov    $0x20,%eax
80102177:	89 ca                	mov    %ecx,%edx
80102179:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010217a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217d:	5b                   	pop    %ebx
8010217e:	5e                   	pop    %esi
8010217f:	5f                   	pop    %edi
80102180:	5d                   	pop    %ebp
80102181:	c3                   	ret    
80102182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102188:	b8 30 00 00 00       	mov    $0x30,%eax
8010218d:	89 ca                	mov    %ecx,%edx
8010218f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102190:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102195:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102198:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010219d:	fc                   	cld    
8010219e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a3:	5b                   	pop    %ebx
801021a4:	5e                   	pop    %esi
801021a5:	5f                   	pop    %edi
801021a6:	5d                   	pop    %ebp
801021a7:	c3                   	ret    
    panic("incorrect blockno");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 b4 76 10 80       	push   $0x801076b4
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 ab 76 10 80       	push   $0x801076ab
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 c6 76 10 80       	push   $0x801076c6
801021db:	68 00 16 11 80       	push   $0x80111600
801021e0:	e8 3b 23 00 00       	call   80104520 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021e5:	58                   	pop    %eax
801021e6:	a1 84 17 11 80       	mov    0x80111784,%eax
801021eb:	5a                   	pop    %edx
801021ec:	83 e8 01             	sub    $0x1,%eax
801021ef:	50                   	push   %eax
801021f0:	6a 0e                	push   $0xe
801021f2:	e8 99 02 00 00       	call   80102490 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ff:	90                   	nop
80102200:	ec                   	in     (%dx),%al
80102201:	83 e0 c0             	and    $0xffffffc0,%eax
80102204:	3c 40                	cmp    $0x40,%al
80102206:	75 f8                	jne    80102200 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102208:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010220d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102212:	ee                   	out    %al,(%dx)
80102213:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102218:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221d:	eb 06                	jmp    80102225 <ideinit+0x55>
8010221f:	90                   	nop
  for(i=0; i<1000; i++){
80102220:	83 e9 01             	sub    $0x1,%ecx
80102223:	74 0f                	je     80102234 <ideinit+0x64>
80102225:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102226:	84 c0                	test   %al,%al
80102228:	74 f6                	je     80102220 <ideinit+0x50>
      havedisk1 = 1;
8010222a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102231:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102234:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102239:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010223e:	ee                   	out    %al,(%dx)
}
8010223f:	c9                   	leave  
80102240:	c3                   	ret    
80102241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010224f:	90                   	nop

80102250 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102259:	68 00 16 11 80       	push   $0x80111600
8010225e:	e8 8d 24 00 00       	call   801046f0 <acquire>

  if((b = idequeue) == 0){
80102263:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102269:	83 c4 10             	add    $0x10,%esp
8010226c:	85 db                	test   %ebx,%ebx
8010226e:	74 63                	je     801022d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102270:	8b 43 58             	mov    0x58(%ebx),%eax
80102273:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102278:	8b 33                	mov    (%ebx),%esi
8010227a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102280:	75 2f                	jne    801022b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102282:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228e:	66 90                	xchg   %ax,%ax
80102290:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102291:	89 c1                	mov    %eax,%ecx
80102293:	83 e1 c0             	and    $0xffffffc0,%ecx
80102296:	80 f9 40             	cmp    $0x40,%cl
80102299:	75 f5                	jne    80102290 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010229b:	a8 21                	test   $0x21,%al
8010229d:	75 12                	jne    801022b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010229f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ac:	fc                   	cld    
801022ad:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022af:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022b7:	83 ce 02             	or     $0x2,%esi
801022ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022bc:	53                   	push   %ebx
801022bd:	e8 ee 1e 00 00       	call   801041b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022c2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022c7:	83 c4 10             	add    $0x10,%esp
801022ca:	85 c0                	test   %eax,%eax
801022cc:	74 05                	je     801022d3 <ideintr+0x83>
    idestart(idequeue);
801022ce:	e8 1d fe ff ff       	call   801020f0 <idestart>
    release(&idelock);
801022d3:	83 ec 0c             	sub    $0xc,%esp
801022d6:	68 00 16 11 80       	push   $0x80111600
801022db:	e8 b0 23 00 00       	call   80104690 <release>

  release(&idelock);
}
801022e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e3:	5b                   	pop    %ebx
801022e4:	5e                   	pop    %esi
801022e5:	5f                   	pop    %edi
801022e6:	5d                   	pop    %ebp
801022e7:	c3                   	ret    
801022e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ef:	90                   	nop

801022f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 10             	sub    $0x10,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801022fd:	50                   	push   %eax
801022fe:	e8 cd 21 00 00       	call   801044d0 <holdingsleep>
80102303:	83 c4 10             	add    $0x10,%esp
80102306:	85 c0                	test   %eax,%eax
80102308:	0f 84 c3 00 00 00    	je     801023d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	0f 84 a8 00 00 00    	je     801023c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010231c:	8b 53 04             	mov    0x4(%ebx),%edx
8010231f:	85 d2                	test   %edx,%edx
80102321:	74 0d                	je     80102330 <iderw+0x40>
80102323:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102328:	85 c0                	test   %eax,%eax
8010232a:	0f 84 87 00 00 00    	je     801023b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	68 00 16 11 80       	push   $0x80111600
80102338:	e8 b3 23 00 00       	call   801046f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010233d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102342:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	85 c0                	test   %eax,%eax
8010234e:	74 60                	je     801023b0 <iderw+0xc0>
80102350:	89 c2                	mov    %eax,%edx
80102352:	8b 40 58             	mov    0x58(%eax),%eax
80102355:	85 c0                	test   %eax,%eax
80102357:	75 f7                	jne    80102350 <iderw+0x60>
80102359:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010235c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010235e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102364:	74 3a                	je     801023a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102366:	8b 03                	mov    (%ebx),%eax
80102368:	83 e0 06             	and    $0x6,%eax
8010236b:	83 f8 02             	cmp    $0x2,%eax
8010236e:	74 1b                	je     8010238b <iderw+0x9b>
    sleep(b, &idelock);
80102370:	83 ec 08             	sub    $0x8,%esp
80102373:	68 00 16 11 80       	push   $0x80111600
80102378:	53                   	push   %ebx
80102379:	e8 72 1d 00 00       	call   801040f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 c4 10             	add    $0x10,%esp
80102383:	83 e0 06             	and    $0x6,%eax
80102386:	83 f8 02             	cmp    $0x2,%eax
80102389:	75 e5                	jne    80102370 <iderw+0x80>
  }


  release(&idelock);
8010238b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102395:	c9                   	leave  
  release(&idelock);
80102396:	e9 f5 22 00 00       	jmp    80104690 <release>
8010239b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010239f:	90                   	nop
    idestart(b);
801023a0:	89 d8                	mov    %ebx,%eax
801023a2:	e8 49 fd ff ff       	call   801020f0 <idestart>
801023a7:	eb bd                	jmp    80102366 <iderw+0x76>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023b0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801023b5:	eb a5                	jmp    8010235c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 f5 76 10 80       	push   $0x801076f5
801023bf:	e8 bc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 e0 76 10 80       	push   $0x801076e0
801023cc:	e8 af df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 ca 76 10 80       	push   $0x801076ca
801023d9:	e8 a2 df ff ff       	call   80100380 <panic>
801023de:	66 90                	xchg   %ax,%ax

801023e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023e1:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023e8:	00 c0 fe 
{
801023eb:	89 e5                	mov    %esp,%ebp
801023ed:	56                   	push   %esi
801023ee:	53                   	push   %ebx
  ioapic->reg = reg;
801023ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023f6:	00 00 00 
  return ioapic->data;
801023f9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801023ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102402:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102408:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010240e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102415:	c1 ee 10             	shr    $0x10,%esi
80102418:	89 f0                	mov    %esi,%eax
8010241a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010241d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102420:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102423:	39 c2                	cmp    %eax,%edx
80102425:	74 16                	je     8010243d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102427:	83 ec 0c             	sub    $0xc,%esp
8010242a:	68 14 77 10 80       	push   $0x80107714
8010242f:	e8 6c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102434:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010243a:	83 c4 10             	add    $0x10,%esp
8010243d:	83 c6 21             	add    $0x21,%esi
{
80102440:	ba 10 00 00 00       	mov    $0x10,%edx
80102445:	b8 20 00 00 00       	mov    $0x20,%eax
8010244a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102450:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102452:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102454:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
8010245a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010245d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102463:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102466:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102469:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010246c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010246e:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102474:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010247b:	39 f0                	cmp    %esi,%eax
8010247d:	75 d1                	jne    80102450 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010247f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102482:	5b                   	pop    %ebx
80102483:	5e                   	pop    %esi
80102484:	5d                   	pop    %ebp
80102485:	c3                   	ret    
80102486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010248d:	8d 76 00             	lea    0x0(%esi),%esi

80102490 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102490:	55                   	push   %ebp
  ioapic->reg = reg;
80102491:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102497:	89 e5                	mov    %esp,%ebp
80102499:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010249c:	8d 50 20             	lea    0x20(%eax),%edx
8010249f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024be:	89 50 10             	mov    %edx,0x10(%eax)
}
801024c1:	5d                   	pop    %ebp
801024c2:	c3                   	ret    
801024c3:	66 90                	xchg   %ax,%ax
801024c5:	66 90                	xchg   %ax,%ax
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 04             	sub    $0x4,%esp
801024d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024e0:	75 76                	jne    80102558 <kfree+0x88>
801024e2:	81 fb d0 56 11 80    	cmp    $0x801156d0,%ebx
801024e8:	72 6e                	jb     80102558 <kfree+0x88>
801024ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024f5:	77 61                	ja     80102558 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024f7:	83 ec 04             	sub    $0x4,%esp
801024fa:	68 00 10 00 00       	push   $0x1000
801024ff:	6a 01                	push   $0x1
80102501:	53                   	push   %ebx
80102502:	e8 a9 22 00 00       	call   801047b0 <memset>

  if(kmem.use_lock)
80102507:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	85 d2                	test   %edx,%edx
80102512:	75 1c                	jne    80102530 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102514:	a1 78 16 11 80       	mov    0x80111678,%eax
80102519:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010251b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102520:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102526:	85 c0                	test   %eax,%eax
80102528:	75 1e                	jne    80102548 <kfree+0x78>
    release(&kmem.lock);
}
8010252a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252d:	c9                   	leave  
8010252e:	c3                   	ret    
8010252f:	90                   	nop
    acquire(&kmem.lock);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 40 16 11 80       	push   $0x80111640
80102538:	e8 b3 21 00 00       	call   801046f0 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb d2                	jmp    80102514 <kfree+0x44>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102552:	c9                   	leave  
    release(&kmem.lock);
80102553:	e9 38 21 00 00       	jmp    80104690 <release>
    panic("kfree");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 46 77 10 80       	push   $0x80107746
80102560:	e8 1b de ff ff       	call   80100380 <panic>
80102565:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010256c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102570 <freerange>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102574:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102577:	8b 75 0c             	mov    0xc(%ebp),%esi
8010257a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010257b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102581:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102587:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010258d:	39 de                	cmp    %ebx,%esi
8010258f:	72 23                	jb     801025b4 <freerange+0x44>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025a7:	50                   	push   %eax
801025a8:	e8 23 ff ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	39 f3                	cmp    %esi,%ebx
801025b2:	76 e4                	jbe    80102598 <freerange+0x28>
}
801025b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025b7:	5b                   	pop    %ebx
801025b8:	5e                   	pop    %esi
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret    
801025bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025bf:	90                   	nop

801025c0 <kinit2>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <kinit2+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 d3 fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102604:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010260b:	00 00 00 
}
8010260e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102611:	5b                   	pop    %ebx
80102612:	5e                   	pop    %esi
80102613:	5d                   	pop    %ebp
80102614:	c3                   	ret    
80102615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010261c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102620 <kinit1>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	56                   	push   %esi
80102624:	53                   	push   %ebx
80102625:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102628:	83 ec 08             	sub    $0x8,%esp
8010262b:	68 4c 77 10 80       	push   $0x8010774c
80102630:	68 40 16 11 80       	push   $0x80111640
80102635:	e8 e6 1e 00 00       	call   80104520 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102640:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102647:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010264a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102650:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102656:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010265c:	39 de                	cmp    %ebx,%esi
8010265e:	72 1c                	jb     8010267c <kinit1+0x5c>
    kfree(p);
80102660:	83 ec 0c             	sub    $0xc,%esp
80102663:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102669:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010266f:	50                   	push   %eax
80102670:	e8 5b fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102675:	83 c4 10             	add    $0x10,%esp
80102678:	39 de                	cmp    %ebx,%esi
8010267a:	73 e4                	jae    80102660 <kinit1+0x40>
}
8010267c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010267f:	5b                   	pop    %ebx
80102680:	5e                   	pop    %esi
80102681:	5d                   	pop    %ebp
80102682:	c3                   	ret    
80102683:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102690 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102690:	a1 74 16 11 80       	mov    0x80111674,%eax
80102695:	85 c0                	test   %eax,%eax
80102697:	75 1f                	jne    801026b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102699:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
8010269e:	85 c0                	test   %eax,%eax
801026a0:	74 0e                	je     801026b0 <kalloc+0x20>
    kmem.freelist = r->next;
801026a2:	8b 10                	mov    (%eax),%edx
801026a4:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801026aa:	c3                   	ret    
801026ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026af:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026b0:	c3                   	ret    
801026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026b8:	55                   	push   %ebp
801026b9:	89 e5                	mov    %esp,%ebp
801026bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026be:	68 40 16 11 80       	push   $0x80111640
801026c3:	e8 28 20 00 00       	call   801046f0 <acquire>
  r = kmem.freelist;
801026c8:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
801026cd:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801026d3:	83 c4 10             	add    $0x10,%esp
801026d6:	85 c0                	test   %eax,%eax
801026d8:	74 08                	je     801026e2 <kalloc+0x52>
    kmem.freelist = r->next;
801026da:	8b 08                	mov    (%eax),%ecx
801026dc:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
801026e2:	85 d2                	test   %edx,%edx
801026e4:	74 16                	je     801026fc <kalloc+0x6c>
    release(&kmem.lock);
801026e6:	83 ec 0c             	sub    $0xc,%esp
801026e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026ec:	68 40 16 11 80       	push   $0x80111640
801026f1:	e8 9a 1f 00 00       	call   80104690 <release>
  return (char*)r;
801026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026f9:	83 c4 10             	add    $0x10,%esp
}
801026fc:	c9                   	leave  
801026fd:	c3                   	ret    
801026fe:	66 90                	xchg   %ax,%ax

80102700 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102700:	ba 64 00 00 00       	mov    $0x64,%edx
80102705:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102706:	a8 01                	test   $0x1,%al
80102708:	0f 84 c2 00 00 00    	je     801027d0 <kbdgetc+0xd0>
{
8010270e:	55                   	push   %ebp
8010270f:	ba 60 00 00 00       	mov    $0x60,%edx
80102714:	89 e5                	mov    %esp,%ebp
80102716:	53                   	push   %ebx
80102717:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102718:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010271e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102721:	3c e0                	cmp    $0xe0,%al
80102723:	74 5b                	je     80102780 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102725:	89 da                	mov    %ebx,%edx
80102727:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010272a:	84 c0                	test   %al,%al
8010272c:	78 62                	js     80102790 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010272e:	85 d2                	test   %edx,%edx
80102730:	74 09                	je     8010273b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102732:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102735:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102738:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010273b:	0f b6 91 80 78 10 80 	movzbl -0x7fef8780(%ecx),%edx
  shift ^= togglecode[data];
80102742:	0f b6 81 80 77 10 80 	movzbl -0x7fef8880(%ecx),%eax
  shift |= shiftcode[data];
80102749:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010274b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010274f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102755:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102758:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275b:	8b 04 85 60 77 10 80 	mov    -0x7fef88a0(,%eax,4),%eax
80102762:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102766:	74 0b                	je     80102773 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102768:	8d 50 9f             	lea    -0x61(%eax),%edx
8010276b:	83 fa 19             	cmp    $0x19,%edx
8010276e:	77 48                	ja     801027b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102770:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102773:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102776:	c9                   	leave  
80102777:	c3                   	ret    
80102778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277f:	90                   	nop
    shift |= E0ESC;
80102780:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102783:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102785:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010278b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010278e:	c9                   	leave  
8010278f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102790:	83 e0 7f             	and    $0x7f,%eax
80102793:	85 d2                	test   %edx,%edx
80102795:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102798:	0f b6 81 80 78 10 80 	movzbl -0x7fef8780(%ecx),%eax
8010279f:	83 c8 40             	or     $0x40,%eax
801027a2:	0f b6 c0             	movzbl %al,%eax
801027a5:	f7 d0                	not    %eax
801027a7:	21 d8                	and    %ebx,%eax
}
801027a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027ac:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801027b1:	31 c0                	xor    %eax,%eax
}
801027b3:	c9                   	leave  
801027b4:	c3                   	ret    
801027b5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027c1:	c9                   	leave  
      c += 'a' - 'A';
801027c2:	83 f9 1a             	cmp    $0x1a,%ecx
801027c5:	0f 42 c2             	cmovb  %edx,%eax
}
801027c8:	c3                   	ret    
801027c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027d5:	c3                   	ret    
801027d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027dd:	8d 76 00             	lea    0x0(%esi),%esi

801027e0 <kbdintr>:

void
kbdintr(void)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027e6:	68 00 27 10 80       	push   $0x80102700
801027eb:	e8 90 e0 ff ff       	call   80100880 <consoleintr>
}
801027f0:	83 c4 10             	add    $0x10,%esp
801027f3:	c9                   	leave  
801027f4:	c3                   	ret    
801027f5:	66 90                	xchg   %ax,%ax
801027f7:	66 90                	xchg   %ax,%ax
801027f9:	66 90                	xchg   %ax,%ax
801027fb:	66 90                	xchg   %ax,%ax
801027fd:	66 90                	xchg   %ax,%ax
801027ff:	90                   	nop

80102800 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102800:	a1 80 16 11 80       	mov    0x80111680,%eax
80102805:	85 c0                	test   %eax,%eax
80102807:	0f 84 cb 00 00 00    	je     801028d8 <lapicinit+0xd8>
  lapic[index] = value;
8010280d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102814:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010282e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010283b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102848:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102855:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010285b:	8b 50 30             	mov    0x30(%eax),%edx
8010285e:	c1 ea 10             	shr    $0x10,%edx
80102861:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102867:	75 77                	jne    801028e0 <lapicinit+0xe0>
  lapic[index] = value;
80102869:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102870:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102873:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102876:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102880:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102883:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102890:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102897:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028b4:	8b 50 20             	mov    0x20(%eax),%edx
801028b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028be:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028c6:	80 e6 10             	and    $0x10,%dh
801028c9:	75 f5                	jne    801028c0 <lapicinit+0xc0>
  lapic[index] = value;
801028cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028d8:	c3                   	ret    
801028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801028ed:	e9 77 ff ff ff       	jmp    80102869 <lapicinit+0x69>
801028f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102900:	a1 80 16 11 80       	mov    0x80111680,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	74 07                	je     80102910 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102909:	8b 40 20             	mov    0x20(%eax),%eax
8010290c:	c1 e8 18             	shr    $0x18,%eax
8010290f:	c3                   	ret    
    return 0;
80102910:	31 c0                	xor    %eax,%eax
}
80102912:	c3                   	ret    
80102913:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102920 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102920:	a1 80 16 11 80       	mov    0x80111680,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	74 0d                	je     80102936 <lapiceoi+0x16>
  lapic[index] = value;
80102929:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102930:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102933:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102936:	c3                   	ret    
80102937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293e:	66 90                	xchg   %ax,%ax

80102940 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102940:	c3                   	ret    
80102941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop

80102950 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102950:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102951:	b8 0f 00 00 00       	mov    $0xf,%eax
80102956:	ba 70 00 00 00       	mov    $0x70,%edx
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	53                   	push   %ebx
8010295e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102961:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102964:	ee                   	out    %al,(%dx)
80102965:	b8 0a 00 00 00       	mov    $0xa,%eax
8010296a:	ba 71 00 00 00       	mov    $0x71,%edx
8010296f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102970:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102972:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102975:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010297b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010297d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102980:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102982:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102985:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102988:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010298e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102993:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102999:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029bc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029dd:	c9                   	leave  
801029de:	c3                   	ret    
801029df:	90                   	nop

801029e0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029e0:	55                   	push   %ebp
801029e1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029e6:	ba 70 00 00 00       	mov    $0x70,%edx
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	57                   	push   %edi
801029ee:	56                   	push   %esi
801029ef:	53                   	push   %ebx
801029f0:	83 ec 4c             	sub    $0x4c,%esp
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	ba 71 00 00 00       	mov    $0x71,%edx
801029f9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029fa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a05:	8d 76 00             	lea    0x0(%esi),%esi
80102a08:	31 c0                	xor    %eax,%eax
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a18:	89 da                	mov    %ebx,%edx
80102a1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a20:	89 ca                	mov    %ecx,%edx
80102a22:	ec                   	in     (%dx),%al
80102a23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a26:	89 da                	mov    %ebx,%edx
80102a28:	b8 04 00 00 00       	mov    $0x4,%eax
80102a2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2e:	89 ca                	mov    %ecx,%edx
80102a30:	ec                   	in     (%dx),%al
80102a31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a34:	89 da                	mov    %ebx,%edx
80102a36:	b8 07 00 00 00       	mov    $0x7,%eax
80102a3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3c:	89 ca                	mov    %ecx,%edx
80102a3e:	ec                   	in     (%dx),%al
80102a3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a42:	89 da                	mov    %ebx,%edx
80102a44:	b8 08 00 00 00       	mov    $0x8,%eax
80102a49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4a:	89 ca                	mov    %ecx,%edx
80102a4c:	ec                   	in     (%dx),%al
80102a4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4f:	89 da                	mov    %ebx,%edx
80102a51:	b8 09 00 00 00       	mov    $0x9,%eax
80102a56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a57:	89 ca                	mov    %ecx,%edx
80102a59:	ec                   	in     (%dx),%al
80102a5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5c:	89 da                	mov    %ebx,%edx
80102a5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a67:	84 c0                	test   %al,%al
80102a69:	78 9d                	js     80102a08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a6f:	89 fa                	mov    %edi,%edx
80102a71:	0f b6 fa             	movzbl %dl,%edi
80102a74:	89 f2                	mov    %esi,%edx
80102a76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a7d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a80:	89 da                	mov    %ebx,%edx
80102a82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a99:	31 c0                	xor    %eax,%eax
80102a9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	89 ca                	mov    %ecx,%edx
80102a9e:	ec                   	in     (%dx),%al
80102a9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa2:	89 da                	mov    %ebx,%edx
80102aa4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102aa7:	b8 02 00 00 00       	mov    $0x2,%eax
80102aac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aad:	89 ca                	mov    %ecx,%edx
80102aaf:	ec                   	in     (%dx),%al
80102ab0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab3:	89 da                	mov    %ebx,%edx
80102ab5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ab8:	b8 04 00 00 00       	mov    $0x4,%eax
80102abd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abe:	89 ca                	mov    %ecx,%edx
80102ac0:	ec                   	in     (%dx),%al
80102ac1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac4:	89 da                	mov    %ebx,%edx
80102ac6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ac9:	b8 07 00 00 00       	mov    $0x7,%eax
80102ace:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acf:	89 ca                	mov    %ecx,%edx
80102ad1:	ec                   	in     (%dx),%al
80102ad2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad5:	89 da                	mov    %ebx,%edx
80102ad7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ada:	b8 08 00 00 00       	mov    $0x8,%eax
80102adf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae0:	89 ca                	mov    %ecx,%edx
80102ae2:	ec                   	in     (%dx),%al
80102ae3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae6:	89 da                	mov    %ebx,%edx
80102ae8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aeb:	b8 09 00 00 00       	mov    $0x9,%eax
80102af0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af1:	89 ca                	mov    %ecx,%edx
80102af3:	ec                   	in     (%dx),%al
80102af4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102af7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102afa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102afd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b00:	6a 18                	push   $0x18
80102b02:	50                   	push   %eax
80102b03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b06:	50                   	push   %eax
80102b07:	e8 f4 1c 00 00       	call   80104800 <memcmp>
80102b0c:	83 c4 10             	add    $0x10,%esp
80102b0f:	85 c0                	test   %eax,%eax
80102b11:	0f 85 f1 fe ff ff    	jne    80102a08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b1b:	75 78                	jne    80102b95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b20:	89 c2                	mov    %eax,%edx
80102b22:	83 e0 0f             	and    $0xf,%eax
80102b25:	c1 ea 04             	shr    $0x4,%edx
80102b28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b34:	89 c2                	mov    %eax,%edx
80102b36:	83 e0 0f             	and    $0xf,%eax
80102b39:	c1 ea 04             	shr    $0x4,%edx
80102b3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b48:	89 c2                	mov    %eax,%edx
80102b4a:	83 e0 0f             	and    $0xf,%eax
80102b4d:	c1 ea 04             	shr    $0x4,%edx
80102b50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b5c:	89 c2                	mov    %eax,%edx
80102b5e:	83 e0 0f             	and    $0xf,%eax
80102b61:	c1 ea 04             	shr    $0x4,%edx
80102b64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b70:	89 c2                	mov    %eax,%edx
80102b72:	83 e0 0f             	and    $0xf,%eax
80102b75:	c1 ea 04             	shr    $0x4,%edx
80102b78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b84:	89 c2                	mov    %eax,%edx
80102b86:	83 e0 0f             	and    $0xf,%eax
80102b89:	c1 ea 04             	shr    $0x4,%edx
80102b8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b95:	8b 75 08             	mov    0x8(%ebp),%esi
80102b98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b9b:	89 06                	mov    %eax,(%esi)
80102b9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ba0:	89 46 04             	mov    %eax,0x4(%esi)
80102ba3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ba6:	89 46 08             	mov    %eax,0x8(%esi)
80102ba9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bac:	89 46 0c             	mov    %eax,0xc(%esi)
80102baf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb2:	89 46 10             	mov    %eax,0x10(%esi)
80102bb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bc5:	5b                   	pop    %ebx
80102bc6:	5e                   	pop    %esi
80102bc7:	5f                   	pop    %edi
80102bc8:	5d                   	pop    %ebp
80102bc9:	c3                   	ret    
80102bca:	66 90                	xchg   %ax,%ax
80102bcc:	66 90                	xchg   %ax,%ax
80102bce:	66 90                	xchg   %ax,%ax

80102bd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bd0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102bd6:	85 c9                	test   %ecx,%ecx
80102bd8:	0f 8e 8a 00 00 00    	jle    80102c68 <install_trans+0x98>
{
80102bde:	55                   	push   %ebp
80102bdf:	89 e5                	mov    %esp,%ebp
80102be1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102be2:	31 ff                	xor    %edi,%edi
{
80102be4:	56                   	push   %esi
80102be5:	53                   	push   %ebx
80102be6:	83 ec 0c             	sub    $0xc,%esp
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bf0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102bf5:	83 ec 08             	sub    $0x8,%esp
80102bf8:	01 f8                	add    %edi,%eax
80102bfa:	83 c0 01             	add    $0x1,%eax
80102bfd:	50                   	push   %eax
80102bfe:	ff 35 e4 16 11 80    	push   0x801116e4
80102c04:	e8 c7 d4 ff ff       	call   801000d0 <bread>
80102c09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0b:	58                   	pop    %eax
80102c0c:	5a                   	pop    %edx
80102c0d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102c14:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1d:	e8 ae d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2a:	68 00 02 00 00       	push   $0x200
80102c2f:	50                   	push   %eax
80102c30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c33:	50                   	push   %eax
80102c34:	e8 17 1c 00 00       	call   80104850 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 6f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c41:	89 34 24             	mov    %esi,(%esp)
80102c44:	e8 a7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 9f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c51:	83 c4 10             	add    $0x10,%esp
80102c54:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102c5a:	7f 94                	jg     80102bf0 <install_trans+0x20>
  }
}
80102c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c5f:	5b                   	pop    %ebx
80102c60:	5e                   	pop    %esi
80102c61:	5f                   	pop    %edi
80102c62:	5d                   	pop    %ebp
80102c63:	c3                   	ret    
80102c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c68:	c3                   	ret    
80102c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	53                   	push   %ebx
80102c74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c77:	ff 35 d4 16 11 80    	push   0x801116d4
80102c7d:	ff 35 e4 16 11 80    	push   0x801116e4
80102c83:	e8 48 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c8d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102c92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c95:	85 c0                	test   %eax,%eax
80102c97:	7e 19                	jle    80102cb2 <write_head+0x42>
80102c99:	31 d2                	xor    %edx,%edx
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102ca0:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102ca7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cab:	83 c2 01             	add    $0x1,%edx
80102cae:	39 d0                	cmp    %edx,%eax
80102cb0:	75 ee                	jne    80102ca0 <write_head+0x30>
  }
  bwrite(buf);
80102cb2:	83 ec 0c             	sub    $0xc,%esp
80102cb5:	53                   	push   %ebx
80102cb6:	e8 f5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cbb:	89 1c 24             	mov    %ebx,(%esp)
80102cbe:	e8 2d d5 ff ff       	call   801001f0 <brelse>
}
80102cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cc6:	83 c4 10             	add    $0x10,%esp
80102cc9:	c9                   	leave  
80102cca:	c3                   	ret    
80102ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ccf:	90                   	nop

80102cd0 <initlog>:
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 2c             	sub    $0x2c,%esp
80102cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cda:	68 80 79 10 80       	push   $0x80107980
80102cdf:	68 a0 16 11 80       	push   $0x801116a0
80102ce4:	e8 37 18 00 00       	call   80104520 <initlock>
  readsb(dev, &sb);
80102ce9:	58                   	pop    %eax
80102cea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ced:	5a                   	pop    %edx
80102cee:	50                   	push   %eax
80102cef:	53                   	push   %ebx
80102cf0:	e8 3b e8 ff ff       	call   80101530 <readsb>
  log.start = sb.logstart;
80102cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cf8:	59                   	pop    %ecx
  log.dev = dev;
80102cf9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102cff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d02:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102d07:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102d0d:	5a                   	pop    %edx
80102d0e:	50                   	push   %eax
80102d0f:	53                   	push   %ebx
80102d10:	e8 bb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d18:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d1b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102d21:	85 db                	test   %ebx,%ebx
80102d23:	7e 1d                	jle    80102d42 <initlog+0x72>
80102d25:	31 d2                	xor    %edx,%edx
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d30:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d34:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d3b:	83 c2 01             	add    $0x1,%edx
80102d3e:	39 d3                	cmp    %edx,%ebx
80102d40:	75 ee                	jne    80102d30 <initlog+0x60>
  brelse(buf);
80102d42:	83 ec 0c             	sub    $0xc,%esp
80102d45:	50                   	push   %eax
80102d46:	e8 a5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d4b:	e8 80 fe ff ff       	call   80102bd0 <install_trans>
  log.lh.n = 0;
80102d50:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102d57:	00 00 00 
  write_head(); // clear the log
80102d5a:	e8 11 ff ff ff       	call   80102c70 <write_head>
}
80102d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d62:	83 c4 10             	add    $0x10,%esp
80102d65:	c9                   	leave  
80102d66:	c3                   	ret    
80102d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d76:	68 a0 16 11 80       	push   $0x801116a0
80102d7b:	e8 70 19 00 00       	call   801046f0 <acquire>
80102d80:	83 c4 10             	add    $0x10,%esp
80102d83:	eb 18                	jmp    80102d9d <begin_op+0x2d>
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d88:	83 ec 08             	sub    $0x8,%esp
80102d8b:	68 a0 16 11 80       	push   $0x801116a0
80102d90:	68 a0 16 11 80       	push   $0x801116a0
80102d95:	e8 56 13 00 00       	call   801040f0 <sleep>
80102d9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d9d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102da2:	85 c0                	test   %eax,%eax
80102da4:	75 e2                	jne    80102d88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102da6:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102dab:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102db1:	83 c0 01             	add    $0x1,%eax
80102db4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102db7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dba:	83 fa 1e             	cmp    $0x1e,%edx
80102dbd:	7f c9                	jg     80102d88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dc2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102dc7:	68 a0 16 11 80       	push   $0x801116a0
80102dcc:	e8 bf 18 00 00       	call   80104690 <release>
      break;
    }
  }
}
80102dd1:	83 c4 10             	add    $0x10,%esp
80102dd4:	c9                   	leave  
80102dd5:	c3                   	ret    
80102dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi

80102de0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	57                   	push   %edi
80102de4:	56                   	push   %esi
80102de5:	53                   	push   %ebx
80102de6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102de9:	68 a0 16 11 80       	push   $0x801116a0
80102dee:	e8 fd 18 00 00       	call   801046f0 <acquire>
  log.outstanding -= 1;
80102df3:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102df8:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102dfe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e04:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102e0a:	85 f6                	test   %esi,%esi
80102e0c:	0f 85 22 01 00 00    	jne    80102f34 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e12:	85 db                	test   %ebx,%ebx
80102e14:	0f 85 f6 00 00 00    	jne    80102f10 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e1a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102e21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e24:	83 ec 0c             	sub    $0xc,%esp
80102e27:	68 a0 16 11 80       	push   $0x801116a0
80102e2c:	e8 5f 18 00 00       	call   80104690 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e31:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e37:	83 c4 10             	add    $0x10,%esp
80102e3a:	85 c9                	test   %ecx,%ecx
80102e3c:	7f 42                	jg     80102e80 <end_op+0xa0>
    acquire(&log.lock);
80102e3e:	83 ec 0c             	sub    $0xc,%esp
80102e41:	68 a0 16 11 80       	push   $0x801116a0
80102e46:	e8 a5 18 00 00       	call   801046f0 <acquire>
    wakeup(&log);
80102e4b:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
    log.committing = 0;
80102e52:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102e59:	00 00 00 
    wakeup(&log);
80102e5c:	e8 4f 13 00 00       	call   801041b0 <wakeup>
    release(&log.lock);
80102e61:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e68:	e8 23 18 00 00       	call   80104690 <release>
80102e6d:	83 c4 10             	add    $0x10,%esp
}
80102e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e73:	5b                   	pop    %ebx
80102e74:	5e                   	pop    %esi
80102e75:	5f                   	pop    %edi
80102e76:	5d                   	pop    %ebp
80102e77:	c3                   	ret    
80102e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e80:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102e85:	83 ec 08             	sub    $0x8,%esp
80102e88:	01 d8                	add    %ebx,%eax
80102e8a:	83 c0 01             	add    $0x1,%eax
80102e8d:	50                   	push   %eax
80102e8e:	ff 35 e4 16 11 80    	push   0x801116e4
80102e94:	e8 37 d2 ff ff       	call   801000d0 <bread>
80102e99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9b:	58                   	pop    %eax
80102e9c:	5a                   	pop    %edx
80102e9d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102ea4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eaa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ead:	e8 1e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102eb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102eb7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eba:	68 00 02 00 00       	push   $0x200
80102ebf:	50                   	push   %eax
80102ec0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ec3:	50                   	push   %eax
80102ec4:	e8 87 19 00 00       	call   80104850 <memmove>
    bwrite(to);  // write the log
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 df d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ed1:	89 3c 24             	mov    %edi,(%esp)
80102ed4:	e8 17 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 0f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ee1:	83 c4 10             	add    $0x10,%esp
80102ee4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102eea:	7c 94                	jl     80102e80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eec:	e8 7f fd ff ff       	call   80102c70 <write_head>
    install_trans(); // Now install writes to home locations
80102ef1:	e8 da fc ff ff       	call   80102bd0 <install_trans>
    log.lh.n = 0;
80102ef6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102efd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f00:	e8 6b fd ff ff       	call   80102c70 <write_head>
80102f05:	e9 34 ff ff ff       	jmp    80102e3e <end_op+0x5e>
80102f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f10:	83 ec 0c             	sub    $0xc,%esp
80102f13:	68 a0 16 11 80       	push   $0x801116a0
80102f18:	e8 93 12 00 00       	call   801041b0 <wakeup>
  release(&log.lock);
80102f1d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f24:	e8 67 17 00 00       	call   80104690 <release>
80102f29:	83 c4 10             	add    $0x10,%esp
}
80102f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f2f:	5b                   	pop    %ebx
80102f30:	5e                   	pop    %esi
80102f31:	5f                   	pop    %edi
80102f32:	5d                   	pop    %ebp
80102f33:	c3                   	ret    
    panic("log.committing");
80102f34:	83 ec 0c             	sub    $0xc,%esp
80102f37:	68 84 79 10 80       	push   $0x80107984
80102f3c:	e8 3f d4 ff ff       	call   80100380 <panic>
80102f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f4f:	90                   	nop

80102f50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	53                   	push   %ebx
80102f54:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f57:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102f5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f60:	83 fa 1d             	cmp    $0x1d,%edx
80102f63:	0f 8f 85 00 00 00    	jg     80102fee <log_write+0x9e>
80102f69:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102f6e:	83 e8 01             	sub    $0x1,%eax
80102f71:	39 c2                	cmp    %eax,%edx
80102f73:	7d 79                	jge    80102fee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f75:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f7a:	85 c0                	test   %eax,%eax
80102f7c:	7e 7d                	jle    80102ffb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f7e:	83 ec 0c             	sub    $0xc,%esp
80102f81:	68 a0 16 11 80       	push   $0x801116a0
80102f86:	e8 65 17 00 00       	call   801046f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	85 d2                	test   %edx,%edx
80102f96:	7e 4a                	jle    80102fe2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f98:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f9b:	31 c0                	xor    %eax,%eax
80102f9d:	eb 08                	jmp    80102fa7 <log_write+0x57>
80102f9f:	90                   	nop
80102fa0:	83 c0 01             	add    $0x1,%eax
80102fa3:	39 c2                	cmp    %eax,%edx
80102fa5:	74 29                	je     80102fd0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa7:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102fae:	75 f0                	jne    80102fa0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fb7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fbd:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102fc4:	c9                   	leave  
  release(&log.lock);
80102fc5:	e9 c6 16 00 00       	jmp    80104690 <release>
80102fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102fd7:	83 c2 01             	add    $0x1,%edx
80102fda:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102fe0:	eb d5                	jmp    80102fb7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fe2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fe5:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
80102fea:	75 cb                	jne    80102fb7 <log_write+0x67>
80102fec:	eb e9                	jmp    80102fd7 <log_write+0x87>
    panic("too big a transaction");
80102fee:	83 ec 0c             	sub    $0xc,%esp
80102ff1:	68 93 79 10 80       	push   $0x80107993
80102ff6:	e8 85 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102ffb:	83 ec 0c             	sub    $0xc,%esp
80102ffe:	68 a9 79 10 80       	push   $0x801079a9
80103003:	e8 78 d3 ff ff       	call   80100380 <panic>
80103008:	66 90                	xchg   %ax,%ax
8010300a:	66 90                	xchg   %ax,%ax
8010300c:	66 90                	xchg   %ax,%ax
8010300e:	66 90                	xchg   %ax,%ax

80103010 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103017:	e8 64 09 00 00       	call   80103980 <cpuid>
8010301c:	89 c3                	mov    %eax,%ebx
8010301e:	e8 5d 09 00 00       	call   80103980 <cpuid>
80103023:	83 ec 04             	sub    $0x4,%esp
80103026:	53                   	push   %ebx
80103027:	50                   	push   %eax
80103028:	68 c4 79 10 80       	push   $0x801079c4
8010302d:	e8 6e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103032:	e8 39 2a 00 00       	call   80105a70 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103037:	e8 e4 08 00 00       	call   80103920 <mycpu>
8010303c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010303e:	b8 01 00 00 00       	mov    $0x1,%eax
80103043:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010304a:	e8 11 0c 00 00       	call   80103c60 <scheduler>
8010304f:	90                   	nop

80103050 <mpenter>:
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103056:	e8 05 3b 00 00       	call   80106b60 <switchkvm>
  seginit();
8010305b:	e8 70 3a 00 00       	call   80106ad0 <seginit>
  lapicinit();
80103060:	e8 9b f7 ff ff       	call   80102800 <lapicinit>
  mpmain();
80103065:	e8 a6 ff ff ff       	call   80103010 <mpmain>
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <main>:
{
80103070:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103074:	83 e4 f0             	and    $0xfffffff0,%esp
80103077:	ff 71 fc             	push   -0x4(%ecx)
8010307a:	55                   	push   %ebp
8010307b:	89 e5                	mov    %esp,%ebp
8010307d:	53                   	push   %ebx
8010307e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010307f:	83 ec 08             	sub    $0x8,%esp
80103082:	68 00 00 40 80       	push   $0x80400000
80103087:	68 d0 56 11 80       	push   $0x801156d0
8010308c:	e8 8f f5 ff ff       	call   80102620 <kinit1>
  kvmalloc();      // kernel page table
80103091:	e8 ba 3f 00 00       	call   80107050 <kvmalloc>
  mpinit();        // detect other processors
80103096:	e8 85 01 00 00       	call   80103220 <mpinit>
  lapicinit();     // interrupt controller
8010309b:	e8 60 f7 ff ff       	call   80102800 <lapicinit>
  seginit();       // segment descriptors
801030a0:	e8 2b 3a 00 00       	call   80106ad0 <seginit>
  picinit();       // disable pic
801030a5:	e8 76 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
801030aa:	e8 31 f3 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
801030af:	e8 ac d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030b4:	e8 a7 2c 00 00       	call   80105d60 <uartinit>
  pinit();         // process table
801030b9:	e8 42 08 00 00       	call   80103900 <pinit>
  tvinit();        // trap vectors
801030be:	e8 2d 29 00 00       	call   801059f0 <tvinit>
  binit();         // buffer cache
801030c3:	e8 78 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030c8:	e8 53 dd ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
801030cd:	e8 fe f0 ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030d2:	83 c4 0c             	add    $0xc,%esp
801030d5:	68 8a 00 00 00       	push   $0x8a
801030da:	68 8c a4 10 80       	push   $0x8010a48c
801030df:	68 00 70 00 80       	push   $0x80007000
801030e4:	e8 67 17 00 00       	call   80104850 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030e9:	83 c4 10             	add    $0x10,%esp
801030ec:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801030f3:	00 00 00 
801030f6:	05 a0 17 11 80       	add    $0x801117a0,%eax
801030fb:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103100:	76 7e                	jbe    80103180 <main+0x110>
80103102:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103107:	eb 20                	jmp    80103129 <main+0xb9>
80103109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103110:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103117:	00 00 00 
8010311a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103120:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103125:	39 c3                	cmp    %eax,%ebx
80103127:	73 57                	jae    80103180 <main+0x110>
    if(c == mycpu())  // We've started already.
80103129:	e8 f2 07 00 00       	call   80103920 <mycpu>
8010312e:	39 c3                	cmp    %eax,%ebx
80103130:	74 de                	je     80103110 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103132:	e8 59 f5 ff ff       	call   80102690 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103137:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010313a:	c7 05 f8 6f 00 80 50 	movl   $0x80103050,0x80006ff8
80103141:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103144:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010314b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010314e:	05 00 10 00 00       	add    $0x1000,%eax
80103153:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103158:	0f b6 03             	movzbl (%ebx),%eax
8010315b:	68 00 70 00 00       	push   $0x7000
80103160:	50                   	push   %eax
80103161:	e8 ea f7 ff ff       	call   80102950 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103166:	83 c4 10             	add    $0x10,%esp
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103170:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103176:	85 c0                	test   %eax,%eax
80103178:	74 f6                	je     80103170 <main+0x100>
8010317a:	eb 94                	jmp    80103110 <main+0xa0>
8010317c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103180:	83 ec 08             	sub    $0x8,%esp
80103183:	68 00 00 00 8e       	push   $0x8e000000
80103188:	68 00 00 40 80       	push   $0x80400000
8010318d:	e8 2e f4 ff ff       	call   801025c0 <kinit2>
  userinit();      // first user process
80103192:	e8 39 08 00 00       	call   801039d0 <userinit>
  mpmain();        // finish this processor's setup
80103197:	e8 74 fe ff ff       	call   80103010 <mpmain>
8010319c:	66 90                	xchg   %ax,%ax
8010319e:	66 90                	xchg   %ax,%ax

801031a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031ab:	53                   	push   %ebx
  e = addr+len;
801031ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031b2:	39 de                	cmp    %ebx,%esi
801031b4:	72 10                	jb     801031c6 <mpsearch1+0x26>
801031b6:	eb 50                	jmp    80103208 <mpsearch1+0x68>
801031b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031bf:	90                   	nop
801031c0:	89 fe                	mov    %edi,%esi
801031c2:	39 fb                	cmp    %edi,%ebx
801031c4:	76 42                	jbe    80103208 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c6:	83 ec 04             	sub    $0x4,%esp
801031c9:	8d 7e 10             	lea    0x10(%esi),%edi
801031cc:	6a 04                	push   $0x4
801031ce:	68 d8 79 10 80       	push   $0x801079d8
801031d3:	56                   	push   %esi
801031d4:	e8 27 16 00 00       	call   80104800 <memcmp>
801031d9:	83 c4 10             	add    $0x10,%esp
801031dc:	85 c0                	test   %eax,%eax
801031de:	75 e0                	jne    801031c0 <mpsearch1+0x20>
801031e0:	89 f2                	mov    %esi,%edx
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031f0:	39 fa                	cmp    %edi,%edx
801031f2:	75 f4                	jne    801031e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f4:	84 c0                	test   %al,%al
801031f6:	75 c8                	jne    801031c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031fb:	89 f0                	mov    %esi,%eax
801031fd:	5b                   	pop    %ebx
801031fe:	5e                   	pop    %esi
801031ff:	5f                   	pop    %edi
80103200:	5d                   	pop    %ebp
80103201:	c3                   	ret    
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010320b:	31 f6                	xor    %esi,%esi
}
8010320d:	5b                   	pop    %ebx
8010320e:	89 f0                	mov    %esi,%eax
80103210:	5e                   	pop    %esi
80103211:	5f                   	pop    %edi
80103212:	5d                   	pop    %ebp
80103213:	c3                   	ret    
80103214:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010321f:	90                   	nop

80103220 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	57                   	push   %edi
80103224:	56                   	push   %esi
80103225:	53                   	push   %ebx
80103226:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103229:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103230:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103237:	c1 e0 08             	shl    $0x8,%eax
8010323a:	09 d0                	or     %edx,%eax
8010323c:	c1 e0 04             	shl    $0x4,%eax
8010323f:	75 1b                	jne    8010325c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103241:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103248:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010324f:	c1 e0 08             	shl    $0x8,%eax
80103252:	09 d0                	or     %edx,%eax
80103254:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103257:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010325c:	ba 00 04 00 00       	mov    $0x400,%edx
80103261:	e8 3a ff ff ff       	call   801031a0 <mpsearch1>
80103266:	89 c3                	mov    %eax,%ebx
80103268:	85 c0                	test   %eax,%eax
8010326a:	0f 84 40 01 00 00    	je     801033b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103270:	8b 73 04             	mov    0x4(%ebx),%esi
80103273:	85 f6                	test   %esi,%esi
80103275:	0f 84 25 01 00 00    	je     801033a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010327b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103284:	6a 04                	push   $0x4
80103286:	68 dd 79 10 80       	push   $0x801079dd
8010328b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010328f:	e8 6c 15 00 00       	call   80104800 <memcmp>
80103294:	83 c4 10             	add    $0x10,%esp
80103297:	85 c0                	test   %eax,%eax
80103299:	0f 85 01 01 00 00    	jne    801033a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010329f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032a6:	3c 01                	cmp    $0x1,%al
801032a8:	74 08                	je     801032b2 <mpinit+0x92>
801032aa:	3c 04                	cmp    $0x4,%al
801032ac:	0f 85 ee 00 00 00    	jne    801033a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032b9:	66 85 d2             	test   %dx,%dx
801032bc:	74 22                	je     801032e0 <mpinit+0xc0>
801032be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032c3:	31 d2                	xor    %edx,%edx
801032c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032d4:	39 c7                	cmp    %eax,%edi
801032d6:	75 f0                	jne    801032c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032d8:	84 d2                	test   %dl,%dl
801032da:	0f 85 c0 00 00 00    	jne    801033a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032e6:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103300:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103307:	90                   	nop
80103308:	39 d0                	cmp    %edx,%eax
8010330a:	73 15                	jae    80103321 <mpinit+0x101>
    switch(*p){
8010330c:	0f b6 08             	movzbl (%eax),%ecx
8010330f:	80 f9 02             	cmp    $0x2,%cl
80103312:	74 4c                	je     80103360 <mpinit+0x140>
80103314:	77 3a                	ja     80103350 <mpinit+0x130>
80103316:	84 c9                	test   %cl,%cl
80103318:	74 56                	je     80103370 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010331a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010331d:	39 d0                	cmp    %edx,%eax
8010331f:	72 eb                	jb     8010330c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103321:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103324:	85 f6                	test   %esi,%esi
80103326:	0f 84 d9 00 00 00    	je     80103405 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010332c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103330:	74 15                	je     80103347 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103332:	b8 70 00 00 00       	mov    $0x70,%eax
80103337:	ba 22 00 00 00       	mov    $0x22,%edx
8010333c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010333d:	ba 23 00 00 00       	mov    $0x23,%edx
80103342:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103343:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103346:	ee                   	out    %al,(%dx)
  }
}
80103347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010334a:	5b                   	pop    %ebx
8010334b:	5e                   	pop    %esi
8010334c:	5f                   	pop    %edi
8010334d:	5d                   	pop    %ebp
8010334e:	c3                   	ret    
8010334f:	90                   	nop
    switch(*p){
80103350:	83 e9 03             	sub    $0x3,%ecx
80103353:	80 f9 01             	cmp    $0x1,%cl
80103356:	76 c2                	jbe    8010331a <mpinit+0xfa>
80103358:	31 f6                	xor    %esi,%esi
8010335a:	eb ac                	jmp    80103308 <mpinit+0xe8>
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103360:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103364:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103367:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010336d:	eb 99                	jmp    80103308 <mpinit+0xe8>
8010336f:	90                   	nop
      if(ncpu < NCPU) {
80103370:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 6c ff ff ff       	jmp    80103308 <mpinit+0xe8>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033a0:	83 ec 0c             	sub    $0xc,%esp
801033a3:	68 e2 79 10 80       	push   $0x801079e2
801033a8:	e8 d3 cf ff ff       	call   80100380 <panic>
801033ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801033b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033b5:	eb 13                	jmp    801033ca <mpinit+0x1aa>
801033b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033c0:	89 f3                	mov    %esi,%ebx
801033c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033c8:	74 d6                	je     801033a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ca:	83 ec 04             	sub    $0x4,%esp
801033cd:	8d 73 10             	lea    0x10(%ebx),%esi
801033d0:	6a 04                	push   $0x4
801033d2:	68 d8 79 10 80       	push   $0x801079d8
801033d7:	53                   	push   %ebx
801033d8:	e8 23 14 00 00       	call   80104800 <memcmp>
801033dd:	83 c4 10             	add    $0x10,%esp
801033e0:	85 c0                	test   %eax,%eax
801033e2:	75 dc                	jne    801033c0 <mpinit+0x1a0>
801033e4:	89 da                	mov    %ebx,%edx
801033e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033f8:	39 d6                	cmp    %edx,%esi
801033fa:	75 f4                	jne    801033f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033fc:	84 c0                	test   %al,%al
801033fe:	75 c0                	jne    801033c0 <mpinit+0x1a0>
80103400:	e9 6b fe ff ff       	jmp    80103270 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103405:	83 ec 0c             	sub    $0xc,%esp
80103408:	68 fc 79 10 80       	push   $0x801079fc
8010340d:	e8 6e cf ff ff       	call   80100380 <panic>
80103412:	66 90                	xchg   %ax,%ax
80103414:	66 90                	xchg   %ax,%ax
80103416:	66 90                	xchg   %ax,%ax
80103418:	66 90                	xchg   %ax,%ax
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <picinit>:
80103420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103425:	ba 21 00 00 00       	mov    $0x21,%edx
8010342a:	ee                   	out    %al,(%dx)
8010342b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103430:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103431:	c3                   	ret    
80103432:	66 90                	xchg   %ax,%ax
80103434:	66 90                	xchg   %ax,%ax
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010344c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010344f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103455:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345b:	e8 e0 d9 ff ff       	call   80100e40 <filealloc>
80103460:	89 03                	mov    %eax,(%ebx)
80103462:	85 c0                	test   %eax,%eax
80103464:	0f 84 a8 00 00 00    	je     80103512 <pipealloc+0xd2>
8010346a:	e8 d1 d9 ff ff       	call   80100e40 <filealloc>
8010346f:	89 06                	mov    %eax,(%esi)
80103471:	85 c0                	test   %eax,%eax
80103473:	0f 84 87 00 00 00    	je     80103500 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103479:	e8 12 f2 ff ff       	call   80102690 <kalloc>
8010347e:	89 c7                	mov    %eax,%edi
80103480:	85 c0                	test   %eax,%eax
80103482:	0f 84 b0 00 00 00    	je     80103538 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103488:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010348f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103492:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103495:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010349c:	00 00 00 
  p->nwrite = 0;
8010349f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034a6:	00 00 00 
  p->nread = 0;
801034a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b0:	00 00 00 
  initlock(&p->lock, "pipe");
801034b3:	68 1b 7a 10 80       	push   $0x80107a1b
801034b8:	50                   	push   %eax
801034b9:	e8 62 10 00 00       	call   80104520 <initlock>
  (*f0)->type = FD_PIPE;
801034be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034c9:	8b 03                	mov    (%ebx),%eax
801034cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034cf:	8b 03                	mov    (%ebx),%eax
801034d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d5:	8b 03                	mov    (%ebx),%eax
801034d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e2:	8b 06                	mov    (%esi),%eax
801034e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034e8:	8b 06                	mov    (%esi),%eax
801034ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ee:	8b 06                	mov    (%esi),%eax
801034f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034f6:	31 c0                	xor    %eax,%eax
}
801034f8:	5b                   	pop    %ebx
801034f9:	5e                   	pop    %esi
801034fa:	5f                   	pop    %edi
801034fb:	5d                   	pop    %ebp
801034fc:	c3                   	ret    
801034fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	74 1e                	je     80103524 <pipealloc+0xe4>
    fileclose(*f0);
80103506:	83 ec 0c             	sub    $0xc,%esp
80103509:	50                   	push   %eax
8010350a:	e8 f1 d9 ff ff       	call   80100f00 <fileclose>
8010350f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103512:	8b 06                	mov    (%esi),%eax
80103514:	85 c0                	test   %eax,%eax
80103516:	74 0c                	je     80103524 <pipealloc+0xe4>
    fileclose(*f1);
80103518:	83 ec 0c             	sub    $0xc,%esp
8010351b:	50                   	push   %eax
8010351c:	e8 df d9 ff ff       	call   80100f00 <fileclose>
80103521:	83 c4 10             	add    $0x10,%esp
}
80103524:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010352c:	5b                   	pop    %ebx
8010352d:	5e                   	pop    %esi
8010352e:	5f                   	pop    %edi
8010352f:	5d                   	pop    %ebp
80103530:	c3                   	ret    
80103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103538:	8b 03                	mov    (%ebx),%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	75 c8                	jne    80103506 <pipealloc+0xc6>
8010353e:	eb d2                	jmp    80103512 <pipealloc+0xd2>

80103540 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103548:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	53                   	push   %ebx
8010354f:	e8 9c 11 00 00       	call   801046f0 <acquire>
  if(writable){
80103554:	83 c4 10             	add    $0x10,%esp
80103557:	85 f6                	test   %esi,%esi
80103559:	74 65                	je     801035c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103564:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010356b:	00 00 00 
    wakeup(&p->nread);
8010356e:	50                   	push   %eax
8010356f:	e8 3c 0c 00 00       	call   801041b0 <wakeup>
80103574:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103577:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010357d:	85 d2                	test   %edx,%edx
8010357f:	75 0a                	jne    8010358b <pipeclose+0x4b>
80103581:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103587:	85 c0                	test   %eax,%eax
80103589:	74 15                	je     801035a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010358b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010358e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103591:	5b                   	pop    %ebx
80103592:	5e                   	pop    %esi
80103593:	5d                   	pop    %ebp
    release(&p->lock);
80103594:	e9 f7 10 00 00       	jmp    80104690 <release>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	53                   	push   %ebx
801035a4:	e8 e7 10 00 00       	call   80104690 <release>
    kfree((char*)p);
801035a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ac:	83 c4 10             	add    $0x10,%esp
}
801035af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b2:	5b                   	pop    %ebx
801035b3:	5e                   	pop    %esi
801035b4:	5d                   	pop    %ebp
    kfree((char*)p);
801035b5:	e9 16 ef ff ff       	jmp    801024d0 <kfree>
801035ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035d0:	00 00 00 
    wakeup(&p->nwrite);
801035d3:	50                   	push   %eax
801035d4:	e8 d7 0b 00 00       	call   801041b0 <wakeup>
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	eb 99                	jmp    80103577 <pipeclose+0x37>
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 28             	sub    $0x28,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035ec:	53                   	push   %ebx
801035ed:	e8 fe 10 00 00       	call   801046f0 <acquire>
  for(i = 0; i < n; i++){
801035f2:	8b 45 10             	mov    0x10(%ebp),%eax
801035f5:	83 c4 10             	add    $0x10,%esp
801035f8:	85 c0                	test   %eax,%eax
801035fa:	0f 8e c0 00 00 00    	jle    801036c0 <pipewrite+0xe0>
80103600:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103603:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103609:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010360f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103612:	03 45 10             	add    0x10(%ebp),%eax
80103615:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103618:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103624:	89 ca                	mov    %ecx,%edx
80103626:	05 00 02 00 00       	add    $0x200,%eax
8010362b:	39 c1                	cmp    %eax,%ecx
8010362d:	74 3f                	je     8010366e <pipewrite+0x8e>
8010362f:	eb 67                	jmp    80103698 <pipewrite+0xb8>
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103638:	e8 63 03 00 00       	call   801039a0 <myproc>
8010363d:	8b 48 24             	mov    0x24(%eax),%ecx
80103640:	85 c9                	test   %ecx,%ecx
80103642:	75 34                	jne    80103678 <pipewrite+0x98>
      wakeup(&p->nread);
80103644:	83 ec 0c             	sub    $0xc,%esp
80103647:	57                   	push   %edi
80103648:	e8 63 0b 00 00       	call   801041b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010364d:	58                   	pop    %eax
8010364e:	5a                   	pop    %edx
8010364f:	53                   	push   %ebx
80103650:	56                   	push   %esi
80103651:	e8 9a 0a 00 00       	call   801040f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103656:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010365c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103662:	83 c4 10             	add    $0x10,%esp
80103665:	05 00 02 00 00       	add    $0x200,%eax
8010366a:	39 c2                	cmp    %eax,%edx
8010366c:	75 2a                	jne    80103698 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010366e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103674:	85 c0                	test   %eax,%eax
80103676:	75 c0                	jne    80103638 <pipewrite+0x58>
        release(&p->lock);
80103678:	83 ec 0c             	sub    $0xc,%esp
8010367b:	53                   	push   %ebx
8010367c:	e8 0f 10 00 00       	call   80104690 <release>
        return -1;
80103681:	83 c4 10             	add    $0x10,%esp
80103684:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103689:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010368c:	5b                   	pop    %ebx
8010368d:	5e                   	pop    %esi
8010368e:	5f                   	pop    %edi
8010368f:	5d                   	pop    %ebp
80103690:	c3                   	ret    
80103691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103698:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010369b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010369e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036a4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036aa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036ad:	83 c6 01             	add    $0x1,%esi
801036b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036b7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ba:	0f 85 58 ff ff ff    	jne    80103618 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036c9:	50                   	push   %eax
801036ca:	e8 e1 0a 00 00       	call   801041b0 <wakeup>
  release(&p->lock);
801036cf:	89 1c 24             	mov    %ebx,(%esp)
801036d2:	e8 b9 0f 00 00       	call   80104690 <release>
  return n;
801036d7:	8b 45 10             	mov    0x10(%ebp),%eax
801036da:	83 c4 10             	add    $0x10,%esp
801036dd:	eb aa                	jmp    80103689 <pipewrite+0xa9>
801036df:	90                   	nop

801036e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 18             	sub    $0x18,%esp
801036e9:	8b 75 08             	mov    0x8(%ebp),%esi
801036ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ef:	56                   	push   %esi
801036f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036f6:	e8 f5 0f 00 00       	call   801046f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103701:	83 c4 10             	add    $0x10,%esp
80103704:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010370a:	74 2f                	je     8010373b <piperead+0x5b>
8010370c:	eb 37                	jmp    80103745 <piperead+0x65>
8010370e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103710:	e8 8b 02 00 00       	call   801039a0 <myproc>
80103715:	8b 48 24             	mov    0x24(%eax),%ecx
80103718:	85 c9                	test   %ecx,%ecx
8010371a:	0f 85 80 00 00 00    	jne    801037a0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103720:	83 ec 08             	sub    $0x8,%esp
80103723:	56                   	push   %esi
80103724:	53                   	push   %ebx
80103725:	e8 c6 09 00 00       	call   801040f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010372a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103730:	83 c4 10             	add    $0x10,%esp
80103733:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103739:	75 0a                	jne    80103745 <piperead+0x65>
8010373b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103741:	85 c0                	test   %eax,%eax
80103743:	75 cb                	jne    80103710 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103745:	8b 55 10             	mov    0x10(%ebp),%edx
80103748:	31 db                	xor    %ebx,%ebx
8010374a:	85 d2                	test   %edx,%edx
8010374c:	7f 20                	jg     8010376e <piperead+0x8e>
8010374e:	eb 2c                	jmp    8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103750:	8d 48 01             	lea    0x1(%eax),%ecx
80103753:	25 ff 01 00 00       	and    $0x1ff,%eax
80103758:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010375e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103763:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103766:	83 c3 01             	add    $0x1,%ebx
80103769:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010376c:	74 0e                	je     8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010376e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103774:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010377a:	75 d4                	jne    80103750 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103785:	50                   	push   %eax
80103786:	e8 25 0a 00 00       	call   801041b0 <wakeup>
  release(&p->lock);
8010378b:	89 34 24             	mov    %esi,(%esp)
8010378e:	e8 fd 0e 00 00       	call   80104690 <release>
  return i;
80103793:	83 c4 10             	add    $0x10,%esp
}
80103796:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103799:	89 d8                	mov    %ebx,%eax
8010379b:	5b                   	pop    %ebx
8010379c:	5e                   	pop    %esi
8010379d:	5f                   	pop    %edi
8010379e:	5d                   	pop    %ebp
8010379f:	c3                   	ret    
      release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037a8:	56                   	push   %esi
801037a9:	e8 e2 0e 00 00       	call   80104690 <release>
      return -1;
801037ae:	83 c4 10             	add    $0x10,%esp
}
801037b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b4:	89 d8                	mov    %ebx,%eax
801037b6:	5b                   	pop    %ebx
801037b7:	5e                   	pop    %esi
801037b8:	5f                   	pop    %edi
801037b9:	5d                   	pop    %ebp
801037ba:	c3                   	ret    
801037bb:	66 90                	xchg   %ax,%ax
801037bd:	66 90                	xchg   %ax,%ax
801037bf:	90                   	nop

801037c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801037c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037cc:	68 20 1d 11 80       	push   $0x80111d20
801037d1:	e8 1a 0f 00 00       	call   801046f0 <acquire>
801037d6:	83 c4 10             	add    $0x10,%esp
801037d9:	eb 17                	jmp    801037f2 <allocproc+0x32>
801037db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037df:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e0:	81 c3 84 00 00 00    	add    $0x84,%ebx
801037e6:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
801037ec:	0f 84 8e 00 00 00    	je     80103880 <allocproc+0xc0>
    if(p->state == UNUSED)
801037f2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037f5:	85 c0                	test   %eax,%eax
801037f7:	75 e7                	jne    801037e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037f9:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->priority = 1;
  p->ticks = 0;

  release(&ptable.lock);
801037fe:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103801:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 1;
80103808:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  p->pid = nextpid++;
8010380f:	89 43 10             	mov    %eax,0x10(%ebx)
80103812:	8d 50 01             	lea    0x1(%eax),%edx
  p->ticks = 0;
80103815:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010381c:	00 00 00 
  release(&ptable.lock);
8010381f:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
80103824:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010382a:	e8 61 0e 00 00       	call   80104690 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010382f:	e8 5c ee ff ff       	call   80102690 <kalloc>
80103834:	83 c4 10             	add    $0x10,%esp
80103837:	89 43 08             	mov    %eax,0x8(%ebx)
8010383a:	85 c0                	test   %eax,%eax
8010383c:	74 5b                	je     80103899 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010383e:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103844:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103847:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010384c:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010384f:	c7 40 14 df 59 10 80 	movl   $0x801059df,0x14(%eax)
  p->context = (struct context*)sp;
80103856:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103859:	6a 14                	push   $0x14
8010385b:	6a 00                	push   $0x0
8010385d:	50                   	push   %eax
8010385e:	e8 4d 0f 00 00       	call   801047b0 <memset>
  p->context->eip = (uint)forkret;
80103863:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103866:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103869:	c7 40 10 b0 38 10 80 	movl   $0x801038b0,0x10(%eax)
}
80103870:	89 d8                	mov    %ebx,%eax
80103872:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103875:	c9                   	leave  
80103876:	c3                   	ret    
80103877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103883:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103885:	68 20 1d 11 80       	push   $0x80111d20
8010388a:	e8 01 0e 00 00       	call   80104690 <release>
}
8010388f:	89 d8                	mov    %ebx,%eax
  return 0;
80103891:	83 c4 10             	add    $0x10,%esp
}
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave  
80103898:	c3                   	ret    
    p->state = UNUSED;
80103899:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038a0:	31 db                	xor    %ebx,%ebx
}
801038a2:	89 d8                	mov    %ebx,%eax
801038a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a7:	c9                   	leave  
801038a8:	c3                   	ret    
801038a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038b6:	68 20 1d 11 80       	push   $0x80111d20
801038bb:	e8 d0 0d 00 00       	call   80104690 <release>

  if (first) {
801038c0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	85 c0                	test   %eax,%eax
801038ca:	75 04                	jne    801038d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038cc:	c9                   	leave  
801038cd:	c3                   	ret    
801038ce:	66 90                	xchg   %ax,%ax
    first = 0;
801038d0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038d7:	00 00 00 
    iinit(ROOTDEV);
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	6a 01                	push   $0x1
801038df:	e8 8c dc ff ff       	call   80101570 <iinit>
    initlog(ROOTDEV);
801038e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038eb:	e8 e0 f3 ff ff       	call   80102cd0 <initlog>
}
801038f0:	83 c4 10             	add    $0x10,%esp
801038f3:	c9                   	leave  
801038f4:	c3                   	ret    
801038f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103900 <pinit>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103906:	68 20 7a 10 80       	push   $0x80107a20
8010390b:	68 20 1d 11 80       	push   $0x80111d20
80103910:	e8 0b 0c 00 00       	call   80104520 <initlock>
}
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	c9                   	leave  
80103919:	c3                   	ret    
8010391a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103920 <mycpu>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	56                   	push   %esi
80103924:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103925:	9c                   	pushf  
80103926:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103927:	f6 c4 02             	test   $0x2,%ah
8010392a:	75 46                	jne    80103972 <mycpu+0x52>
  apicid = lapicid();
8010392c:	e8 cf ef ff ff       	call   80102900 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103931:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103937:	85 f6                	test   %esi,%esi
80103939:	7e 2a                	jle    80103965 <mycpu+0x45>
8010393b:	31 d2                	xor    %edx,%edx
8010393d:	eb 08                	jmp    80103947 <mycpu+0x27>
8010393f:	90                   	nop
80103940:	83 c2 01             	add    $0x1,%edx
80103943:	39 f2                	cmp    %esi,%edx
80103945:	74 1e                	je     80103965 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103947:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010394d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103954:	39 c3                	cmp    %eax,%ebx
80103956:	75 e8                	jne    80103940 <mycpu+0x20>
}
80103958:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010395b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103961:	5b                   	pop    %ebx
80103962:	5e                   	pop    %esi
80103963:	5d                   	pop    %ebp
80103964:	c3                   	ret    
  panic("unknown apicid\n");
80103965:	83 ec 0c             	sub    $0xc,%esp
80103968:	68 27 7a 10 80       	push   $0x80107a27
8010396d:	e8 0e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103972:	83 ec 0c             	sub    $0xc,%esp
80103975:	68 04 7b 10 80       	push   $0x80107b04
8010397a:	e8 01 ca ff ff       	call   80100380 <panic>
8010397f:	90                   	nop

80103980 <cpuid>:
cpuid() {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103986:	e8 95 ff ff ff       	call   80103920 <mycpu>
}
8010398b:	c9                   	leave  
  return mycpu()-cpus;
8010398c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103991:	c1 f8 04             	sar    $0x4,%eax
80103994:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010399a:	c3                   	ret    
8010399b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010399f:	90                   	nop

801039a0 <myproc>:
myproc(void) {
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
801039a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039a7:	e8 f4 0b 00 00       	call   801045a0 <pushcli>
  c = mycpu();
801039ac:	e8 6f ff ff ff       	call   80103920 <mycpu>
  p = c->proc;
801039b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039b7:	e8 34 0c 00 00       	call   801045f0 <popcli>
}
801039bc:	89 d8                	mov    %ebx,%eax
801039be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039c1:	c9                   	leave  
801039c2:	c3                   	ret    
801039c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039d0 <userinit>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
801039d4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039d7:	e8 e4 fd ff ff       	call   801037c0 <allocproc>
801039dc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039de:	a3 54 3e 11 80       	mov    %eax,0x80113e54
  if((p->pgdir = setupkvm()) == 0)
801039e3:	e8 e8 35 00 00       	call   80106fd0 <setupkvm>
801039e8:	89 43 04             	mov    %eax,0x4(%ebx)
801039eb:	85 c0                	test   %eax,%eax
801039ed:	0f 84 bd 00 00 00    	je     80103ab0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039f3:	83 ec 04             	sub    $0x4,%esp
801039f6:	68 2c 00 00 00       	push   $0x2c
801039fb:	68 60 a4 10 80       	push   $0x8010a460
80103a00:	50                   	push   %eax
80103a01:	e8 7a 32 00 00       	call   80106c80 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a06:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a09:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a0f:	6a 4c                	push   $0x4c
80103a11:	6a 00                	push   $0x0
80103a13:	ff 73 18             	push   0x18(%ebx)
80103a16:	e8 95 0d 00 00       	call   801047b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a1b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a23:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a26:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a2b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a32:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a3d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a41:	8b 43 18             	mov    0x18(%ebx),%eax
80103a44:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a48:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a4c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a4f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a56:	8b 43 18             	mov    0x18(%ebx),%eax
80103a59:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a60:	8b 43 18             	mov    0x18(%ebx),%eax
80103a63:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a6a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a6d:	6a 10                	push   $0x10
80103a6f:	68 50 7a 10 80       	push   $0x80107a50
80103a74:	50                   	push   %eax
80103a75:	e8 f6 0e 00 00       	call   80104970 <safestrcpy>
  p->cwd = namei("/");
80103a7a:	c7 04 24 59 7a 10 80 	movl   $0x80107a59,(%esp)
80103a81:	e8 2a e6 ff ff       	call   801020b0 <namei>
80103a86:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a89:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a90:	e8 5b 0c 00 00       	call   801046f0 <acquire>
  p->state = RUNNABLE;
80103a95:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a9c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103aa3:	e8 e8 0b 00 00       	call   80104690 <release>
}
80103aa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aab:	83 c4 10             	add    $0x10,%esp
80103aae:	c9                   	leave  
80103aaf:	c3                   	ret    
    panic("userinit: out of memory?");
80103ab0:	83 ec 0c             	sub    $0xc,%esp
80103ab3:	68 37 7a 10 80       	push   $0x80107a37
80103ab8:	e8 c3 c8 ff ff       	call   80100380 <panic>
80103abd:	8d 76 00             	lea    0x0(%esi),%esi

80103ac0 <growproc>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
80103ac5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ac8:	e8 d3 0a 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103acd:	e8 4e fe ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103ad2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad8:	e8 13 0b 00 00       	call   801045f0 <popcli>
  sz = curproc->sz;
80103add:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103adf:	85 f6                	test   %esi,%esi
80103ae1:	7f 1d                	jg     80103b00 <growproc+0x40>
  } else if(n < 0){
80103ae3:	75 3b                	jne    80103b20 <growproc+0x60>
  switchuvm(curproc);
80103ae5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ae8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aea:	53                   	push   %ebx
80103aeb:	e8 80 30 00 00       	call   80106b70 <switchuvm>
  return 0;
80103af0:	83 c4 10             	add    $0x10,%esp
80103af3:	31 c0                	xor    %eax,%eax
}
80103af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103af8:	5b                   	pop    %ebx
80103af9:	5e                   	pop    %esi
80103afa:	5d                   	pop    %ebp
80103afb:	c3                   	ret    
80103afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	push   0x4(%ebx)
80103b0a:	e8 e1 32 00 00       	call   80106df0 <allocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 cf                	jne    80103ae5 <growproc+0x25>
      return -1;
80103b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b1b:	eb d8                	jmp    80103af5 <growproc+0x35>
80103b1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b20:	83 ec 04             	sub    $0x4,%esp
80103b23:	01 c6                	add    %eax,%esi
80103b25:	56                   	push   %esi
80103b26:	50                   	push   %eax
80103b27:	ff 73 04             	push   0x4(%ebx)
80103b2a:	e8 f1 33 00 00       	call   80106f20 <deallocuvm>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	85 c0                	test   %eax,%eax
80103b34:	75 af                	jne    80103ae5 <growproc+0x25>
80103b36:	eb de                	jmp    80103b16 <growproc+0x56>
80103b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b3f:	90                   	nop

80103b40 <fork>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	57                   	push   %edi
80103b44:	56                   	push   %esi
80103b45:	53                   	push   %ebx
80103b46:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b49:	e8 52 0a 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103b4e:	e8 cd fd ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103b53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b59:	e8 92 0a 00 00       	call   801045f0 <popcli>
  if((np = allocproc()) == 0){
80103b5e:	e8 5d fc ff ff       	call   801037c0 <allocproc>
80103b63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b66:	85 c0                	test   %eax,%eax
80103b68:	0f 84 bf 00 00 00    	je     80103c2d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b6e:	83 ec 08             	sub    $0x8,%esp
80103b71:	ff 33                	push   (%ebx)
80103b73:	89 c7                	mov    %eax,%edi
80103b75:	ff 73 04             	push   0x4(%ebx)
80103b78:	e8 43 35 00 00       	call   801070c0 <copyuvm>
80103b7d:	83 c4 10             	add    $0x10,%esp
80103b80:	89 47 04             	mov    %eax,0x4(%edi)
80103b83:	85 c0                	test   %eax,%eax
80103b85:	0f 84 a9 00 00 00    	je     80103c34 <fork+0xf4>
  np->sz = curproc->sz;
80103b8b:	8b 03                	mov    (%ebx),%eax
80103b8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103b90:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103b95:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80103b97:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
80103b9a:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103b9d:	8b 73 18             	mov    0x18(%ebx),%esi
80103ba0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ba2:	31 f6                	xor    %esi,%esi
  np->priority = curproc->priority;
80103ba4:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103ba7:	89 42 7c             	mov    %eax,0x7c(%edx)
  np->tf->eax = 0;
80103baa:	8b 42 18             	mov    0x18(%edx),%eax
80103bad:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103bb8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bbc:	85 c0                	test   %eax,%eax
80103bbe:	74 13                	je     80103bd3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bc0:	83 ec 0c             	sub    $0xc,%esp
80103bc3:	50                   	push   %eax
80103bc4:	e8 e7 d2 ff ff       	call   80100eb0 <filedup>
80103bc9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bcc:	83 c4 10             	add    $0x10,%esp
80103bcf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bd3:	83 c6 01             	add    $0x1,%esi
80103bd6:	83 fe 10             	cmp    $0x10,%esi
80103bd9:	75 dd                	jne    80103bb8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103bdb:	83 ec 0c             	sub    $0xc,%esp
80103bde:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103be4:	e8 77 db ff ff       	call   80101760 <idup>
80103be9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bec:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bef:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bf2:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bf5:	6a 10                	push   $0x10
80103bf7:	53                   	push   %ebx
80103bf8:	50                   	push   %eax
80103bf9:	e8 72 0d 00 00       	call   80104970 <safestrcpy>
  pid = np->pid;
80103bfe:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c01:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c08:	e8 e3 0a 00 00       	call   801046f0 <acquire>
  np->state = RUNNABLE;
80103c0d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c14:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c1b:	e8 70 0a 00 00       	call   80104690 <release>
  return pid;
80103c20:	83 c4 10             	add    $0x10,%esp
}
80103c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c26:	89 d8                	mov    %ebx,%eax
80103c28:	5b                   	pop    %ebx
80103c29:	5e                   	pop    %esi
80103c2a:	5f                   	pop    %edi
80103c2b:	5d                   	pop    %ebp
80103c2c:	c3                   	ret    
    return -1;
80103c2d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c32:	eb ef                	jmp    80103c23 <fork+0xe3>
    kfree(np->kstack);
80103c34:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c37:	83 ec 0c             	sub    $0xc,%esp
80103c3a:	ff 73 08             	push   0x8(%ebx)
80103c3d:	e8 8e e8 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103c42:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c49:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c4c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c53:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c58:	eb c9                	jmp    80103c23 <fork+0xe3>
80103c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c60 <scheduler>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
80103c65:	53                   	push   %ebx
80103c66:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103c69:	e8 b2 fc ff ff       	call   80103920 <mycpu>
  c->proc = 0;
80103c6e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c75:	00 00 00 
  struct cpu *c = mycpu();
80103c78:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c7a:	8d 40 04             	lea    0x4(%eax),%eax
80103c7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103c80:	fb                   	sti    
    acquire(&ptable.lock);
80103c81:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c84:	bf 54 1d 11 80       	mov    $0x80111d54,%edi
    acquire(&ptable.lock);
80103c89:	68 20 1d 11 80       	push   $0x80111d20
80103c8e:	e8 5d 0a 00 00       	call   801046f0 <acquire>
80103c93:	83 c4 10             	add    $0x10,%esp
80103c96:	eb 1a                	jmp    80103cb2 <scheduler+0x52>
80103c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c9f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca0:	81 c7 84 00 00 00    	add    $0x84,%edi
80103ca6:	81 ff 54 3e 11 80    	cmp    $0x80113e54,%edi
80103cac:	0f 84 b4 00 00 00    	je     80103d66 <scheduler+0x106>
      if(p->state != RUNNABLE)
80103cb2:	8b 47 0c             	mov    0xc(%edi),%eax
80103cb5:	83 f8 03             	cmp    $0x3,%eax
80103cb8:	75 e6                	jne    80103ca0 <scheduler+0x40>
      for(priorProcIter = p;priorProcIter <&ptable.proc[NPROC];priorProcIter++){
80103cba:	81 ff 54 3e 11 80    	cmp    $0x80113e54,%edi
80103cc0:	73 2a                	jae    80103cec <scheduler+0x8c>
80103cc2:	89 fb                	mov    %edi,%ebx
80103cc4:	eb 0d                	jmp    80103cd3 <scheduler+0x73>
80103cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ccd:	8d 76 00             	lea    0x0(%esi),%esi
        if(priorProcIter->state != RUNNABLE)
80103cd0:	8b 43 0c             	mov    0xc(%ebx),%eax
80103cd3:	83 f8 03             	cmp    $0x3,%eax
80103cd6:	75 06                	jne    80103cde <scheduler+0x7e>
        if(priorProcIter->priority == 1){
80103cd8:	83 7b 7c 01          	cmpl   $0x1,0x7c(%ebx)
80103cdc:	74 3a                	je     80103d18 <scheduler+0xb8>
      for(priorProcIter = p;priorProcIter <&ptable.proc[NPROC];priorProcIter++){
80103cde:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103ce4:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
80103cea:	72 e4                	jb     80103cd0 <scheduler+0x70>
        for(priorProcIter = ptable.proc;priorProcIter <p;priorProcIter++){
80103cec:	81 ff 54 1d 11 80    	cmp    $0x80111d54,%edi
80103cf2:	76 22                	jbe    80103d16 <scheduler+0xb6>
80103cf4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          if(priorProcIter->state != RUNNABLE)
80103d00:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d04:	75 06                	jne    80103d0c <scheduler+0xac>
          if(priorProcIter->priority == 1){
80103d06:	83 7b 7c 01          	cmpl   $0x1,0x7c(%ebx)
80103d0a:	74 0c                	je     80103d18 <scheduler+0xb8>
        for(priorProcIter = ptable.proc;priorProcIter <p;priorProcIter++){
80103d0c:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103d12:	39 fb                	cmp    %edi,%ebx
80103d14:	72 ea                	jb     80103d00 <scheduler+0xa0>
80103d16:	89 fb                	mov    %edi,%ebx
      switchuvm(priorProc);
80103d18:	83 ec 0c             	sub    $0xc,%esp
      c->proc = priorProc;
80103d1b:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d21:	81 c7 84 00 00 00    	add    $0x84,%edi
      switchuvm(priorProc);
80103d27:	53                   	push   %ebx
80103d28:	e8 43 2e 00 00       	call   80106b70 <switchuvm>
      priorProc->ticks = priorProc->ticks+1;
80103d2d:	83 83 80 00 00 00 01 	addl   $0x1,0x80(%ebx)
      priorProc->state = RUNNING;
80103d34:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), priorProc->context);
80103d3b:	58                   	pop    %eax
80103d3c:	5a                   	pop    %edx
80103d3d:	ff 73 1c             	push   0x1c(%ebx)
80103d40:	ff 75 e4             	push   -0x1c(%ebp)
80103d43:	e8 83 0c 00 00       	call   801049cb <swtch>
      switchkvm();
80103d48:	e8 13 2e 00 00       	call   80106b60 <switchkvm>
      c->proc = 0;
80103d4d:	83 c4 10             	add    $0x10,%esp
80103d50:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d57:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d5a:	81 ff 54 3e 11 80    	cmp    $0x80113e54,%edi
80103d60:	0f 85 4c ff ff ff    	jne    80103cb2 <scheduler+0x52>
    release(&ptable.lock);
80103d66:	83 ec 0c             	sub    $0xc,%esp
80103d69:	68 20 1d 11 80       	push   $0x80111d20
80103d6e:	e8 1d 09 00 00       	call   80104690 <release>
    sti();
80103d73:	83 c4 10             	add    $0x10,%esp
80103d76:	e9 05 ff ff ff       	jmp    80103c80 <scheduler+0x20>
80103d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d7f:	90                   	nop

80103d80 <sched>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	56                   	push   %esi
80103d84:	53                   	push   %ebx
  pushcli();
80103d85:	e8 16 08 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103d8a:	e8 91 fb ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103d8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d95:	e8 56 08 00 00       	call   801045f0 <popcli>
  if(!holding(&ptable.lock))
80103d9a:	83 ec 0c             	sub    $0xc,%esp
80103d9d:	68 20 1d 11 80       	push   $0x80111d20
80103da2:	e8 a9 08 00 00       	call   80104650 <holding>
80103da7:	83 c4 10             	add    $0x10,%esp
80103daa:	85 c0                	test   %eax,%eax
80103dac:	74 4f                	je     80103dfd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dae:	e8 6d fb ff ff       	call   80103920 <mycpu>
80103db3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dba:	75 68                	jne    80103e24 <sched+0xa4>
  if(p->state == RUNNING)
80103dbc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103dc0:	74 55                	je     80103e17 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103dc2:	9c                   	pushf  
80103dc3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dc4:	f6 c4 02             	test   $0x2,%ah
80103dc7:	75 41                	jne    80103e0a <sched+0x8a>
  intena = mycpu()->intena;
80103dc9:	e8 52 fb ff ff       	call   80103920 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103dd1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103dd7:	e8 44 fb ff ff       	call   80103920 <mycpu>
80103ddc:	83 ec 08             	sub    $0x8,%esp
80103ddf:	ff 70 04             	push   0x4(%eax)
80103de2:	53                   	push   %ebx
80103de3:	e8 e3 0b 00 00       	call   801049cb <swtch>
  mycpu()->intena = intena;
80103de8:	e8 33 fb ff ff       	call   80103920 <mycpu>
}
80103ded:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103df0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103df6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103df9:	5b                   	pop    %ebx
80103dfa:	5e                   	pop    %esi
80103dfb:	5d                   	pop    %ebp
80103dfc:	c3                   	ret    
    panic("sched ptable.lock");
80103dfd:	83 ec 0c             	sub    $0xc,%esp
80103e00:	68 5b 7a 10 80       	push   $0x80107a5b
80103e05:	e8 76 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e0a:	83 ec 0c             	sub    $0xc,%esp
80103e0d:	68 87 7a 10 80       	push   $0x80107a87
80103e12:	e8 69 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e17:	83 ec 0c             	sub    $0xc,%esp
80103e1a:	68 79 7a 10 80       	push   $0x80107a79
80103e1f:	e8 5c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e24:	83 ec 0c             	sub    $0xc,%esp
80103e27:	68 6d 7a 10 80       	push   $0x80107a6d
80103e2c:	e8 4f c5 ff ff       	call   80100380 <panic>
80103e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e3f:	90                   	nop

80103e40 <exit>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e49:	e8 52 fb ff ff       	call   801039a0 <myproc>
  if(curproc == initproc)
80103e4e:	39 05 54 3e 11 80    	cmp    %eax,0x80113e54
80103e54:	0f 84 07 01 00 00    	je     80103f61 <exit+0x121>
80103e5a:	89 c3                	mov    %eax,%ebx
80103e5c:	8d 70 28             	lea    0x28(%eax),%esi
80103e5f:	8d 78 68             	lea    0x68(%eax),%edi
80103e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e68:	8b 06                	mov    (%esi),%eax
80103e6a:	85 c0                	test   %eax,%eax
80103e6c:	74 12                	je     80103e80 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e6e:	83 ec 0c             	sub    $0xc,%esp
80103e71:	50                   	push   %eax
80103e72:	e8 89 d0 ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80103e77:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e7d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e80:	83 c6 04             	add    $0x4,%esi
80103e83:	39 f7                	cmp    %esi,%edi
80103e85:	75 e1                	jne    80103e68 <exit+0x28>
  begin_op();
80103e87:	e8 e4 ee ff ff       	call   80102d70 <begin_op>
  iput(curproc->cwd);
80103e8c:	83 ec 0c             	sub    $0xc,%esp
80103e8f:	ff 73 68             	push   0x68(%ebx)
80103e92:	e8 29 da ff ff       	call   801018c0 <iput>
  end_op();
80103e97:	e8 44 ef ff ff       	call   80102de0 <end_op>
  curproc->cwd = 0;
80103e9c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103ea3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103eaa:	e8 41 08 00 00       	call   801046f0 <acquire>
  wakeup1(curproc->parent);
80103eaf:	8b 53 14             	mov    0x14(%ebx),%edx
80103eb2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eb5:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103eba:	eb 10                	jmp    80103ecc <exit+0x8c>
80103ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ec0:	05 84 00 00 00       	add    $0x84,%eax
80103ec5:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
80103eca:	74 1e                	je     80103eea <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
80103ecc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ed0:	75 ee                	jne    80103ec0 <exit+0x80>
80103ed2:	3b 50 20             	cmp    0x20(%eax),%edx
80103ed5:	75 e9                	jne    80103ec0 <exit+0x80>
      p->state = RUNNABLE;
80103ed7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ede:	05 84 00 00 00       	add    $0x84,%eax
80103ee3:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
80103ee8:	75 e2                	jne    80103ecc <exit+0x8c>
      p->parent = initproc;
80103eea:	8b 0d 54 3e 11 80    	mov    0x80113e54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef0:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103ef5:	eb 17                	jmp    80103f0e <exit+0xce>
80103ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103efe:	66 90                	xchg   %ax,%ax
80103f00:	81 c2 84 00 00 00    	add    $0x84,%edx
80103f06:	81 fa 54 3e 11 80    	cmp    $0x80113e54,%edx
80103f0c:	74 3a                	je     80103f48 <exit+0x108>
    if(p->parent == curproc){
80103f0e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f11:	75 ed                	jne    80103f00 <exit+0xc0>
      if(p->state == ZOMBIE)
80103f13:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f17:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f1a:	75 e4                	jne    80103f00 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f1c:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103f21:	eb 11                	jmp    80103f34 <exit+0xf4>
80103f23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f27:	90                   	nop
80103f28:	05 84 00 00 00       	add    $0x84,%eax
80103f2d:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
80103f32:	74 cc                	je     80103f00 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103f34:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f38:	75 ee                	jne    80103f28 <exit+0xe8>
80103f3a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f3d:	75 e9                	jne    80103f28 <exit+0xe8>
      p->state = RUNNABLE;
80103f3f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f46:	eb e0                	jmp    80103f28 <exit+0xe8>
  curproc->state = ZOMBIE;
80103f48:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f4f:	e8 2c fe ff ff       	call   80103d80 <sched>
  panic("zombie exit");
80103f54:	83 ec 0c             	sub    $0xc,%esp
80103f57:	68 a8 7a 10 80       	push   $0x80107aa8
80103f5c:	e8 1f c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f61:	83 ec 0c             	sub    $0xc,%esp
80103f64:	68 9b 7a 10 80       	push   $0x80107a9b
80103f69:	e8 12 c4 ff ff       	call   80100380 <panic>
80103f6e:	66 90                	xchg   %ax,%ax

80103f70 <wait>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	56                   	push   %esi
80103f74:	53                   	push   %ebx
  pushcli();
80103f75:	e8 26 06 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103f7a:	e8 a1 f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103f7f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f85:	e8 66 06 00 00       	call   801045f0 <popcli>
  acquire(&ptable.lock);
80103f8a:	83 ec 0c             	sub    $0xc,%esp
80103f8d:	68 20 1d 11 80       	push   $0x80111d20
80103f92:	e8 59 07 00 00       	call   801046f0 <acquire>
80103f97:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f9a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103fa1:	eb 13                	jmp    80103fb6 <wait+0x46>
80103fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fa7:	90                   	nop
80103fa8:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103fae:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
80103fb4:	74 1e                	je     80103fd4 <wait+0x64>
      if(p->parent != curproc)
80103fb6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fb9:	75 ed                	jne    80103fa8 <wait+0x38>
      if(p->state == ZOMBIE){
80103fbb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fbf:	74 5f                	je     80104020 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fc1:	81 c3 84 00 00 00    	add    $0x84,%ebx
      havekids = 1;
80103fc7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fcc:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
80103fd2:	75 e2                	jne    80103fb6 <wait+0x46>
    if(!havekids || curproc->killed){
80103fd4:	85 c0                	test   %eax,%eax
80103fd6:	0f 84 9a 00 00 00    	je     80104076 <wait+0x106>
80103fdc:	8b 46 24             	mov    0x24(%esi),%eax
80103fdf:	85 c0                	test   %eax,%eax
80103fe1:	0f 85 8f 00 00 00    	jne    80104076 <wait+0x106>
  pushcli();
80103fe7:	e8 b4 05 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103fec:	e8 2f f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103ff1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ff7:	e8 f4 05 00 00       	call   801045f0 <popcli>
  if(p == 0)
80103ffc:	85 db                	test   %ebx,%ebx
80103ffe:	0f 84 89 00 00 00    	je     8010408d <wait+0x11d>
  p->chan = chan;
80104004:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104007:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010400e:	e8 6d fd ff ff       	call   80103d80 <sched>
  p->chan = 0;
80104013:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010401a:	e9 7b ff ff ff       	jmp    80103f9a <wait+0x2a>
8010401f:	90                   	nop
        kfree(p->kstack);
80104020:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104023:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104026:	ff 73 08             	push   0x8(%ebx)
80104029:	e8 a2 e4 ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
8010402e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104035:	5a                   	pop    %edx
80104036:	ff 73 04             	push   0x4(%ebx)
80104039:	e8 12 2f 00 00       	call   80106f50 <freevm>
        p->pid = 0;
8010403e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104045:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010404c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104050:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104057:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010405e:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104065:	e8 26 06 00 00       	call   80104690 <release>
        return pid;
8010406a:	83 c4 10             	add    $0x10,%esp
}
8010406d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104070:	89 f0                	mov    %esi,%eax
80104072:	5b                   	pop    %ebx
80104073:	5e                   	pop    %esi
80104074:	5d                   	pop    %ebp
80104075:	c3                   	ret    
      release(&ptable.lock);
80104076:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104079:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010407e:	68 20 1d 11 80       	push   $0x80111d20
80104083:	e8 08 06 00 00       	call   80104690 <release>
      return -1;
80104088:	83 c4 10             	add    $0x10,%esp
8010408b:	eb e0                	jmp    8010406d <wait+0xfd>
    panic("sleep");
8010408d:	83 ec 0c             	sub    $0xc,%esp
80104090:	68 b4 7a 10 80       	push   $0x80107ab4
80104095:	e8 e6 c2 ff ff       	call   80100380 <panic>
8010409a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040a0 <yield>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040a7:	68 20 1d 11 80       	push   $0x80111d20
801040ac:	e8 3f 06 00 00       	call   801046f0 <acquire>
  pushcli();
801040b1:	e8 ea 04 00 00       	call   801045a0 <pushcli>
  c = mycpu();
801040b6:	e8 65 f8 ff ff       	call   80103920 <mycpu>
  p = c->proc;
801040bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040c1:	e8 2a 05 00 00       	call   801045f0 <popcli>
  myproc()->state = RUNNABLE;
801040c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040cd:	e8 ae fc ff ff       	call   80103d80 <sched>
  release(&ptable.lock);
801040d2:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040d9:	e8 b2 05 00 00       	call   80104690 <release>
}
801040de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040e1:	83 c4 10             	add    $0x10,%esp
801040e4:	c9                   	leave  
801040e5:	c3                   	ret    
801040e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ed:	8d 76 00             	lea    0x0(%esi),%esi

801040f0 <sleep>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	57                   	push   %edi
801040f4:	56                   	push   %esi
801040f5:	53                   	push   %ebx
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801040fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801040ff:	e8 9c 04 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80104104:	e8 17 f8 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80104109:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010410f:	e8 dc 04 00 00       	call   801045f0 <popcli>
  if(p == 0)
80104114:	85 db                	test   %ebx,%ebx
80104116:	0f 84 87 00 00 00    	je     801041a3 <sleep+0xb3>
  if(lk == 0)
8010411c:	85 f6                	test   %esi,%esi
8010411e:	74 76                	je     80104196 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104120:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80104126:	74 50                	je     80104178 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104128:	83 ec 0c             	sub    $0xc,%esp
8010412b:	68 20 1d 11 80       	push   $0x80111d20
80104130:	e8 bb 05 00 00       	call   801046f0 <acquire>
    release(lk);
80104135:	89 34 24             	mov    %esi,(%esp)
80104138:	e8 53 05 00 00       	call   80104690 <release>
  p->chan = chan;
8010413d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104140:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104147:	e8 34 fc ff ff       	call   80103d80 <sched>
  p->chan = 0;
8010414c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104153:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010415a:	e8 31 05 00 00       	call   80104690 <release>
    acquire(lk);
8010415f:	89 75 08             	mov    %esi,0x8(%ebp)
80104162:	83 c4 10             	add    $0x10,%esp
}
80104165:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104168:	5b                   	pop    %ebx
80104169:	5e                   	pop    %esi
8010416a:	5f                   	pop    %edi
8010416b:	5d                   	pop    %ebp
    acquire(lk);
8010416c:	e9 7f 05 00 00       	jmp    801046f0 <acquire>
80104171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104178:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010417b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104182:	e8 f9 fb ff ff       	call   80103d80 <sched>
  p->chan = 0;
80104187:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010418e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104191:	5b                   	pop    %ebx
80104192:	5e                   	pop    %esi
80104193:	5f                   	pop    %edi
80104194:	5d                   	pop    %ebp
80104195:	c3                   	ret    
    panic("sleep without lk");
80104196:	83 ec 0c             	sub    $0xc,%esp
80104199:	68 ba 7a 10 80       	push   $0x80107aba
8010419e:	e8 dd c1 ff ff       	call   80100380 <panic>
    panic("sleep");
801041a3:	83 ec 0c             	sub    $0xc,%esp
801041a6:	68 b4 7a 10 80       	push   $0x80107ab4
801041ab:	e8 d0 c1 ff ff       	call   80100380 <panic>

801041b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	53                   	push   %ebx
801041b4:	83 ec 10             	sub    $0x10,%esp
801041b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041ba:	68 20 1d 11 80       	push   $0x80111d20
801041bf:	e8 2c 05 00 00       	call   801046f0 <acquire>
801041c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041c7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801041cc:	eb 0e                	jmp    801041dc <wakeup+0x2c>
801041ce:	66 90                	xchg   %ax,%ax
801041d0:	05 84 00 00 00       	add    $0x84,%eax
801041d5:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
801041da:	74 1e                	je     801041fa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801041dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041e0:	75 ee                	jne    801041d0 <wakeup+0x20>
801041e2:	3b 58 20             	cmp    0x20(%eax),%ebx
801041e5:	75 e9                	jne    801041d0 <wakeup+0x20>
      p->state = RUNNABLE;
801041e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041ee:	05 84 00 00 00       	add    $0x84,%eax
801041f3:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
801041f8:	75 e2                	jne    801041dc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801041fa:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
80104201:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104204:	c9                   	leave  
  release(&ptable.lock);
80104205:	e9 86 04 00 00       	jmp    80104690 <release>
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104210 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	53                   	push   %ebx
80104214:	83 ec 10             	sub    $0x10,%esp
80104217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010421a:	68 20 1d 11 80       	push   $0x80111d20
8010421f:	e8 cc 04 00 00       	call   801046f0 <acquire>
80104224:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104227:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010422c:	eb 0e                	jmp    8010423c <kill+0x2c>
8010422e:	66 90                	xchg   %ax,%ax
80104230:	05 84 00 00 00       	add    $0x84,%eax
80104235:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
8010423a:	74 34                	je     80104270 <kill+0x60>
    if(p->pid == pid){
8010423c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010423f:	75 ef                	jne    80104230 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104241:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104245:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010424c:	75 07                	jne    80104255 <kill+0x45>
        p->state = RUNNABLE;
8010424e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104255:	83 ec 0c             	sub    $0xc,%esp
80104258:	68 20 1d 11 80       	push   $0x80111d20
8010425d:	e8 2e 04 00 00       	call   80104690 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104262:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104265:	83 c4 10             	add    $0x10,%esp
80104268:	31 c0                	xor    %eax,%eax
}
8010426a:	c9                   	leave  
8010426b:	c3                   	ret    
8010426c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104270:	83 ec 0c             	sub    $0xc,%esp
80104273:	68 20 1d 11 80       	push   $0x80111d20
80104278:	e8 13 04 00 00       	call   80104690 <release>
}
8010427d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104280:	83 c4 10             	add    $0x10,%esp
80104283:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104288:	c9                   	leave  
80104289:	c3                   	ret    
8010428a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104290 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104298:	53                   	push   %ebx
80104299:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010429e:	83 ec 3c             	sub    $0x3c,%esp
801042a1:	eb 27                	jmp    801042ca <procdump+0x3a>
801042a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042a7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801042a8:	83 ec 0c             	sub    $0xc,%esp
801042ab:	68 47 7e 10 80       	push   $0x80107e47
801042b0:	e8 eb c3 ff ff       	call   801006a0 <cprintf>
801042b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b8:	81 c3 84 00 00 00    	add    $0x84,%ebx
801042be:	81 fb c0 3e 11 80    	cmp    $0x80113ec0,%ebx
801042c4:	0f 84 7e 00 00 00    	je     80104348 <procdump+0xb8>
    if(p->state == UNUSED)
801042ca:	8b 43 a0             	mov    -0x60(%ebx),%eax
801042cd:	85 c0                	test   %eax,%eax
801042cf:	74 e7                	je     801042b8 <procdump+0x28>
      state = "???";
801042d1:	ba cb 7a 10 80       	mov    $0x80107acb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042d6:	83 f8 05             	cmp    $0x5,%eax
801042d9:	77 11                	ja     801042ec <procdump+0x5c>
801042db:	8b 14 85 2c 7b 10 80 	mov    -0x7fef84d4(,%eax,4),%edx
      state = "???";
801042e2:	b8 cb 7a 10 80       	mov    $0x80107acb,%eax
801042e7:	85 d2                	test   %edx,%edx
801042e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042ec:	53                   	push   %ebx
801042ed:	52                   	push   %edx
801042ee:	ff 73 a4             	push   -0x5c(%ebx)
801042f1:	68 cf 7a 10 80       	push   $0x80107acf
801042f6:	e8 a5 c3 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801042fb:	83 c4 10             	add    $0x10,%esp
801042fe:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104302:	75 a4                	jne    801042a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104304:	83 ec 08             	sub    $0x8,%esp
80104307:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010430a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010430d:	50                   	push   %eax
8010430e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104311:	8b 40 0c             	mov    0xc(%eax),%eax
80104314:	83 c0 08             	add    $0x8,%eax
80104317:	50                   	push   %eax
80104318:	e8 23 02 00 00       	call   80104540 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010431d:	83 c4 10             	add    $0x10,%esp
80104320:	8b 17                	mov    (%edi),%edx
80104322:	85 d2                	test   %edx,%edx
80104324:	74 82                	je     801042a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104326:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104329:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010432c:	52                   	push   %edx
8010432d:	68 21 75 10 80       	push   $0x80107521
80104332:	e8 69 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104337:	83 c4 10             	add    $0x10,%esp
8010433a:	39 fe                	cmp    %edi,%esi
8010433c:	75 e2                	jne    80104320 <procdump+0x90>
8010433e:	e9 65 ff ff ff       	jmp    801042a8 <procdump+0x18>
80104343:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104347:	90                   	nop
  }
}
80104348:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010434b:	5b                   	pop    %ebx
8010434c:	5e                   	pop    %esi
8010434d:	5f                   	pop    %edi
8010434e:	5d                   	pop    %ebp
8010434f:	c3                   	ret    

80104350 <sys_getpinfo>:


int
sys_getpinfo(void)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	56                   	push   %esi
80104354:	53                   	push   %ebx
  struct pstat *cur_pstat;
  
  if(( argptr(0, (void*)&cur_pstat, sizeof(struct pstat)) < 0)) {
80104355:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104358:	83 ec 14             	sub    $0x14,%esp
  if(( argptr(0, (void*)&cur_pstat, sizeof(struct pstat)) < 0)) {
8010435b:	68 00 04 00 00       	push   $0x400
80104360:	50                   	push   %eax
80104361:	6a 00                	push   $0x0
80104363:	e8 58 07 00 00       	call   80104ac0 <argptr>
80104368:	83 c4 10             	add    $0x10,%esp
8010436b:	85 c0                	test   %eax,%eax
8010436d:	78 75                	js     801043e4 <sys_getpinfo+0x94>
    return -1;
  }

  // lock the process table
  acquire(&ptable.lock);
8010436f:	83 ec 0c             	sub    $0xc,%esp
80104372:	68 20 1d 11 80       	push   $0x80111d20
80104377:	e8 74 03 00 00       	call   801046f0 <acquire>
  int i=0;
  for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->state == UNUSED) {
      cur_pstat->inuse[i] = 0;
8010437c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010437f:	83 c4 10             	add    $0x10,%esp
  for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104382:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
  int i=0;
80104387:	31 d2                	xor    %edx,%edx
80104389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == UNUSED) {
80104390:	8b 70 0c             	mov    0xc(%eax),%esi
80104393:	31 c9                	xor    %ecx,%ecx
80104395:	85 f6                	test   %esi,%esi
80104397:	0f 95 c1             	setne  %cl
  for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010439a:	05 84 00 00 00       	add    $0x84,%eax
      cur_pstat->inuse[i] = 0;
8010439f:	89 0c 93             	mov    %ecx,(%ebx,%edx,4)
    }
    else {
      cur_pstat->inuse[i] = 1;
    }
    cur_pstat->pid[i] = p->pid;
801043a2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801043a5:	8b 70 8c             	mov    -0x74(%eax),%esi
801043a8:	8d 0c 93             	lea    (%ebx,%edx,4),%ecx
    cur_pstat->tickets[i] = p->priority;
    cur_pstat->ticks[i] = p->ticks;
    i++;
801043ab:	83 c2 01             	add    $0x1,%edx
    cur_pstat->pid[i] = p->pid;
801043ae:	89 b1 00 02 00 00    	mov    %esi,0x200(%ecx)
    cur_pstat->tickets[i] = p->priority;
801043b4:	8b 70 f8             	mov    -0x8(%eax),%esi
801043b7:	89 b1 00 01 00 00    	mov    %esi,0x100(%ecx)
    cur_pstat->ticks[i] = p->ticks;
801043bd:	8b 70 fc             	mov    -0x4(%eax),%esi
801043c0:	89 b1 00 03 00 00    	mov    %esi,0x300(%ecx)
  for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043c6:	83 fa 40             	cmp    $0x40,%edx
801043c9:	75 c5                	jne    80104390 <sys_getpinfo+0x40>
  }
  release(&ptable.lock);
801043cb:	83 ec 0c             	sub    $0xc,%esp
801043ce:	68 20 1d 11 80       	push   $0x80111d20
801043d3:	e8 b8 02 00 00       	call   80104690 <release>
  
  return 0;
801043d8:	83 c4 10             	add    $0x10,%esp
801043db:	31 c0                	xor    %eax,%eax
}
801043dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043e0:	5b                   	pop    %ebx
801043e1:	5e                   	pop    %esi
801043e2:	5d                   	pop    %ebp
801043e3:	c3                   	ret    
    return -1;
801043e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043e9:	eb f2                	jmp    801043dd <sys_getpinfo+0x8d>
801043eb:	66 90                	xchg   %ax,%ax
801043ed:	66 90                	xchg   %ax,%ax
801043ef:	90                   	nop

801043f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	83 ec 0c             	sub    $0xc,%esp
801043f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043fa:	68 44 7b 10 80       	push   $0x80107b44
801043ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104402:	50                   	push   %eax
80104403:	e8 18 01 00 00       	call   80104520 <initlock>
  lk->name = name;
80104408:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010440b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104411:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104414:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010441b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010441e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104421:	c9                   	leave  
80104422:	c3                   	ret    
80104423:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104430 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
80104435:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104438:	8d 73 04             	lea    0x4(%ebx),%esi
8010443b:	83 ec 0c             	sub    $0xc,%esp
8010443e:	56                   	push   %esi
8010443f:	e8 ac 02 00 00       	call   801046f0 <acquire>
  while (lk->locked) {
80104444:	8b 13                	mov    (%ebx),%edx
80104446:	83 c4 10             	add    $0x10,%esp
80104449:	85 d2                	test   %edx,%edx
8010444b:	74 16                	je     80104463 <acquiresleep+0x33>
8010444d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104450:	83 ec 08             	sub    $0x8,%esp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
80104455:	e8 96 fc ff ff       	call   801040f0 <sleep>
  while (lk->locked) {
8010445a:	8b 03                	mov    (%ebx),%eax
8010445c:	83 c4 10             	add    $0x10,%esp
8010445f:	85 c0                	test   %eax,%eax
80104461:	75 ed                	jne    80104450 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104463:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104469:	e8 32 f5 ff ff       	call   801039a0 <myproc>
8010446e:	8b 40 10             	mov    0x10(%eax),%eax
80104471:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104474:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104477:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010447a:	5b                   	pop    %ebx
8010447b:	5e                   	pop    %esi
8010447c:	5d                   	pop    %ebp
  release(&lk->lk);
8010447d:	e9 0e 02 00 00       	jmp    80104690 <release>
80104482:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104490 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	53                   	push   %ebx
80104495:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104498:	8d 73 04             	lea    0x4(%ebx),%esi
8010449b:	83 ec 0c             	sub    $0xc,%esp
8010449e:	56                   	push   %esi
8010449f:	e8 4c 02 00 00       	call   801046f0 <acquire>
  lk->locked = 0;
801044a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044b1:	89 1c 24             	mov    %ebx,(%esp)
801044b4:	e8 f7 fc ff ff       	call   801041b0 <wakeup>
  release(&lk->lk);
801044b9:	89 75 08             	mov    %esi,0x8(%ebp)
801044bc:	83 c4 10             	add    $0x10,%esp
}
801044bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044c2:	5b                   	pop    %ebx
801044c3:	5e                   	pop    %esi
801044c4:	5d                   	pop    %ebp
  release(&lk->lk);
801044c5:	e9 c6 01 00 00       	jmp    80104690 <release>
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	57                   	push   %edi
801044d4:	31 ff                	xor    %edi,%edi
801044d6:	56                   	push   %esi
801044d7:	53                   	push   %ebx
801044d8:	83 ec 18             	sub    $0x18,%esp
801044db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044de:	8d 73 04             	lea    0x4(%ebx),%esi
801044e1:	56                   	push   %esi
801044e2:	e8 09 02 00 00       	call   801046f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044e7:	8b 03                	mov    (%ebx),%eax
801044e9:	83 c4 10             	add    $0x10,%esp
801044ec:	85 c0                	test   %eax,%eax
801044ee:	75 18                	jne    80104508 <holdingsleep+0x38>
  release(&lk->lk);
801044f0:	83 ec 0c             	sub    $0xc,%esp
801044f3:	56                   	push   %esi
801044f4:	e8 97 01 00 00       	call   80104690 <release>
  return r;
}
801044f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044fc:	89 f8                	mov    %edi,%eax
801044fe:	5b                   	pop    %ebx
801044ff:	5e                   	pop    %esi
80104500:	5f                   	pop    %edi
80104501:	5d                   	pop    %ebp
80104502:	c3                   	ret    
80104503:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104507:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104508:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010450b:	e8 90 f4 ff ff       	call   801039a0 <myproc>
80104510:	39 58 10             	cmp    %ebx,0x10(%eax)
80104513:	0f 94 c0             	sete   %al
80104516:	0f b6 c0             	movzbl %al,%eax
80104519:	89 c7                	mov    %eax,%edi
8010451b:	eb d3                	jmp    801044f0 <holdingsleep+0x20>
8010451d:	66 90                	xchg   %ax,%ax
8010451f:	90                   	nop

80104520 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104526:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104529:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010452f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104532:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104539:	5d                   	pop    %ebp
8010453a:	c3                   	ret    
8010453b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010453f:	90                   	nop

80104540 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104540:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104541:	31 d2                	xor    %edx,%edx
{
80104543:	89 e5                	mov    %esp,%ebp
80104545:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104546:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104549:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010454c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010454f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104550:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104556:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010455c:	77 1a                	ja     80104578 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010455e:	8b 58 04             	mov    0x4(%eax),%ebx
80104561:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104564:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104567:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104569:	83 fa 0a             	cmp    $0xa,%edx
8010456c:	75 e2                	jne    80104550 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010456e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104571:	c9                   	leave  
80104572:	c3                   	ret    
80104573:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104577:	90                   	nop
  for(; i < 10; i++)
80104578:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010457b:	8d 51 28             	lea    0x28(%ecx),%edx
8010457e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104580:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104586:	83 c0 04             	add    $0x4,%eax
80104589:	39 d0                	cmp    %edx,%eax
8010458b:	75 f3                	jne    80104580 <getcallerpcs+0x40>
}
8010458d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104590:	c9                   	leave  
80104591:	c3                   	ret    
80104592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 04             	sub    $0x4,%esp
801045a7:	9c                   	pushf  
801045a8:	5b                   	pop    %ebx
  asm volatile("cli");
801045a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801045aa:	e8 71 f3 ff ff       	call   80103920 <mycpu>
801045af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045b5:	85 c0                	test   %eax,%eax
801045b7:	74 17                	je     801045d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801045b9:	e8 62 f3 ff ff       	call   80103920 <mycpu>
801045be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045c8:	c9                   	leave  
801045c9:	c3                   	ret    
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801045d0:	e8 4b f3 ff ff       	call   80103920 <mycpu>
801045d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045e1:	eb d6                	jmp    801045b9 <pushcli+0x19>
801045e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045f0 <popcli>:

void
popcli(void)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045f6:	9c                   	pushf  
801045f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045f8:	f6 c4 02             	test   $0x2,%ah
801045fb:	75 35                	jne    80104632 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045fd:	e8 1e f3 ff ff       	call   80103920 <mycpu>
80104602:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104609:	78 34                	js     8010463f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010460b:	e8 10 f3 ff ff       	call   80103920 <mycpu>
80104610:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104616:	85 d2                	test   %edx,%edx
80104618:	74 06                	je     80104620 <popcli+0x30>
    sti();
}
8010461a:	c9                   	leave  
8010461b:	c3                   	ret    
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104620:	e8 fb f2 ff ff       	call   80103920 <mycpu>
80104625:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010462b:	85 c0                	test   %eax,%eax
8010462d:	74 eb                	je     8010461a <popcli+0x2a>
  asm volatile("sti");
8010462f:	fb                   	sti    
}
80104630:	c9                   	leave  
80104631:	c3                   	ret    
    panic("popcli - interruptible");
80104632:	83 ec 0c             	sub    $0xc,%esp
80104635:	68 4f 7b 10 80       	push   $0x80107b4f
8010463a:	e8 41 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010463f:	83 ec 0c             	sub    $0xc,%esp
80104642:	68 66 7b 10 80       	push   $0x80107b66
80104647:	e8 34 bd ff ff       	call   80100380 <panic>
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104650 <holding>:
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	8b 75 08             	mov    0x8(%ebp),%esi
80104658:	31 db                	xor    %ebx,%ebx
  pushcli();
8010465a:	e8 41 ff ff ff       	call   801045a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010465f:	8b 06                	mov    (%esi),%eax
80104661:	85 c0                	test   %eax,%eax
80104663:	75 0b                	jne    80104670 <holding+0x20>
  popcli();
80104665:	e8 86 ff ff ff       	call   801045f0 <popcli>
}
8010466a:	89 d8                	mov    %ebx,%eax
8010466c:	5b                   	pop    %ebx
8010466d:	5e                   	pop    %esi
8010466e:	5d                   	pop    %ebp
8010466f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104670:	8b 5e 08             	mov    0x8(%esi),%ebx
80104673:	e8 a8 f2 ff ff       	call   80103920 <mycpu>
80104678:	39 c3                	cmp    %eax,%ebx
8010467a:	0f 94 c3             	sete   %bl
  popcli();
8010467d:	e8 6e ff ff ff       	call   801045f0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104682:	0f b6 db             	movzbl %bl,%ebx
}
80104685:	89 d8                	mov    %ebx,%eax
80104687:	5b                   	pop    %ebx
80104688:	5e                   	pop    %esi
80104689:	5d                   	pop    %ebp
8010468a:	c3                   	ret    
8010468b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010468f:	90                   	nop

80104690 <release>:
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104698:	e8 03 ff ff ff       	call   801045a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010469d:	8b 03                	mov    (%ebx),%eax
8010469f:	85 c0                	test   %eax,%eax
801046a1:	75 15                	jne    801046b8 <release+0x28>
  popcli();
801046a3:	e8 48 ff ff ff       	call   801045f0 <popcli>
    panic("release");
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	68 6d 7b 10 80       	push   $0x80107b6d
801046b0:	e8 cb bc ff ff       	call   80100380 <panic>
801046b5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801046b8:	8b 73 08             	mov    0x8(%ebx),%esi
801046bb:	e8 60 f2 ff ff       	call   80103920 <mycpu>
801046c0:	39 c6                	cmp    %eax,%esi
801046c2:	75 df                	jne    801046a3 <release+0x13>
  popcli();
801046c4:	e8 27 ff ff ff       	call   801045f0 <popcli>
  lk->pcs[0] = 0;
801046c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046d0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046d7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046e5:	5b                   	pop    %ebx
801046e6:	5e                   	pop    %esi
801046e7:	5d                   	pop    %ebp
  popcli();
801046e8:	e9 03 ff ff ff       	jmp    801045f0 <popcli>
801046ed:	8d 76 00             	lea    0x0(%esi),%esi

801046f0 <acquire>:
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801046f7:	e8 a4 fe ff ff       	call   801045a0 <pushcli>
  if(holding(lk))
801046fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046ff:	e8 9c fe ff ff       	call   801045a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104704:	8b 03                	mov    (%ebx),%eax
80104706:	85 c0                	test   %eax,%eax
80104708:	75 7e                	jne    80104788 <acquire+0x98>
  popcli();
8010470a:	e8 e1 fe ff ff       	call   801045f0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010470f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104718:	8b 55 08             	mov    0x8(%ebp),%edx
8010471b:	89 c8                	mov    %ecx,%eax
8010471d:	f0 87 02             	lock xchg %eax,(%edx)
80104720:	85 c0                	test   %eax,%eax
80104722:	75 f4                	jne    80104718 <acquire+0x28>
  __sync_synchronize();
80104724:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104729:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010472c:	e8 ef f1 ff ff       	call   80103920 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104731:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104734:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104736:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104739:	31 c0                	xor    %eax,%eax
8010473b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010473f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104740:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104746:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010474c:	77 1a                	ja     80104768 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010474e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104751:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104755:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104758:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010475a:	83 f8 0a             	cmp    $0xa,%eax
8010475d:	75 e1                	jne    80104740 <acquire+0x50>
}
8010475f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104762:	c9                   	leave  
80104763:	c3                   	ret    
80104764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104768:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010476c:	8d 51 34             	lea    0x34(%ecx),%edx
8010476f:	90                   	nop
    pcs[i] = 0;
80104770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104776:	83 c0 04             	add    $0x4,%eax
80104779:	39 c2                	cmp    %eax,%edx
8010477b:	75 f3                	jne    80104770 <acquire+0x80>
}
8010477d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104780:	c9                   	leave  
80104781:	c3                   	ret    
80104782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104788:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010478b:	e8 90 f1 ff ff       	call   80103920 <mycpu>
80104790:	39 c3                	cmp    %eax,%ebx
80104792:	0f 85 72 ff ff ff    	jne    8010470a <acquire+0x1a>
  popcli();
80104798:	e8 53 fe ff ff       	call   801045f0 <popcli>
    panic("acquire");
8010479d:	83 ec 0c             	sub    $0xc,%esp
801047a0:	68 75 7b 10 80       	push   $0x80107b75
801047a5:	e8 d6 bb ff ff       	call   80100380 <panic>
801047aa:	66 90                	xchg   %ax,%ax
801047ac:	66 90                	xchg   %ax,%ax
801047ae:	66 90                	xchg   %ax,%ax

801047b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	57                   	push   %edi
801047b4:	8b 55 08             	mov    0x8(%ebp),%edx
801047b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047ba:	53                   	push   %ebx
801047bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801047be:	89 d7                	mov    %edx,%edi
801047c0:	09 cf                	or     %ecx,%edi
801047c2:	83 e7 03             	and    $0x3,%edi
801047c5:	75 29                	jne    801047f0 <memset+0x40>
    c &= 0xFF;
801047c7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047ca:	c1 e0 18             	shl    $0x18,%eax
801047cd:	89 fb                	mov    %edi,%ebx
801047cf:	c1 e9 02             	shr    $0x2,%ecx
801047d2:	c1 e3 10             	shl    $0x10,%ebx
801047d5:	09 d8                	or     %ebx,%eax
801047d7:	09 f8                	or     %edi,%eax
801047d9:	c1 e7 08             	shl    $0x8,%edi
801047dc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047de:	89 d7                	mov    %edx,%edi
801047e0:	fc                   	cld    
801047e1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801047e3:	5b                   	pop    %ebx
801047e4:	89 d0                	mov    %edx,%eax
801047e6:	5f                   	pop    %edi
801047e7:	5d                   	pop    %ebp
801047e8:	c3                   	ret    
801047e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801047f0:	89 d7                	mov    %edx,%edi
801047f2:	fc                   	cld    
801047f3:	f3 aa                	rep stos %al,%es:(%edi)
801047f5:	5b                   	pop    %ebx
801047f6:	89 d0                	mov    %edx,%eax
801047f8:	5f                   	pop    %edi
801047f9:	5d                   	pop    %ebp
801047fa:	c3                   	ret    
801047fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047ff:	90                   	nop

80104800 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	8b 75 10             	mov    0x10(%ebp),%esi
80104807:	8b 55 08             	mov    0x8(%ebp),%edx
8010480a:	53                   	push   %ebx
8010480b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010480e:	85 f6                	test   %esi,%esi
80104810:	74 2e                	je     80104840 <memcmp+0x40>
80104812:	01 c6                	add    %eax,%esi
80104814:	eb 14                	jmp    8010482a <memcmp+0x2a>
80104816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104820:	83 c0 01             	add    $0x1,%eax
80104823:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104826:	39 f0                	cmp    %esi,%eax
80104828:	74 16                	je     80104840 <memcmp+0x40>
    if(*s1 != *s2)
8010482a:	0f b6 0a             	movzbl (%edx),%ecx
8010482d:	0f b6 18             	movzbl (%eax),%ebx
80104830:	38 d9                	cmp    %bl,%cl
80104832:	74 ec                	je     80104820 <memcmp+0x20>
      return *s1 - *s2;
80104834:	0f b6 c1             	movzbl %cl,%eax
80104837:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104839:	5b                   	pop    %ebx
8010483a:	5e                   	pop    %esi
8010483b:	5d                   	pop    %ebp
8010483c:	c3                   	ret    
8010483d:	8d 76 00             	lea    0x0(%esi),%esi
80104840:	5b                   	pop    %ebx
  return 0;
80104841:	31 c0                	xor    %eax,%eax
}
80104843:	5e                   	pop    %esi
80104844:	5d                   	pop    %ebp
80104845:	c3                   	ret    
80104846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484d:	8d 76 00             	lea    0x0(%esi),%esi

80104850 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	8b 55 08             	mov    0x8(%ebp),%edx
80104857:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010485a:	56                   	push   %esi
8010485b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010485e:	39 d6                	cmp    %edx,%esi
80104860:	73 26                	jae    80104888 <memmove+0x38>
80104862:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104865:	39 fa                	cmp    %edi,%edx
80104867:	73 1f                	jae    80104888 <memmove+0x38>
80104869:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010486c:	85 c9                	test   %ecx,%ecx
8010486e:	74 0c                	je     8010487c <memmove+0x2c>
      *--d = *--s;
80104870:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104874:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104877:	83 e8 01             	sub    $0x1,%eax
8010487a:	73 f4                	jae    80104870 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010487c:	5e                   	pop    %esi
8010487d:	89 d0                	mov    %edx,%eax
8010487f:	5f                   	pop    %edi
80104880:	5d                   	pop    %ebp
80104881:	c3                   	ret    
80104882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104888:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010488b:	89 d7                	mov    %edx,%edi
8010488d:	85 c9                	test   %ecx,%ecx
8010488f:	74 eb                	je     8010487c <memmove+0x2c>
80104891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104898:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104899:	39 c6                	cmp    %eax,%esi
8010489b:	75 fb                	jne    80104898 <memmove+0x48>
}
8010489d:	5e                   	pop    %esi
8010489e:	89 d0                	mov    %edx,%eax
801048a0:	5f                   	pop    %edi
801048a1:	5d                   	pop    %ebp
801048a2:	c3                   	ret    
801048a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801048b0:	eb 9e                	jmp    80104850 <memmove>
801048b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	56                   	push   %esi
801048c4:	8b 75 10             	mov    0x10(%ebp),%esi
801048c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048ca:	53                   	push   %ebx
801048cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801048ce:	85 f6                	test   %esi,%esi
801048d0:	74 2e                	je     80104900 <strncmp+0x40>
801048d2:	01 d6                	add    %edx,%esi
801048d4:	eb 18                	jmp    801048ee <strncmp+0x2e>
801048d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
801048e0:	38 d8                	cmp    %bl,%al
801048e2:	75 14                	jne    801048f8 <strncmp+0x38>
    n--, p++, q++;
801048e4:	83 c2 01             	add    $0x1,%edx
801048e7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048ea:	39 f2                	cmp    %esi,%edx
801048ec:	74 12                	je     80104900 <strncmp+0x40>
801048ee:	0f b6 01             	movzbl (%ecx),%eax
801048f1:	0f b6 1a             	movzbl (%edx),%ebx
801048f4:	84 c0                	test   %al,%al
801048f6:	75 e8                	jne    801048e0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801048f8:	29 d8                	sub    %ebx,%eax
}
801048fa:	5b                   	pop    %ebx
801048fb:	5e                   	pop    %esi
801048fc:	5d                   	pop    %ebp
801048fd:	c3                   	ret    
801048fe:	66 90                	xchg   %ax,%ax
80104900:	5b                   	pop    %ebx
    return 0;
80104901:	31 c0                	xor    %eax,%eax
}
80104903:	5e                   	pop    %esi
80104904:	5d                   	pop    %ebp
80104905:	c3                   	ret    
80104906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490d:	8d 76 00             	lea    0x0(%esi),%esi

80104910 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	56                   	push   %esi
80104915:	8b 75 08             	mov    0x8(%ebp),%esi
80104918:	53                   	push   %ebx
80104919:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010491c:	89 f0                	mov    %esi,%eax
8010491e:	eb 15                	jmp    80104935 <strncpy+0x25>
80104920:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104924:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104927:	83 c0 01             	add    $0x1,%eax
8010492a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010492e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104931:	84 d2                	test   %dl,%dl
80104933:	74 09                	je     8010493e <strncpy+0x2e>
80104935:	89 cb                	mov    %ecx,%ebx
80104937:	83 e9 01             	sub    $0x1,%ecx
8010493a:	85 db                	test   %ebx,%ebx
8010493c:	7f e2                	jg     80104920 <strncpy+0x10>
    ;
  while(n-- > 0)
8010493e:	89 c2                	mov    %eax,%edx
80104940:	85 c9                	test   %ecx,%ecx
80104942:	7e 17                	jle    8010495b <strncpy+0x4b>
80104944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104948:	83 c2 01             	add    $0x1,%edx
8010494b:	89 c1                	mov    %eax,%ecx
8010494d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104951:	29 d1                	sub    %edx,%ecx
80104953:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104957:	85 c9                	test   %ecx,%ecx
80104959:	7f ed                	jg     80104948 <strncpy+0x38>
  return os;
}
8010495b:	5b                   	pop    %ebx
8010495c:	89 f0                	mov    %esi,%eax
8010495e:	5e                   	pop    %esi
8010495f:	5f                   	pop    %edi
80104960:	5d                   	pop    %ebp
80104961:	c3                   	ret    
80104962:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104970 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	8b 55 10             	mov    0x10(%ebp),%edx
80104977:	8b 75 08             	mov    0x8(%ebp),%esi
8010497a:	53                   	push   %ebx
8010497b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010497e:	85 d2                	test   %edx,%edx
80104980:	7e 25                	jle    801049a7 <safestrcpy+0x37>
80104982:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104986:	89 f2                	mov    %esi,%edx
80104988:	eb 16                	jmp    801049a0 <safestrcpy+0x30>
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104990:	0f b6 08             	movzbl (%eax),%ecx
80104993:	83 c0 01             	add    $0x1,%eax
80104996:	83 c2 01             	add    $0x1,%edx
80104999:	88 4a ff             	mov    %cl,-0x1(%edx)
8010499c:	84 c9                	test   %cl,%cl
8010499e:	74 04                	je     801049a4 <safestrcpy+0x34>
801049a0:	39 d8                	cmp    %ebx,%eax
801049a2:	75 ec                	jne    80104990 <safestrcpy+0x20>
    ;
  *s = 0;
801049a4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801049a7:	89 f0                	mov    %esi,%eax
801049a9:	5b                   	pop    %ebx
801049aa:	5e                   	pop    %esi
801049ab:	5d                   	pop    %ebp
801049ac:	c3                   	ret    
801049ad:	8d 76 00             	lea    0x0(%esi),%esi

801049b0 <strlen>:

int
strlen(const char *s)
{
801049b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049b1:	31 c0                	xor    %eax,%eax
{
801049b3:	89 e5                	mov    %esp,%ebp
801049b5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049b8:	80 3a 00             	cmpb   $0x0,(%edx)
801049bb:	74 0c                	je     801049c9 <strlen+0x19>
801049bd:	8d 76 00             	lea    0x0(%esi),%esi
801049c0:	83 c0 01             	add    $0x1,%eax
801049c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049c7:	75 f7                	jne    801049c0 <strlen+0x10>
    ;
  return n;
}
801049c9:	5d                   	pop    %ebp
801049ca:	c3                   	ret    

801049cb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801049cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801049cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801049d3:	55                   	push   %ebp
  pushl %ebx
801049d4:	53                   	push   %ebx
  pushl %esi
801049d5:	56                   	push   %esi
  pushl %edi
801049d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801049d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801049d9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801049db:	5f                   	pop    %edi
  popl %esi
801049dc:	5e                   	pop    %esi
  popl %ebx
801049dd:	5b                   	pop    %ebx
  popl %ebp
801049de:	5d                   	pop    %ebp
  ret
801049df:	c3                   	ret    

801049e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	53                   	push   %ebx
801049e4:	83 ec 04             	sub    $0x4,%esp
801049e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049ea:	e8 b1 ef ff ff       	call   801039a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049ef:	8b 00                	mov    (%eax),%eax
801049f1:	39 d8                	cmp    %ebx,%eax
801049f3:	76 1b                	jbe    80104a10 <fetchint+0x30>
801049f5:	8d 53 04             	lea    0x4(%ebx),%edx
801049f8:	39 d0                	cmp    %edx,%eax
801049fa:	72 14                	jb     80104a10 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ff:	8b 13                	mov    (%ebx),%edx
80104a01:	89 10                	mov    %edx,(%eax)
  return 0;
80104a03:	31 c0                	xor    %eax,%eax
}
80104a05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a08:	c9                   	leave  
80104a09:	c3                   	ret    
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a15:	eb ee                	jmp    80104a05 <fetchint+0x25>
80104a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	53                   	push   %ebx
80104a24:	83 ec 04             	sub    $0x4,%esp
80104a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a2a:	e8 71 ef ff ff       	call   801039a0 <myproc>

  if(addr >= curproc->sz)
80104a2f:	39 18                	cmp    %ebx,(%eax)
80104a31:	76 2d                	jbe    80104a60 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a33:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a36:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a38:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a3a:	39 d3                	cmp    %edx,%ebx
80104a3c:	73 22                	jae    80104a60 <fetchstr+0x40>
80104a3e:	89 d8                	mov    %ebx,%eax
80104a40:	eb 0d                	jmp    80104a4f <fetchstr+0x2f>
80104a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a48:	83 c0 01             	add    $0x1,%eax
80104a4b:	39 c2                	cmp    %eax,%edx
80104a4d:	76 11                	jbe    80104a60 <fetchstr+0x40>
    if(*s == 0)
80104a4f:	80 38 00             	cmpb   $0x0,(%eax)
80104a52:	75 f4                	jne    80104a48 <fetchstr+0x28>
      return s - *pp;
80104a54:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a59:	c9                   	leave  
80104a5a:	c3                   	ret    
80104a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a5f:	90                   	nop
80104a60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104a63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a68:	c9                   	leave  
80104a69:	c3                   	ret    
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a75:	e8 26 ef ff ff       	call   801039a0 <myproc>
80104a7a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a7d:	8b 40 18             	mov    0x18(%eax),%eax
80104a80:	8b 40 44             	mov    0x44(%eax),%eax
80104a83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a86:	e8 15 ef ff ff       	call   801039a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a8b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a8e:	8b 00                	mov    (%eax),%eax
80104a90:	39 c6                	cmp    %eax,%esi
80104a92:	73 1c                	jae    80104ab0 <argint+0x40>
80104a94:	8d 53 08             	lea    0x8(%ebx),%edx
80104a97:	39 d0                	cmp    %edx,%eax
80104a99:	72 15                	jb     80104ab0 <argint+0x40>
  *ip = *(int*)(addr);
80104a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104aa1:	89 10                	mov    %edx,(%eax)
  return 0;
80104aa3:	31 c0                	xor    %eax,%eax
}
80104aa5:	5b                   	pop    %ebx
80104aa6:	5e                   	pop    %esi
80104aa7:	5d                   	pop    %ebp
80104aa8:	c3                   	ret    
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ab5:	eb ee                	jmp    80104aa5 <argint+0x35>
80104ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abe:	66 90                	xchg   %ax,%ax

80104ac0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	53                   	push   %ebx
80104ac6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104ac9:	e8 d2 ee ff ff       	call   801039a0 <myproc>
80104ace:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ad0:	e8 cb ee ff ff       	call   801039a0 <myproc>
80104ad5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ad8:	8b 40 18             	mov    0x18(%eax),%eax
80104adb:	8b 40 44             	mov    0x44(%eax),%eax
80104ade:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ae1:	e8 ba ee ff ff       	call   801039a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ae6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ae9:	8b 00                	mov    (%eax),%eax
80104aeb:	39 c7                	cmp    %eax,%edi
80104aed:	73 39                	jae    80104b28 <argptr+0x68>
80104aef:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104af2:	39 c8                	cmp    %ecx,%eax
80104af4:	72 32                	jb     80104b28 <argptr+0x68>
 
  if(argint(n, &i) < 0 || i==0)
    return -1;
    
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104af6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104af9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104afc:	85 d2                	test   %edx,%edx
80104afe:	78 28                	js     80104b28 <argptr+0x68>
80104b00:	85 c0                	test   %eax,%eax
80104b02:	74 24                	je     80104b28 <argptr+0x68>
80104b04:	8b 16                	mov    (%esi),%edx
80104b06:	39 c2                	cmp    %eax,%edx
80104b08:	76 1e                	jbe    80104b28 <argptr+0x68>
80104b0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b0d:	01 c3                	add    %eax,%ebx
80104b0f:	39 da                	cmp    %ebx,%edx
80104b11:	72 15                	jb     80104b28 <argptr+0x68>
    return -1;
  *pp = (char*)i;
80104b13:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b16:	89 02                	mov    %eax,(%edx)
  return 0;
80104b18:	31 c0                	xor    %eax,%eax
}
80104b1a:	83 c4 0c             	add    $0xc,%esp
80104b1d:	5b                   	pop    %ebx
80104b1e:	5e                   	pop    %esi
80104b1f:	5f                   	pop    %edi
80104b20:	5d                   	pop    %ebp
80104b21:	c3                   	ret    
80104b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b2d:	eb eb                	jmp    80104b1a <argptr+0x5a>
80104b2f:	90                   	nop

80104b30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	56                   	push   %esi
80104b34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b35:	e8 66 ee ff ff       	call   801039a0 <myproc>
80104b3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b3d:	8b 40 18             	mov    0x18(%eax),%eax
80104b40:	8b 40 44             	mov    0x44(%eax),%eax
80104b43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b46:	e8 55 ee ff ff       	call   801039a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b4e:	8b 00                	mov    (%eax),%eax
80104b50:	39 c6                	cmp    %eax,%esi
80104b52:	73 44                	jae    80104b98 <argstr+0x68>
80104b54:	8d 53 08             	lea    0x8(%ebx),%edx
80104b57:	39 d0                	cmp    %edx,%eax
80104b59:	72 3d                	jb     80104b98 <argstr+0x68>
  *ip = *(int*)(addr);
80104b5b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104b5e:	e8 3d ee ff ff       	call   801039a0 <myproc>
  if(addr >= curproc->sz)
80104b63:	3b 18                	cmp    (%eax),%ebx
80104b65:	73 31                	jae    80104b98 <argstr+0x68>
  *pp = (char*)addr;
80104b67:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b6a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b6c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b6e:	39 d3                	cmp    %edx,%ebx
80104b70:	73 26                	jae    80104b98 <argstr+0x68>
80104b72:	89 d8                	mov    %ebx,%eax
80104b74:	eb 11                	jmp    80104b87 <argstr+0x57>
80104b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi
80104b80:	83 c0 01             	add    $0x1,%eax
80104b83:	39 c2                	cmp    %eax,%edx
80104b85:	76 11                	jbe    80104b98 <argstr+0x68>
    if(*s == 0)
80104b87:	80 38 00             	cmpb   $0x0,(%eax)
80104b8a:	75 f4                	jne    80104b80 <argstr+0x50>
      return s - *pp;
80104b8c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104b8e:	5b                   	pop    %ebx
80104b8f:	5e                   	pop    %esi
80104b90:	5d                   	pop    %ebp
80104b91:	c3                   	ret    
80104b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b98:	5b                   	pop    %ebx
    return -1;
80104b99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b9e:	5e                   	pop    %esi
80104b9f:	5d                   	pop    %ebp
80104ba0:	c3                   	ret    
80104ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104baf:	90                   	nop

80104bb0 <syscall>:
[SYS_munprotect] sys_munprotect,
};

void
syscall(void)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104bb7:	e8 e4 ed ff ff       	call   801039a0 <myproc>
80104bbc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104bbe:	8b 40 18             	mov    0x18(%eax),%eax
80104bc1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104bc4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104bc7:	83 fa 18             	cmp    $0x18,%edx
80104bca:	77 24                	ja     80104bf0 <syscall+0x40>
80104bcc:	8b 14 85 a0 7b 10 80 	mov    -0x7fef8460(,%eax,4),%edx
80104bd3:	85 d2                	test   %edx,%edx
80104bd5:	74 19                	je     80104bf0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104bd7:	ff d2                	call   *%edx
80104bd9:	89 c2                	mov    %eax,%edx
80104bdb:	8b 43 18             	mov    0x18(%ebx),%eax
80104bde:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104be1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104be4:	c9                   	leave  
80104be5:	c3                   	ret    
80104be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bed:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104bf0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104bf1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104bf4:	50                   	push   %eax
80104bf5:	ff 73 10             	push   0x10(%ebx)
80104bf8:	68 7d 7b 10 80       	push   $0x80107b7d
80104bfd:	e8 9e ba ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104c02:	8b 43 18             	mov    0x18(%ebx),%eax
80104c05:	83 c4 10             	add    $0x10,%esp
80104c08:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c12:	c9                   	leave  
80104c13:	c3                   	ret    
80104c14:	66 90                	xchg   %ax,%ax
80104c16:	66 90                	xchg   %ax,%ax
80104c18:	66 90                	xchg   %ax,%ax
80104c1a:	66 90                	xchg   %ax,%ax
80104c1c:	66 90                	xchg   %ax,%ax
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	57                   	push   %edi
80104c24:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c25:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c28:	53                   	push   %ebx
80104c29:	83 ec 34             	sub    $0x34,%esp
80104c2c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104c32:	57                   	push   %edi
80104c33:	50                   	push   %eax
{
80104c34:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c37:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c3a:	e8 91 d4 ff ff       	call   801020d0 <nameiparent>
80104c3f:	83 c4 10             	add    $0x10,%esp
80104c42:	85 c0                	test   %eax,%eax
80104c44:	0f 84 46 01 00 00    	je     80104d90 <create+0x170>
    return 0;
  ilock(dp);
80104c4a:	83 ec 0c             	sub    $0xc,%esp
80104c4d:	89 c3                	mov    %eax,%ebx
80104c4f:	50                   	push   %eax
80104c50:	e8 3b cb ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c55:	83 c4 0c             	add    $0xc,%esp
80104c58:	6a 00                	push   $0x0
80104c5a:	57                   	push   %edi
80104c5b:	53                   	push   %ebx
80104c5c:	e8 8f d0 ff ff       	call   80101cf0 <dirlookup>
80104c61:	83 c4 10             	add    $0x10,%esp
80104c64:	89 c6                	mov    %eax,%esi
80104c66:	85 c0                	test   %eax,%eax
80104c68:	74 56                	je     80104cc0 <create+0xa0>
    iunlockput(dp);
80104c6a:	83 ec 0c             	sub    $0xc,%esp
80104c6d:	53                   	push   %ebx
80104c6e:	e8 ad cd ff ff       	call   80101a20 <iunlockput>
    ilock(ip);
80104c73:	89 34 24             	mov    %esi,(%esp)
80104c76:	e8 15 cb ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c7b:	83 c4 10             	add    $0x10,%esp
80104c7e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104c83:	75 1b                	jne    80104ca0 <create+0x80>
80104c85:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c8a:	75 14                	jne    80104ca0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c8f:	89 f0                	mov    %esi,%eax
80104c91:	5b                   	pop    %ebx
80104c92:	5e                   	pop    %esi
80104c93:	5f                   	pop    %edi
80104c94:	5d                   	pop    %ebp
80104c95:	c3                   	ret    
80104c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104ca0:	83 ec 0c             	sub    $0xc,%esp
80104ca3:	56                   	push   %esi
    return 0;
80104ca4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104ca6:	e8 75 cd ff ff       	call   80101a20 <iunlockput>
    return 0;
80104cab:	83 c4 10             	add    $0x10,%esp
}
80104cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cb1:	89 f0                	mov    %esi,%eax
80104cb3:	5b                   	pop    %ebx
80104cb4:	5e                   	pop    %esi
80104cb5:	5f                   	pop    %edi
80104cb6:	5d                   	pop    %ebp
80104cb7:	c3                   	ret    
80104cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104cc0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104cc4:	83 ec 08             	sub    $0x8,%esp
80104cc7:	50                   	push   %eax
80104cc8:	ff 33                	push   (%ebx)
80104cca:	e8 51 c9 ff ff       	call   80101620 <ialloc>
80104ccf:	83 c4 10             	add    $0x10,%esp
80104cd2:	89 c6                	mov    %eax,%esi
80104cd4:	85 c0                	test   %eax,%eax
80104cd6:	0f 84 cd 00 00 00    	je     80104da9 <create+0x189>
  ilock(ip);
80104cdc:	83 ec 0c             	sub    $0xc,%esp
80104cdf:	50                   	push   %eax
80104ce0:	e8 ab ca ff ff       	call   80101790 <ilock>
  ip->major = major;
80104ce5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ce9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104ced:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104cf1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104cf5:	b8 01 00 00 00       	mov    $0x1,%eax
80104cfa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104cfe:	89 34 24             	mov    %esi,(%esp)
80104d01:	e8 da c9 ff ff       	call   801016e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d06:	83 c4 10             	add    $0x10,%esp
80104d09:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d0e:	74 30                	je     80104d40 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d10:	83 ec 04             	sub    $0x4,%esp
80104d13:	ff 76 04             	push   0x4(%esi)
80104d16:	57                   	push   %edi
80104d17:	53                   	push   %ebx
80104d18:	e8 d3 d2 ff ff       	call   80101ff0 <dirlink>
80104d1d:	83 c4 10             	add    $0x10,%esp
80104d20:	85 c0                	test   %eax,%eax
80104d22:	78 78                	js     80104d9c <create+0x17c>
  iunlockput(dp);
80104d24:	83 ec 0c             	sub    $0xc,%esp
80104d27:	53                   	push   %ebx
80104d28:	e8 f3 cc ff ff       	call   80101a20 <iunlockput>
  return ip;
80104d2d:	83 c4 10             	add    $0x10,%esp
}
80104d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d33:	89 f0                	mov    %esi,%eax
80104d35:	5b                   	pop    %ebx
80104d36:	5e                   	pop    %esi
80104d37:	5f                   	pop    %edi
80104d38:	5d                   	pop    %ebp
80104d39:	c3                   	ret    
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104d40:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d43:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d48:	53                   	push   %ebx
80104d49:	e8 92 c9 ff ff       	call   801016e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d4e:	83 c4 0c             	add    $0xc,%esp
80104d51:	ff 76 04             	push   0x4(%esi)
80104d54:	68 24 7c 10 80       	push   $0x80107c24
80104d59:	56                   	push   %esi
80104d5a:	e8 91 d2 ff ff       	call   80101ff0 <dirlink>
80104d5f:	83 c4 10             	add    $0x10,%esp
80104d62:	85 c0                	test   %eax,%eax
80104d64:	78 18                	js     80104d7e <create+0x15e>
80104d66:	83 ec 04             	sub    $0x4,%esp
80104d69:	ff 73 04             	push   0x4(%ebx)
80104d6c:	68 23 7c 10 80       	push   $0x80107c23
80104d71:	56                   	push   %esi
80104d72:	e8 79 d2 ff ff       	call   80101ff0 <dirlink>
80104d77:	83 c4 10             	add    $0x10,%esp
80104d7a:	85 c0                	test   %eax,%eax
80104d7c:	79 92                	jns    80104d10 <create+0xf0>
      panic("create dots");
80104d7e:	83 ec 0c             	sub    $0xc,%esp
80104d81:	68 17 7c 10 80       	push   $0x80107c17
80104d86:	e8 f5 b5 ff ff       	call   80100380 <panic>
80104d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d8f:	90                   	nop
}
80104d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d93:	31 f6                	xor    %esi,%esi
}
80104d95:	5b                   	pop    %ebx
80104d96:	89 f0                	mov    %esi,%eax
80104d98:	5e                   	pop    %esi
80104d99:	5f                   	pop    %edi
80104d9a:	5d                   	pop    %ebp
80104d9b:	c3                   	ret    
    panic("create: dirlink");
80104d9c:	83 ec 0c             	sub    $0xc,%esp
80104d9f:	68 26 7c 10 80       	push   $0x80107c26
80104da4:	e8 d7 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104da9:	83 ec 0c             	sub    $0xc,%esp
80104dac:	68 08 7c 10 80       	push   $0x80107c08
80104db1:	e8 ca b5 ff ff       	call   80100380 <panic>
80104db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dbd:	8d 76 00             	lea    0x0(%esi),%esi

80104dc0 <sys_dup>:
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	56                   	push   %esi
80104dc4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104dc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104dc8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104dcb:	50                   	push   %eax
80104dcc:	6a 00                	push   $0x0
80104dce:	e8 9d fc ff ff       	call   80104a70 <argint>
80104dd3:	83 c4 10             	add    $0x10,%esp
80104dd6:	85 c0                	test   %eax,%eax
80104dd8:	78 36                	js     80104e10 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dde:	77 30                	ja     80104e10 <sys_dup+0x50>
80104de0:	e8 bb eb ff ff       	call   801039a0 <myproc>
80104de5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104de8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104dec:	85 f6                	test   %esi,%esi
80104dee:	74 20                	je     80104e10 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104df0:	e8 ab eb ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104df5:	31 db                	xor    %ebx,%ebx
80104df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104e00:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e04:	85 d2                	test   %edx,%edx
80104e06:	74 18                	je     80104e20 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104e08:	83 c3 01             	add    $0x1,%ebx
80104e0b:	83 fb 10             	cmp    $0x10,%ebx
80104e0e:	75 f0                	jne    80104e00 <sys_dup+0x40>
}
80104e10:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e13:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e18:	89 d8                	mov    %ebx,%eax
80104e1a:	5b                   	pop    %ebx
80104e1b:	5e                   	pop    %esi
80104e1c:	5d                   	pop    %ebp
80104e1d:	c3                   	ret    
80104e1e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104e20:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104e23:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e27:	56                   	push   %esi
80104e28:	e8 83 c0 ff ff       	call   80100eb0 <filedup>
  return fd;
80104e2d:	83 c4 10             	add    $0x10,%esp
}
80104e30:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e33:	89 d8                	mov    %ebx,%eax
80104e35:	5b                   	pop    %ebx
80104e36:	5e                   	pop    %esi
80104e37:	5d                   	pop    %ebp
80104e38:	c3                   	ret    
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e40 <sys_read>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e45:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e4b:	53                   	push   %ebx
80104e4c:	6a 00                	push   $0x0
80104e4e:	e8 1d fc ff ff       	call   80104a70 <argint>
80104e53:	83 c4 10             	add    $0x10,%esp
80104e56:	85 c0                	test   %eax,%eax
80104e58:	78 5e                	js     80104eb8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e5e:	77 58                	ja     80104eb8 <sys_read+0x78>
80104e60:	e8 3b eb ff ff       	call   801039a0 <myproc>
80104e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e68:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e6c:	85 f6                	test   %esi,%esi
80104e6e:	74 48                	je     80104eb8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e70:	83 ec 08             	sub    $0x8,%esp
80104e73:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e76:	50                   	push   %eax
80104e77:	6a 02                	push   $0x2
80104e79:	e8 f2 fb ff ff       	call   80104a70 <argint>
80104e7e:	83 c4 10             	add    $0x10,%esp
80104e81:	85 c0                	test   %eax,%eax
80104e83:	78 33                	js     80104eb8 <sys_read+0x78>
80104e85:	83 ec 04             	sub    $0x4,%esp
80104e88:	ff 75 f0             	push   -0x10(%ebp)
80104e8b:	53                   	push   %ebx
80104e8c:	6a 01                	push   $0x1
80104e8e:	e8 2d fc ff ff       	call   80104ac0 <argptr>
80104e93:	83 c4 10             	add    $0x10,%esp
80104e96:	85 c0                	test   %eax,%eax
80104e98:	78 1e                	js     80104eb8 <sys_read+0x78>
  return fileread(f, p, n);
80104e9a:	83 ec 04             	sub    $0x4,%esp
80104e9d:	ff 75 f0             	push   -0x10(%ebp)
80104ea0:	ff 75 f4             	push   -0xc(%ebp)
80104ea3:	56                   	push   %esi
80104ea4:	e8 87 c1 ff ff       	call   80101030 <fileread>
80104ea9:	83 c4 10             	add    $0x10,%esp
}
80104eac:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eaf:	5b                   	pop    %ebx
80104eb0:	5e                   	pop    %esi
80104eb1:	5d                   	pop    %ebp
80104eb2:	c3                   	ret    
80104eb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eb7:	90                   	nop
    return -1;
80104eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ebd:	eb ed                	jmp    80104eac <sys_read+0x6c>
80104ebf:	90                   	nop

80104ec0 <sys_write>:
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ec5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ec8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ecb:	53                   	push   %ebx
80104ecc:	6a 00                	push   $0x0
80104ece:	e8 9d fb ff ff       	call   80104a70 <argint>
80104ed3:	83 c4 10             	add    $0x10,%esp
80104ed6:	85 c0                	test   %eax,%eax
80104ed8:	78 5e                	js     80104f38 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ede:	77 58                	ja     80104f38 <sys_write+0x78>
80104ee0:	e8 bb ea ff ff       	call   801039a0 <myproc>
80104ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ee8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104eec:	85 f6                	test   %esi,%esi
80104eee:	74 48                	je     80104f38 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ef0:	83 ec 08             	sub    $0x8,%esp
80104ef3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ef6:	50                   	push   %eax
80104ef7:	6a 02                	push   $0x2
80104ef9:	e8 72 fb ff ff       	call   80104a70 <argint>
80104efe:	83 c4 10             	add    $0x10,%esp
80104f01:	85 c0                	test   %eax,%eax
80104f03:	78 33                	js     80104f38 <sys_write+0x78>
80104f05:	83 ec 04             	sub    $0x4,%esp
80104f08:	ff 75 f0             	push   -0x10(%ebp)
80104f0b:	53                   	push   %ebx
80104f0c:	6a 01                	push   $0x1
80104f0e:	e8 ad fb ff ff       	call   80104ac0 <argptr>
80104f13:	83 c4 10             	add    $0x10,%esp
80104f16:	85 c0                	test   %eax,%eax
80104f18:	78 1e                	js     80104f38 <sys_write+0x78>
  return filewrite(f, p, n);
80104f1a:	83 ec 04             	sub    $0x4,%esp
80104f1d:	ff 75 f0             	push   -0x10(%ebp)
80104f20:	ff 75 f4             	push   -0xc(%ebp)
80104f23:	56                   	push   %esi
80104f24:	e8 97 c1 ff ff       	call   801010c0 <filewrite>
80104f29:	83 c4 10             	add    $0x10,%esp
}
80104f2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f2f:	5b                   	pop    %ebx
80104f30:	5e                   	pop    %esi
80104f31:	5d                   	pop    %ebp
80104f32:	c3                   	ret    
80104f33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f37:	90                   	nop
    return -1;
80104f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f3d:	eb ed                	jmp    80104f2c <sys_write+0x6c>
80104f3f:	90                   	nop

80104f40 <sys_close>:
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f45:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f4b:	50                   	push   %eax
80104f4c:	6a 00                	push   $0x0
80104f4e:	e8 1d fb ff ff       	call   80104a70 <argint>
80104f53:	83 c4 10             	add    $0x10,%esp
80104f56:	85 c0                	test   %eax,%eax
80104f58:	78 3e                	js     80104f98 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f5e:	77 38                	ja     80104f98 <sys_close+0x58>
80104f60:	e8 3b ea ff ff       	call   801039a0 <myproc>
80104f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f68:	8d 5a 08             	lea    0x8(%edx),%ebx
80104f6b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104f6f:	85 f6                	test   %esi,%esi
80104f71:	74 25                	je     80104f98 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104f73:	e8 28 ea ff ff       	call   801039a0 <myproc>
  fileclose(f);
80104f78:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f7b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104f82:	00 
  fileclose(f);
80104f83:	56                   	push   %esi
80104f84:	e8 77 bf ff ff       	call   80100f00 <fileclose>
  return 0;
80104f89:	83 c4 10             	add    $0x10,%esp
80104f8c:	31 c0                	xor    %eax,%eax
}
80104f8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f91:	5b                   	pop    %ebx
80104f92:	5e                   	pop    %esi
80104f93:	5d                   	pop    %ebp
80104f94:	c3                   	ret    
80104f95:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9d:	eb ef                	jmp    80104f8e <sys_close+0x4e>
80104f9f:	90                   	nop

80104fa0 <sys_fstat>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fa5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fa8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fab:	53                   	push   %ebx
80104fac:	6a 00                	push   $0x0
80104fae:	e8 bd fa ff ff       	call   80104a70 <argint>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 46                	js     80105000 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fbe:	77 40                	ja     80105000 <sys_fstat+0x60>
80104fc0:	e8 db e9 ff ff       	call   801039a0 <myproc>
80104fc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fcc:	85 f6                	test   %esi,%esi
80104fce:	74 30                	je     80105000 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104fd0:	83 ec 04             	sub    $0x4,%esp
80104fd3:	6a 14                	push   $0x14
80104fd5:	53                   	push   %ebx
80104fd6:	6a 01                	push   $0x1
80104fd8:	e8 e3 fa ff ff       	call   80104ac0 <argptr>
80104fdd:	83 c4 10             	add    $0x10,%esp
80104fe0:	85 c0                	test   %eax,%eax
80104fe2:	78 1c                	js     80105000 <sys_fstat+0x60>
  return filestat(f, st);
80104fe4:	83 ec 08             	sub    $0x8,%esp
80104fe7:	ff 75 f4             	push   -0xc(%ebp)
80104fea:	56                   	push   %esi
80104feb:	e8 f0 bf ff ff       	call   80100fe0 <filestat>
80104ff0:	83 c4 10             	add    $0x10,%esp
}
80104ff3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ff6:	5b                   	pop    %ebx
80104ff7:	5e                   	pop    %esi
80104ff8:	5d                   	pop    %ebp
80104ff9:	c3                   	ret    
80104ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105005:	eb ec                	jmp    80104ff3 <sys_fstat+0x53>
80105007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500e:	66 90                	xchg   %ax,%ax

80105010 <sys_link>:
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	57                   	push   %edi
80105014:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105015:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105018:	53                   	push   %ebx
80105019:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010501c:	50                   	push   %eax
8010501d:	6a 00                	push   $0x0
8010501f:	e8 0c fb ff ff       	call   80104b30 <argstr>
80105024:	83 c4 10             	add    $0x10,%esp
80105027:	85 c0                	test   %eax,%eax
80105029:	0f 88 fb 00 00 00    	js     8010512a <sys_link+0x11a>
8010502f:	83 ec 08             	sub    $0x8,%esp
80105032:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105035:	50                   	push   %eax
80105036:	6a 01                	push   $0x1
80105038:	e8 f3 fa ff ff       	call   80104b30 <argstr>
8010503d:	83 c4 10             	add    $0x10,%esp
80105040:	85 c0                	test   %eax,%eax
80105042:	0f 88 e2 00 00 00    	js     8010512a <sys_link+0x11a>
  begin_op();
80105048:	e8 23 dd ff ff       	call   80102d70 <begin_op>
  if((ip = namei(old)) == 0){
8010504d:	83 ec 0c             	sub    $0xc,%esp
80105050:	ff 75 d4             	push   -0x2c(%ebp)
80105053:	e8 58 d0 ff ff       	call   801020b0 <namei>
80105058:	83 c4 10             	add    $0x10,%esp
8010505b:	89 c3                	mov    %eax,%ebx
8010505d:	85 c0                	test   %eax,%eax
8010505f:	0f 84 e4 00 00 00    	je     80105149 <sys_link+0x139>
  ilock(ip);
80105065:	83 ec 0c             	sub    $0xc,%esp
80105068:	50                   	push   %eax
80105069:	e8 22 c7 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
8010506e:	83 c4 10             	add    $0x10,%esp
80105071:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105076:	0f 84 b5 00 00 00    	je     80105131 <sys_link+0x121>
  iupdate(ip);
8010507c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010507f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105084:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105087:	53                   	push   %ebx
80105088:	e8 53 c6 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
8010508d:	89 1c 24             	mov    %ebx,(%esp)
80105090:	e8 db c7 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105095:	58                   	pop    %eax
80105096:	5a                   	pop    %edx
80105097:	57                   	push   %edi
80105098:	ff 75 d0             	push   -0x30(%ebp)
8010509b:	e8 30 d0 ff ff       	call   801020d0 <nameiparent>
801050a0:	83 c4 10             	add    $0x10,%esp
801050a3:	89 c6                	mov    %eax,%esi
801050a5:	85 c0                	test   %eax,%eax
801050a7:	74 5b                	je     80105104 <sys_link+0xf4>
  ilock(dp);
801050a9:	83 ec 0c             	sub    $0xc,%esp
801050ac:	50                   	push   %eax
801050ad:	e8 de c6 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801050b2:	8b 03                	mov    (%ebx),%eax
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	39 06                	cmp    %eax,(%esi)
801050b9:	75 3d                	jne    801050f8 <sys_link+0xe8>
801050bb:	83 ec 04             	sub    $0x4,%esp
801050be:	ff 73 04             	push   0x4(%ebx)
801050c1:	57                   	push   %edi
801050c2:	56                   	push   %esi
801050c3:	e8 28 cf ff ff       	call   80101ff0 <dirlink>
801050c8:	83 c4 10             	add    $0x10,%esp
801050cb:	85 c0                	test   %eax,%eax
801050cd:	78 29                	js     801050f8 <sys_link+0xe8>
  iunlockput(dp);
801050cf:	83 ec 0c             	sub    $0xc,%esp
801050d2:	56                   	push   %esi
801050d3:	e8 48 c9 ff ff       	call   80101a20 <iunlockput>
  iput(ip);
801050d8:	89 1c 24             	mov    %ebx,(%esp)
801050db:	e8 e0 c7 ff ff       	call   801018c0 <iput>
  end_op();
801050e0:	e8 fb dc ff ff       	call   80102de0 <end_op>
  return 0;
801050e5:	83 c4 10             	add    $0x10,%esp
801050e8:	31 c0                	xor    %eax,%eax
}
801050ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050ed:	5b                   	pop    %ebx
801050ee:	5e                   	pop    %esi
801050ef:	5f                   	pop    %edi
801050f0:	5d                   	pop    %ebp
801050f1:	c3                   	ret    
801050f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801050f8:	83 ec 0c             	sub    $0xc,%esp
801050fb:	56                   	push   %esi
801050fc:	e8 1f c9 ff ff       	call   80101a20 <iunlockput>
    goto bad;
80105101:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105104:	83 ec 0c             	sub    $0xc,%esp
80105107:	53                   	push   %ebx
80105108:	e8 83 c6 ff ff       	call   80101790 <ilock>
  ip->nlink--;
8010510d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105112:	89 1c 24             	mov    %ebx,(%esp)
80105115:	e8 c6 c5 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
8010511a:	89 1c 24             	mov    %ebx,(%esp)
8010511d:	e8 fe c8 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105122:	e8 b9 dc ff ff       	call   80102de0 <end_op>
  return -1;
80105127:	83 c4 10             	add    $0x10,%esp
8010512a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010512f:	eb b9                	jmp    801050ea <sys_link+0xda>
    iunlockput(ip);
80105131:	83 ec 0c             	sub    $0xc,%esp
80105134:	53                   	push   %ebx
80105135:	e8 e6 c8 ff ff       	call   80101a20 <iunlockput>
    end_op();
8010513a:	e8 a1 dc ff ff       	call   80102de0 <end_op>
    return -1;
8010513f:	83 c4 10             	add    $0x10,%esp
80105142:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105147:	eb a1                	jmp    801050ea <sys_link+0xda>
    end_op();
80105149:	e8 92 dc ff ff       	call   80102de0 <end_op>
    return -1;
8010514e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105153:	eb 95                	jmp    801050ea <sys_link+0xda>
80105155:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105160 <sys_unlink>:
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	57                   	push   %edi
80105164:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105165:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105168:	53                   	push   %ebx
80105169:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010516c:	50                   	push   %eax
8010516d:	6a 00                	push   $0x0
8010516f:	e8 bc f9 ff ff       	call   80104b30 <argstr>
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
80105179:	0f 88 7a 01 00 00    	js     801052f9 <sys_unlink+0x199>
  begin_op();
8010517f:	e8 ec db ff ff       	call   80102d70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105184:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105187:	83 ec 08             	sub    $0x8,%esp
8010518a:	53                   	push   %ebx
8010518b:	ff 75 c0             	push   -0x40(%ebp)
8010518e:	e8 3d cf ff ff       	call   801020d0 <nameiparent>
80105193:	83 c4 10             	add    $0x10,%esp
80105196:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105199:	85 c0                	test   %eax,%eax
8010519b:	0f 84 62 01 00 00    	je     80105303 <sys_unlink+0x1a3>
  ilock(dp);
801051a1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801051a4:	83 ec 0c             	sub    $0xc,%esp
801051a7:	57                   	push   %edi
801051a8:	e8 e3 c5 ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801051ad:	58                   	pop    %eax
801051ae:	5a                   	pop    %edx
801051af:	68 24 7c 10 80       	push   $0x80107c24
801051b4:	53                   	push   %ebx
801051b5:	e8 16 cb ff ff       	call   80101cd0 <namecmp>
801051ba:	83 c4 10             	add    $0x10,%esp
801051bd:	85 c0                	test   %eax,%eax
801051bf:	0f 84 fb 00 00 00    	je     801052c0 <sys_unlink+0x160>
801051c5:	83 ec 08             	sub    $0x8,%esp
801051c8:	68 23 7c 10 80       	push   $0x80107c23
801051cd:	53                   	push   %ebx
801051ce:	e8 fd ca ff ff       	call   80101cd0 <namecmp>
801051d3:	83 c4 10             	add    $0x10,%esp
801051d6:	85 c0                	test   %eax,%eax
801051d8:	0f 84 e2 00 00 00    	je     801052c0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801051de:	83 ec 04             	sub    $0x4,%esp
801051e1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801051e4:	50                   	push   %eax
801051e5:	53                   	push   %ebx
801051e6:	57                   	push   %edi
801051e7:	e8 04 cb ff ff       	call   80101cf0 <dirlookup>
801051ec:	83 c4 10             	add    $0x10,%esp
801051ef:	89 c3                	mov    %eax,%ebx
801051f1:	85 c0                	test   %eax,%eax
801051f3:	0f 84 c7 00 00 00    	je     801052c0 <sys_unlink+0x160>
  ilock(ip);
801051f9:	83 ec 0c             	sub    $0xc,%esp
801051fc:	50                   	push   %eax
801051fd:	e8 8e c5 ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
80105202:	83 c4 10             	add    $0x10,%esp
80105205:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010520a:	0f 8e 1c 01 00 00    	jle    8010532c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105210:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105215:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105218:	74 66                	je     80105280 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010521a:	83 ec 04             	sub    $0x4,%esp
8010521d:	6a 10                	push   $0x10
8010521f:	6a 00                	push   $0x0
80105221:	57                   	push   %edi
80105222:	e8 89 f5 ff ff       	call   801047b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105227:	6a 10                	push   $0x10
80105229:	ff 75 c4             	push   -0x3c(%ebp)
8010522c:	57                   	push   %edi
8010522d:	ff 75 b4             	push   -0x4c(%ebp)
80105230:	e8 6b c9 ff ff       	call   80101ba0 <writei>
80105235:	83 c4 20             	add    $0x20,%esp
80105238:	83 f8 10             	cmp    $0x10,%eax
8010523b:	0f 85 de 00 00 00    	jne    8010531f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105241:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105246:	0f 84 94 00 00 00    	je     801052e0 <sys_unlink+0x180>
  iunlockput(dp);
8010524c:	83 ec 0c             	sub    $0xc,%esp
8010524f:	ff 75 b4             	push   -0x4c(%ebp)
80105252:	e8 c9 c7 ff ff       	call   80101a20 <iunlockput>
  ip->nlink--;
80105257:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010525c:	89 1c 24             	mov    %ebx,(%esp)
8010525f:	e8 7c c4 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
80105264:	89 1c 24             	mov    %ebx,(%esp)
80105267:	e8 b4 c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
8010526c:	e8 6f db ff ff       	call   80102de0 <end_op>
  return 0;
80105271:	83 c4 10             	add    $0x10,%esp
80105274:	31 c0                	xor    %eax,%eax
}
80105276:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105279:	5b                   	pop    %ebx
8010527a:	5e                   	pop    %esi
8010527b:	5f                   	pop    %edi
8010527c:	5d                   	pop    %ebp
8010527d:	c3                   	ret    
8010527e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105280:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105284:	76 94                	jbe    8010521a <sys_unlink+0xba>
80105286:	be 20 00 00 00       	mov    $0x20,%esi
8010528b:	eb 0b                	jmp    80105298 <sys_unlink+0x138>
8010528d:	8d 76 00             	lea    0x0(%esi),%esi
80105290:	83 c6 10             	add    $0x10,%esi
80105293:	3b 73 58             	cmp    0x58(%ebx),%esi
80105296:	73 82                	jae    8010521a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105298:	6a 10                	push   $0x10
8010529a:	56                   	push   %esi
8010529b:	57                   	push   %edi
8010529c:	53                   	push   %ebx
8010529d:	e8 fe c7 ff ff       	call   80101aa0 <readi>
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	83 f8 10             	cmp    $0x10,%eax
801052a8:	75 68                	jne    80105312 <sys_unlink+0x1b2>
    if(de.inum != 0)
801052aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801052af:	74 df                	je     80105290 <sys_unlink+0x130>
    iunlockput(ip);
801052b1:	83 ec 0c             	sub    $0xc,%esp
801052b4:	53                   	push   %ebx
801052b5:	e8 66 c7 ff ff       	call   80101a20 <iunlockput>
    goto bad;
801052ba:	83 c4 10             	add    $0x10,%esp
801052bd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	ff 75 b4             	push   -0x4c(%ebp)
801052c6:	e8 55 c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
801052cb:	e8 10 db ff ff       	call   80102de0 <end_op>
  return -1;
801052d0:	83 c4 10             	add    $0x10,%esp
801052d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052d8:	eb 9c                	jmp    80105276 <sys_unlink+0x116>
801052da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801052e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801052e3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801052e6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801052eb:	50                   	push   %eax
801052ec:	e8 ef c3 ff ff       	call   801016e0 <iupdate>
801052f1:	83 c4 10             	add    $0x10,%esp
801052f4:	e9 53 ff ff ff       	jmp    8010524c <sys_unlink+0xec>
    return -1;
801052f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052fe:	e9 73 ff ff ff       	jmp    80105276 <sys_unlink+0x116>
    end_op();
80105303:	e8 d8 da ff ff       	call   80102de0 <end_op>
    return -1;
80105308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010530d:	e9 64 ff ff ff       	jmp    80105276 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105312:	83 ec 0c             	sub    $0xc,%esp
80105315:	68 48 7c 10 80       	push   $0x80107c48
8010531a:	e8 61 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010531f:	83 ec 0c             	sub    $0xc,%esp
80105322:	68 5a 7c 10 80       	push   $0x80107c5a
80105327:	e8 54 b0 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010532c:	83 ec 0c             	sub    $0xc,%esp
8010532f:	68 36 7c 10 80       	push   $0x80107c36
80105334:	e8 47 b0 ff ff       	call   80100380 <panic>
80105339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105340 <sys_open>:

int
sys_open(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	57                   	push   %edi
80105344:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105345:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105348:	53                   	push   %ebx
80105349:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010534c:	50                   	push   %eax
8010534d:	6a 00                	push   $0x0
8010534f:	e8 dc f7 ff ff       	call   80104b30 <argstr>
80105354:	83 c4 10             	add    $0x10,%esp
80105357:	85 c0                	test   %eax,%eax
80105359:	0f 88 8e 00 00 00    	js     801053ed <sys_open+0xad>
8010535f:	83 ec 08             	sub    $0x8,%esp
80105362:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105365:	50                   	push   %eax
80105366:	6a 01                	push   $0x1
80105368:	e8 03 f7 ff ff       	call   80104a70 <argint>
8010536d:	83 c4 10             	add    $0x10,%esp
80105370:	85 c0                	test   %eax,%eax
80105372:	78 79                	js     801053ed <sys_open+0xad>
    return -1;

  begin_op();
80105374:	e8 f7 d9 ff ff       	call   80102d70 <begin_op>

  if(omode & O_CREATE){
80105379:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010537d:	75 79                	jne    801053f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010537f:	83 ec 0c             	sub    $0xc,%esp
80105382:	ff 75 e0             	push   -0x20(%ebp)
80105385:	e8 26 cd ff ff       	call   801020b0 <namei>
8010538a:	83 c4 10             	add    $0x10,%esp
8010538d:	89 c6                	mov    %eax,%esi
8010538f:	85 c0                	test   %eax,%eax
80105391:	0f 84 7e 00 00 00    	je     80105415 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105397:	83 ec 0c             	sub    $0xc,%esp
8010539a:	50                   	push   %eax
8010539b:	e8 f0 c3 ff ff       	call   80101790 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801053a0:	83 c4 10             	add    $0x10,%esp
801053a3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801053a8:	0f 84 c2 00 00 00    	je     80105470 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801053ae:	e8 8d ba ff ff       	call   80100e40 <filealloc>
801053b3:	89 c7                	mov    %eax,%edi
801053b5:	85 c0                	test   %eax,%eax
801053b7:	74 23                	je     801053dc <sys_open+0x9c>
  struct proc *curproc = myproc();
801053b9:	e8 e2 e5 ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053be:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801053c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053c4:	85 d2                	test   %edx,%edx
801053c6:	74 60                	je     80105428 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801053c8:	83 c3 01             	add    $0x1,%ebx
801053cb:	83 fb 10             	cmp    $0x10,%ebx
801053ce:	75 f0                	jne    801053c0 <sys_open+0x80>
    if(f)
      fileclose(f);
801053d0:	83 ec 0c             	sub    $0xc,%esp
801053d3:	57                   	push   %edi
801053d4:	e8 27 bb ff ff       	call   80100f00 <fileclose>
801053d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801053dc:	83 ec 0c             	sub    $0xc,%esp
801053df:	56                   	push   %esi
801053e0:	e8 3b c6 ff ff       	call   80101a20 <iunlockput>
    end_op();
801053e5:	e8 f6 d9 ff ff       	call   80102de0 <end_op>
    return -1;
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053f2:	eb 6d                	jmp    80105461 <sys_open+0x121>
801053f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801053f8:	83 ec 0c             	sub    $0xc,%esp
801053fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053fe:	31 c9                	xor    %ecx,%ecx
80105400:	ba 02 00 00 00       	mov    $0x2,%edx
80105405:	6a 00                	push   $0x0
80105407:	e8 14 f8 ff ff       	call   80104c20 <create>
    if(ip == 0){
8010540c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010540f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105411:	85 c0                	test   %eax,%eax
80105413:	75 99                	jne    801053ae <sys_open+0x6e>
      end_op();
80105415:	e8 c6 d9 ff ff       	call   80102de0 <end_op>
      return -1;
8010541a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010541f:	eb 40                	jmp    80105461 <sys_open+0x121>
80105421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105428:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010542b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010542f:	56                   	push   %esi
80105430:	e8 3b c4 ff ff       	call   80101870 <iunlock>
  end_op();
80105435:	e8 a6 d9 ff ff       	call   80102de0 <end_op>

  f->type = FD_INODE;
8010543a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105440:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105443:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105446:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105449:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010544b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105452:	f7 d0                	not    %eax
80105454:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105457:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010545a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010545d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105461:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105464:	89 d8                	mov    %ebx,%eax
80105466:	5b                   	pop    %ebx
80105467:	5e                   	pop    %esi
80105468:	5f                   	pop    %edi
80105469:	5d                   	pop    %ebp
8010546a:	c3                   	ret    
8010546b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010546f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105470:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105473:	85 c9                	test   %ecx,%ecx
80105475:	0f 84 33 ff ff ff    	je     801053ae <sys_open+0x6e>
8010547b:	e9 5c ff ff ff       	jmp    801053dc <sys_open+0x9c>

80105480 <sys_mkdir>:

int
sys_mkdir(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105486:	e8 e5 d8 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010548b:	83 ec 08             	sub    $0x8,%esp
8010548e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105491:	50                   	push   %eax
80105492:	6a 00                	push   $0x0
80105494:	e8 97 f6 ff ff       	call   80104b30 <argstr>
80105499:	83 c4 10             	add    $0x10,%esp
8010549c:	85 c0                	test   %eax,%eax
8010549e:	78 30                	js     801054d0 <sys_mkdir+0x50>
801054a0:	83 ec 0c             	sub    $0xc,%esp
801054a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a6:	31 c9                	xor    %ecx,%ecx
801054a8:	ba 01 00 00 00       	mov    $0x1,%edx
801054ad:	6a 00                	push   $0x0
801054af:	e8 6c f7 ff ff       	call   80104c20 <create>
801054b4:	83 c4 10             	add    $0x10,%esp
801054b7:	85 c0                	test   %eax,%eax
801054b9:	74 15                	je     801054d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054bb:	83 ec 0c             	sub    $0xc,%esp
801054be:	50                   	push   %eax
801054bf:	e8 5c c5 ff ff       	call   80101a20 <iunlockput>
  end_op();
801054c4:	e8 17 d9 ff ff       	call   80102de0 <end_op>
  return 0;
801054c9:	83 c4 10             	add    $0x10,%esp
801054cc:	31 c0                	xor    %eax,%eax
}
801054ce:	c9                   	leave  
801054cf:	c3                   	ret    
    end_op();
801054d0:	e8 0b d9 ff ff       	call   80102de0 <end_op>
    return -1;
801054d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054da:	c9                   	leave  
801054db:	c3                   	ret    
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054e0 <sys_mknod>:

int
sys_mknod(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801054e6:	e8 85 d8 ff ff       	call   80102d70 <begin_op>
  if((argstr(0, &path)) < 0 ||
801054eb:	83 ec 08             	sub    $0x8,%esp
801054ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054f1:	50                   	push   %eax
801054f2:	6a 00                	push   $0x0
801054f4:	e8 37 f6 ff ff       	call   80104b30 <argstr>
801054f9:	83 c4 10             	add    $0x10,%esp
801054fc:	85 c0                	test   %eax,%eax
801054fe:	78 60                	js     80105560 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105500:	83 ec 08             	sub    $0x8,%esp
80105503:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105506:	50                   	push   %eax
80105507:	6a 01                	push   $0x1
80105509:	e8 62 f5 ff ff       	call   80104a70 <argint>
  if((argstr(0, &path)) < 0 ||
8010550e:	83 c4 10             	add    $0x10,%esp
80105511:	85 c0                	test   %eax,%eax
80105513:	78 4b                	js     80105560 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105515:	83 ec 08             	sub    $0x8,%esp
80105518:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010551b:	50                   	push   %eax
8010551c:	6a 02                	push   $0x2
8010551e:	e8 4d f5 ff ff       	call   80104a70 <argint>
     argint(1, &major) < 0 ||
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	78 36                	js     80105560 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010552a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010552e:	83 ec 0c             	sub    $0xc,%esp
80105531:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105535:	ba 03 00 00 00       	mov    $0x3,%edx
8010553a:	50                   	push   %eax
8010553b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010553e:	e8 dd f6 ff ff       	call   80104c20 <create>
     argint(2, &minor) < 0 ||
80105543:	83 c4 10             	add    $0x10,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	74 16                	je     80105560 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010554a:	83 ec 0c             	sub    $0xc,%esp
8010554d:	50                   	push   %eax
8010554e:	e8 cd c4 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105553:	e8 88 d8 ff ff       	call   80102de0 <end_op>
  return 0;
80105558:	83 c4 10             	add    $0x10,%esp
8010555b:	31 c0                	xor    %eax,%eax
}
8010555d:	c9                   	leave  
8010555e:	c3                   	ret    
8010555f:	90                   	nop
    end_op();
80105560:	e8 7b d8 ff ff       	call   80102de0 <end_op>
    return -1;
80105565:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010556a:	c9                   	leave  
8010556b:	c3                   	ret    
8010556c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105570 <sys_chdir>:

int
sys_chdir(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	56                   	push   %esi
80105574:	53                   	push   %ebx
80105575:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105578:	e8 23 e4 ff ff       	call   801039a0 <myproc>
8010557d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010557f:	e8 ec d7 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105584:	83 ec 08             	sub    $0x8,%esp
80105587:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010558a:	50                   	push   %eax
8010558b:	6a 00                	push   $0x0
8010558d:	e8 9e f5 ff ff       	call   80104b30 <argstr>
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	85 c0                	test   %eax,%eax
80105597:	78 77                	js     80105610 <sys_chdir+0xa0>
80105599:	83 ec 0c             	sub    $0xc,%esp
8010559c:	ff 75 f4             	push   -0xc(%ebp)
8010559f:	e8 0c cb ff ff       	call   801020b0 <namei>
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	89 c3                	mov    %eax,%ebx
801055a9:	85 c0                	test   %eax,%eax
801055ab:	74 63                	je     80105610 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801055ad:	83 ec 0c             	sub    $0xc,%esp
801055b0:	50                   	push   %eax
801055b1:	e8 da c1 ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
801055b6:	83 c4 10             	add    $0x10,%esp
801055b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055be:	75 30                	jne    801055f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055c0:	83 ec 0c             	sub    $0xc,%esp
801055c3:	53                   	push   %ebx
801055c4:	e8 a7 c2 ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
801055c9:	58                   	pop    %eax
801055ca:	ff 76 68             	push   0x68(%esi)
801055cd:	e8 ee c2 ff ff       	call   801018c0 <iput>
  end_op();
801055d2:	e8 09 d8 ff ff       	call   80102de0 <end_op>
  curproc->cwd = ip;
801055d7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801055da:	83 c4 10             	add    $0x10,%esp
801055dd:	31 c0                	xor    %eax,%eax
}
801055df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055e2:	5b                   	pop    %ebx
801055e3:	5e                   	pop    %esi
801055e4:	5d                   	pop    %ebp
801055e5:	c3                   	ret    
801055e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801055f0:	83 ec 0c             	sub    $0xc,%esp
801055f3:	53                   	push   %ebx
801055f4:	e8 27 c4 ff ff       	call   80101a20 <iunlockput>
    end_op();
801055f9:	e8 e2 d7 ff ff       	call   80102de0 <end_op>
    return -1;
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105606:	eb d7                	jmp    801055df <sys_chdir+0x6f>
80105608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560f:	90                   	nop
    end_op();
80105610:	e8 cb d7 ff ff       	call   80102de0 <end_op>
    return -1;
80105615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010561a:	eb c3                	jmp    801055df <sys_chdir+0x6f>
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105620 <sys_exec>:

int
sys_exec(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	57                   	push   %edi
80105624:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105625:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010562b:	53                   	push   %ebx
8010562c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105632:	50                   	push   %eax
80105633:	6a 00                	push   $0x0
80105635:	e8 f6 f4 ff ff       	call   80104b30 <argstr>
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	85 c0                	test   %eax,%eax
8010563f:	0f 88 87 00 00 00    	js     801056cc <sys_exec+0xac>
80105645:	83 ec 08             	sub    $0x8,%esp
80105648:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010564e:	50                   	push   %eax
8010564f:	6a 01                	push   $0x1
80105651:	e8 1a f4 ff ff       	call   80104a70 <argint>
80105656:	83 c4 10             	add    $0x10,%esp
80105659:	85 c0                	test   %eax,%eax
8010565b:	78 6f                	js     801056cc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010565d:	83 ec 04             	sub    $0x4,%esp
80105660:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105666:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105668:	68 80 00 00 00       	push   $0x80
8010566d:	6a 00                	push   $0x0
8010566f:	56                   	push   %esi
80105670:	e8 3b f1 ff ff       	call   801047b0 <memset>
80105675:	83 c4 10             	add    $0x10,%esp
80105678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105680:	83 ec 08             	sub    $0x8,%esp
80105683:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105689:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105690:	50                   	push   %eax
80105691:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105697:	01 f8                	add    %edi,%eax
80105699:	50                   	push   %eax
8010569a:	e8 41 f3 ff ff       	call   801049e0 <fetchint>
8010569f:	83 c4 10             	add    $0x10,%esp
801056a2:	85 c0                	test   %eax,%eax
801056a4:	78 26                	js     801056cc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801056a6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801056ac:	85 c0                	test   %eax,%eax
801056ae:	74 30                	je     801056e0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801056b0:	83 ec 08             	sub    $0x8,%esp
801056b3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801056b6:	52                   	push   %edx
801056b7:	50                   	push   %eax
801056b8:	e8 63 f3 ff ff       	call   80104a20 <fetchstr>
801056bd:	83 c4 10             	add    $0x10,%esp
801056c0:	85 c0                	test   %eax,%eax
801056c2:	78 08                	js     801056cc <sys_exec+0xac>
  for(i=0;; i++){
801056c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801056c7:	83 fb 20             	cmp    $0x20,%ebx
801056ca:	75 b4                	jne    80105680 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801056cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801056cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056d4:	5b                   	pop    %ebx
801056d5:	5e                   	pop    %esi
801056d6:	5f                   	pop    %edi
801056d7:	5d                   	pop    %ebp
801056d8:	c3                   	ret    
801056d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801056e0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801056e7:	00 00 00 00 
  return exec(path, argv);
801056eb:	83 ec 08             	sub    $0x8,%esp
801056ee:	56                   	push   %esi
801056ef:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801056f5:	e8 b6 b3 ff ff       	call   80100ab0 <exec>
801056fa:	83 c4 10             	add    $0x10,%esp
}
801056fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105700:	5b                   	pop    %ebx
80105701:	5e                   	pop    %esi
80105702:	5f                   	pop    %edi
80105703:	5d                   	pop    %ebp
80105704:	c3                   	ret    
80105705:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_pipe>:

int
sys_pipe(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	57                   	push   %edi
80105714:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105715:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105718:	53                   	push   %ebx
80105719:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010571c:	6a 08                	push   $0x8
8010571e:	50                   	push   %eax
8010571f:	6a 00                	push   $0x0
80105721:	e8 9a f3 ff ff       	call   80104ac0 <argptr>
80105726:	83 c4 10             	add    $0x10,%esp
80105729:	85 c0                	test   %eax,%eax
8010572b:	78 4a                	js     80105777 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010572d:	83 ec 08             	sub    $0x8,%esp
80105730:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105733:	50                   	push   %eax
80105734:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105737:	50                   	push   %eax
80105738:	e8 03 dd ff ff       	call   80103440 <pipealloc>
8010573d:	83 c4 10             	add    $0x10,%esp
80105740:	85 c0                	test   %eax,%eax
80105742:	78 33                	js     80105777 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105744:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105747:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105749:	e8 52 e2 ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010574e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105750:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105754:	85 f6                	test   %esi,%esi
80105756:	74 28                	je     80105780 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105758:	83 c3 01             	add    $0x1,%ebx
8010575b:	83 fb 10             	cmp    $0x10,%ebx
8010575e:	75 f0                	jne    80105750 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	ff 75 e0             	push   -0x20(%ebp)
80105766:	e8 95 b7 ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
8010576b:	58                   	pop    %eax
8010576c:	ff 75 e4             	push   -0x1c(%ebp)
8010576f:	e8 8c b7 ff ff       	call   80100f00 <fileclose>
    return -1;
80105774:	83 c4 10             	add    $0x10,%esp
80105777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577c:	eb 53                	jmp    801057d1 <sys_pipe+0xc1>
8010577e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105780:	8d 73 08             	lea    0x8(%ebx),%esi
80105783:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105787:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010578a:	e8 11 e2 ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010578f:	31 d2                	xor    %edx,%edx
80105791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105798:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010579c:	85 c9                	test   %ecx,%ecx
8010579e:	74 20                	je     801057c0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801057a0:	83 c2 01             	add    $0x1,%edx
801057a3:	83 fa 10             	cmp    $0x10,%edx
801057a6:	75 f0                	jne    80105798 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801057a8:	e8 f3 e1 ff ff       	call   801039a0 <myproc>
801057ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801057b4:	00 
801057b5:	eb a9                	jmp    80105760 <sys_pipe+0x50>
801057b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801057c0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801057c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057c7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801057c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057cc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801057cf:	31 c0                	xor    %eax,%eax
}
801057d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057d4:	5b                   	pop    %ebx
801057d5:	5e                   	pop    %esi
801057d6:	5f                   	pop    %edi
801057d7:	5d                   	pop    %ebp
801057d8:	c3                   	ret    
801057d9:	66 90                	xchg   %ax,%ax
801057db:	66 90                	xchg   %ax,%ax
801057dd:	66 90                	xchg   %ax,%ax
801057df:	90                   	nop

801057e0 <sys_fork>:
#include <stddef.h>

int
sys_fork(void)
{
  return fork();
801057e0:	e9 5b e3 ff ff       	jmp    80103b40 <fork>
801057e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_exit>:
}

int
sys_exit(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801057f6:	e8 45 e6 ff ff       	call   80103e40 <exit>
  return 0;  // not reached
}
801057fb:	31 c0                	xor    %eax,%eax
801057fd:	c9                   	leave  
801057fe:	c3                   	ret    
801057ff:	90                   	nop

80105800 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105800:	e9 6b e7 ff ff       	jmp    80103f70 <wait>
80105805:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_kill>:
}

int
sys_kill(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105816:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105819:	50                   	push   %eax
8010581a:	6a 00                	push   $0x0
8010581c:	e8 4f f2 ff ff       	call   80104a70 <argint>
80105821:	83 c4 10             	add    $0x10,%esp
80105824:	85 c0                	test   %eax,%eax
80105826:	78 18                	js     80105840 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	ff 75 f4             	push   -0xc(%ebp)
8010582e:	e8 dd e9 ff ff       	call   80104210 <kill>
80105833:	83 c4 10             	add    $0x10,%esp
}
80105836:	c9                   	leave  
80105837:	c3                   	ret    
80105838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583f:	90                   	nop
80105840:	c9                   	leave  
    return -1;
80105841:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105846:	c3                   	ret    
80105847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584e:	66 90                	xchg   %ax,%ax

80105850 <sys_getpid>:

int
sys_getpid(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105856:	e8 45 e1 ff ff       	call   801039a0 <myproc>
8010585b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010585e:	c9                   	leave  
8010585f:	c3                   	ret    

80105860 <sys_sbrk>:

int
sys_sbrk(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105864:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105867:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010586a:	50                   	push   %eax
8010586b:	6a 00                	push   $0x0
8010586d:	e8 fe f1 ff ff       	call   80104a70 <argint>
80105872:	83 c4 10             	add    $0x10,%esp
80105875:	85 c0                	test   %eax,%eax
80105877:	78 27                	js     801058a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105879:	e8 22 e1 ff ff       	call   801039a0 <myproc>
  if(growproc(n) < 0)
8010587e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105881:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105883:	ff 75 f4             	push   -0xc(%ebp)
80105886:	e8 35 e2 ff ff       	call   80103ac0 <growproc>
8010588b:	83 c4 10             	add    $0x10,%esp
8010588e:	85 c0                	test   %eax,%eax
80105890:	78 0e                	js     801058a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105892:	89 d8                	mov    %ebx,%eax
80105894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105897:	c9                   	leave  
80105898:	c3                   	ret    
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058a5:	eb eb                	jmp    80105892 <sys_sbrk+0x32>
801058a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ae:	66 90                	xchg   %ax,%ax

801058b0 <sys_sleep>:

int
sys_sleep(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801058b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058ba:	50                   	push   %eax
801058bb:	6a 00                	push   $0x0
801058bd:	e8 ae f1 ff ff       	call   80104a70 <argint>
801058c2:	83 c4 10             	add    $0x10,%esp
801058c5:	85 c0                	test   %eax,%eax
801058c7:	0f 88 8a 00 00 00    	js     80105957 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801058cd:	83 ec 0c             	sub    $0xc,%esp
801058d0:	68 80 3e 11 80       	push   $0x80113e80
801058d5:	e8 16 ee ff ff       	call   801046f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801058da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801058dd:	8b 1d 60 3e 11 80    	mov    0x80113e60,%ebx
  while(ticks - ticks0 < n){
801058e3:	83 c4 10             	add    $0x10,%esp
801058e6:	85 d2                	test   %edx,%edx
801058e8:	75 27                	jne    80105911 <sys_sleep+0x61>
801058ea:	eb 54                	jmp    80105940 <sys_sleep+0x90>
801058ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801058f0:	83 ec 08             	sub    $0x8,%esp
801058f3:	68 80 3e 11 80       	push   $0x80113e80
801058f8:	68 60 3e 11 80       	push   $0x80113e60
801058fd:	e8 ee e7 ff ff       	call   801040f0 <sleep>
  while(ticks - ticks0 < n){
80105902:	a1 60 3e 11 80       	mov    0x80113e60,%eax
80105907:	83 c4 10             	add    $0x10,%esp
8010590a:	29 d8                	sub    %ebx,%eax
8010590c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010590f:	73 2f                	jae    80105940 <sys_sleep+0x90>
    if(myproc()->killed){
80105911:	e8 8a e0 ff ff       	call   801039a0 <myproc>
80105916:	8b 40 24             	mov    0x24(%eax),%eax
80105919:	85 c0                	test   %eax,%eax
8010591b:	74 d3                	je     801058f0 <sys_sleep+0x40>
      release(&tickslock);
8010591d:	83 ec 0c             	sub    $0xc,%esp
80105920:	68 80 3e 11 80       	push   $0x80113e80
80105925:	e8 66 ed ff ff       	call   80104690 <release>
  }
  release(&tickslock);
  return 0;
}
8010592a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010592d:	83 c4 10             	add    $0x10,%esp
80105930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105935:	c9                   	leave  
80105936:	c3                   	ret    
80105937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105940:	83 ec 0c             	sub    $0xc,%esp
80105943:	68 80 3e 11 80       	push   $0x80113e80
80105948:	e8 43 ed ff ff       	call   80104690 <release>
  return 0;
8010594d:	83 c4 10             	add    $0x10,%esp
80105950:	31 c0                	xor    %eax,%eax
}
80105952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105955:	c9                   	leave  
80105956:	c3                   	ret    
    return -1;
80105957:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010595c:	eb f4                	jmp    80105952 <sys_sleep+0xa2>
8010595e:	66 90                	xchg   %ax,%ax

80105960 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	53                   	push   %ebx
80105964:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105967:	68 80 3e 11 80       	push   $0x80113e80
8010596c:	e8 7f ed ff ff       	call   801046f0 <acquire>
  xticks = ticks;
80105971:	8b 1d 60 3e 11 80    	mov    0x80113e60,%ebx
  release(&tickslock);
80105977:	c7 04 24 80 3e 11 80 	movl   $0x80113e80,(%esp)
8010597e:	e8 0d ed ff ff       	call   80104690 <release>
  return xticks;
}
80105983:	89 d8                	mov    %ebx,%eax
80105985:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105988:	c9                   	leave  
80105989:	c3                   	ret    
8010598a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105990 <sys_settickets>:

int
sys_settickets(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 20             	sub    $0x20,%esp
  int n;

  if(argint(0, &n) < 0)
80105996:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105999:	50                   	push   %eax
8010599a:	6a 00                	push   $0x0
8010599c:	e8 cf f0 ff ff       	call   80104a70 <argint>
801059a1:	83 c4 10             	add    $0x10,%esp
801059a4:	85 c0                	test   %eax,%eax
801059a6:	78 18                	js     801059c0 <sys_settickets+0x30>
    return -1;

  if(n >1 || n<0) {
801059a8:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801059ac:	77 12                	ja     801059c0 <sys_settickets+0x30>
	  return -1;
  }
  myproc()->priority = n;
801059ae:	e8 ed df ff ff       	call   801039a0 <myproc>
801059b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059b6:	89 50 7c             	mov    %edx,0x7c(%eax)
  // success
  return 0;
801059b9:	31 c0                	xor    %eax,%eax
}
801059bb:	c9                   	leave  
801059bc:	c3                   	ret    
801059bd:	8d 76 00             	lea    0x0(%esi),%esi
801059c0:	c9                   	leave  
    return -1;
801059c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c6:	c3                   	ret    

801059c7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801059c7:	1e                   	push   %ds
  pushl %es
801059c8:	06                   	push   %es
  pushl %fs
801059c9:	0f a0                	push   %fs
  pushl %gs
801059cb:	0f a8                	push   %gs
  pushal
801059cd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801059ce:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801059d2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801059d4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801059d6:	54                   	push   %esp
  call trap
801059d7:	e8 c4 00 00 00       	call   80105aa0 <trap>
  addl $4, %esp
801059dc:	83 c4 04             	add    $0x4,%esp

801059df <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801059df:	61                   	popa   
  popl %gs
801059e0:	0f a9                	pop    %gs
  popl %fs
801059e2:	0f a1                	pop    %fs
  popl %es
801059e4:	07                   	pop    %es
  popl %ds
801059e5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801059e6:	83 c4 08             	add    $0x8,%esp
  iret
801059e9:	cf                   	iret   
801059ea:	66 90                	xchg   %ax,%ax
801059ec:	66 90                	xchg   %ax,%ax
801059ee:	66 90                	xchg   %ax,%ax

801059f0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801059f0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801059f1:	31 c0                	xor    %eax,%eax
{
801059f3:	89 e5                	mov    %esp,%ebp
801059f5:	83 ec 08             	sub    $0x8,%esp
801059f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ff:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a00:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105a07:	c7 04 c5 c2 3e 11 80 	movl   $0x8e000008,-0x7feec13e(,%eax,8)
80105a0e:	08 00 00 8e 
80105a12:	66 89 14 c5 c0 3e 11 	mov    %dx,-0x7feec140(,%eax,8)
80105a19:	80 
80105a1a:	c1 ea 10             	shr    $0x10,%edx
80105a1d:	66 89 14 c5 c6 3e 11 	mov    %dx,-0x7feec13a(,%eax,8)
80105a24:	80 
  for(i = 0; i < 256; i++)
80105a25:	83 c0 01             	add    $0x1,%eax
80105a28:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a2d:	75 d1                	jne    80105a00 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105a2f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a32:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105a37:	c7 05 c2 40 11 80 08 	movl   $0xef000008,0x801140c2
80105a3e:	00 00 ef 
  initlock(&tickslock, "time");
80105a41:	68 69 7c 10 80       	push   $0x80107c69
80105a46:	68 80 3e 11 80       	push   $0x80113e80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a4b:	66 a3 c0 40 11 80    	mov    %ax,0x801140c0
80105a51:	c1 e8 10             	shr    $0x10,%eax
80105a54:	66 a3 c6 40 11 80    	mov    %ax,0x801140c6
  initlock(&tickslock, "time");
80105a5a:	e8 c1 ea ff ff       	call   80104520 <initlock>
}
80105a5f:	83 c4 10             	add    $0x10,%esp
80105a62:	c9                   	leave  
80105a63:	c3                   	ret    
80105a64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a6f:	90                   	nop

80105a70 <idtinit>:

void
idtinit(void)
{
80105a70:	55                   	push   %ebp
  pd[0] = size-1;
80105a71:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105a76:	89 e5                	mov    %esp,%ebp
80105a78:	83 ec 10             	sub    $0x10,%esp
80105a7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105a7f:	b8 c0 3e 11 80       	mov    $0x80113ec0,%eax
80105a84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105a88:	c1 e8 10             	shr    $0x10,%eax
80105a8b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105a8f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a92:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105a95:	c9                   	leave  
80105a96:	c3                   	ret    
80105a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9e:	66 90                	xchg   %ax,%ax

80105aa0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	57                   	push   %edi
80105aa4:	56                   	push   %esi
80105aa5:	53                   	push   %ebx
80105aa6:	83 ec 1c             	sub    $0x1c,%esp
80105aa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105aac:	8b 43 30             	mov    0x30(%ebx),%eax
80105aaf:	83 f8 40             	cmp    $0x40,%eax
80105ab2:	0f 84 68 01 00 00    	je     80105c20 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105ab8:	83 e8 20             	sub    $0x20,%eax
80105abb:	83 f8 1f             	cmp    $0x1f,%eax
80105abe:	0f 87 8c 00 00 00    	ja     80105b50 <trap+0xb0>
80105ac4:	ff 24 85 10 7d 10 80 	jmp    *-0x7fef82f0(,%eax,4)
80105acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105acf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ad0:	e8 7b c7 ff ff       	call   80102250 <ideintr>
    lapiceoi();
80105ad5:	e8 46 ce ff ff       	call   80102920 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ada:	e8 c1 de ff ff       	call   801039a0 <myproc>
80105adf:	85 c0                	test   %eax,%eax
80105ae1:	74 1d                	je     80105b00 <trap+0x60>
80105ae3:	e8 b8 de ff ff       	call   801039a0 <myproc>
80105ae8:	8b 50 24             	mov    0x24(%eax),%edx
80105aeb:	85 d2                	test   %edx,%edx
80105aed:	74 11                	je     80105b00 <trap+0x60>
80105aef:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105af3:	83 e0 03             	and    $0x3,%eax
80105af6:	66 83 f8 03          	cmp    $0x3,%ax
80105afa:	0f 84 e8 01 00 00    	je     80105ce8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105b00:	e8 9b de ff ff       	call   801039a0 <myproc>
80105b05:	85 c0                	test   %eax,%eax
80105b07:	74 0f                	je     80105b18 <trap+0x78>
80105b09:	e8 92 de ff ff       	call   801039a0 <myproc>
80105b0e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b12:	0f 84 b8 00 00 00    	je     80105bd0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b18:	e8 83 de ff ff       	call   801039a0 <myproc>
80105b1d:	85 c0                	test   %eax,%eax
80105b1f:	74 1d                	je     80105b3e <trap+0x9e>
80105b21:	e8 7a de ff ff       	call   801039a0 <myproc>
80105b26:	8b 40 24             	mov    0x24(%eax),%eax
80105b29:	85 c0                	test   %eax,%eax
80105b2b:	74 11                	je     80105b3e <trap+0x9e>
80105b2d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b31:	83 e0 03             	and    $0x3,%eax
80105b34:	66 83 f8 03          	cmp    $0x3,%ax
80105b38:	0f 84 0f 01 00 00    	je     80105c4d <trap+0x1ad>
    exit();
}
80105b3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b41:	5b                   	pop    %ebx
80105b42:	5e                   	pop    %esi
80105b43:	5f                   	pop    %edi
80105b44:	5d                   	pop    %ebp
80105b45:	c3                   	ret    
80105b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b50:	e8 4b de ff ff       	call   801039a0 <myproc>
80105b55:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b58:	85 c0                	test   %eax,%eax
80105b5a:	0f 84 a2 01 00 00    	je     80105d02 <trap+0x262>
80105b60:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105b64:	0f 84 98 01 00 00    	je     80105d02 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b6a:	0f 20 d1             	mov    %cr2,%ecx
80105b6d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b70:	e8 0b de ff ff       	call   80103980 <cpuid>
80105b75:	8b 73 30             	mov    0x30(%ebx),%esi
80105b78:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105b7b:	8b 43 34             	mov    0x34(%ebx),%eax
80105b7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105b81:	e8 1a de ff ff       	call   801039a0 <myproc>
80105b86:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105b89:	e8 12 de ff ff       	call   801039a0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b8e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105b91:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105b94:	51                   	push   %ecx
80105b95:	57                   	push   %edi
80105b96:	52                   	push   %edx
80105b97:	ff 75 e4             	push   -0x1c(%ebp)
80105b9a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105b9b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105b9e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ba1:	56                   	push   %esi
80105ba2:	ff 70 10             	push   0x10(%eax)
80105ba5:	68 cc 7c 10 80       	push   $0x80107ccc
80105baa:	e8 f1 aa ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105baf:	83 c4 20             	add    $0x20,%esp
80105bb2:	e8 e9 dd ff ff       	call   801039a0 <myproc>
80105bb7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bbe:	e8 dd dd ff ff       	call   801039a0 <myproc>
80105bc3:	85 c0                	test   %eax,%eax
80105bc5:	0f 85 18 ff ff ff    	jne    80105ae3 <trap+0x43>
80105bcb:	e9 30 ff ff ff       	jmp    80105b00 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105bd0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105bd4:	0f 85 3e ff ff ff    	jne    80105b18 <trap+0x78>
    yield();
80105bda:	e8 c1 e4 ff ff       	call   801040a0 <yield>
80105bdf:	e9 34 ff ff ff       	jmp    80105b18 <trap+0x78>
80105be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105be8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105beb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105bef:	e8 8c dd ff ff       	call   80103980 <cpuid>
80105bf4:	57                   	push   %edi
80105bf5:	56                   	push   %esi
80105bf6:	50                   	push   %eax
80105bf7:	68 74 7c 10 80       	push   $0x80107c74
80105bfc:	e8 9f aa ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105c01:	e8 1a cd ff ff       	call   80102920 <lapiceoi>
    break;
80105c06:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c09:	e8 92 dd ff ff       	call   801039a0 <myproc>
80105c0e:	85 c0                	test   %eax,%eax
80105c10:	0f 85 cd fe ff ff    	jne    80105ae3 <trap+0x43>
80105c16:	e9 e5 fe ff ff       	jmp    80105b00 <trap+0x60>
80105c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c1f:	90                   	nop
    if(myproc()->killed)
80105c20:	e8 7b dd ff ff       	call   801039a0 <myproc>
80105c25:	8b 70 24             	mov    0x24(%eax),%esi
80105c28:	85 f6                	test   %esi,%esi
80105c2a:	0f 85 c8 00 00 00    	jne    80105cf8 <trap+0x258>
    myproc()->tf = tf;
80105c30:	e8 6b dd ff ff       	call   801039a0 <myproc>
80105c35:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c38:	e8 73 ef ff ff       	call   80104bb0 <syscall>
    if(myproc()->killed)
80105c3d:	e8 5e dd ff ff       	call   801039a0 <myproc>
80105c42:	8b 48 24             	mov    0x24(%eax),%ecx
80105c45:	85 c9                	test   %ecx,%ecx
80105c47:	0f 84 f1 fe ff ff    	je     80105b3e <trap+0x9e>
}
80105c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c50:	5b                   	pop    %ebx
80105c51:	5e                   	pop    %esi
80105c52:	5f                   	pop    %edi
80105c53:	5d                   	pop    %ebp
      exit();
80105c54:	e9 e7 e1 ff ff       	jmp    80103e40 <exit>
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105c60:	e8 3b 02 00 00       	call   80105ea0 <uartintr>
    lapiceoi();
80105c65:	e8 b6 cc ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c6a:	e8 31 dd ff ff       	call   801039a0 <myproc>
80105c6f:	85 c0                	test   %eax,%eax
80105c71:	0f 85 6c fe ff ff    	jne    80105ae3 <trap+0x43>
80105c77:	e9 84 fe ff ff       	jmp    80105b00 <trap+0x60>
80105c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105c80:	e8 5b cb ff ff       	call   801027e0 <kbdintr>
    lapiceoi();
80105c85:	e8 96 cc ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c8a:	e8 11 dd ff ff       	call   801039a0 <myproc>
80105c8f:	85 c0                	test   %eax,%eax
80105c91:	0f 85 4c fe ff ff    	jne    80105ae3 <trap+0x43>
80105c97:	e9 64 fe ff ff       	jmp    80105b00 <trap+0x60>
80105c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ca0:	e8 db dc ff ff       	call   80103980 <cpuid>
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	0f 85 28 fe ff ff    	jne    80105ad5 <trap+0x35>
      acquire(&tickslock);
80105cad:	83 ec 0c             	sub    $0xc,%esp
80105cb0:	68 80 3e 11 80       	push   $0x80113e80
80105cb5:	e8 36 ea ff ff       	call   801046f0 <acquire>
      wakeup(&ticks);
80105cba:	c7 04 24 60 3e 11 80 	movl   $0x80113e60,(%esp)
      ticks++;
80105cc1:	83 05 60 3e 11 80 01 	addl   $0x1,0x80113e60
      wakeup(&ticks);
80105cc8:	e8 e3 e4 ff ff       	call   801041b0 <wakeup>
      release(&tickslock);
80105ccd:	c7 04 24 80 3e 11 80 	movl   $0x80113e80,(%esp)
80105cd4:	e8 b7 e9 ff ff       	call   80104690 <release>
80105cd9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105cdc:	e9 f4 fd ff ff       	jmp    80105ad5 <trap+0x35>
80105ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105ce8:	e8 53 e1 ff ff       	call   80103e40 <exit>
80105ced:	e9 0e fe ff ff       	jmp    80105b00 <trap+0x60>
80105cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105cf8:	e8 43 e1 ff ff       	call   80103e40 <exit>
80105cfd:	e9 2e ff ff ff       	jmp    80105c30 <trap+0x190>
80105d02:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d05:	e8 76 dc ff ff       	call   80103980 <cpuid>
80105d0a:	83 ec 0c             	sub    $0xc,%esp
80105d0d:	56                   	push   %esi
80105d0e:	57                   	push   %edi
80105d0f:	50                   	push   %eax
80105d10:	ff 73 30             	push   0x30(%ebx)
80105d13:	68 98 7c 10 80       	push   $0x80107c98
80105d18:	e8 83 a9 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105d1d:	83 c4 14             	add    $0x14,%esp
80105d20:	68 6e 7c 10 80       	push   $0x80107c6e
80105d25:	e8 56 a6 ff ff       	call   80100380 <panic>
80105d2a:	66 90                	xchg   %ax,%ax
80105d2c:	66 90                	xchg   %ax,%ax
80105d2e:	66 90                	xchg   %ax,%ax

80105d30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105d30:	a1 c0 46 11 80       	mov    0x801146c0,%eax
80105d35:	85 c0                	test   %eax,%eax
80105d37:	74 17                	je     80105d50 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d39:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d3e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d3f:	a8 01                	test   $0x1,%al
80105d41:	74 0d                	je     80105d50 <uartgetc+0x20>
80105d43:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d48:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105d49:	0f b6 c0             	movzbl %al,%eax
80105d4c:	c3                   	ret    
80105d4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d55:	c3                   	ret    
80105d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5d:	8d 76 00             	lea    0x0(%esi),%esi

80105d60 <uartinit>:
{
80105d60:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d61:	31 c9                	xor    %ecx,%ecx
80105d63:	89 c8                	mov    %ecx,%eax
80105d65:	89 e5                	mov    %esp,%ebp
80105d67:	57                   	push   %edi
80105d68:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105d6d:	56                   	push   %esi
80105d6e:	89 fa                	mov    %edi,%edx
80105d70:	53                   	push   %ebx
80105d71:	83 ec 1c             	sub    $0x1c,%esp
80105d74:	ee                   	out    %al,(%dx)
80105d75:	be fb 03 00 00       	mov    $0x3fb,%esi
80105d7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d7f:	89 f2                	mov    %esi,%edx
80105d81:	ee                   	out    %al,(%dx)
80105d82:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d8c:	ee                   	out    %al,(%dx)
80105d8d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105d92:	89 c8                	mov    %ecx,%eax
80105d94:	89 da                	mov    %ebx,%edx
80105d96:	ee                   	out    %al,(%dx)
80105d97:	b8 03 00 00 00       	mov    $0x3,%eax
80105d9c:	89 f2                	mov    %esi,%edx
80105d9e:	ee                   	out    %al,(%dx)
80105d9f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105da4:	89 c8                	mov    %ecx,%eax
80105da6:	ee                   	out    %al,(%dx)
80105da7:	b8 01 00 00 00       	mov    $0x1,%eax
80105dac:	89 da                	mov    %ebx,%edx
80105dae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105daf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105db4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105db5:	3c ff                	cmp    $0xff,%al
80105db7:	74 78                	je     80105e31 <uartinit+0xd1>
  uart = 1;
80105db9:	c7 05 c0 46 11 80 01 	movl   $0x1,0x801146c0
80105dc0:	00 00 00 
80105dc3:	89 fa                	mov    %edi,%edx
80105dc5:	ec                   	in     (%dx),%al
80105dc6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dcb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105dcc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105dcf:	bf 90 7d 10 80       	mov    $0x80107d90,%edi
80105dd4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105dd9:	6a 00                	push   $0x0
80105ddb:	6a 04                	push   $0x4
80105ddd:	e8 ae c6 ff ff       	call   80102490 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105de2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105de6:	83 c4 10             	add    $0x10,%esp
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105df0:	a1 c0 46 11 80       	mov    0x801146c0,%eax
80105df5:	bb 80 00 00 00       	mov    $0x80,%ebx
80105dfa:	85 c0                	test   %eax,%eax
80105dfc:	75 14                	jne    80105e12 <uartinit+0xb2>
80105dfe:	eb 23                	jmp    80105e23 <uartinit+0xc3>
    microdelay(10);
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	6a 0a                	push   $0xa
80105e05:	e8 36 cb ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e0a:	83 c4 10             	add    $0x10,%esp
80105e0d:	83 eb 01             	sub    $0x1,%ebx
80105e10:	74 07                	je     80105e19 <uartinit+0xb9>
80105e12:	89 f2                	mov    %esi,%edx
80105e14:	ec                   	in     (%dx),%al
80105e15:	a8 20                	test   $0x20,%al
80105e17:	74 e7                	je     80105e00 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e19:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105e1d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e22:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105e23:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105e27:	83 c7 01             	add    $0x1,%edi
80105e2a:	88 45 e7             	mov    %al,-0x19(%ebp)
80105e2d:	84 c0                	test   %al,%al
80105e2f:	75 bf                	jne    80105df0 <uartinit+0x90>
}
80105e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e34:	5b                   	pop    %ebx
80105e35:	5e                   	pop    %esi
80105e36:	5f                   	pop    %edi
80105e37:	5d                   	pop    %ebp
80105e38:	c3                   	ret    
80105e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e40 <uartputc>:
  if(!uart)
80105e40:	a1 c0 46 11 80       	mov    0x801146c0,%eax
80105e45:	85 c0                	test   %eax,%eax
80105e47:	74 47                	je     80105e90 <uartputc+0x50>
{
80105e49:	55                   	push   %ebp
80105e4a:	89 e5                	mov    %esp,%ebp
80105e4c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e4d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105e52:	53                   	push   %ebx
80105e53:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e58:	eb 18                	jmp    80105e72 <uartputc+0x32>
80105e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105e60:	83 ec 0c             	sub    $0xc,%esp
80105e63:	6a 0a                	push   $0xa
80105e65:	e8 d6 ca ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e6a:	83 c4 10             	add    $0x10,%esp
80105e6d:	83 eb 01             	sub    $0x1,%ebx
80105e70:	74 07                	je     80105e79 <uartputc+0x39>
80105e72:	89 f2                	mov    %esi,%edx
80105e74:	ec                   	in     (%dx),%al
80105e75:	a8 20                	test   $0x20,%al
80105e77:	74 e7                	je     80105e60 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e79:	8b 45 08             	mov    0x8(%ebp),%eax
80105e7c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e81:	ee                   	out    %al,(%dx)
}
80105e82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e85:	5b                   	pop    %ebx
80105e86:	5e                   	pop    %esi
80105e87:	5d                   	pop    %ebp
80105e88:	c3                   	ret    
80105e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e90:	c3                   	ret    
80105e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9f:	90                   	nop

80105ea0 <uartintr>:

void
uartintr(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105ea6:	68 30 5d 10 80       	push   $0x80105d30
80105eab:	e8 d0 a9 ff ff       	call   80100880 <consoleintr>
}
80105eb0:	83 c4 10             	add    $0x10,%esp
80105eb3:	c9                   	leave  
80105eb4:	c3                   	ret    

80105eb5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $0
80105eb7:	6a 00                	push   $0x0
  jmp alltraps
80105eb9:	e9 09 fb ff ff       	jmp    801059c7 <alltraps>

80105ebe <vector1>:
.globl vector1
vector1:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $1
80105ec0:	6a 01                	push   $0x1
  jmp alltraps
80105ec2:	e9 00 fb ff ff       	jmp    801059c7 <alltraps>

80105ec7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $2
80105ec9:	6a 02                	push   $0x2
  jmp alltraps
80105ecb:	e9 f7 fa ff ff       	jmp    801059c7 <alltraps>

80105ed0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $3
80105ed2:	6a 03                	push   $0x3
  jmp alltraps
80105ed4:	e9 ee fa ff ff       	jmp    801059c7 <alltraps>

80105ed9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $4
80105edb:	6a 04                	push   $0x4
  jmp alltraps
80105edd:	e9 e5 fa ff ff       	jmp    801059c7 <alltraps>

80105ee2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $5
80105ee4:	6a 05                	push   $0x5
  jmp alltraps
80105ee6:	e9 dc fa ff ff       	jmp    801059c7 <alltraps>

80105eeb <vector6>:
.globl vector6
vector6:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $6
80105eed:	6a 06                	push   $0x6
  jmp alltraps
80105eef:	e9 d3 fa ff ff       	jmp    801059c7 <alltraps>

80105ef4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $7
80105ef6:	6a 07                	push   $0x7
  jmp alltraps
80105ef8:	e9 ca fa ff ff       	jmp    801059c7 <alltraps>

80105efd <vector8>:
.globl vector8
vector8:
  pushl $8
80105efd:	6a 08                	push   $0x8
  jmp alltraps
80105eff:	e9 c3 fa ff ff       	jmp    801059c7 <alltraps>

80105f04 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f04:	6a 00                	push   $0x0
  pushl $9
80105f06:	6a 09                	push   $0x9
  jmp alltraps
80105f08:	e9 ba fa ff ff       	jmp    801059c7 <alltraps>

80105f0d <vector10>:
.globl vector10
vector10:
  pushl $10
80105f0d:	6a 0a                	push   $0xa
  jmp alltraps
80105f0f:	e9 b3 fa ff ff       	jmp    801059c7 <alltraps>

80105f14 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f14:	6a 0b                	push   $0xb
  jmp alltraps
80105f16:	e9 ac fa ff ff       	jmp    801059c7 <alltraps>

80105f1b <vector12>:
.globl vector12
vector12:
  pushl $12
80105f1b:	6a 0c                	push   $0xc
  jmp alltraps
80105f1d:	e9 a5 fa ff ff       	jmp    801059c7 <alltraps>

80105f22 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f22:	6a 0d                	push   $0xd
  jmp alltraps
80105f24:	e9 9e fa ff ff       	jmp    801059c7 <alltraps>

80105f29 <vector14>:
.globl vector14
vector14:
  pushl $14
80105f29:	6a 0e                	push   $0xe
  jmp alltraps
80105f2b:	e9 97 fa ff ff       	jmp    801059c7 <alltraps>

80105f30 <vector15>:
.globl vector15
vector15:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $15
80105f32:	6a 0f                	push   $0xf
  jmp alltraps
80105f34:	e9 8e fa ff ff       	jmp    801059c7 <alltraps>

80105f39 <vector16>:
.globl vector16
vector16:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $16
80105f3b:	6a 10                	push   $0x10
  jmp alltraps
80105f3d:	e9 85 fa ff ff       	jmp    801059c7 <alltraps>

80105f42 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f42:	6a 11                	push   $0x11
  jmp alltraps
80105f44:	e9 7e fa ff ff       	jmp    801059c7 <alltraps>

80105f49 <vector18>:
.globl vector18
vector18:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $18
80105f4b:	6a 12                	push   $0x12
  jmp alltraps
80105f4d:	e9 75 fa ff ff       	jmp    801059c7 <alltraps>

80105f52 <vector19>:
.globl vector19
vector19:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $19
80105f54:	6a 13                	push   $0x13
  jmp alltraps
80105f56:	e9 6c fa ff ff       	jmp    801059c7 <alltraps>

80105f5b <vector20>:
.globl vector20
vector20:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $20
80105f5d:	6a 14                	push   $0x14
  jmp alltraps
80105f5f:	e9 63 fa ff ff       	jmp    801059c7 <alltraps>

80105f64 <vector21>:
.globl vector21
vector21:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $21
80105f66:	6a 15                	push   $0x15
  jmp alltraps
80105f68:	e9 5a fa ff ff       	jmp    801059c7 <alltraps>

80105f6d <vector22>:
.globl vector22
vector22:
  pushl $0
80105f6d:	6a 00                	push   $0x0
  pushl $22
80105f6f:	6a 16                	push   $0x16
  jmp alltraps
80105f71:	e9 51 fa ff ff       	jmp    801059c7 <alltraps>

80105f76 <vector23>:
.globl vector23
vector23:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $23
80105f78:	6a 17                	push   $0x17
  jmp alltraps
80105f7a:	e9 48 fa ff ff       	jmp    801059c7 <alltraps>

80105f7f <vector24>:
.globl vector24
vector24:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $24
80105f81:	6a 18                	push   $0x18
  jmp alltraps
80105f83:	e9 3f fa ff ff       	jmp    801059c7 <alltraps>

80105f88 <vector25>:
.globl vector25
vector25:
  pushl $0
80105f88:	6a 00                	push   $0x0
  pushl $25
80105f8a:	6a 19                	push   $0x19
  jmp alltraps
80105f8c:	e9 36 fa ff ff       	jmp    801059c7 <alltraps>

80105f91 <vector26>:
.globl vector26
vector26:
  pushl $0
80105f91:	6a 00                	push   $0x0
  pushl $26
80105f93:	6a 1a                	push   $0x1a
  jmp alltraps
80105f95:	e9 2d fa ff ff       	jmp    801059c7 <alltraps>

80105f9a <vector27>:
.globl vector27
vector27:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $27
80105f9c:	6a 1b                	push   $0x1b
  jmp alltraps
80105f9e:	e9 24 fa ff ff       	jmp    801059c7 <alltraps>

80105fa3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105fa3:	6a 00                	push   $0x0
  pushl $28
80105fa5:	6a 1c                	push   $0x1c
  jmp alltraps
80105fa7:	e9 1b fa ff ff       	jmp    801059c7 <alltraps>

80105fac <vector29>:
.globl vector29
vector29:
  pushl $0
80105fac:	6a 00                	push   $0x0
  pushl $29
80105fae:	6a 1d                	push   $0x1d
  jmp alltraps
80105fb0:	e9 12 fa ff ff       	jmp    801059c7 <alltraps>

80105fb5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105fb5:	6a 00                	push   $0x0
  pushl $30
80105fb7:	6a 1e                	push   $0x1e
  jmp alltraps
80105fb9:	e9 09 fa ff ff       	jmp    801059c7 <alltraps>

80105fbe <vector31>:
.globl vector31
vector31:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $31
80105fc0:	6a 1f                	push   $0x1f
  jmp alltraps
80105fc2:	e9 00 fa ff ff       	jmp    801059c7 <alltraps>

80105fc7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $32
80105fc9:	6a 20                	push   $0x20
  jmp alltraps
80105fcb:	e9 f7 f9 ff ff       	jmp    801059c7 <alltraps>

80105fd0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105fd0:	6a 00                	push   $0x0
  pushl $33
80105fd2:	6a 21                	push   $0x21
  jmp alltraps
80105fd4:	e9 ee f9 ff ff       	jmp    801059c7 <alltraps>

80105fd9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $34
80105fdb:	6a 22                	push   $0x22
  jmp alltraps
80105fdd:	e9 e5 f9 ff ff       	jmp    801059c7 <alltraps>

80105fe2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $35
80105fe4:	6a 23                	push   $0x23
  jmp alltraps
80105fe6:	e9 dc f9 ff ff       	jmp    801059c7 <alltraps>

80105feb <vector36>:
.globl vector36
vector36:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $36
80105fed:	6a 24                	push   $0x24
  jmp alltraps
80105fef:	e9 d3 f9 ff ff       	jmp    801059c7 <alltraps>

80105ff4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $37
80105ff6:	6a 25                	push   $0x25
  jmp alltraps
80105ff8:	e9 ca f9 ff ff       	jmp    801059c7 <alltraps>

80105ffd <vector38>:
.globl vector38
vector38:
  pushl $0
80105ffd:	6a 00                	push   $0x0
  pushl $38
80105fff:	6a 26                	push   $0x26
  jmp alltraps
80106001:	e9 c1 f9 ff ff       	jmp    801059c7 <alltraps>

80106006 <vector39>:
.globl vector39
vector39:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $39
80106008:	6a 27                	push   $0x27
  jmp alltraps
8010600a:	e9 b8 f9 ff ff       	jmp    801059c7 <alltraps>

8010600f <vector40>:
.globl vector40
vector40:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $40
80106011:	6a 28                	push   $0x28
  jmp alltraps
80106013:	e9 af f9 ff ff       	jmp    801059c7 <alltraps>

80106018 <vector41>:
.globl vector41
vector41:
  pushl $0
80106018:	6a 00                	push   $0x0
  pushl $41
8010601a:	6a 29                	push   $0x29
  jmp alltraps
8010601c:	e9 a6 f9 ff ff       	jmp    801059c7 <alltraps>

80106021 <vector42>:
.globl vector42
vector42:
  pushl $0
80106021:	6a 00                	push   $0x0
  pushl $42
80106023:	6a 2a                	push   $0x2a
  jmp alltraps
80106025:	e9 9d f9 ff ff       	jmp    801059c7 <alltraps>

8010602a <vector43>:
.globl vector43
vector43:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $43
8010602c:	6a 2b                	push   $0x2b
  jmp alltraps
8010602e:	e9 94 f9 ff ff       	jmp    801059c7 <alltraps>

80106033 <vector44>:
.globl vector44
vector44:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $44
80106035:	6a 2c                	push   $0x2c
  jmp alltraps
80106037:	e9 8b f9 ff ff       	jmp    801059c7 <alltraps>

8010603c <vector45>:
.globl vector45
vector45:
  pushl $0
8010603c:	6a 00                	push   $0x0
  pushl $45
8010603e:	6a 2d                	push   $0x2d
  jmp alltraps
80106040:	e9 82 f9 ff ff       	jmp    801059c7 <alltraps>

80106045 <vector46>:
.globl vector46
vector46:
  pushl $0
80106045:	6a 00                	push   $0x0
  pushl $46
80106047:	6a 2e                	push   $0x2e
  jmp alltraps
80106049:	e9 79 f9 ff ff       	jmp    801059c7 <alltraps>

8010604e <vector47>:
.globl vector47
vector47:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $47
80106050:	6a 2f                	push   $0x2f
  jmp alltraps
80106052:	e9 70 f9 ff ff       	jmp    801059c7 <alltraps>

80106057 <vector48>:
.globl vector48
vector48:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $48
80106059:	6a 30                	push   $0x30
  jmp alltraps
8010605b:	e9 67 f9 ff ff       	jmp    801059c7 <alltraps>

80106060 <vector49>:
.globl vector49
vector49:
  pushl $0
80106060:	6a 00                	push   $0x0
  pushl $49
80106062:	6a 31                	push   $0x31
  jmp alltraps
80106064:	e9 5e f9 ff ff       	jmp    801059c7 <alltraps>

80106069 <vector50>:
.globl vector50
vector50:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $50
8010606b:	6a 32                	push   $0x32
  jmp alltraps
8010606d:	e9 55 f9 ff ff       	jmp    801059c7 <alltraps>

80106072 <vector51>:
.globl vector51
vector51:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $51
80106074:	6a 33                	push   $0x33
  jmp alltraps
80106076:	e9 4c f9 ff ff       	jmp    801059c7 <alltraps>

8010607b <vector52>:
.globl vector52
vector52:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $52
8010607d:	6a 34                	push   $0x34
  jmp alltraps
8010607f:	e9 43 f9 ff ff       	jmp    801059c7 <alltraps>

80106084 <vector53>:
.globl vector53
vector53:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $53
80106086:	6a 35                	push   $0x35
  jmp alltraps
80106088:	e9 3a f9 ff ff       	jmp    801059c7 <alltraps>

8010608d <vector54>:
.globl vector54
vector54:
  pushl $0
8010608d:	6a 00                	push   $0x0
  pushl $54
8010608f:	6a 36                	push   $0x36
  jmp alltraps
80106091:	e9 31 f9 ff ff       	jmp    801059c7 <alltraps>

80106096 <vector55>:
.globl vector55
vector55:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $55
80106098:	6a 37                	push   $0x37
  jmp alltraps
8010609a:	e9 28 f9 ff ff       	jmp    801059c7 <alltraps>

8010609f <vector56>:
.globl vector56
vector56:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $56
801060a1:	6a 38                	push   $0x38
  jmp alltraps
801060a3:	e9 1f f9 ff ff       	jmp    801059c7 <alltraps>

801060a8 <vector57>:
.globl vector57
vector57:
  pushl $0
801060a8:	6a 00                	push   $0x0
  pushl $57
801060aa:	6a 39                	push   $0x39
  jmp alltraps
801060ac:	e9 16 f9 ff ff       	jmp    801059c7 <alltraps>

801060b1 <vector58>:
.globl vector58
vector58:
  pushl $0
801060b1:	6a 00                	push   $0x0
  pushl $58
801060b3:	6a 3a                	push   $0x3a
  jmp alltraps
801060b5:	e9 0d f9 ff ff       	jmp    801059c7 <alltraps>

801060ba <vector59>:
.globl vector59
vector59:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $59
801060bc:	6a 3b                	push   $0x3b
  jmp alltraps
801060be:	e9 04 f9 ff ff       	jmp    801059c7 <alltraps>

801060c3 <vector60>:
.globl vector60
vector60:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $60
801060c5:	6a 3c                	push   $0x3c
  jmp alltraps
801060c7:	e9 fb f8 ff ff       	jmp    801059c7 <alltraps>

801060cc <vector61>:
.globl vector61
vector61:
  pushl $0
801060cc:	6a 00                	push   $0x0
  pushl $61
801060ce:	6a 3d                	push   $0x3d
  jmp alltraps
801060d0:	e9 f2 f8 ff ff       	jmp    801059c7 <alltraps>

801060d5 <vector62>:
.globl vector62
vector62:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $62
801060d7:	6a 3e                	push   $0x3e
  jmp alltraps
801060d9:	e9 e9 f8 ff ff       	jmp    801059c7 <alltraps>

801060de <vector63>:
.globl vector63
vector63:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $63
801060e0:	6a 3f                	push   $0x3f
  jmp alltraps
801060e2:	e9 e0 f8 ff ff       	jmp    801059c7 <alltraps>

801060e7 <vector64>:
.globl vector64
vector64:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $64
801060e9:	6a 40                	push   $0x40
  jmp alltraps
801060eb:	e9 d7 f8 ff ff       	jmp    801059c7 <alltraps>

801060f0 <vector65>:
.globl vector65
vector65:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $65
801060f2:	6a 41                	push   $0x41
  jmp alltraps
801060f4:	e9 ce f8 ff ff       	jmp    801059c7 <alltraps>

801060f9 <vector66>:
.globl vector66
vector66:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $66
801060fb:	6a 42                	push   $0x42
  jmp alltraps
801060fd:	e9 c5 f8 ff ff       	jmp    801059c7 <alltraps>

80106102 <vector67>:
.globl vector67
vector67:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $67
80106104:	6a 43                	push   $0x43
  jmp alltraps
80106106:	e9 bc f8 ff ff       	jmp    801059c7 <alltraps>

8010610b <vector68>:
.globl vector68
vector68:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $68
8010610d:	6a 44                	push   $0x44
  jmp alltraps
8010610f:	e9 b3 f8 ff ff       	jmp    801059c7 <alltraps>

80106114 <vector69>:
.globl vector69
vector69:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $69
80106116:	6a 45                	push   $0x45
  jmp alltraps
80106118:	e9 aa f8 ff ff       	jmp    801059c7 <alltraps>

8010611d <vector70>:
.globl vector70
vector70:
  pushl $0
8010611d:	6a 00                	push   $0x0
  pushl $70
8010611f:	6a 46                	push   $0x46
  jmp alltraps
80106121:	e9 a1 f8 ff ff       	jmp    801059c7 <alltraps>

80106126 <vector71>:
.globl vector71
vector71:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $71
80106128:	6a 47                	push   $0x47
  jmp alltraps
8010612a:	e9 98 f8 ff ff       	jmp    801059c7 <alltraps>

8010612f <vector72>:
.globl vector72
vector72:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $72
80106131:	6a 48                	push   $0x48
  jmp alltraps
80106133:	e9 8f f8 ff ff       	jmp    801059c7 <alltraps>

80106138 <vector73>:
.globl vector73
vector73:
  pushl $0
80106138:	6a 00                	push   $0x0
  pushl $73
8010613a:	6a 49                	push   $0x49
  jmp alltraps
8010613c:	e9 86 f8 ff ff       	jmp    801059c7 <alltraps>

80106141 <vector74>:
.globl vector74
vector74:
  pushl $0
80106141:	6a 00                	push   $0x0
  pushl $74
80106143:	6a 4a                	push   $0x4a
  jmp alltraps
80106145:	e9 7d f8 ff ff       	jmp    801059c7 <alltraps>

8010614a <vector75>:
.globl vector75
vector75:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $75
8010614c:	6a 4b                	push   $0x4b
  jmp alltraps
8010614e:	e9 74 f8 ff ff       	jmp    801059c7 <alltraps>

80106153 <vector76>:
.globl vector76
vector76:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $76
80106155:	6a 4c                	push   $0x4c
  jmp alltraps
80106157:	e9 6b f8 ff ff       	jmp    801059c7 <alltraps>

8010615c <vector77>:
.globl vector77
vector77:
  pushl $0
8010615c:	6a 00                	push   $0x0
  pushl $77
8010615e:	6a 4d                	push   $0x4d
  jmp alltraps
80106160:	e9 62 f8 ff ff       	jmp    801059c7 <alltraps>

80106165 <vector78>:
.globl vector78
vector78:
  pushl $0
80106165:	6a 00                	push   $0x0
  pushl $78
80106167:	6a 4e                	push   $0x4e
  jmp alltraps
80106169:	e9 59 f8 ff ff       	jmp    801059c7 <alltraps>

8010616e <vector79>:
.globl vector79
vector79:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $79
80106170:	6a 4f                	push   $0x4f
  jmp alltraps
80106172:	e9 50 f8 ff ff       	jmp    801059c7 <alltraps>

80106177 <vector80>:
.globl vector80
vector80:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $80
80106179:	6a 50                	push   $0x50
  jmp alltraps
8010617b:	e9 47 f8 ff ff       	jmp    801059c7 <alltraps>

80106180 <vector81>:
.globl vector81
vector81:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $81
80106182:	6a 51                	push   $0x51
  jmp alltraps
80106184:	e9 3e f8 ff ff       	jmp    801059c7 <alltraps>

80106189 <vector82>:
.globl vector82
vector82:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $82
8010618b:	6a 52                	push   $0x52
  jmp alltraps
8010618d:	e9 35 f8 ff ff       	jmp    801059c7 <alltraps>

80106192 <vector83>:
.globl vector83
vector83:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $83
80106194:	6a 53                	push   $0x53
  jmp alltraps
80106196:	e9 2c f8 ff ff       	jmp    801059c7 <alltraps>

8010619b <vector84>:
.globl vector84
vector84:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $84
8010619d:	6a 54                	push   $0x54
  jmp alltraps
8010619f:	e9 23 f8 ff ff       	jmp    801059c7 <alltraps>

801061a4 <vector85>:
.globl vector85
vector85:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $85
801061a6:	6a 55                	push   $0x55
  jmp alltraps
801061a8:	e9 1a f8 ff ff       	jmp    801059c7 <alltraps>

801061ad <vector86>:
.globl vector86
vector86:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $86
801061af:	6a 56                	push   $0x56
  jmp alltraps
801061b1:	e9 11 f8 ff ff       	jmp    801059c7 <alltraps>

801061b6 <vector87>:
.globl vector87
vector87:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $87
801061b8:	6a 57                	push   $0x57
  jmp alltraps
801061ba:	e9 08 f8 ff ff       	jmp    801059c7 <alltraps>

801061bf <vector88>:
.globl vector88
vector88:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $88
801061c1:	6a 58                	push   $0x58
  jmp alltraps
801061c3:	e9 ff f7 ff ff       	jmp    801059c7 <alltraps>

801061c8 <vector89>:
.globl vector89
vector89:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $89
801061ca:	6a 59                	push   $0x59
  jmp alltraps
801061cc:	e9 f6 f7 ff ff       	jmp    801059c7 <alltraps>

801061d1 <vector90>:
.globl vector90
vector90:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $90
801061d3:	6a 5a                	push   $0x5a
  jmp alltraps
801061d5:	e9 ed f7 ff ff       	jmp    801059c7 <alltraps>

801061da <vector91>:
.globl vector91
vector91:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $91
801061dc:	6a 5b                	push   $0x5b
  jmp alltraps
801061de:	e9 e4 f7 ff ff       	jmp    801059c7 <alltraps>

801061e3 <vector92>:
.globl vector92
vector92:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $92
801061e5:	6a 5c                	push   $0x5c
  jmp alltraps
801061e7:	e9 db f7 ff ff       	jmp    801059c7 <alltraps>

801061ec <vector93>:
.globl vector93
vector93:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $93
801061ee:	6a 5d                	push   $0x5d
  jmp alltraps
801061f0:	e9 d2 f7 ff ff       	jmp    801059c7 <alltraps>

801061f5 <vector94>:
.globl vector94
vector94:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $94
801061f7:	6a 5e                	push   $0x5e
  jmp alltraps
801061f9:	e9 c9 f7 ff ff       	jmp    801059c7 <alltraps>

801061fe <vector95>:
.globl vector95
vector95:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $95
80106200:	6a 5f                	push   $0x5f
  jmp alltraps
80106202:	e9 c0 f7 ff ff       	jmp    801059c7 <alltraps>

80106207 <vector96>:
.globl vector96
vector96:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $96
80106209:	6a 60                	push   $0x60
  jmp alltraps
8010620b:	e9 b7 f7 ff ff       	jmp    801059c7 <alltraps>

80106210 <vector97>:
.globl vector97
vector97:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $97
80106212:	6a 61                	push   $0x61
  jmp alltraps
80106214:	e9 ae f7 ff ff       	jmp    801059c7 <alltraps>

80106219 <vector98>:
.globl vector98
vector98:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $98
8010621b:	6a 62                	push   $0x62
  jmp alltraps
8010621d:	e9 a5 f7 ff ff       	jmp    801059c7 <alltraps>

80106222 <vector99>:
.globl vector99
vector99:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $99
80106224:	6a 63                	push   $0x63
  jmp alltraps
80106226:	e9 9c f7 ff ff       	jmp    801059c7 <alltraps>

8010622b <vector100>:
.globl vector100
vector100:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $100
8010622d:	6a 64                	push   $0x64
  jmp alltraps
8010622f:	e9 93 f7 ff ff       	jmp    801059c7 <alltraps>

80106234 <vector101>:
.globl vector101
vector101:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $101
80106236:	6a 65                	push   $0x65
  jmp alltraps
80106238:	e9 8a f7 ff ff       	jmp    801059c7 <alltraps>

8010623d <vector102>:
.globl vector102
vector102:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $102
8010623f:	6a 66                	push   $0x66
  jmp alltraps
80106241:	e9 81 f7 ff ff       	jmp    801059c7 <alltraps>

80106246 <vector103>:
.globl vector103
vector103:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $103
80106248:	6a 67                	push   $0x67
  jmp alltraps
8010624a:	e9 78 f7 ff ff       	jmp    801059c7 <alltraps>

8010624f <vector104>:
.globl vector104
vector104:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $104
80106251:	6a 68                	push   $0x68
  jmp alltraps
80106253:	e9 6f f7 ff ff       	jmp    801059c7 <alltraps>

80106258 <vector105>:
.globl vector105
vector105:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $105
8010625a:	6a 69                	push   $0x69
  jmp alltraps
8010625c:	e9 66 f7 ff ff       	jmp    801059c7 <alltraps>

80106261 <vector106>:
.globl vector106
vector106:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $106
80106263:	6a 6a                	push   $0x6a
  jmp alltraps
80106265:	e9 5d f7 ff ff       	jmp    801059c7 <alltraps>

8010626a <vector107>:
.globl vector107
vector107:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $107
8010626c:	6a 6b                	push   $0x6b
  jmp alltraps
8010626e:	e9 54 f7 ff ff       	jmp    801059c7 <alltraps>

80106273 <vector108>:
.globl vector108
vector108:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $108
80106275:	6a 6c                	push   $0x6c
  jmp alltraps
80106277:	e9 4b f7 ff ff       	jmp    801059c7 <alltraps>

8010627c <vector109>:
.globl vector109
vector109:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $109
8010627e:	6a 6d                	push   $0x6d
  jmp alltraps
80106280:	e9 42 f7 ff ff       	jmp    801059c7 <alltraps>

80106285 <vector110>:
.globl vector110
vector110:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $110
80106287:	6a 6e                	push   $0x6e
  jmp alltraps
80106289:	e9 39 f7 ff ff       	jmp    801059c7 <alltraps>

8010628e <vector111>:
.globl vector111
vector111:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $111
80106290:	6a 6f                	push   $0x6f
  jmp alltraps
80106292:	e9 30 f7 ff ff       	jmp    801059c7 <alltraps>

80106297 <vector112>:
.globl vector112
vector112:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $112
80106299:	6a 70                	push   $0x70
  jmp alltraps
8010629b:	e9 27 f7 ff ff       	jmp    801059c7 <alltraps>

801062a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $113
801062a2:	6a 71                	push   $0x71
  jmp alltraps
801062a4:	e9 1e f7 ff ff       	jmp    801059c7 <alltraps>

801062a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $114
801062ab:	6a 72                	push   $0x72
  jmp alltraps
801062ad:	e9 15 f7 ff ff       	jmp    801059c7 <alltraps>

801062b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $115
801062b4:	6a 73                	push   $0x73
  jmp alltraps
801062b6:	e9 0c f7 ff ff       	jmp    801059c7 <alltraps>

801062bb <vector116>:
.globl vector116
vector116:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $116
801062bd:	6a 74                	push   $0x74
  jmp alltraps
801062bf:	e9 03 f7 ff ff       	jmp    801059c7 <alltraps>

801062c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $117
801062c6:	6a 75                	push   $0x75
  jmp alltraps
801062c8:	e9 fa f6 ff ff       	jmp    801059c7 <alltraps>

801062cd <vector118>:
.globl vector118
vector118:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $118
801062cf:	6a 76                	push   $0x76
  jmp alltraps
801062d1:	e9 f1 f6 ff ff       	jmp    801059c7 <alltraps>

801062d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $119
801062d8:	6a 77                	push   $0x77
  jmp alltraps
801062da:	e9 e8 f6 ff ff       	jmp    801059c7 <alltraps>

801062df <vector120>:
.globl vector120
vector120:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $120
801062e1:	6a 78                	push   $0x78
  jmp alltraps
801062e3:	e9 df f6 ff ff       	jmp    801059c7 <alltraps>

801062e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $121
801062ea:	6a 79                	push   $0x79
  jmp alltraps
801062ec:	e9 d6 f6 ff ff       	jmp    801059c7 <alltraps>

801062f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $122
801062f3:	6a 7a                	push   $0x7a
  jmp alltraps
801062f5:	e9 cd f6 ff ff       	jmp    801059c7 <alltraps>

801062fa <vector123>:
.globl vector123
vector123:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $123
801062fc:	6a 7b                	push   $0x7b
  jmp alltraps
801062fe:	e9 c4 f6 ff ff       	jmp    801059c7 <alltraps>

80106303 <vector124>:
.globl vector124
vector124:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $124
80106305:	6a 7c                	push   $0x7c
  jmp alltraps
80106307:	e9 bb f6 ff ff       	jmp    801059c7 <alltraps>

8010630c <vector125>:
.globl vector125
vector125:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $125
8010630e:	6a 7d                	push   $0x7d
  jmp alltraps
80106310:	e9 b2 f6 ff ff       	jmp    801059c7 <alltraps>

80106315 <vector126>:
.globl vector126
vector126:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $126
80106317:	6a 7e                	push   $0x7e
  jmp alltraps
80106319:	e9 a9 f6 ff ff       	jmp    801059c7 <alltraps>

8010631e <vector127>:
.globl vector127
vector127:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $127
80106320:	6a 7f                	push   $0x7f
  jmp alltraps
80106322:	e9 a0 f6 ff ff       	jmp    801059c7 <alltraps>

80106327 <vector128>:
.globl vector128
vector128:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $128
80106329:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010632e:	e9 94 f6 ff ff       	jmp    801059c7 <alltraps>

80106333 <vector129>:
.globl vector129
vector129:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $129
80106335:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010633a:	e9 88 f6 ff ff       	jmp    801059c7 <alltraps>

8010633f <vector130>:
.globl vector130
vector130:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $130
80106341:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106346:	e9 7c f6 ff ff       	jmp    801059c7 <alltraps>

8010634b <vector131>:
.globl vector131
vector131:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $131
8010634d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106352:	e9 70 f6 ff ff       	jmp    801059c7 <alltraps>

80106357 <vector132>:
.globl vector132
vector132:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $132
80106359:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010635e:	e9 64 f6 ff ff       	jmp    801059c7 <alltraps>

80106363 <vector133>:
.globl vector133
vector133:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $133
80106365:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010636a:	e9 58 f6 ff ff       	jmp    801059c7 <alltraps>

8010636f <vector134>:
.globl vector134
vector134:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $134
80106371:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106376:	e9 4c f6 ff ff       	jmp    801059c7 <alltraps>

8010637b <vector135>:
.globl vector135
vector135:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $135
8010637d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106382:	e9 40 f6 ff ff       	jmp    801059c7 <alltraps>

80106387 <vector136>:
.globl vector136
vector136:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $136
80106389:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010638e:	e9 34 f6 ff ff       	jmp    801059c7 <alltraps>

80106393 <vector137>:
.globl vector137
vector137:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $137
80106395:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010639a:	e9 28 f6 ff ff       	jmp    801059c7 <alltraps>

8010639f <vector138>:
.globl vector138
vector138:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $138
801063a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801063a6:	e9 1c f6 ff ff       	jmp    801059c7 <alltraps>

801063ab <vector139>:
.globl vector139
vector139:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $139
801063ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801063b2:	e9 10 f6 ff ff       	jmp    801059c7 <alltraps>

801063b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $140
801063b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801063be:	e9 04 f6 ff ff       	jmp    801059c7 <alltraps>

801063c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $141
801063c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801063ca:	e9 f8 f5 ff ff       	jmp    801059c7 <alltraps>

801063cf <vector142>:
.globl vector142
vector142:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $142
801063d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801063d6:	e9 ec f5 ff ff       	jmp    801059c7 <alltraps>

801063db <vector143>:
.globl vector143
vector143:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $143
801063dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801063e2:	e9 e0 f5 ff ff       	jmp    801059c7 <alltraps>

801063e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $144
801063e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801063ee:	e9 d4 f5 ff ff       	jmp    801059c7 <alltraps>

801063f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $145
801063f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801063fa:	e9 c8 f5 ff ff       	jmp    801059c7 <alltraps>

801063ff <vector146>:
.globl vector146
vector146:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $146
80106401:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106406:	e9 bc f5 ff ff       	jmp    801059c7 <alltraps>

8010640b <vector147>:
.globl vector147
vector147:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $147
8010640d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106412:	e9 b0 f5 ff ff       	jmp    801059c7 <alltraps>

80106417 <vector148>:
.globl vector148
vector148:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $148
80106419:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010641e:	e9 a4 f5 ff ff       	jmp    801059c7 <alltraps>

80106423 <vector149>:
.globl vector149
vector149:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $149
80106425:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010642a:	e9 98 f5 ff ff       	jmp    801059c7 <alltraps>

8010642f <vector150>:
.globl vector150
vector150:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $150
80106431:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106436:	e9 8c f5 ff ff       	jmp    801059c7 <alltraps>

8010643b <vector151>:
.globl vector151
vector151:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $151
8010643d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106442:	e9 80 f5 ff ff       	jmp    801059c7 <alltraps>

80106447 <vector152>:
.globl vector152
vector152:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $152
80106449:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010644e:	e9 74 f5 ff ff       	jmp    801059c7 <alltraps>

80106453 <vector153>:
.globl vector153
vector153:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $153
80106455:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010645a:	e9 68 f5 ff ff       	jmp    801059c7 <alltraps>

8010645f <vector154>:
.globl vector154
vector154:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $154
80106461:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106466:	e9 5c f5 ff ff       	jmp    801059c7 <alltraps>

8010646b <vector155>:
.globl vector155
vector155:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $155
8010646d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106472:	e9 50 f5 ff ff       	jmp    801059c7 <alltraps>

80106477 <vector156>:
.globl vector156
vector156:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $156
80106479:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010647e:	e9 44 f5 ff ff       	jmp    801059c7 <alltraps>

80106483 <vector157>:
.globl vector157
vector157:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $157
80106485:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010648a:	e9 38 f5 ff ff       	jmp    801059c7 <alltraps>

8010648f <vector158>:
.globl vector158
vector158:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $158
80106491:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106496:	e9 2c f5 ff ff       	jmp    801059c7 <alltraps>

8010649b <vector159>:
.globl vector159
vector159:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $159
8010649d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801064a2:	e9 20 f5 ff ff       	jmp    801059c7 <alltraps>

801064a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $160
801064a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801064ae:	e9 14 f5 ff ff       	jmp    801059c7 <alltraps>

801064b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $161
801064b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801064ba:	e9 08 f5 ff ff       	jmp    801059c7 <alltraps>

801064bf <vector162>:
.globl vector162
vector162:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $162
801064c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801064c6:	e9 fc f4 ff ff       	jmp    801059c7 <alltraps>

801064cb <vector163>:
.globl vector163
vector163:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $163
801064cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801064d2:	e9 f0 f4 ff ff       	jmp    801059c7 <alltraps>

801064d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $164
801064d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801064de:	e9 e4 f4 ff ff       	jmp    801059c7 <alltraps>

801064e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $165
801064e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801064ea:	e9 d8 f4 ff ff       	jmp    801059c7 <alltraps>

801064ef <vector166>:
.globl vector166
vector166:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $166
801064f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801064f6:	e9 cc f4 ff ff       	jmp    801059c7 <alltraps>

801064fb <vector167>:
.globl vector167
vector167:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $167
801064fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106502:	e9 c0 f4 ff ff       	jmp    801059c7 <alltraps>

80106507 <vector168>:
.globl vector168
vector168:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $168
80106509:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010650e:	e9 b4 f4 ff ff       	jmp    801059c7 <alltraps>

80106513 <vector169>:
.globl vector169
vector169:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $169
80106515:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010651a:	e9 a8 f4 ff ff       	jmp    801059c7 <alltraps>

8010651f <vector170>:
.globl vector170
vector170:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $170
80106521:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106526:	e9 9c f4 ff ff       	jmp    801059c7 <alltraps>

8010652b <vector171>:
.globl vector171
vector171:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $171
8010652d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106532:	e9 90 f4 ff ff       	jmp    801059c7 <alltraps>

80106537 <vector172>:
.globl vector172
vector172:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $172
80106539:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010653e:	e9 84 f4 ff ff       	jmp    801059c7 <alltraps>

80106543 <vector173>:
.globl vector173
vector173:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $173
80106545:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010654a:	e9 78 f4 ff ff       	jmp    801059c7 <alltraps>

8010654f <vector174>:
.globl vector174
vector174:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $174
80106551:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106556:	e9 6c f4 ff ff       	jmp    801059c7 <alltraps>

8010655b <vector175>:
.globl vector175
vector175:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $175
8010655d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106562:	e9 60 f4 ff ff       	jmp    801059c7 <alltraps>

80106567 <vector176>:
.globl vector176
vector176:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $176
80106569:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010656e:	e9 54 f4 ff ff       	jmp    801059c7 <alltraps>

80106573 <vector177>:
.globl vector177
vector177:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $177
80106575:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010657a:	e9 48 f4 ff ff       	jmp    801059c7 <alltraps>

8010657f <vector178>:
.globl vector178
vector178:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $178
80106581:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106586:	e9 3c f4 ff ff       	jmp    801059c7 <alltraps>

8010658b <vector179>:
.globl vector179
vector179:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $179
8010658d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106592:	e9 30 f4 ff ff       	jmp    801059c7 <alltraps>

80106597 <vector180>:
.globl vector180
vector180:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $180
80106599:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010659e:	e9 24 f4 ff ff       	jmp    801059c7 <alltraps>

801065a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $181
801065a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801065aa:	e9 18 f4 ff ff       	jmp    801059c7 <alltraps>

801065af <vector182>:
.globl vector182
vector182:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $182
801065b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801065b6:	e9 0c f4 ff ff       	jmp    801059c7 <alltraps>

801065bb <vector183>:
.globl vector183
vector183:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $183
801065bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801065c2:	e9 00 f4 ff ff       	jmp    801059c7 <alltraps>

801065c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $184
801065c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801065ce:	e9 f4 f3 ff ff       	jmp    801059c7 <alltraps>

801065d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $185
801065d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801065da:	e9 e8 f3 ff ff       	jmp    801059c7 <alltraps>

801065df <vector186>:
.globl vector186
vector186:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $186
801065e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801065e6:	e9 dc f3 ff ff       	jmp    801059c7 <alltraps>

801065eb <vector187>:
.globl vector187
vector187:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $187
801065ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801065f2:	e9 d0 f3 ff ff       	jmp    801059c7 <alltraps>

801065f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $188
801065f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801065fe:	e9 c4 f3 ff ff       	jmp    801059c7 <alltraps>

80106603 <vector189>:
.globl vector189
vector189:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $189
80106605:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010660a:	e9 b8 f3 ff ff       	jmp    801059c7 <alltraps>

8010660f <vector190>:
.globl vector190
vector190:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $190
80106611:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106616:	e9 ac f3 ff ff       	jmp    801059c7 <alltraps>

8010661b <vector191>:
.globl vector191
vector191:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $191
8010661d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106622:	e9 a0 f3 ff ff       	jmp    801059c7 <alltraps>

80106627 <vector192>:
.globl vector192
vector192:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $192
80106629:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010662e:	e9 94 f3 ff ff       	jmp    801059c7 <alltraps>

80106633 <vector193>:
.globl vector193
vector193:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $193
80106635:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010663a:	e9 88 f3 ff ff       	jmp    801059c7 <alltraps>

8010663f <vector194>:
.globl vector194
vector194:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $194
80106641:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106646:	e9 7c f3 ff ff       	jmp    801059c7 <alltraps>

8010664b <vector195>:
.globl vector195
vector195:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $195
8010664d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106652:	e9 70 f3 ff ff       	jmp    801059c7 <alltraps>

80106657 <vector196>:
.globl vector196
vector196:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $196
80106659:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010665e:	e9 64 f3 ff ff       	jmp    801059c7 <alltraps>

80106663 <vector197>:
.globl vector197
vector197:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $197
80106665:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010666a:	e9 58 f3 ff ff       	jmp    801059c7 <alltraps>

8010666f <vector198>:
.globl vector198
vector198:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $198
80106671:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106676:	e9 4c f3 ff ff       	jmp    801059c7 <alltraps>

8010667b <vector199>:
.globl vector199
vector199:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $199
8010667d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106682:	e9 40 f3 ff ff       	jmp    801059c7 <alltraps>

80106687 <vector200>:
.globl vector200
vector200:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $200
80106689:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010668e:	e9 34 f3 ff ff       	jmp    801059c7 <alltraps>

80106693 <vector201>:
.globl vector201
vector201:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $201
80106695:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010669a:	e9 28 f3 ff ff       	jmp    801059c7 <alltraps>

8010669f <vector202>:
.globl vector202
vector202:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $202
801066a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801066a6:	e9 1c f3 ff ff       	jmp    801059c7 <alltraps>

801066ab <vector203>:
.globl vector203
vector203:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $203
801066ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801066b2:	e9 10 f3 ff ff       	jmp    801059c7 <alltraps>

801066b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $204
801066b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801066be:	e9 04 f3 ff ff       	jmp    801059c7 <alltraps>

801066c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $205
801066c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801066ca:	e9 f8 f2 ff ff       	jmp    801059c7 <alltraps>

801066cf <vector206>:
.globl vector206
vector206:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $206
801066d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801066d6:	e9 ec f2 ff ff       	jmp    801059c7 <alltraps>

801066db <vector207>:
.globl vector207
vector207:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $207
801066dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801066e2:	e9 e0 f2 ff ff       	jmp    801059c7 <alltraps>

801066e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $208
801066e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801066ee:	e9 d4 f2 ff ff       	jmp    801059c7 <alltraps>

801066f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $209
801066f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801066fa:	e9 c8 f2 ff ff       	jmp    801059c7 <alltraps>

801066ff <vector210>:
.globl vector210
vector210:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $210
80106701:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106706:	e9 bc f2 ff ff       	jmp    801059c7 <alltraps>

8010670b <vector211>:
.globl vector211
vector211:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $211
8010670d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106712:	e9 b0 f2 ff ff       	jmp    801059c7 <alltraps>

80106717 <vector212>:
.globl vector212
vector212:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $212
80106719:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010671e:	e9 a4 f2 ff ff       	jmp    801059c7 <alltraps>

80106723 <vector213>:
.globl vector213
vector213:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $213
80106725:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010672a:	e9 98 f2 ff ff       	jmp    801059c7 <alltraps>

8010672f <vector214>:
.globl vector214
vector214:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $214
80106731:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106736:	e9 8c f2 ff ff       	jmp    801059c7 <alltraps>

8010673b <vector215>:
.globl vector215
vector215:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $215
8010673d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106742:	e9 80 f2 ff ff       	jmp    801059c7 <alltraps>

80106747 <vector216>:
.globl vector216
vector216:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $216
80106749:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010674e:	e9 74 f2 ff ff       	jmp    801059c7 <alltraps>

80106753 <vector217>:
.globl vector217
vector217:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $217
80106755:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010675a:	e9 68 f2 ff ff       	jmp    801059c7 <alltraps>

8010675f <vector218>:
.globl vector218
vector218:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $218
80106761:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106766:	e9 5c f2 ff ff       	jmp    801059c7 <alltraps>

8010676b <vector219>:
.globl vector219
vector219:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $219
8010676d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106772:	e9 50 f2 ff ff       	jmp    801059c7 <alltraps>

80106777 <vector220>:
.globl vector220
vector220:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $220
80106779:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010677e:	e9 44 f2 ff ff       	jmp    801059c7 <alltraps>

80106783 <vector221>:
.globl vector221
vector221:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $221
80106785:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010678a:	e9 38 f2 ff ff       	jmp    801059c7 <alltraps>

8010678f <vector222>:
.globl vector222
vector222:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $222
80106791:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106796:	e9 2c f2 ff ff       	jmp    801059c7 <alltraps>

8010679b <vector223>:
.globl vector223
vector223:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $223
8010679d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801067a2:	e9 20 f2 ff ff       	jmp    801059c7 <alltraps>

801067a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $224
801067a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801067ae:	e9 14 f2 ff ff       	jmp    801059c7 <alltraps>

801067b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $225
801067b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801067ba:	e9 08 f2 ff ff       	jmp    801059c7 <alltraps>

801067bf <vector226>:
.globl vector226
vector226:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $226
801067c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801067c6:	e9 fc f1 ff ff       	jmp    801059c7 <alltraps>

801067cb <vector227>:
.globl vector227
vector227:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $227
801067cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801067d2:	e9 f0 f1 ff ff       	jmp    801059c7 <alltraps>

801067d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $228
801067d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801067de:	e9 e4 f1 ff ff       	jmp    801059c7 <alltraps>

801067e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $229
801067e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801067ea:	e9 d8 f1 ff ff       	jmp    801059c7 <alltraps>

801067ef <vector230>:
.globl vector230
vector230:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $230
801067f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801067f6:	e9 cc f1 ff ff       	jmp    801059c7 <alltraps>

801067fb <vector231>:
.globl vector231
vector231:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $231
801067fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106802:	e9 c0 f1 ff ff       	jmp    801059c7 <alltraps>

80106807 <vector232>:
.globl vector232
vector232:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $232
80106809:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010680e:	e9 b4 f1 ff ff       	jmp    801059c7 <alltraps>

80106813 <vector233>:
.globl vector233
vector233:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $233
80106815:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010681a:	e9 a8 f1 ff ff       	jmp    801059c7 <alltraps>

8010681f <vector234>:
.globl vector234
vector234:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $234
80106821:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106826:	e9 9c f1 ff ff       	jmp    801059c7 <alltraps>

8010682b <vector235>:
.globl vector235
vector235:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $235
8010682d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106832:	e9 90 f1 ff ff       	jmp    801059c7 <alltraps>

80106837 <vector236>:
.globl vector236
vector236:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $236
80106839:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010683e:	e9 84 f1 ff ff       	jmp    801059c7 <alltraps>

80106843 <vector237>:
.globl vector237
vector237:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $237
80106845:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010684a:	e9 78 f1 ff ff       	jmp    801059c7 <alltraps>

8010684f <vector238>:
.globl vector238
vector238:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $238
80106851:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106856:	e9 6c f1 ff ff       	jmp    801059c7 <alltraps>

8010685b <vector239>:
.globl vector239
vector239:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $239
8010685d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106862:	e9 60 f1 ff ff       	jmp    801059c7 <alltraps>

80106867 <vector240>:
.globl vector240
vector240:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $240
80106869:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010686e:	e9 54 f1 ff ff       	jmp    801059c7 <alltraps>

80106873 <vector241>:
.globl vector241
vector241:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $241
80106875:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010687a:	e9 48 f1 ff ff       	jmp    801059c7 <alltraps>

8010687f <vector242>:
.globl vector242
vector242:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $242
80106881:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106886:	e9 3c f1 ff ff       	jmp    801059c7 <alltraps>

8010688b <vector243>:
.globl vector243
vector243:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $243
8010688d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106892:	e9 30 f1 ff ff       	jmp    801059c7 <alltraps>

80106897 <vector244>:
.globl vector244
vector244:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $244
80106899:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010689e:	e9 24 f1 ff ff       	jmp    801059c7 <alltraps>

801068a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $245
801068a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801068aa:	e9 18 f1 ff ff       	jmp    801059c7 <alltraps>

801068af <vector246>:
.globl vector246
vector246:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $246
801068b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801068b6:	e9 0c f1 ff ff       	jmp    801059c7 <alltraps>

801068bb <vector247>:
.globl vector247
vector247:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $247
801068bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801068c2:	e9 00 f1 ff ff       	jmp    801059c7 <alltraps>

801068c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $248
801068c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801068ce:	e9 f4 f0 ff ff       	jmp    801059c7 <alltraps>

801068d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $249
801068d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801068da:	e9 e8 f0 ff ff       	jmp    801059c7 <alltraps>

801068df <vector250>:
.globl vector250
vector250:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $250
801068e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801068e6:	e9 dc f0 ff ff       	jmp    801059c7 <alltraps>

801068eb <vector251>:
.globl vector251
vector251:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $251
801068ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801068f2:	e9 d0 f0 ff ff       	jmp    801059c7 <alltraps>

801068f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $252
801068f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801068fe:	e9 c4 f0 ff ff       	jmp    801059c7 <alltraps>

80106903 <vector253>:
.globl vector253
vector253:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $253
80106905:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010690a:	e9 b8 f0 ff ff       	jmp    801059c7 <alltraps>

8010690f <vector254>:
.globl vector254
vector254:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $254
80106911:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106916:	e9 ac f0 ff ff       	jmp    801059c7 <alltraps>

8010691b <vector255>:
.globl vector255
vector255:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $255
8010691d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106922:	e9 a0 f0 ff ff       	jmp    801059c7 <alltraps>
80106927:	66 90                	xchg   %ax,%ax
80106929:	66 90                	xchg   %ax,%ax
8010692b:	66 90                	xchg   %ax,%ax
8010692d:	66 90                	xchg   %ax,%ax
8010692f:	90                   	nop

80106930 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	57                   	push   %edi
80106934:	56                   	push   %esi
80106935:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106936:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010693c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106942:	83 ec 1c             	sub    $0x1c,%esp
80106945:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106948:	39 d3                	cmp    %edx,%ebx
8010694a:	73 49                	jae    80106995 <deallocuvm.part.0+0x65>
8010694c:	89 c7                	mov    %eax,%edi
8010694e:	eb 0c                	jmp    8010695c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106950:	83 c0 01             	add    $0x1,%eax
80106953:	c1 e0 16             	shl    $0x16,%eax
80106956:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106958:	39 da                	cmp    %ebx,%edx
8010695a:	76 39                	jbe    80106995 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010695c:	89 d8                	mov    %ebx,%eax
8010695e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106961:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106964:	f6 c1 01             	test   $0x1,%cl
80106967:	74 e7                	je     80106950 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106969:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010696b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106971:	c1 ee 0a             	shr    $0xa,%esi
80106974:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010697a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106981:	85 f6                	test   %esi,%esi
80106983:	74 cb                	je     80106950 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106985:	8b 06                	mov    (%esi),%eax
80106987:	a8 01                	test   $0x1,%al
80106989:	75 15                	jne    801069a0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010698b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106991:	39 da                	cmp    %ebx,%edx
80106993:	77 c7                	ja     8010695c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106995:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106998:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010699b:	5b                   	pop    %ebx
8010699c:	5e                   	pop    %esi
8010699d:	5f                   	pop    %edi
8010699e:	5d                   	pop    %ebp
8010699f:	c3                   	ret    
      if(pa == 0)
801069a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069a5:	74 25                	je     801069cc <deallocuvm.part.0+0x9c>
      kfree(v);
801069a7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801069aa:	05 00 00 00 80       	add    $0x80000000,%eax
801069af:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801069b2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801069b8:	50                   	push   %eax
801069b9:	e8 12 bb ff ff       	call   801024d0 <kfree>
      *pte = 0;
801069be:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801069c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801069c7:	83 c4 10             	add    $0x10,%esp
801069ca:	eb 8c                	jmp    80106958 <deallocuvm.part.0+0x28>
        panic("kfree");
801069cc:	83 ec 0c             	sub    $0xc,%esp
801069cf:	68 46 77 10 80       	push   $0x80107746
801069d4:	e8 a7 99 ff ff       	call   80100380 <panic>
801069d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069e0 <mappages>:
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	57                   	push   %edi
801069e4:	56                   	push   %esi
801069e5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801069e6:	89 d3                	mov    %edx,%ebx
801069e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801069ee:	83 ec 1c             	sub    $0x1c,%esp
801069f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801069f4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801069f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106a00:	8b 45 08             	mov    0x8(%ebp),%eax
80106a03:	29 d8                	sub    %ebx,%eax
80106a05:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a08:	eb 3d                	jmp    80106a47 <mappages+0x67>
80106a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106a10:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a17:	c1 ea 0a             	shr    $0xa,%edx
80106a1a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106a20:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106a27:	85 c0                	test   %eax,%eax
80106a29:	74 75                	je     80106aa0 <mappages+0xc0>
    if(*pte & PTE_P)
80106a2b:	f6 00 01             	testb  $0x1,(%eax)
80106a2e:	0f 85 86 00 00 00    	jne    80106aba <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106a34:	0b 75 0c             	or     0xc(%ebp),%esi
80106a37:	83 ce 01             	or     $0x1,%esi
80106a3a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106a3c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106a3f:	74 6f                	je     80106ab0 <mappages+0xd0>
    a += PGSIZE;
80106a41:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106a47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106a4a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a4d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106a50:	89 d8                	mov    %ebx,%eax
80106a52:	c1 e8 16             	shr    $0x16,%eax
80106a55:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106a58:	8b 07                	mov    (%edi),%eax
80106a5a:	a8 01                	test   $0x1,%al
80106a5c:	75 b2                	jne    80106a10 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a5e:	e8 2d bc ff ff       	call   80102690 <kalloc>
80106a63:	85 c0                	test   %eax,%eax
80106a65:	74 39                	je     80106aa0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106a67:	83 ec 04             	sub    $0x4,%esp
80106a6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106a6d:	68 00 10 00 00       	push   $0x1000
80106a72:	6a 00                	push   $0x0
80106a74:	50                   	push   %eax
80106a75:	e8 36 dd ff ff       	call   801047b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a7a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106a7d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a80:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106a86:	83 c8 07             	or     $0x7,%eax
80106a89:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106a8b:	89 d8                	mov    %ebx,%eax
80106a8d:	c1 e8 0a             	shr    $0xa,%eax
80106a90:	25 fc 0f 00 00       	and    $0xffc,%eax
80106a95:	01 d0                	add    %edx,%eax
80106a97:	eb 92                	jmp    80106a2b <mappages+0x4b>
80106a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106aa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106aa8:	5b                   	pop    %ebx
80106aa9:	5e                   	pop    %esi
80106aaa:	5f                   	pop    %edi
80106aab:	5d                   	pop    %ebp
80106aac:	c3                   	ret    
80106aad:	8d 76 00             	lea    0x0(%esi),%esi
80106ab0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ab3:	31 c0                	xor    %eax,%eax
}
80106ab5:	5b                   	pop    %ebx
80106ab6:	5e                   	pop    %esi
80106ab7:	5f                   	pop    %edi
80106ab8:	5d                   	pop    %ebp
80106ab9:	c3                   	ret    
      panic("remap");
80106aba:	83 ec 0c             	sub    $0xc,%esp
80106abd:	68 98 7d 10 80       	push   $0x80107d98
80106ac2:	e8 b9 98 ff ff       	call   80100380 <panic>
80106ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ace:	66 90                	xchg   %ax,%ax

80106ad0 <seginit>:
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ad6:	e8 a5 ce ff ff       	call   80103980 <cpuid>
  pd[0] = size-1;
80106adb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ae0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ae6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106aea:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106af1:	ff 00 00 
80106af4:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106afb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106afe:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106b05:	ff 00 00 
80106b08:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106b0f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b12:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106b19:	ff 00 00 
80106b1c:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106b23:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b26:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106b2d:	ff 00 00 
80106b30:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106b37:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106b3a:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106b3f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106b43:	c1 e8 10             	shr    $0x10,%eax
80106b46:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106b4a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106b4d:	0f 01 10             	lgdtl  (%eax)
}
80106b50:	c9                   	leave  
80106b51:	c3                   	ret    
80106b52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b60 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b60:	a1 c4 46 11 80       	mov    0x801146c4,%eax
80106b65:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b6a:	0f 22 d8             	mov    %eax,%cr3
}
80106b6d:	c3                   	ret    
80106b6e:	66 90                	xchg   %ax,%ax

80106b70 <switchuvm>:
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
80106b76:	83 ec 1c             	sub    $0x1c,%esp
80106b79:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106b7c:	85 f6                	test   %esi,%esi
80106b7e:	0f 84 cb 00 00 00    	je     80106c4f <switchuvm+0xdf>
  if(p->kstack == 0)
80106b84:	8b 46 08             	mov    0x8(%esi),%eax
80106b87:	85 c0                	test   %eax,%eax
80106b89:	0f 84 da 00 00 00    	je     80106c69 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106b8f:	8b 46 04             	mov    0x4(%esi),%eax
80106b92:	85 c0                	test   %eax,%eax
80106b94:	0f 84 c2 00 00 00    	je     80106c5c <switchuvm+0xec>
  pushcli();
80106b9a:	e8 01 da ff ff       	call   801045a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b9f:	e8 7c cd ff ff       	call   80103920 <mycpu>
80106ba4:	89 c3                	mov    %eax,%ebx
80106ba6:	e8 75 cd ff ff       	call   80103920 <mycpu>
80106bab:	89 c7                	mov    %eax,%edi
80106bad:	e8 6e cd ff ff       	call   80103920 <mycpu>
80106bb2:	83 c7 08             	add    $0x8,%edi
80106bb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106bb8:	e8 63 cd ff ff       	call   80103920 <mycpu>
80106bbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106bc0:	ba 67 00 00 00       	mov    $0x67,%edx
80106bc5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106bcc:	83 c0 08             	add    $0x8,%eax
80106bcf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106bd6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106bdb:	83 c1 08             	add    $0x8,%ecx
80106bde:	c1 e8 18             	shr    $0x18,%eax
80106be1:	c1 e9 10             	shr    $0x10,%ecx
80106be4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106bea:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106bf0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106bf5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106bfc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106c01:	e8 1a cd ff ff       	call   80103920 <mycpu>
80106c06:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c0d:	e8 0e cd ff ff       	call   80103920 <mycpu>
80106c12:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106c16:	8b 5e 08             	mov    0x8(%esi),%ebx
80106c19:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c1f:	e8 fc cc ff ff       	call   80103920 <mycpu>
80106c24:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c27:	e8 f4 cc ff ff       	call   80103920 <mycpu>
80106c2c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106c30:	b8 28 00 00 00       	mov    $0x28,%eax
80106c35:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106c38:	8b 46 04             	mov    0x4(%esi),%eax
80106c3b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c40:	0f 22 d8             	mov    %eax,%cr3
}
80106c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c46:	5b                   	pop    %ebx
80106c47:	5e                   	pop    %esi
80106c48:	5f                   	pop    %edi
80106c49:	5d                   	pop    %ebp
  popcli();
80106c4a:	e9 a1 d9 ff ff       	jmp    801045f0 <popcli>
    panic("switchuvm: no process");
80106c4f:	83 ec 0c             	sub    $0xc,%esp
80106c52:	68 9e 7d 10 80       	push   $0x80107d9e
80106c57:	e8 24 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106c5c:	83 ec 0c             	sub    $0xc,%esp
80106c5f:	68 c9 7d 10 80       	push   $0x80107dc9
80106c64:	e8 17 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106c69:	83 ec 0c             	sub    $0xc,%esp
80106c6c:	68 b4 7d 10 80       	push   $0x80107db4
80106c71:	e8 0a 97 ff ff       	call   80100380 <panic>
80106c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c7d:	8d 76 00             	lea    0x0(%esi),%esi

80106c80 <inituvm>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 1c             	sub    $0x1c,%esp
80106c89:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c8c:	8b 75 10             	mov    0x10(%ebp),%esi
80106c8f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106c95:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c9b:	77 4b                	ja     80106ce8 <inituvm+0x68>
  mem = kalloc();
80106c9d:	e8 ee b9 ff ff       	call   80102690 <kalloc>
  memset(mem, 0, PGSIZE);
80106ca2:	83 ec 04             	sub    $0x4,%esp
80106ca5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106caa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106cac:	6a 00                	push   $0x0
80106cae:	50                   	push   %eax
80106caf:	e8 fc da ff ff       	call   801047b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106cb4:	58                   	pop    %eax
80106cb5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cbb:	5a                   	pop    %edx
80106cbc:	6a 06                	push   $0x6
80106cbe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106cc3:	31 d2                	xor    %edx,%edx
80106cc5:	50                   	push   %eax
80106cc6:	89 f8                	mov    %edi,%eax
80106cc8:	e8 13 fd ff ff       	call   801069e0 <mappages>
  memmove(mem, init, sz);
80106ccd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cd0:	89 75 10             	mov    %esi,0x10(%ebp)
80106cd3:	83 c4 10             	add    $0x10,%esp
80106cd6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106cd9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106cdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cdf:	5b                   	pop    %ebx
80106ce0:	5e                   	pop    %esi
80106ce1:	5f                   	pop    %edi
80106ce2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ce3:	e9 68 db ff ff       	jmp    80104850 <memmove>
    panic("inituvm: more than a page");
80106ce8:	83 ec 0c             	sub    $0xc,%esp
80106ceb:	68 dd 7d 10 80       	push   $0x80107ddd
80106cf0:	e8 8b 96 ff ff       	call   80100380 <panic>
80106cf5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d00 <loaduvm>:
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
80106d06:	83 ec 1c             	sub    $0x1c,%esp
80106d09:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d0c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106d0f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106d14:	0f 85 bb 00 00 00    	jne    80106dd5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106d1a:	01 f0                	add    %esi,%eax
80106d1c:	89 f3                	mov    %esi,%ebx
80106d1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d21:	8b 45 14             	mov    0x14(%ebp),%eax
80106d24:	01 f0                	add    %esi,%eax
80106d26:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106d29:	85 f6                	test   %esi,%esi
80106d2b:	0f 84 87 00 00 00    	je     80106db8 <loaduvm+0xb8>
80106d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106d38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106d3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106d3e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106d40:	89 c2                	mov    %eax,%edx
80106d42:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106d45:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106d48:	f6 c2 01             	test   $0x1,%dl
80106d4b:	75 13                	jne    80106d60 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106d4d:	83 ec 0c             	sub    $0xc,%esp
80106d50:	68 f7 7d 10 80       	push   $0x80107df7
80106d55:	e8 26 96 ff ff       	call   80100380 <panic>
80106d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d60:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d63:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106d69:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d6e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d75:	85 c0                	test   %eax,%eax
80106d77:	74 d4                	je     80106d4d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106d79:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d7b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106d7e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106d83:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106d88:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106d8e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d91:	29 d9                	sub    %ebx,%ecx
80106d93:	05 00 00 00 80       	add    $0x80000000,%eax
80106d98:	57                   	push   %edi
80106d99:	51                   	push   %ecx
80106d9a:	50                   	push   %eax
80106d9b:	ff 75 10             	push   0x10(%ebp)
80106d9e:	e8 fd ac ff ff       	call   80101aa0 <readi>
80106da3:	83 c4 10             	add    $0x10,%esp
80106da6:	39 f8                	cmp    %edi,%eax
80106da8:	75 1e                	jne    80106dc8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106daa:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106db0:	89 f0                	mov    %esi,%eax
80106db2:	29 d8                	sub    %ebx,%eax
80106db4:	39 c6                	cmp    %eax,%esi
80106db6:	77 80                	ja     80106d38 <loaduvm+0x38>
}
80106db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106dbb:	31 c0                	xor    %eax,%eax
}
80106dbd:	5b                   	pop    %ebx
80106dbe:	5e                   	pop    %esi
80106dbf:	5f                   	pop    %edi
80106dc0:	5d                   	pop    %ebp
80106dc1:	c3                   	ret    
80106dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106dcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106dd0:	5b                   	pop    %ebx
80106dd1:	5e                   	pop    %esi
80106dd2:	5f                   	pop    %edi
80106dd3:	5d                   	pop    %ebp
80106dd4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106dd5:	83 ec 0c             	sub    $0xc,%esp
80106dd8:	68 98 7e 10 80       	push   $0x80107e98
80106ddd:	e8 9e 95 ff ff       	call   80100380 <panic>
80106de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106df0 <allocuvm>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106df9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106dfc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106dff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e02:	85 c0                	test   %eax,%eax
80106e04:	0f 88 b6 00 00 00    	js     80106ec0 <allocuvm+0xd0>
  if(newsz < oldsz)
80106e0a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106e10:	0f 82 9a 00 00 00    	jb     80106eb0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106e16:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106e1c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106e22:	39 75 10             	cmp    %esi,0x10(%ebp)
80106e25:	77 44                	ja     80106e6b <allocuvm+0x7b>
80106e27:	e9 87 00 00 00       	jmp    80106eb3 <allocuvm+0xc3>
80106e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106e30:	83 ec 04             	sub    $0x4,%esp
80106e33:	68 00 10 00 00       	push   $0x1000
80106e38:	6a 00                	push   $0x0
80106e3a:	50                   	push   %eax
80106e3b:	e8 70 d9 ff ff       	call   801047b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e40:	58                   	pop    %eax
80106e41:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e47:	5a                   	pop    %edx
80106e48:	6a 06                	push   $0x6
80106e4a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e4f:	89 f2                	mov    %esi,%edx
80106e51:	50                   	push   %eax
80106e52:	89 f8                	mov    %edi,%eax
80106e54:	e8 87 fb ff ff       	call   801069e0 <mappages>
80106e59:	83 c4 10             	add    $0x10,%esp
80106e5c:	85 c0                	test   %eax,%eax
80106e5e:	78 78                	js     80106ed8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106e60:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e66:	39 75 10             	cmp    %esi,0x10(%ebp)
80106e69:	76 48                	jbe    80106eb3 <allocuvm+0xc3>
    mem = kalloc();
80106e6b:	e8 20 b8 ff ff       	call   80102690 <kalloc>
80106e70:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106e72:	85 c0                	test   %eax,%eax
80106e74:	75 ba                	jne    80106e30 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106e76:	83 ec 0c             	sub    $0xc,%esp
80106e79:	68 15 7e 10 80       	push   $0x80107e15
80106e7e:	e8 1d 98 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106e83:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e86:	83 c4 10             	add    $0x10,%esp
80106e89:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e8c:	74 32                	je     80106ec0 <allocuvm+0xd0>
80106e8e:	8b 55 10             	mov    0x10(%ebp),%edx
80106e91:	89 c1                	mov    %eax,%ecx
80106e93:	89 f8                	mov    %edi,%eax
80106e95:	e8 96 fa ff ff       	call   80106930 <deallocuvm.part.0>
      return 0;
80106e9a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106ea1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ea7:	5b                   	pop    %ebx
80106ea8:	5e                   	pop    %esi
80106ea9:	5f                   	pop    %edi
80106eaa:	5d                   	pop    %ebp
80106eab:	c3                   	ret    
80106eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106eb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106eb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106eb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eb9:	5b                   	pop    %ebx
80106eba:	5e                   	pop    %esi
80106ebb:	5f                   	pop    %edi
80106ebc:	5d                   	pop    %ebp
80106ebd:	c3                   	ret    
80106ebe:	66 90                	xchg   %ax,%ax
    return 0;
80106ec0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106ec7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ecd:	5b                   	pop    %ebx
80106ece:	5e                   	pop    %esi
80106ecf:	5f                   	pop    %edi
80106ed0:	5d                   	pop    %ebp
80106ed1:	c3                   	ret    
80106ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ed8:	83 ec 0c             	sub    $0xc,%esp
80106edb:	68 2d 7e 10 80       	push   $0x80107e2d
80106ee0:	e8 bb 97 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ee8:	83 c4 10             	add    $0x10,%esp
80106eeb:	39 45 10             	cmp    %eax,0x10(%ebp)
80106eee:	74 0c                	je     80106efc <allocuvm+0x10c>
80106ef0:	8b 55 10             	mov    0x10(%ebp),%edx
80106ef3:	89 c1                	mov    %eax,%ecx
80106ef5:	89 f8                	mov    %edi,%eax
80106ef7:	e8 34 fa ff ff       	call   80106930 <deallocuvm.part.0>
      kfree(mem);
80106efc:	83 ec 0c             	sub    $0xc,%esp
80106eff:	53                   	push   %ebx
80106f00:	e8 cb b5 ff ff       	call   801024d0 <kfree>
      return 0;
80106f05:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106f0c:	83 c4 10             	add    $0x10,%esp
}
80106f0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f15:	5b                   	pop    %ebx
80106f16:	5e                   	pop    %esi
80106f17:	5f                   	pop    %edi
80106f18:	5d                   	pop    %ebp
80106f19:	c3                   	ret    
80106f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f20 <deallocuvm>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f26:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106f29:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106f2c:	39 d1                	cmp    %edx,%ecx
80106f2e:	73 10                	jae    80106f40 <deallocuvm+0x20>
}
80106f30:	5d                   	pop    %ebp
80106f31:	e9 fa f9 ff ff       	jmp    80106930 <deallocuvm.part.0>
80106f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3d:	8d 76 00             	lea    0x0(%esi),%esi
80106f40:	89 d0                	mov    %edx,%eax
80106f42:	5d                   	pop    %ebp
80106f43:	c3                   	ret    
80106f44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f4f:	90                   	nop

80106f50 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
80106f55:	53                   	push   %ebx
80106f56:	83 ec 0c             	sub    $0xc,%esp
80106f59:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f5c:	85 f6                	test   %esi,%esi
80106f5e:	74 59                	je     80106fb9 <freevm+0x69>
  if(newsz >= oldsz)
80106f60:	31 c9                	xor    %ecx,%ecx
80106f62:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f67:	89 f0                	mov    %esi,%eax
80106f69:	89 f3                	mov    %esi,%ebx
80106f6b:	e8 c0 f9 ff ff       	call   80106930 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f70:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106f76:	eb 0f                	jmp    80106f87 <freevm+0x37>
80106f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f7f:	90                   	nop
80106f80:	83 c3 04             	add    $0x4,%ebx
80106f83:	39 df                	cmp    %ebx,%edi
80106f85:	74 23                	je     80106faa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106f87:	8b 03                	mov    (%ebx),%eax
80106f89:	a8 01                	test   $0x1,%al
80106f8b:	74 f3                	je     80106f80 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f8d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106f92:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f95:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f98:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f9d:	50                   	push   %eax
80106f9e:	e8 2d b5 ff ff       	call   801024d0 <kfree>
80106fa3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106fa6:	39 df                	cmp    %ebx,%edi
80106fa8:	75 dd                	jne    80106f87 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106faa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fb0:	5b                   	pop    %ebx
80106fb1:	5e                   	pop    %esi
80106fb2:	5f                   	pop    %edi
80106fb3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106fb4:	e9 17 b5 ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
80106fb9:	83 ec 0c             	sub    $0xc,%esp
80106fbc:	68 49 7e 10 80       	push   $0x80107e49
80106fc1:	e8 ba 93 ff ff       	call   80100380 <panic>
80106fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fcd:	8d 76 00             	lea    0x0(%esi),%esi

80106fd0 <setupkvm>:
{
80106fd0:	55                   	push   %ebp
80106fd1:	89 e5                	mov    %esp,%ebp
80106fd3:	56                   	push   %esi
80106fd4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106fd5:	e8 b6 b6 ff ff       	call   80102690 <kalloc>
80106fda:	89 c6                	mov    %eax,%esi
80106fdc:	85 c0                	test   %eax,%eax
80106fde:	74 42                	je     80107022 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106fe0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fe3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106fe8:	68 00 10 00 00       	push   $0x1000
80106fed:	6a 00                	push   $0x0
80106fef:	50                   	push   %eax
80106ff0:	e8 bb d7 ff ff       	call   801047b0 <memset>
80106ff5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106ff8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ffb:	83 ec 08             	sub    $0x8,%esp
80106ffe:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107001:	ff 73 0c             	push   0xc(%ebx)
80107004:	8b 13                	mov    (%ebx),%edx
80107006:	50                   	push   %eax
80107007:	29 c1                	sub    %eax,%ecx
80107009:	89 f0                	mov    %esi,%eax
8010700b:	e8 d0 f9 ff ff       	call   801069e0 <mappages>
80107010:	83 c4 10             	add    $0x10,%esp
80107013:	85 c0                	test   %eax,%eax
80107015:	78 19                	js     80107030 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107017:	83 c3 10             	add    $0x10,%ebx
8010701a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107020:	75 d6                	jne    80106ff8 <setupkvm+0x28>
}
80107022:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107025:	89 f0                	mov    %esi,%eax
80107027:	5b                   	pop    %ebx
80107028:	5e                   	pop    %esi
80107029:	5d                   	pop    %ebp
8010702a:	c3                   	ret    
8010702b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010702f:	90                   	nop
      freevm(pgdir);
80107030:	83 ec 0c             	sub    $0xc,%esp
80107033:	56                   	push   %esi
      return 0;
80107034:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107036:	e8 15 ff ff ff       	call   80106f50 <freevm>
      return 0;
8010703b:	83 c4 10             	add    $0x10,%esp
}
8010703e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107041:	89 f0                	mov    %esi,%eax
80107043:	5b                   	pop    %ebx
80107044:	5e                   	pop    %esi
80107045:	5d                   	pop    %ebp
80107046:	c3                   	ret    
80107047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010704e:	66 90                	xchg   %ax,%ax

80107050 <kvmalloc>:
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107056:	e8 75 ff ff ff       	call   80106fd0 <setupkvm>
8010705b:	a3 c4 46 11 80       	mov    %eax,0x801146c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107060:	05 00 00 00 80       	add    $0x80000000,%eax
80107065:	0f 22 d8             	mov    %eax,%cr3
}
80107068:	c9                   	leave  
80107069:	c3                   	ret    
8010706a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107070 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	83 ec 08             	sub    $0x8,%esp
80107076:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107079:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010707c:	89 c1                	mov    %eax,%ecx
8010707e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107081:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107084:	f6 c2 01             	test   $0x1,%dl
80107087:	75 17                	jne    801070a0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107089:	83 ec 0c             	sub    $0xc,%esp
8010708c:	68 5a 7e 10 80       	push   $0x80107e5a
80107091:	e8 ea 92 ff ff       	call   80100380 <panic>
80107096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010709d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070a0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070a3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801070a9:	25 fc 0f 00 00       	and    $0xffc,%eax
801070ae:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801070b5:	85 c0                	test   %eax,%eax
801070b7:	74 d0                	je     80107089 <clearpteu+0x19>
  *pte &= ~PTE_U;
801070b9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801070bc:	c9                   	leave  
801070bd:	c3                   	ret    
801070be:	66 90                	xchg   %ax,%ax

801070c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801070c9:	e8 02 ff ff ff       	call   80106fd0 <setupkvm>
801070ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070d1:	85 c0                	test   %eax,%eax
801070d3:	0f 84 bd 00 00 00    	je     80107196 <copyuvm+0xd6>
    return 0;
  for(i = PGSIZE; i < sz; i += PGSIZE){
801070d9:	81 7d 0c 00 10 00 00 	cmpl   $0x1000,0xc(%ebp)
801070e0:	0f 86 b0 00 00 00    	jbe    80107196 <copyuvm+0xd6>
801070e6:	be 00 10 00 00       	mov    $0x1000,%esi
801070eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070ef:	90                   	nop
  if(*pde & PTE_P){
801070f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801070f3:	89 f0                	mov    %esi,%eax
801070f5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801070f8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801070fb:	a8 01                	test   $0x1,%al
801070fd:	75 11                	jne    80107110 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801070ff:	83 ec 0c             	sub    $0xc,%esp
80107102:	68 64 7e 10 80       	push   $0x80107e64
80107107:	e8 74 92 ff ff       	call   80100380 <panic>
8010710c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107110:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107112:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107117:	c1 ea 0a             	shr    $0xa,%edx
8010711a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107120:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107127:	85 c0                	test   %eax,%eax
80107129:	74 d4                	je     801070ff <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010712b:	8b 00                	mov    (%eax),%eax
8010712d:	a8 01                	test   $0x1,%al
8010712f:	0f 84 9f 00 00 00    	je     801071d4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107135:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107137:	25 ff 0f 00 00       	and    $0xfff,%eax
8010713c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010713f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107145:	e8 46 b5 ff ff       	call   80102690 <kalloc>
8010714a:	89 c3                	mov    %eax,%ebx
8010714c:	85 c0                	test   %eax,%eax
8010714e:	74 64                	je     801071b4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107150:	83 ec 04             	sub    $0x4,%esp
80107153:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107159:	68 00 10 00 00       	push   $0x1000
8010715e:	57                   	push   %edi
8010715f:	50                   	push   %eax
80107160:	e8 eb d6 ff ff       	call   80104850 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107165:	58                   	pop    %eax
80107166:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010716c:	5a                   	pop    %edx
8010716d:	ff 75 e4             	push   -0x1c(%ebp)
80107170:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107175:	89 f2                	mov    %esi,%edx
80107177:	50                   	push   %eax
80107178:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010717b:	e8 60 f8 ff ff       	call   801069e0 <mappages>
80107180:	83 c4 10             	add    $0x10,%esp
80107183:	85 c0                	test   %eax,%eax
80107185:	78 21                	js     801071a8 <copyuvm+0xe8>
  for(i = PGSIZE; i < sz; i += PGSIZE){
80107187:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010718d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107190:	0f 87 5a ff ff ff    	ja     801070f0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107196:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107199:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010719c:	5b                   	pop    %ebx
8010719d:	5e                   	pop    %esi
8010719e:	5f                   	pop    %edi
8010719f:	5d                   	pop    %ebp
801071a0:	c3                   	ret    
801071a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801071a8:	83 ec 0c             	sub    $0xc,%esp
801071ab:	53                   	push   %ebx
801071ac:	e8 1f b3 ff ff       	call   801024d0 <kfree>
      goto bad;
801071b1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801071b4:	83 ec 0c             	sub    $0xc,%esp
801071b7:	ff 75 e0             	push   -0x20(%ebp)
801071ba:	e8 91 fd ff ff       	call   80106f50 <freevm>
  return 0;
801071bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801071c6:	83 c4 10             	add    $0x10,%esp
}
801071c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071cf:	5b                   	pop    %ebx
801071d0:	5e                   	pop    %esi
801071d1:	5f                   	pop    %edi
801071d2:	5d                   	pop    %ebp
801071d3:	c3                   	ret    
      panic("copyuvm: page not present");
801071d4:	83 ec 0c             	sub    $0xc,%esp
801071d7:	68 7e 7e 10 80       	push   $0x80107e7e
801071dc:	e8 9f 91 ff ff       	call   80100380 <panic>
801071e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ef:	90                   	nop

801071f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801071f6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801071f9:	89 c1                	mov    %eax,%ecx
801071fb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801071fe:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107201:	f6 c2 01             	test   $0x1,%dl
80107204:	0f 84 b4 02 00 00    	je     801074be <uva2ka.cold>
  return &pgtab[PTX(va)];
8010720a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010720d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107213:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107214:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107219:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107220:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107222:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107227:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010722a:	05 00 00 00 80       	add    $0x80000000,%eax
8010722f:	83 fa 05             	cmp    $0x5,%edx
80107232:	ba 00 00 00 00       	mov    $0x0,%edx
80107237:	0f 45 c2             	cmovne %edx,%eax
}
8010723a:	c3                   	ret    
8010723b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010723f:	90                   	nop

80107240 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	56                   	push   %esi
80107245:	53                   	push   %ebx
80107246:	83 ec 0c             	sub    $0xc,%esp
80107249:	8b 75 14             	mov    0x14(%ebp),%esi
8010724c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010724f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107252:	85 f6                	test   %esi,%esi
80107254:	75 51                	jne    801072a7 <copyout+0x67>
80107256:	e9 a5 00 00 00       	jmp    80107300 <copyout+0xc0>
8010725b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010725f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107260:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107266:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010726c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107272:	74 75                	je     801072e9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107274:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107276:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107279:	29 c3                	sub    %eax,%ebx
8010727b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107281:	39 f3                	cmp    %esi,%ebx
80107283:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107286:	29 f8                	sub    %edi,%eax
80107288:	83 ec 04             	sub    $0x4,%esp
8010728b:	01 c1                	add    %eax,%ecx
8010728d:	53                   	push   %ebx
8010728e:	52                   	push   %edx
8010728f:	51                   	push   %ecx
80107290:	e8 bb d5 ff ff       	call   80104850 <memmove>
    len -= n;
    buf += n;
80107295:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107298:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010729e:	83 c4 10             	add    $0x10,%esp
    buf += n;
801072a1:	01 da                	add    %ebx,%edx
  while(len > 0){
801072a3:	29 de                	sub    %ebx,%esi
801072a5:	74 59                	je     80107300 <copyout+0xc0>
  if(*pde & PTE_P){
801072a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801072aa:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801072ac:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801072ae:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801072b1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801072b7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801072ba:	f6 c1 01             	test   $0x1,%cl
801072bd:	0f 84 02 02 00 00    	je     801074c5 <copyout.cold>
  return &pgtab[PTX(va)];
801072c3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072c5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801072cb:	c1 eb 0c             	shr    $0xc,%ebx
801072ce:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801072d4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801072db:	89 d9                	mov    %ebx,%ecx
801072dd:	83 e1 05             	and    $0x5,%ecx
801072e0:	83 f9 05             	cmp    $0x5,%ecx
801072e3:	0f 84 77 ff ff ff    	je     80107260 <copyout+0x20>
  }
  return 0;
}
801072e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801072ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072f1:	5b                   	pop    %ebx
801072f2:	5e                   	pop    %esi
801072f3:	5f                   	pop    %edi
801072f4:	5d                   	pop    %ebp
801072f5:	c3                   	ret    
801072f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072fd:	8d 76 00             	lea    0x0(%esi),%esi
80107300:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107303:	31 c0                	xor    %eax,%eax
}
80107305:	5b                   	pop    %ebx
80107306:	5e                   	pop    %esi
80107307:	5f                   	pop    %edi
80107308:	5d                   	pop    %ebp
80107309:	c3                   	ret    
8010730a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107310 <sys_mprotect>:


int 
sys_mprotect(void){
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	56                   	push   %esi
80107314:	53                   	push   %ebx
  int len;
  void* addr;
  if(argptr(1,(char**)&addr,sizeof(char)) <0)
80107315:	8d 45 f4             	lea    -0xc(%ebp),%eax
sys_mprotect(void){
80107318:	83 ec 14             	sub    $0x14,%esp
  if(argptr(1,(char**)&addr,sizeof(char)) <0)
8010731b:	6a 01                	push   $0x1
8010731d:	50                   	push   %eax
8010731e:	6a 01                	push   $0x1
80107320:	e8 9b d7 ff ff       	call   80104ac0 <argptr>
80107325:	83 c4 10             	add    $0x10,%esp
80107328:	85 c0                	test   %eax,%eax
8010732a:	0f 88 b1 00 00 00    	js     801073e1 <sys_mprotect+0xd1>
    return -1;
  if(argint(1,&len) <0 || len<=0)
80107330:	83 ec 08             	sub    $0x8,%esp
80107333:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107336:	50                   	push   %eax
80107337:	6a 01                	push   $0x1
80107339:	e8 32 d7 ff ff       	call   80104a70 <argint>
8010733e:	83 c4 10             	add    $0x10,%esp
80107341:	85 c0                	test   %eax,%eax
80107343:	0f 88 98 00 00 00    	js     801073e1 <sys_mprotect+0xd1>
80107349:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010734c:	85 c0                	test   %eax,%eax
8010734e:	0f 8e 8d 00 00 00    	jle    801073e1 <sys_mprotect+0xd1>
    return -1;

  pte_t *page_table_entry;

  char* curr = (char*)addr;
80107354:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  if((((uint)curr)%PGSIZE != 0 )){
80107357:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
8010735d:	0f 85 7e 00 00 00    	jne    801073e1 <sys_mprotect+0xd1>
    return -1;
  }


  if(myproc()->sz<(uint)curr+PGSIZE*len){
80107363:	e8 38 c6 ff ff       	call   801039a0 <myproc>
80107368:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010736b:	89 c1                	mov    %eax,%ecx
8010736d:	89 d0                	mov    %edx,%eax
8010736f:	c1 e0 0c             	shl    $0xc,%eax
80107372:	01 d8                	add    %ebx,%eax
80107374:	39 01                	cmp    %eax,(%ecx)
80107376:	72 69                	jb     801073e1 <sys_mprotect+0xd1>
      return -1;
  }

  for(int i=0;i<len;i++){
80107378:	85 d2                	test   %edx,%edx
8010737a:	7e 4c                	jle    801073c8 <sys_mprotect+0xb8>
8010737c:	31 f6                	xor    %esi,%esi
8010737e:	66 90                	xchg   %ax,%ax
    page_table_entry = walkpgdir(myproc()->pgdir,(void *)curr ,0);
80107380:	e8 1b c6 ff ff       	call   801039a0 <myproc>
  pde = &pgdir[PDX(va)];
80107385:	89 da                	mov    %ebx,%edx
  if(*pde & PTE_P){
80107387:	8b 40 04             	mov    0x4(%eax),%eax
  pde = &pgdir[PDX(va)];
8010738a:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
8010738d:	8b 04 90             	mov    (%eax,%edx,4),%eax
80107390:	a8 01                	test   $0x1,%al
80107392:	0f 84 34 01 00 00    	je     801074cc <sys_mprotect.cold>
  return &pgtab[PTX(va)];
80107398:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010739a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
8010739f:	c1 ea 0a             	shr    $0xa,%edx
801073a2:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801073a8:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    // cprintf("page table entry before: 0x%x desireced prot read only\n",*page_table_entry);
    int writable = *page_table_entry & PTE_W;
801073af:	8b 02                	mov    (%edx),%eax
    if(writable == PTE_W){
801073b1:	a8 02                	test   $0x2,%al
801073b3:	74 05                	je     801073ba <sys_mprotect+0xaa>
     *page_table_entry  =  *page_table_entry ^PTE_W;
801073b5:	83 f0 02             	xor    $0x2,%eax
801073b8:	89 02                	mov    %eax,(%edx)
    }
    //  *page_table_entry  =  *page_table_entry |PTE_W;
    // cprintf("page table entry after: 0x%x\n",*page_table_entry);
    curr += PGSIZE;   
801073ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(int i=0;i<len;i++){
801073c0:	83 c6 01             	add    $0x1,%esi
801073c3:	39 75 f0             	cmp    %esi,-0x10(%ebp)
801073c6:	7f b8                	jg     80107380 <sys_mprotect+0x70>
  }
  // cprintf("Hi out of the for loop\n");
  
  lcr3(V2P(myproc()->pgdir));
801073c8:	e8 d3 c5 ff ff       	call   801039a0 <myproc>
801073cd:	8b 40 04             	mov    0x4(%eax),%eax
801073d0:	05 00 00 00 80       	add    $0x80000000,%eax
801073d5:	0f 22 d8             	mov    %eax,%cr3
  return 0; 
801073d8:	31 c0                	xor    %eax,%eax
}
801073da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073dd:	5b                   	pop    %ebx
801073de:	5e                   	pop    %esi
801073df:	5d                   	pop    %ebp
801073e0:	c3                   	ret    
    return -1;
801073e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073e6:	eb f2                	jmp    801073da <sys_mprotect+0xca>
801073e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ef:	90                   	nop

801073f0 <sys_munprotect>:


int 
sys_munprotect(void){
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	56                   	push   %esi
801073f4:	53                   	push   %ebx
  int len;
  void* addr;
  if(argptr(1,(char**)&addr,sizeof(char)) <0)
801073f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
sys_munprotect(void){
801073f8:	83 ec 14             	sub    $0x14,%esp
  if(argptr(1,(char**)&addr,sizeof(char)) <0)
801073fb:	6a 01                	push   $0x1
801073fd:	50                   	push   %eax
801073fe:	6a 01                	push   $0x1
80107400:	e8 bb d6 ff ff       	call   80104ac0 <argptr>
80107405:	83 c4 10             	add    $0x10,%esp
80107408:	85 c0                	test   %eax,%eax
8010740a:	0f 88 a7 00 00 00    	js     801074b7 <sys_munprotect+0xc7>
    return -1;
  if(argint(1,&len) < 0 || len<=0)
80107410:	83 ec 08             	sub    $0x8,%esp
80107413:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107416:	50                   	push   %eax
80107417:	6a 01                	push   $0x1
80107419:	e8 52 d6 ff ff       	call   80104a70 <argint>
8010741e:	83 c4 10             	add    $0x10,%esp
80107421:	85 c0                	test   %eax,%eax
80107423:	0f 88 8e 00 00 00    	js     801074b7 <sys_munprotect+0xc7>
80107429:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010742c:	85 c0                	test   %eax,%eax
8010742e:	0f 8e 83 00 00 00    	jle    801074b7 <sys_munprotect+0xc7>
    return -1;

  pte_t *page_table_entry;

  
  char* curr = (char*)addr;
80107434:	8b 75 f4             	mov    -0xc(%ebp),%esi

  if((((uint)curr)%PGSIZE != 0 )){
80107437:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
8010743d:	75 78                	jne    801074b7 <sys_munprotect+0xc7>
    return -1;
  }
  if(myproc()->sz<(int)curr+PGSIZE*len){
8010743f:	e8 5c c5 ff ff       	call   801039a0 <myproc>
80107444:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107447:	89 c1                	mov    %eax,%ecx
80107449:	89 d0                	mov    %edx,%eax
8010744b:	c1 e0 0c             	shl    $0xc,%eax
8010744e:	01 f0                	add    %esi,%eax
80107450:	39 01                	cmp    %eax,(%ecx)
80107452:	72 63                	jb     801074b7 <sys_munprotect+0xc7>
      return -1;
  }

  for(int i=0;i<len;i++){
80107454:	85 d2                	test   %edx,%edx
80107456:	7e 46                	jle    8010749e <sys_munprotect+0xae>
80107458:	31 db                	xor    %ebx,%ebx
8010745a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    page_table_entry = walkpgdir(myproc()->pgdir,(void *)curr ,0);
80107460:	e8 3b c5 ff ff       	call   801039a0 <myproc>
  pde = &pgdir[PDX(va)];
80107465:	89 f2                	mov    %esi,%edx
  if(*pde & PTE_P){
80107467:	8b 40 04             	mov    0x4(%eax),%eax
  pde = &pgdir[PDX(va)];
8010746a:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
8010746d:	8b 04 90             	mov    (%eax,%edx,4),%eax
80107470:	a8 01                	test   $0x1,%al
80107472:	0f 84 5b 00 00 00    	je     801074d3 <sys_munprotect.cold>
  return &pgtab[PTX(va)];
80107478:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010747a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    // cprintf("page table entry before: 0x%x desireced prot = read and write\n",*page_table_entry);
    *page_table_entry  =  *page_table_entry | PTE_W;
    curr += PGSIZE;   
8010747f:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(int i=0;i<len;i++){
80107485:	83 c3 01             	add    $0x1,%ebx
  return &pgtab[PTX(va)];
80107488:	c1 ea 0a             	shr    $0xa,%edx
8010748b:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
    *page_table_entry  =  *page_table_entry | PTE_W;
80107491:	83 8c 10 00 00 00 80 	orl    $0x2,-0x80000000(%eax,%edx,1)
80107498:	02 
  for(int i=0;i<len;i++){
80107499:	39 5d f0             	cmp    %ebx,-0x10(%ebp)
8010749c:	7f c2                	jg     80107460 <sys_munprotect+0x70>
    // cprintf("page table entry after: 0x%x\n",*page_table_entry);

  }
  
  lcr3(V2P(myproc()->pgdir));
8010749e:	e8 fd c4 ff ff       	call   801039a0 <myproc>
801074a3:	8b 40 04             	mov    0x4(%eax),%eax
801074a6:	05 00 00 00 80       	add    $0x80000000,%eax
801074ab:	0f 22 d8             	mov    %eax,%cr3
  return 0; 
801074ae:	31 c0                	xor    %eax,%eax
}
801074b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074b3:	5b                   	pop    %ebx
801074b4:	5e                   	pop    %esi
801074b5:	5d                   	pop    %ebp
801074b6:	c3                   	ret    
    return -1;
801074b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074bc:	eb f2                	jmp    801074b0 <sys_munprotect+0xc0>

801074be <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801074be:	a1 00 00 00 00       	mov    0x0,%eax
801074c3:	0f 0b                	ud2    

801074c5 <copyout.cold>:
801074c5:	a1 00 00 00 00       	mov    0x0,%eax
801074ca:	0f 0b                	ud2    

801074cc <sys_mprotect.cold>:
    int writable = *page_table_entry & PTE_W;
801074cc:	a1 00 00 00 00       	mov    0x0,%eax
801074d1:	0f 0b                	ud2    

801074d3 <sys_munprotect.cold>:
    *page_table_entry  =  *page_table_entry | PTE_W;
801074d3:	a1 00 00 00 00       	mov    0x0,%eax
801074d8:	0f 0b                	ud2    
