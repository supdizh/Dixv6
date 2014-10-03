
_big：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

int
main()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	81 ec 30 02 00 00    	sub    $0x230,%esp
  char buf[512];
  int fd, i, sectors;

  fd = open("big.file", O_CREATE | O_WRONLY);
   d:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  14:	00 
  15:	c7 04 24 dc 09 00 00 	movl   $0x9dc,(%esp)
  1c:	e8 9b 04 00 00       	call   4bc <open>
  21:	89 84 24 24 02 00 00 	mov    %eax,0x224(%esp)
  if(fd < 0){
  28:	83 bc 24 24 02 00 00 	cmpl   $0x0,0x224(%esp)
  2f:	00 
  30:	79 19                	jns    4b <main+0x4b>
    printf(2, "big: cannot open big.file for writing\n");
  32:	c7 44 24 04 e8 09 00 	movl   $0x9e8,0x4(%esp)
  39:	00 
  3a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  41:	e8 c3 05 00 00       	call   609 <printf>
    exit();
  46:	e8 31 04 00 00       	call   47c <exit>
  }

  sectors = 0;
  4b:	c7 84 24 28 02 00 00 	movl   $0x0,0x228(%esp)
  52:	00 00 00 00 
  56:	eb 01                	jmp    59 <main+0x59>
    if(cc <= 0)
      break;
    sectors++;
	if (sectors % 100 == 0)
		printf(2, ".");
  }
  58:	90                   	nop
    exit();
  }

  sectors = 0;
  while(1){
    *(int*)buf = sectors;
  59:	8d 44 24 1c          	lea    0x1c(%esp),%eax
  5d:	8b 94 24 28 02 00 00 	mov    0x228(%esp),%edx
  64:	89 10                	mov    %edx,(%eax)
    int cc = write(fd, buf, sizeof(buf));
  66:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  6d:	00 
  6e:	8d 44 24 1c          	lea    0x1c(%esp),%eax
  72:	89 44 24 04          	mov    %eax,0x4(%esp)
  76:	8b 84 24 24 02 00 00 	mov    0x224(%esp),%eax
  7d:	89 04 24             	mov    %eax,(%esp)
  80:	e8 17 04 00 00       	call   49c <write>
  85:	89 84 24 20 02 00 00 	mov    %eax,0x220(%esp)
    if(cc <= 0)
  8c:	83 bc 24 20 02 00 00 	cmpl   $0x0,0x220(%esp)
  93:	00 
  94:	7e 4c                	jle    e2 <main+0xe2>
      break;
    sectors++;
  96:	83 84 24 28 02 00 00 	addl   $0x1,0x228(%esp)
  9d:	01 
	if (sectors % 100 == 0)
  9e:	8b 8c 24 28 02 00 00 	mov    0x228(%esp),%ecx
  a5:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  aa:	89 c8                	mov    %ecx,%eax
  ac:	f7 ea                	imul   %edx
  ae:	c1 fa 05             	sar    $0x5,%edx
  b1:	89 c8                	mov    %ecx,%eax
  b3:	c1 f8 1f             	sar    $0x1f,%eax
  b6:	89 d3                	mov    %edx,%ebx
  b8:	29 c3                	sub    %eax,%ebx
  ba:	89 d8                	mov    %ebx,%eax
  bc:	6b c0 64             	imul   $0x64,%eax,%eax
  bf:	89 ca                	mov    %ecx,%edx
  c1:	29 c2                	sub    %eax,%edx
  c3:	89 d0                	mov    %edx,%eax
  c5:	85 c0                	test   %eax,%eax
  c7:	75 8f                	jne    58 <main+0x58>
		printf(2, ".");
  c9:	c7 44 24 04 0f 0a 00 	movl   $0xa0f,0x4(%esp)
  d0:	00 
  d1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  d8:	e8 2c 05 00 00       	call   609 <printf>
  }
  dd:	e9 76 ff ff ff       	jmp    58 <main+0x58>
  sectors = 0;
  while(1){
    *(int*)buf = sectors;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
  e2:	90                   	nop
    sectors++;
	if (sectors % 100 == 0)
		printf(2, ".");
  }

  printf(1, "\nwrote %d sectors\n", sectors);
  e3:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
  ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  ee:	c7 44 24 04 11 0a 00 	movl   $0xa11,0x4(%esp)
  f5:	00 
  f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fd:	e8 07 05 00 00       	call   609 <printf>

  close(fd);
 102:	8b 84 24 24 02 00 00 	mov    0x224(%esp),%eax
 109:	89 04 24             	mov    %eax,(%esp)
 10c:	e8 93 03 00 00       	call   4a4 <close>
  fd = open("big.file", O_RDONLY);
 111:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 118:	00 
 119:	c7 04 24 dc 09 00 00 	movl   $0x9dc,(%esp)
 120:	e8 97 03 00 00       	call   4bc <open>
 125:	89 84 24 24 02 00 00 	mov    %eax,0x224(%esp)
  if(fd < 0){
 12c:	83 bc 24 24 02 00 00 	cmpl   $0x0,0x224(%esp)
 133:	00 
 134:	79 19                	jns    14f <main+0x14f>
    printf(2, "big: cannot re-open big.file for reading\n");
 136:	c7 44 24 04 24 0a 00 	movl   $0xa24,0x4(%esp)
 13d:	00 
 13e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 145:	e8 bf 04 00 00       	call   609 <printf>
    exit();
 14a:	e8 2d 03 00 00       	call   47c <exit>
  }
  for(i = 0; i < sectors; i++){
 14f:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 156:	00 00 00 00 
 15a:	e9 99 00 00 00       	jmp    1f8 <main+0x1f8>
    int cc = read(fd, buf, sizeof(buf));
 15f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 166:	00 
 167:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 16b:	89 44 24 04          	mov    %eax,0x4(%esp)
 16f:	8b 84 24 24 02 00 00 	mov    0x224(%esp),%eax
 176:	89 04 24             	mov    %eax,(%esp)
 179:	e8 16 03 00 00       	call   494 <read>
 17e:	89 84 24 1c 02 00 00 	mov    %eax,0x21c(%esp)
    if(cc <= 0){
 185:	83 bc 24 1c 02 00 00 	cmpl   $0x0,0x21c(%esp)
 18c:	00 
 18d:	7f 24                	jg     1b3 <main+0x1b3>
      printf(2, "big: read error at sector %d\n", i);
 18f:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
 196:	89 44 24 08          	mov    %eax,0x8(%esp)
 19a:	c7 44 24 04 4e 0a 00 	movl   $0xa4e,0x4(%esp)
 1a1:	00 
 1a2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 1a9:	e8 5b 04 00 00       	call   609 <printf>
      exit();
 1ae:	e8 c9 02 00 00       	call   47c <exit>
    }
    if(*(int*)buf != i){
 1b3:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 1b7:	8b 00                	mov    (%eax),%eax
 1b9:	3b 84 24 2c 02 00 00 	cmp    0x22c(%esp),%eax
 1c0:	74 2e                	je     1f0 <main+0x1f0>
      printf(2, "big: read the wrong data (%d) for sector %d\n",
             *(int*)buf, i);
 1c2:	8d 44 24 1c          	lea    0x1c(%esp),%eax
    if(cc <= 0){
      printf(2, "big: read error at sector %d\n", i);
      exit();
    }
    if(*(int*)buf != i){
      printf(2, "big: read the wrong data (%d) for sector %d\n",
 1c6:	8b 00                	mov    (%eax),%eax
 1c8:	8b 94 24 2c 02 00 00 	mov    0x22c(%esp),%edx
 1cf:	89 54 24 0c          	mov    %edx,0xc(%esp)
 1d3:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d7:	c7 44 24 04 6c 0a 00 	movl   $0xa6c,0x4(%esp)
 1de:	00 
 1df:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 1e6:	e8 1e 04 00 00       	call   609 <printf>
             *(int*)buf, i);
      exit();
 1eb:	e8 8c 02 00 00       	call   47c <exit>
  fd = open("big.file", O_RDONLY);
  if(fd < 0){
    printf(2, "big: cannot re-open big.file for reading\n");
    exit();
  }
  for(i = 0; i < sectors; i++){
 1f0:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 1f7:	01 
 1f8:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
 1ff:	3b 84 24 28 02 00 00 	cmp    0x228(%esp),%eax
 206:	0f 8c 53 ff ff ff    	jl     15f <main+0x15f>
             *(int*)buf, i);
      exit();
    }
  }

  exit();
 20c:	e8 6b 02 00 00       	call   47c <exit>
 211:	66 90                	xchg   %ax,%ax
 213:	90                   	nop

00000214 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	57                   	push   %edi
 218:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 219:	8b 4d 08             	mov    0x8(%ebp),%ecx
 21c:	8b 55 10             	mov    0x10(%ebp),%edx
 21f:	8b 45 0c             	mov    0xc(%ebp),%eax
 222:	89 cb                	mov    %ecx,%ebx
 224:	89 df                	mov    %ebx,%edi
 226:	89 d1                	mov    %edx,%ecx
 228:	fc                   	cld    
 229:	f3 aa                	rep stos %al,%es:(%edi)
 22b:	89 ca                	mov    %ecx,%edx
 22d:	89 fb                	mov    %edi,%ebx
 22f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 232:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 235:	5b                   	pop    %ebx
 236:	5f                   	pop    %edi
 237:	5d                   	pop    %ebp
 238:	c3                   	ret    

00000239 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 245:	90                   	nop
 246:	8b 45 0c             	mov    0xc(%ebp),%eax
 249:	0f b6 10             	movzbl (%eax),%edx
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	88 10                	mov    %dl,(%eax)
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	84 c0                	test   %al,%al
 259:	0f 95 c0             	setne  %al
 25c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 260:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 264:	84 c0                	test   %al,%al
 266:	75 de                	jne    246 <strcpy+0xd>
    ;
  return os;
 268:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 26b:	c9                   	leave  
 26c:	c3                   	ret    

0000026d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 26d:	55                   	push   %ebp
 26e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 270:	eb 08                	jmp    27a <strcmp+0xd>
    p++, q++;
 272:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 276:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	0f b6 00             	movzbl (%eax),%eax
 280:	84 c0                	test   %al,%al
 282:	74 10                	je     294 <strcmp+0x27>
 284:	8b 45 08             	mov    0x8(%ebp),%eax
 287:	0f b6 10             	movzbl (%eax),%edx
 28a:	8b 45 0c             	mov    0xc(%ebp),%eax
 28d:	0f b6 00             	movzbl (%eax),%eax
 290:	38 c2                	cmp    %al,%dl
 292:	74 de                	je     272 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 294:	8b 45 08             	mov    0x8(%ebp),%eax
 297:	0f b6 00             	movzbl (%eax),%eax
 29a:	0f b6 d0             	movzbl %al,%edx
 29d:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a0:	0f b6 00             	movzbl (%eax),%eax
 2a3:	0f b6 c0             	movzbl %al,%eax
 2a6:	89 d1                	mov    %edx,%ecx
 2a8:	29 c1                	sub    %eax,%ecx
 2aa:	89 c8                	mov    %ecx,%eax
}
 2ac:	5d                   	pop    %ebp
 2ad:	c3                   	ret    

000002ae <strlen>:

uint
strlen(char *s)
{
 2ae:	55                   	push   %ebp
 2af:	89 e5                	mov    %esp,%ebp
 2b1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2bb:	eb 04                	jmp    2c1 <strlen+0x13>
 2bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	01 d0                	add    %edx,%eax
 2c9:	0f b6 00             	movzbl (%eax),%eax
 2cc:	84 c0                	test   %al,%al
 2ce:	75 ed                	jne    2bd <strlen+0xf>
    ;
  return n;
 2d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2d5:	55                   	push   %ebp
 2d6:	89 e5                	mov    %esp,%ebp
 2d8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2db:	8b 45 10             	mov    0x10(%ebp),%eax
 2de:	89 44 24 08          	mov    %eax,0x8(%esp)
 2e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	89 04 24             	mov    %eax,(%esp)
 2ef:	e8 20 ff ff ff       	call   214 <stosb>
  return dst;
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <strchr>:

char*
strchr(const char *s, char c)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 04             	sub    $0x4,%esp
 2ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 302:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 305:	eb 14                	jmp    31b <strchr+0x22>
    if(*s == c)
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	0f b6 00             	movzbl (%eax),%eax
 30d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 310:	75 05                	jne    317 <strchr+0x1e>
      return (char*)s;
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	eb 13                	jmp    32a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 317:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 31b:	8b 45 08             	mov    0x8(%ebp),%eax
 31e:	0f b6 00             	movzbl (%eax),%eax
 321:	84 c0                	test   %al,%al
 323:	75 e2                	jne    307 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 325:	b8 00 00 00 00       	mov    $0x0,%eax
}
 32a:	c9                   	leave  
 32b:	c3                   	ret    

0000032c <gets>:

char*
gets(char *buf, int max)
{
 32c:	55                   	push   %ebp
 32d:	89 e5                	mov    %esp,%ebp
 32f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 332:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 339:	eb 46                	jmp    381 <gets+0x55>
    cc = read(0, &c, 1);
 33b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 342:	00 
 343:	8d 45 ef             	lea    -0x11(%ebp),%eax
 346:	89 44 24 04          	mov    %eax,0x4(%esp)
 34a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 351:	e8 3e 01 00 00       	call   494 <read>
 356:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 359:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 35d:	7e 2f                	jle    38e <gets+0x62>
      break;
    buf[i++] = c;
 35f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	01 c2                	add    %eax,%edx
 367:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 36b:	88 02                	mov    %al,(%edx)
 36d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 371:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 375:	3c 0a                	cmp    $0xa,%al
 377:	74 16                	je     38f <gets+0x63>
 379:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 37d:	3c 0d                	cmp    $0xd,%al
 37f:	74 0e                	je     38f <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 381:	8b 45 f4             	mov    -0xc(%ebp),%eax
 384:	83 c0 01             	add    $0x1,%eax
 387:	3b 45 0c             	cmp    0xc(%ebp),%eax
 38a:	7c af                	jl     33b <gets+0xf>
 38c:	eb 01                	jmp    38f <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 38e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 38f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 392:	8b 45 08             	mov    0x8(%ebp),%eax
 395:	01 d0                	add    %edx,%eax
 397:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 39a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 39d:	c9                   	leave  
 39e:	c3                   	ret    

0000039f <stat>:

int
stat(char *n, struct stat *st)
{
 39f:	55                   	push   %ebp
 3a0:	89 e5                	mov    %esp,%ebp
 3a2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3ac:	00 
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
 3b0:	89 04 24             	mov    %eax,(%esp)
 3b3:	e8 04 01 00 00       	call   4bc <open>
 3b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3bf:	79 07                	jns    3c8 <stat+0x29>
    return -1;
 3c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3c6:	eb 23                	jmp    3eb <stat+0x4c>
  r = fstat(fd, st);
 3c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 3cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d2:	89 04 24             	mov    %eax,(%esp)
 3d5:	e8 fa 00 00 00       	call   4d4 <fstat>
 3da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e0:	89 04 24             	mov    %eax,(%esp)
 3e3:	e8 bc 00 00 00       	call   4a4 <close>
  return r;
 3e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3eb:	c9                   	leave  
 3ec:	c3                   	ret    

000003ed <atoi>:

int
atoi(const char *s)
{
 3ed:	55                   	push   %ebp
 3ee:	89 e5                	mov    %esp,%ebp
 3f0:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3fa:	eb 23                	jmp    41f <atoi+0x32>
    n = n*10 + *s++ - '0';
 3fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3ff:	89 d0                	mov    %edx,%eax
 401:	c1 e0 02             	shl    $0x2,%eax
 404:	01 d0                	add    %edx,%eax
 406:	01 c0                	add    %eax,%eax
 408:	89 c2                	mov    %eax,%edx
 40a:	8b 45 08             	mov    0x8(%ebp),%eax
 40d:	0f b6 00             	movzbl (%eax),%eax
 410:	0f be c0             	movsbl %al,%eax
 413:	01 d0                	add    %edx,%eax
 415:	83 e8 30             	sub    $0x30,%eax
 418:	89 45 fc             	mov    %eax,-0x4(%ebp)
 41b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	0f b6 00             	movzbl (%eax),%eax
 425:	3c 2f                	cmp    $0x2f,%al
 427:	7e 0a                	jle    433 <atoi+0x46>
 429:	8b 45 08             	mov    0x8(%ebp),%eax
 42c:	0f b6 00             	movzbl (%eax),%eax
 42f:	3c 39                	cmp    $0x39,%al
 431:	7e c9                	jle    3fc <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 433:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 436:	c9                   	leave  
 437:	c3                   	ret    

00000438 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 438:	55                   	push   %ebp
 439:	89 e5                	mov    %esp,%ebp
 43b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 444:	8b 45 0c             	mov    0xc(%ebp),%eax
 447:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 44a:	eb 13                	jmp    45f <memmove+0x27>
    *dst++ = *src++;
 44c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 44f:	0f b6 10             	movzbl (%eax),%edx
 452:	8b 45 fc             	mov    -0x4(%ebp),%eax
 455:	88 10                	mov    %dl,(%eax)
 457:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 45b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 45f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 463:	0f 9f c0             	setg   %al
 466:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 46a:	84 c0                	test   %al,%al
 46c:	75 de                	jne    44c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 46e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 471:	c9                   	leave  
 472:	c3                   	ret    
 473:	90                   	nop

00000474 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 474:	b8 01 00 00 00       	mov    $0x1,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <exit>:
SYSCALL(exit)
 47c:	b8 02 00 00 00       	mov    $0x2,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <wait>:
SYSCALL(wait)
 484:	b8 03 00 00 00       	mov    $0x3,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <pipe>:
SYSCALL(pipe)
 48c:	b8 04 00 00 00       	mov    $0x4,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <read>:
SYSCALL(read)
 494:	b8 05 00 00 00       	mov    $0x5,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <write>:
SYSCALL(write)
 49c:	b8 10 00 00 00       	mov    $0x10,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <close>:
SYSCALL(close)
 4a4:	b8 15 00 00 00       	mov    $0x15,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <kill>:
SYSCALL(kill)
 4ac:	b8 06 00 00 00       	mov    $0x6,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <exec>:
SYSCALL(exec)
 4b4:	b8 07 00 00 00       	mov    $0x7,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <open>:
SYSCALL(open)
 4bc:	b8 0f 00 00 00       	mov    $0xf,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <mknod>:
SYSCALL(mknod)
 4c4:	b8 11 00 00 00       	mov    $0x11,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <unlink>:
SYSCALL(unlink)
 4cc:	b8 12 00 00 00       	mov    $0x12,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <fstat>:
SYSCALL(fstat)
 4d4:	b8 08 00 00 00       	mov    $0x8,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <link>:
SYSCALL(link)
 4dc:	b8 13 00 00 00       	mov    $0x13,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <mkdir>:
SYSCALL(mkdir)
 4e4:	b8 14 00 00 00       	mov    $0x14,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <chdir>:
SYSCALL(chdir)
 4ec:	b8 09 00 00 00       	mov    $0x9,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <dup>:
SYSCALL(dup)
 4f4:	b8 0a 00 00 00       	mov    $0xa,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <getpid>:
SYSCALL(getpid)
 4fc:	b8 0b 00 00 00       	mov    $0xb,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <sbrk>:
SYSCALL(sbrk)
 504:	b8 0c 00 00 00       	mov    $0xc,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <sleep>:
SYSCALL(sleep)
 50c:	b8 0d 00 00 00       	mov    $0xd,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <uptime>:
SYSCALL(uptime)
 514:	b8 0e 00 00 00       	mov    $0xe,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <halt>:
SYSCALL(halt)
 51c:	b8 16 00 00 00       	mov    $0x16,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <alarm>:
 524:	b8 17 00 00 00       	mov    $0x17,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 52c:	55                   	push   %ebp
 52d:	89 e5                	mov    %esp,%ebp
 52f:	83 ec 28             	sub    $0x28,%esp
 532:	8b 45 0c             	mov    0xc(%ebp),%eax
 535:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 538:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 53f:	00 
 540:	8d 45 f4             	lea    -0xc(%ebp),%eax
 543:	89 44 24 04          	mov    %eax,0x4(%esp)
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	89 04 24             	mov    %eax,(%esp)
 54d:	e8 4a ff ff ff       	call   49c <write>
}
 552:	c9                   	leave  
 553:	c3                   	ret    

00000554 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 55a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 561:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 565:	74 17                	je     57e <printint+0x2a>
 567:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 56b:	79 11                	jns    57e <printint+0x2a>
    neg = 1;
 56d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 574:	8b 45 0c             	mov    0xc(%ebp),%eax
 577:	f7 d8                	neg    %eax
 579:	89 45 ec             	mov    %eax,-0x14(%ebp)
 57c:	eb 06                	jmp    584 <printint+0x30>
  } else {
    x = xx;
 57e:	8b 45 0c             	mov    0xc(%ebp),%eax
 581:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 584:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 58b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 58e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 591:	ba 00 00 00 00       	mov    $0x0,%edx
 596:	f7 f1                	div    %ecx
 598:	89 d0                	mov    %edx,%eax
 59a:	0f b6 80 dc 0c 00 00 	movzbl 0xcdc(%eax),%eax
 5a1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 5a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5a7:	01 ca                	add    %ecx,%edx
 5a9:	88 02                	mov    %al,(%edx)
 5ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 5af:	8b 55 10             	mov    0x10(%ebp),%edx
 5b2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 5b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b8:	ba 00 00 00 00       	mov    $0x0,%edx
 5bd:	f7 75 d4             	divl   -0x2c(%ebp)
 5c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c7:	75 c2                	jne    58b <printint+0x37>
  if(neg)
 5c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5cd:	74 2e                	je     5fd <printint+0xa9>
    buf[i++] = '-';
 5cf:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d5:	01 d0                	add    %edx,%eax
 5d7:	c6 00 2d             	movb   $0x2d,(%eax)
 5da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 5de:	eb 1d                	jmp    5fd <printint+0xa9>
    putc(fd, buf[i]);
 5e0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e6:	01 d0                	add    %edx,%eax
 5e8:	0f b6 00             	movzbl (%eax),%eax
 5eb:	0f be c0             	movsbl %al,%eax
 5ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f2:	8b 45 08             	mov    0x8(%ebp),%eax
 5f5:	89 04 24             	mov    %eax,(%esp)
 5f8:	e8 2f ff ff ff       	call   52c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5fd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 605:	79 d9                	jns    5e0 <printint+0x8c>
    putc(fd, buf[i]);
}
 607:	c9                   	leave  
 608:	c3                   	ret    

00000609 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 609:	55                   	push   %ebp
 60a:	89 e5                	mov    %esp,%ebp
 60c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 60f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 616:	8d 45 0c             	lea    0xc(%ebp),%eax
 619:	83 c0 04             	add    $0x4,%eax
 61c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 61f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 626:	e9 7d 01 00 00       	jmp    7a8 <printf+0x19f>
    c = fmt[i] & 0xff;
 62b:	8b 55 0c             	mov    0xc(%ebp),%edx
 62e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 631:	01 d0                	add    %edx,%eax
 633:	0f b6 00             	movzbl (%eax),%eax
 636:	0f be c0             	movsbl %al,%eax
 639:	25 ff 00 00 00       	and    $0xff,%eax
 63e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 641:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 645:	75 2c                	jne    673 <printf+0x6a>
      if(c == '%'){
 647:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64b:	75 0c                	jne    659 <printf+0x50>
        state = '%';
 64d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 654:	e9 4b 01 00 00       	jmp    7a4 <printf+0x19b>
      } else {
        putc(fd, c);
 659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65c:	0f be c0             	movsbl %al,%eax
 65f:	89 44 24 04          	mov    %eax,0x4(%esp)
 663:	8b 45 08             	mov    0x8(%ebp),%eax
 666:	89 04 24             	mov    %eax,(%esp)
 669:	e8 be fe ff ff       	call   52c <putc>
 66e:	e9 31 01 00 00       	jmp    7a4 <printf+0x19b>
      }
    } else if(state == '%'){
 673:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 677:	0f 85 27 01 00 00    	jne    7a4 <printf+0x19b>
      if(c == 'd'){
 67d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 681:	75 2d                	jne    6b0 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 683:	8b 45 e8             	mov    -0x18(%ebp),%eax
 686:	8b 00                	mov    (%eax),%eax
 688:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 68f:	00 
 690:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 697:	00 
 698:	89 44 24 04          	mov    %eax,0x4(%esp)
 69c:	8b 45 08             	mov    0x8(%ebp),%eax
 69f:	89 04 24             	mov    %eax,(%esp)
 6a2:	e8 ad fe ff ff       	call   554 <printint>
        ap++;
 6a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ab:	e9 ed 00 00 00       	jmp    79d <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 6b0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6b4:	74 06                	je     6bc <printf+0xb3>
 6b6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6ba:	75 2d                	jne    6e9 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6bf:	8b 00                	mov    (%eax),%eax
 6c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6c8:	00 
 6c9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6d0:	00 
 6d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d5:	8b 45 08             	mov    0x8(%ebp),%eax
 6d8:	89 04 24             	mov    %eax,(%esp)
 6db:	e8 74 fe ff ff       	call   554 <printint>
        ap++;
 6e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e4:	e9 b4 00 00 00       	jmp    79d <printf+0x194>
      } else if(c == 's'){
 6e9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6ed:	75 46                	jne    735 <printf+0x12c>
        s = (char*)*ap;
 6ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f2:	8b 00                	mov    (%eax),%eax
 6f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ff:	75 27                	jne    728 <printf+0x11f>
          s = "(null)";
 701:	c7 45 f4 99 0a 00 00 	movl   $0xa99,-0xc(%ebp)
        while(*s != 0){
 708:	eb 1e                	jmp    728 <printf+0x11f>
          putc(fd, *s);
 70a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70d:	0f b6 00             	movzbl (%eax),%eax
 710:	0f be c0             	movsbl %al,%eax
 713:	89 44 24 04          	mov    %eax,0x4(%esp)
 717:	8b 45 08             	mov    0x8(%ebp),%eax
 71a:	89 04 24             	mov    %eax,(%esp)
 71d:	e8 0a fe ff ff       	call   52c <putc>
          s++;
 722:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 726:	eb 01                	jmp    729 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 728:	90                   	nop
 729:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72c:	0f b6 00             	movzbl (%eax),%eax
 72f:	84 c0                	test   %al,%al
 731:	75 d7                	jne    70a <printf+0x101>
 733:	eb 68                	jmp    79d <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 735:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 739:	75 1d                	jne    758 <printf+0x14f>
        putc(fd, *ap);
 73b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73e:	8b 00                	mov    (%eax),%eax
 740:	0f be c0             	movsbl %al,%eax
 743:	89 44 24 04          	mov    %eax,0x4(%esp)
 747:	8b 45 08             	mov    0x8(%ebp),%eax
 74a:	89 04 24             	mov    %eax,(%esp)
 74d:	e8 da fd ff ff       	call   52c <putc>
        ap++;
 752:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 756:	eb 45                	jmp    79d <printf+0x194>
      } else if(c == '%'){
 758:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 75c:	75 17                	jne    775 <printf+0x16c>
        putc(fd, c);
 75e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 761:	0f be c0             	movsbl %al,%eax
 764:	89 44 24 04          	mov    %eax,0x4(%esp)
 768:	8b 45 08             	mov    0x8(%ebp),%eax
 76b:	89 04 24             	mov    %eax,(%esp)
 76e:	e8 b9 fd ff ff       	call   52c <putc>
 773:	eb 28                	jmp    79d <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 775:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 77c:	00 
 77d:	8b 45 08             	mov    0x8(%ebp),%eax
 780:	89 04 24             	mov    %eax,(%esp)
 783:	e8 a4 fd ff ff       	call   52c <putc>
        putc(fd, c);
 788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 78b:	0f be c0             	movsbl %al,%eax
 78e:	89 44 24 04          	mov    %eax,0x4(%esp)
 792:	8b 45 08             	mov    0x8(%ebp),%eax
 795:	89 04 24             	mov    %eax,(%esp)
 798:	e8 8f fd ff ff       	call   52c <putc>
      }
      state = 0;
 79d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7a4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	01 d0                	add    %edx,%eax
 7b0:	0f b6 00             	movzbl (%eax),%eax
 7b3:	84 c0                	test   %al,%al
 7b5:	0f 85 70 fe ff ff    	jne    62b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7bb:	c9                   	leave  
 7bc:	c3                   	ret    
 7bd:	66 90                	xchg   %ax,%ax
 7bf:	90                   	nop

000007c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c6:	8b 45 08             	mov    0x8(%ebp),%eax
 7c9:	83 e8 08             	sub    $0x8,%eax
 7cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7cf:	a1 f8 0c 00 00       	mov    0xcf8,%eax
 7d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d7:	eb 24                	jmp    7fd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e1:	77 12                	ja     7f5 <free+0x35>
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e9:	77 24                	ja     80f <free+0x4f>
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	8b 00                	mov    (%eax),%eax
 7f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f3:	77 1a                	ja     80f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f8:	8b 00                	mov    (%eax),%eax
 7fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 800:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 803:	76 d4                	jbe    7d9 <free+0x19>
 805:	8b 45 fc             	mov    -0x4(%ebp),%eax
 808:	8b 00                	mov    (%eax),%eax
 80a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 80d:	76 ca                	jbe    7d9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 80f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 812:	8b 40 04             	mov    0x4(%eax),%eax
 815:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 81c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81f:	01 c2                	add    %eax,%edx
 821:	8b 45 fc             	mov    -0x4(%ebp),%eax
 824:	8b 00                	mov    (%eax),%eax
 826:	39 c2                	cmp    %eax,%edx
 828:	75 24                	jne    84e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 82a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82d:	8b 50 04             	mov    0x4(%eax),%edx
 830:	8b 45 fc             	mov    -0x4(%ebp),%eax
 833:	8b 00                	mov    (%eax),%eax
 835:	8b 40 04             	mov    0x4(%eax),%eax
 838:	01 c2                	add    %eax,%edx
 83a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 840:	8b 45 fc             	mov    -0x4(%ebp),%eax
 843:	8b 00                	mov    (%eax),%eax
 845:	8b 10                	mov    (%eax),%edx
 847:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84a:	89 10                	mov    %edx,(%eax)
 84c:	eb 0a                	jmp    858 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 84e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 851:	8b 10                	mov    (%eax),%edx
 853:	8b 45 f8             	mov    -0x8(%ebp),%eax
 856:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 858:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85b:	8b 40 04             	mov    0x4(%eax),%eax
 85e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 865:	8b 45 fc             	mov    -0x4(%ebp),%eax
 868:	01 d0                	add    %edx,%eax
 86a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 86d:	75 20                	jne    88f <free+0xcf>
    p->s.size += bp->s.size;
 86f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 872:	8b 50 04             	mov    0x4(%eax),%edx
 875:	8b 45 f8             	mov    -0x8(%ebp),%eax
 878:	8b 40 04             	mov    0x4(%eax),%eax
 87b:	01 c2                	add    %eax,%edx
 87d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 880:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 883:	8b 45 f8             	mov    -0x8(%ebp),%eax
 886:	8b 10                	mov    (%eax),%edx
 888:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88b:	89 10                	mov    %edx,(%eax)
 88d:	eb 08                	jmp    897 <free+0xd7>
  } else
    p->s.ptr = bp;
 88f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 892:	8b 55 f8             	mov    -0x8(%ebp),%edx
 895:	89 10                	mov    %edx,(%eax)
  freep = p;
 897:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89a:	a3 f8 0c 00 00       	mov    %eax,0xcf8
}
 89f:	c9                   	leave  
 8a0:	c3                   	ret    

000008a1 <morecore>:

static Header*
morecore(uint nu)
{
 8a1:	55                   	push   %ebp
 8a2:	89 e5                	mov    %esp,%ebp
 8a4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8a7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8ae:	77 07                	ja     8b7 <morecore+0x16>
    nu = 4096;
 8b0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8b7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ba:	c1 e0 03             	shl    $0x3,%eax
 8bd:	89 04 24             	mov    %eax,(%esp)
 8c0:	e8 3f fc ff ff       	call   504 <sbrk>
 8c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8c8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8cc:	75 07                	jne    8d5 <morecore+0x34>
    return 0;
 8ce:	b8 00 00 00 00       	mov    $0x0,%eax
 8d3:	eb 22                	jmp    8f7 <morecore+0x56>
  hp = (Header*)p;
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8de:	8b 55 08             	mov    0x8(%ebp),%edx
 8e1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e7:	83 c0 08             	add    $0x8,%eax
 8ea:	89 04 24             	mov    %eax,(%esp)
 8ed:	e8 ce fe ff ff       	call   7c0 <free>
  return freep;
 8f2:	a1 f8 0c 00 00       	mov    0xcf8,%eax
}
 8f7:	c9                   	leave  
 8f8:	c3                   	ret    

000008f9 <malloc>:

void*
malloc(uint nbytes)
{
 8f9:	55                   	push   %ebp
 8fa:	89 e5                	mov    %esp,%ebp
 8fc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ff:	8b 45 08             	mov    0x8(%ebp),%eax
 902:	83 c0 07             	add    $0x7,%eax
 905:	c1 e8 03             	shr    $0x3,%eax
 908:	83 c0 01             	add    $0x1,%eax
 90b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 90e:	a1 f8 0c 00 00       	mov    0xcf8,%eax
 913:	89 45 f0             	mov    %eax,-0x10(%ebp)
 916:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 91a:	75 23                	jne    93f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 91c:	c7 45 f0 f0 0c 00 00 	movl   $0xcf0,-0x10(%ebp)
 923:	8b 45 f0             	mov    -0x10(%ebp),%eax
 926:	a3 f8 0c 00 00       	mov    %eax,0xcf8
 92b:	a1 f8 0c 00 00       	mov    0xcf8,%eax
 930:	a3 f0 0c 00 00       	mov    %eax,0xcf0
    base.s.size = 0;
 935:	c7 05 f4 0c 00 00 00 	movl   $0x0,0xcf4
 93c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 942:	8b 00                	mov    (%eax),%eax
 944:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 947:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94a:	8b 40 04             	mov    0x4(%eax),%eax
 94d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 950:	72 4d                	jb     99f <malloc+0xa6>
      if(p->s.size == nunits)
 952:	8b 45 f4             	mov    -0xc(%ebp),%eax
 955:	8b 40 04             	mov    0x4(%eax),%eax
 958:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 95b:	75 0c                	jne    969 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 95d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 960:	8b 10                	mov    (%eax),%edx
 962:	8b 45 f0             	mov    -0x10(%ebp),%eax
 965:	89 10                	mov    %edx,(%eax)
 967:	eb 26                	jmp    98f <malloc+0x96>
      else {
        p->s.size -= nunits;
 969:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96c:	8b 40 04             	mov    0x4(%eax),%eax
 96f:	89 c2                	mov    %eax,%edx
 971:	2b 55 ec             	sub    -0x14(%ebp),%edx
 974:	8b 45 f4             	mov    -0xc(%ebp),%eax
 977:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 97a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97d:	8b 40 04             	mov    0x4(%eax),%eax
 980:	c1 e0 03             	shl    $0x3,%eax
 983:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 986:	8b 45 f4             	mov    -0xc(%ebp),%eax
 989:	8b 55 ec             	mov    -0x14(%ebp),%edx
 98c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 98f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 992:	a3 f8 0c 00 00       	mov    %eax,0xcf8
      return (void*)(p + 1);
 997:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99a:	83 c0 08             	add    $0x8,%eax
 99d:	eb 38                	jmp    9d7 <malloc+0xde>
    }
    if(p == freep)
 99f:	a1 f8 0c 00 00       	mov    0xcf8,%eax
 9a4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9a7:	75 1b                	jne    9c4 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 9a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9ac:	89 04 24             	mov    %eax,(%esp)
 9af:	e8 ed fe ff ff       	call   8a1 <morecore>
 9b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9bb:	75 07                	jne    9c4 <malloc+0xcb>
        return 0;
 9bd:	b8 00 00 00 00       	mov    $0x0,%eax
 9c2:	eb 13                	jmp    9d7 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cd:	8b 00                	mov    (%eax),%eax
 9cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9d2:	e9 70 ff ff ff       	jmp    947 <malloc+0x4e>
}
 9d7:	c9                   	leave  
 9d8:	c3                   	ret    
