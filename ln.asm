
_ln：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 41 08 00 	movl   $0x841,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 4e 04 00 00       	call   471 <printf>
    exit();
  23:	e8 bc 02 00 00       	call   2e4 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 00 03 00 00       	call   344 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 54 08 00 	movl   $0x854,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 fd 03 00 00       	call   471 <printf>
  exit();
  74:	e8 6b 02 00 00       	call   2e4 <exit>
  79:	66 90                	xchg   %ax,%ax
  7b:	90                   	nop

0000007c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	57                   	push   %edi
  80:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  84:	8b 55 10             	mov    0x10(%ebp),%edx
  87:	8b 45 0c             	mov    0xc(%ebp),%eax
  8a:	89 cb                	mov    %ecx,%ebx
  8c:	89 df                	mov    %ebx,%edi
  8e:	89 d1                	mov    %edx,%ecx
  90:	fc                   	cld    
  91:	f3 aa                	rep stos %al,%es:(%edi)
  93:	89 ca                	mov    %ecx,%edx
  95:	89 fb                	mov    %edi,%ebx
  97:	89 5d 08             	mov    %ebx,0x8(%ebp)
  9a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9d:	5b                   	pop    %ebx
  9e:	5f                   	pop    %edi
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ad:	90                   	nop
  ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  b1:	0f b6 10             	movzbl (%eax),%edx
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	88 10                	mov    %dl,(%eax)
  b9:	8b 45 08             	mov    0x8(%ebp),%eax
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	0f 95 c0             	setne  %al
  c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  cc:	84 c0                	test   %al,%al
  ce:	75 de                	jne    ae <strcpy+0xd>
    ;
  return os;
  d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d3:	c9                   	leave  
  d4:	c3                   	ret    

000000d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d5:	55                   	push   %ebp
  d6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d8:	eb 08                	jmp    e2 <strcmp+0xd>
    p++, q++;
  da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  de:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	84 c0                	test   %al,%al
  ea:	74 10                	je     fc <strcmp+0x27>
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	0f b6 10             	movzbl (%eax),%edx
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	0f b6 00             	movzbl (%eax),%eax
  f8:	38 c2                	cmp    %al,%dl
  fa:	74 de                	je     da <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
  ff:	0f b6 00             	movzbl (%eax),%eax
 102:	0f b6 d0             	movzbl %al,%edx
 105:	8b 45 0c             	mov    0xc(%ebp),%eax
 108:	0f b6 00             	movzbl (%eax),%eax
 10b:	0f b6 c0             	movzbl %al,%eax
 10e:	89 d1                	mov    %edx,%ecx
 110:	29 c1                	sub    %eax,%ecx
 112:	89 c8                	mov    %ecx,%eax
}
 114:	5d                   	pop    %ebp
 115:	c3                   	ret    

00000116 <strlen>:

uint
strlen(char *s)
{
 116:	55                   	push   %ebp
 117:	89 e5                	mov    %esp,%ebp
 119:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 123:	eb 04                	jmp    129 <strlen+0x13>
 125:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 129:	8b 55 fc             	mov    -0x4(%ebp),%edx
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	01 d0                	add    %edx,%eax
 131:	0f b6 00             	movzbl (%eax),%eax
 134:	84 c0                	test   %al,%al
 136:	75 ed                	jne    125 <strlen+0xf>
    ;
  return n;
 138:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13b:	c9                   	leave  
 13c:	c3                   	ret    

0000013d <memset>:

void*
memset(void *dst, int c, uint n)
{
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 143:	8b 45 10             	mov    0x10(%ebp),%eax
 146:	89 44 24 08          	mov    %eax,0x8(%esp)
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	89 44 24 04          	mov    %eax,0x4(%esp)
 151:	8b 45 08             	mov    0x8(%ebp),%eax
 154:	89 04 24             	mov    %eax,(%esp)
 157:	e8 20 ff ff ff       	call   7c <stosb>
  return dst;
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15f:	c9                   	leave  
 160:	c3                   	ret    

00000161 <strchr>:

char*
strchr(const char *s, char c)
{
 161:	55                   	push   %ebp
 162:	89 e5                	mov    %esp,%ebp
 164:	83 ec 04             	sub    $0x4,%esp
 167:	8b 45 0c             	mov    0xc(%ebp),%eax
 16a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16d:	eb 14                	jmp    183 <strchr+0x22>
    if(*s == c)
 16f:	8b 45 08             	mov    0x8(%ebp),%eax
 172:	0f b6 00             	movzbl (%eax),%eax
 175:	3a 45 fc             	cmp    -0x4(%ebp),%al
 178:	75 05                	jne    17f <strchr+0x1e>
      return (char*)s;
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	eb 13                	jmp    192 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 17f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	0f b6 00             	movzbl (%eax),%eax
 189:	84 c0                	test   %al,%al
 18b:	75 e2                	jne    16f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 18d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 192:	c9                   	leave  
 193:	c3                   	ret    

00000194 <gets>:

char*
gets(char *buf, int max)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a1:	eb 46                	jmp    1e9 <gets+0x55>
    cc = read(0, &c, 1);
 1a3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1aa:	00 
 1ab:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b9:	e8 3e 01 00 00       	call   2fc <read>
 1be:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c5:	7e 2f                	jle    1f6 <gets+0x62>
      break;
    buf[i++] = c;
 1c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	01 c2                	add    %eax,%edx
 1cf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d3:	88 02                	mov    %al,(%edx)
 1d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1d9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1dd:	3c 0a                	cmp    $0xa,%al
 1df:	74 16                	je     1f7 <gets+0x63>
 1e1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e5:	3c 0d                	cmp    $0xd,%al
 1e7:	74 0e                	je     1f7 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ec:	83 c0 01             	add    $0x1,%eax
 1ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f2:	7c af                	jl     1a3 <gets+0xf>
 1f4:	eb 01                	jmp    1f7 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	01 d0                	add    %edx,%eax
 1ff:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 202:	8b 45 08             	mov    0x8(%ebp),%eax
}
 205:	c9                   	leave  
 206:	c3                   	ret    

00000207 <stat>:

int
stat(char *n, struct stat *st)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 214:	00 
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	89 04 24             	mov    %eax,(%esp)
 21b:	e8 04 01 00 00       	call   324 <open>
 220:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 227:	79 07                	jns    230 <stat+0x29>
    return -1;
 229:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22e:	eb 23                	jmp    253 <stat+0x4c>
  r = fstat(fd, st);
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	89 44 24 04          	mov    %eax,0x4(%esp)
 237:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23a:	89 04 24             	mov    %eax,(%esp)
 23d:	e8 fa 00 00 00       	call   33c <fstat>
 242:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 245:	8b 45 f4             	mov    -0xc(%ebp),%eax
 248:	89 04 24             	mov    %eax,(%esp)
 24b:	e8 bc 00 00 00       	call   30c <close>
  return r;
 250:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 253:	c9                   	leave  
 254:	c3                   	ret    

00000255 <atoi>:

int
atoi(const char *s)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 262:	eb 23                	jmp    287 <atoi+0x32>
    n = n*10 + *s++ - '0';
 264:	8b 55 fc             	mov    -0x4(%ebp),%edx
 267:	89 d0                	mov    %edx,%eax
 269:	c1 e0 02             	shl    $0x2,%eax
 26c:	01 d0                	add    %edx,%eax
 26e:	01 c0                	add    %eax,%eax
 270:	89 c2                	mov    %eax,%edx
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	0f be c0             	movsbl %al,%eax
 27b:	01 d0                	add    %edx,%eax
 27d:	83 e8 30             	sub    $0x30,%eax
 280:	89 45 fc             	mov    %eax,-0x4(%ebp)
 283:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	0f b6 00             	movzbl (%eax),%eax
 28d:	3c 2f                	cmp    $0x2f,%al
 28f:	7e 0a                	jle    29b <atoi+0x46>
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	0f b6 00             	movzbl (%eax),%eax
 297:	3c 39                	cmp    $0x39,%al
 299:	7e c9                	jle    264 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29e:	c9                   	leave  
 29f:	c3                   	ret    

000002a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 2af:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b2:	eb 13                	jmp    2c7 <memmove+0x27>
    *dst++ = *src++;
 2b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b7:	0f b6 10             	movzbl (%eax),%edx
 2ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2bd:	88 10                	mov    %dl,(%eax)
 2bf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2c3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2cb:	0f 9f c0             	setg   %al
 2ce:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2d2:	84 c0                	test   %al,%al
 2d4:	75 de                	jne    2b4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d9:	c9                   	leave  
 2da:	c3                   	ret    
 2db:	90                   	nop

000002dc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2dc:	b8 01 00 00 00       	mov    $0x1,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <exit>:
SYSCALL(exit)
 2e4:	b8 02 00 00 00       	mov    $0x2,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <wait>:
SYSCALL(wait)
 2ec:	b8 03 00 00 00       	mov    $0x3,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <pipe>:
SYSCALL(pipe)
 2f4:	b8 04 00 00 00       	mov    $0x4,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <read>:
SYSCALL(read)
 2fc:	b8 05 00 00 00       	mov    $0x5,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <write>:
SYSCALL(write)
 304:	b8 10 00 00 00       	mov    $0x10,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <close>:
SYSCALL(close)
 30c:	b8 15 00 00 00       	mov    $0x15,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <kill>:
SYSCALL(kill)
 314:	b8 06 00 00 00       	mov    $0x6,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <exec>:
SYSCALL(exec)
 31c:	b8 07 00 00 00       	mov    $0x7,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <open>:
SYSCALL(open)
 324:	b8 0f 00 00 00       	mov    $0xf,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <mknod>:
SYSCALL(mknod)
 32c:	b8 11 00 00 00       	mov    $0x11,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <unlink>:
SYSCALL(unlink)
 334:	b8 12 00 00 00       	mov    $0x12,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <fstat>:
SYSCALL(fstat)
 33c:	b8 08 00 00 00       	mov    $0x8,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <link>:
SYSCALL(link)
 344:	b8 13 00 00 00       	mov    $0x13,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <mkdir>:
SYSCALL(mkdir)
 34c:	b8 14 00 00 00       	mov    $0x14,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <chdir>:
SYSCALL(chdir)
 354:	b8 09 00 00 00       	mov    $0x9,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <dup>:
SYSCALL(dup)
 35c:	b8 0a 00 00 00       	mov    $0xa,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <getpid>:
SYSCALL(getpid)
 364:	b8 0b 00 00 00       	mov    $0xb,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <sbrk>:
SYSCALL(sbrk)
 36c:	b8 0c 00 00 00       	mov    $0xc,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <sleep>:
SYSCALL(sleep)
 374:	b8 0d 00 00 00       	mov    $0xd,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <uptime>:
SYSCALL(uptime)
 37c:	b8 0e 00 00 00       	mov    $0xe,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <halt>:
SYSCALL(halt)
 384:	b8 16 00 00 00       	mov    $0x16,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <alarm>:
 38c:	b8 17 00 00 00       	mov    $0x17,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 394:	55                   	push   %ebp
 395:	89 e5                	mov    %esp,%ebp
 397:	83 ec 28             	sub    $0x28,%esp
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3a7:	00 
 3a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	89 04 24             	mov    %eax,(%esp)
 3b5:	e8 4a ff ff ff       	call   304 <write>
}
 3ba:	c9                   	leave  
 3bb:	c3                   	ret    

000003bc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3bc:	55                   	push   %ebp
 3bd:	89 e5                	mov    %esp,%ebp
 3bf:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3cd:	74 17                	je     3e6 <printint+0x2a>
 3cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d3:	79 11                	jns    3e6 <printint+0x2a>
    neg = 1;
 3d5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3df:	f7 d8                	neg    %eax
 3e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e4:	eb 06                	jmp    3ec <printint+0x30>
  } else {
    x = xx;
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f9:	ba 00 00 00 00       	mov    $0x0,%edx
 3fe:	f7 f1                	div    %ecx
 400:	89 d0                	mov    %edx,%eax
 402:	0f b6 80 ac 0a 00 00 	movzbl 0xaac(%eax),%eax
 409:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 40c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 40f:	01 ca                	add    %ecx,%edx
 411:	88 02                	mov    %al,(%edx)
 413:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 417:	8b 55 10             	mov    0x10(%ebp),%edx
 41a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 41d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 420:	ba 00 00 00 00       	mov    $0x0,%edx
 425:	f7 75 d4             	divl   -0x2c(%ebp)
 428:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 42f:	75 c2                	jne    3f3 <printint+0x37>
  if(neg)
 431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 435:	74 2e                	je     465 <printint+0xa9>
    buf[i++] = '-';
 437:	8d 55 dc             	lea    -0x24(%ebp),%edx
 43a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43d:	01 d0                	add    %edx,%eax
 43f:	c6 00 2d             	movb   $0x2d,(%eax)
 442:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 446:	eb 1d                	jmp    465 <printint+0xa9>
    putc(fd, buf[i]);
 448:	8d 55 dc             	lea    -0x24(%ebp),%edx
 44b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44e:	01 d0                	add    %edx,%eax
 450:	0f b6 00             	movzbl (%eax),%eax
 453:	0f be c0             	movsbl %al,%eax
 456:	89 44 24 04          	mov    %eax,0x4(%esp)
 45a:	8b 45 08             	mov    0x8(%ebp),%eax
 45d:	89 04 24             	mov    %eax,(%esp)
 460:	e8 2f ff ff ff       	call   394 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 465:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 469:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 46d:	79 d9                	jns    448 <printint+0x8c>
    putc(fd, buf[i]);
}
 46f:	c9                   	leave  
 470:	c3                   	ret    

00000471 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 471:	55                   	push   %ebp
 472:	89 e5                	mov    %esp,%ebp
 474:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 477:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 47e:	8d 45 0c             	lea    0xc(%ebp),%eax
 481:	83 c0 04             	add    $0x4,%eax
 484:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 487:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 48e:	e9 7d 01 00 00       	jmp    610 <printf+0x19f>
    c = fmt[i] & 0xff;
 493:	8b 55 0c             	mov    0xc(%ebp),%edx
 496:	8b 45 f0             	mov    -0x10(%ebp),%eax
 499:	01 d0                	add    %edx,%eax
 49b:	0f b6 00             	movzbl (%eax),%eax
 49e:	0f be c0             	movsbl %al,%eax
 4a1:	25 ff 00 00 00       	and    $0xff,%eax
 4a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ad:	75 2c                	jne    4db <printf+0x6a>
      if(c == '%'){
 4af:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b3:	75 0c                	jne    4c1 <printf+0x50>
        state = '%';
 4b5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4bc:	e9 4b 01 00 00       	jmp    60c <printf+0x19b>
      } else {
        putc(fd, c);
 4c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c4:	0f be c0             	movsbl %al,%eax
 4c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ce:	89 04 24             	mov    %eax,(%esp)
 4d1:	e8 be fe ff ff       	call   394 <putc>
 4d6:	e9 31 01 00 00       	jmp    60c <printf+0x19b>
      }
    } else if(state == '%'){
 4db:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4df:	0f 85 27 01 00 00    	jne    60c <printf+0x19b>
      if(c == 'd'){
 4e5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4e9:	75 2d                	jne    518 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ee:	8b 00                	mov    (%eax),%eax
 4f0:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4f7:	00 
 4f8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4ff:	00 
 500:	89 44 24 04          	mov    %eax,0x4(%esp)
 504:	8b 45 08             	mov    0x8(%ebp),%eax
 507:	89 04 24             	mov    %eax,(%esp)
 50a:	e8 ad fe ff ff       	call   3bc <printint>
        ap++;
 50f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 513:	e9 ed 00 00 00       	jmp    605 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 518:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 51c:	74 06                	je     524 <printf+0xb3>
 51e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 522:	75 2d                	jne    551 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 524:	8b 45 e8             	mov    -0x18(%ebp),%eax
 527:	8b 00                	mov    (%eax),%eax
 529:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 530:	00 
 531:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 538:	00 
 539:	89 44 24 04          	mov    %eax,0x4(%esp)
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	89 04 24             	mov    %eax,(%esp)
 543:	e8 74 fe ff ff       	call   3bc <printint>
        ap++;
 548:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54c:	e9 b4 00 00 00       	jmp    605 <printf+0x194>
      } else if(c == 's'){
 551:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 555:	75 46                	jne    59d <printf+0x12c>
        s = (char*)*ap;
 557:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55a:	8b 00                	mov    (%eax),%eax
 55c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 55f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 567:	75 27                	jne    590 <printf+0x11f>
          s = "(null)";
 569:	c7 45 f4 68 08 00 00 	movl   $0x868,-0xc(%ebp)
        while(*s != 0){
 570:	eb 1e                	jmp    590 <printf+0x11f>
          putc(fd, *s);
 572:	8b 45 f4             	mov    -0xc(%ebp),%eax
 575:	0f b6 00             	movzbl (%eax),%eax
 578:	0f be c0             	movsbl %al,%eax
 57b:	89 44 24 04          	mov    %eax,0x4(%esp)
 57f:	8b 45 08             	mov    0x8(%ebp),%eax
 582:	89 04 24             	mov    %eax,(%esp)
 585:	e8 0a fe ff ff       	call   394 <putc>
          s++;
 58a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 58e:	eb 01                	jmp    591 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 590:	90                   	nop
 591:	8b 45 f4             	mov    -0xc(%ebp),%eax
 594:	0f b6 00             	movzbl (%eax),%eax
 597:	84 c0                	test   %al,%al
 599:	75 d7                	jne    572 <printf+0x101>
 59b:	eb 68                	jmp    605 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 59d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5a1:	75 1d                	jne    5c0 <printf+0x14f>
        putc(fd, *ap);
 5a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a6:	8b 00                	mov    (%eax),%eax
 5a8:	0f be c0             	movsbl %al,%eax
 5ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 5af:	8b 45 08             	mov    0x8(%ebp),%eax
 5b2:	89 04 24             	mov    %eax,(%esp)
 5b5:	e8 da fd ff ff       	call   394 <putc>
        ap++;
 5ba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5be:	eb 45                	jmp    605 <printf+0x194>
      } else if(c == '%'){
 5c0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c4:	75 17                	jne    5dd <printf+0x16c>
        putc(fd, c);
 5c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c9:	0f be c0             	movsbl %al,%eax
 5cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d0:	8b 45 08             	mov    0x8(%ebp),%eax
 5d3:	89 04 24             	mov    %eax,(%esp)
 5d6:	e8 b9 fd ff ff       	call   394 <putc>
 5db:	eb 28                	jmp    605 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5dd:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5e4:	00 
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	89 04 24             	mov    %eax,(%esp)
 5eb:	e8 a4 fd ff ff       	call   394 <putc>
        putc(fd, c);
 5f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f3:	0f be c0             	movsbl %al,%eax
 5f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fa:	8b 45 08             	mov    0x8(%ebp),%eax
 5fd:	89 04 24             	mov    %eax,(%esp)
 600:	e8 8f fd ff ff       	call   394 <putc>
      }
      state = 0;
 605:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 60c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 610:	8b 55 0c             	mov    0xc(%ebp),%edx
 613:	8b 45 f0             	mov    -0x10(%ebp),%eax
 616:	01 d0                	add    %edx,%eax
 618:	0f b6 00             	movzbl (%eax),%eax
 61b:	84 c0                	test   %al,%al
 61d:	0f 85 70 fe ff ff    	jne    493 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 623:	c9                   	leave  
 624:	c3                   	ret    
 625:	66 90                	xchg   %ax,%ax
 627:	90                   	nop

00000628 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 628:	55                   	push   %ebp
 629:	89 e5                	mov    %esp,%ebp
 62b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 62e:	8b 45 08             	mov    0x8(%ebp),%eax
 631:	83 e8 08             	sub    $0x8,%eax
 634:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 637:	a1 c8 0a 00 00       	mov    0xac8,%eax
 63c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63f:	eb 24                	jmp    665 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 641:	8b 45 fc             	mov    -0x4(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 649:	77 12                	ja     65d <free+0x35>
 64b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 651:	77 24                	ja     677 <free+0x4f>
 653:	8b 45 fc             	mov    -0x4(%ebp),%eax
 656:	8b 00                	mov    (%eax),%eax
 658:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65b:	77 1a                	ja     677 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	89 45 fc             	mov    %eax,-0x4(%ebp)
 665:	8b 45 f8             	mov    -0x8(%ebp),%eax
 668:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66b:	76 d4                	jbe    641 <free+0x19>
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 675:	76 ca                	jbe    641 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 677:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67a:	8b 40 04             	mov    0x4(%eax),%eax
 67d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 684:	8b 45 f8             	mov    -0x8(%ebp),%eax
 687:	01 c2                	add    %eax,%edx
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	39 c2                	cmp    %eax,%edx
 690:	75 24                	jne    6b6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 692:	8b 45 f8             	mov    -0x8(%ebp),%eax
 695:	8b 50 04             	mov    0x4(%eax),%edx
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 00                	mov    (%eax),%eax
 69d:	8b 40 04             	mov    0x4(%eax),%eax
 6a0:	01 c2                	add    %eax,%edx
 6a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	8b 00                	mov    (%eax),%eax
 6ad:	8b 10                	mov    (%eax),%edx
 6af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b2:	89 10                	mov    %edx,(%eax)
 6b4:	eb 0a                	jmp    6c0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 10                	mov    (%eax),%edx
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 40 04             	mov    0x4(%eax),%eax
 6c6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	01 d0                	add    %edx,%eax
 6d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d5:	75 20                	jne    6f7 <free+0xcf>
    p->s.size += bp->s.size;
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 50 04             	mov    0x4(%eax),%edx
 6dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e0:	8b 40 04             	mov    0x4(%eax),%eax
 6e3:	01 c2                	add    %eax,%edx
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ee:	8b 10                	mov    (%eax),%edx
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	89 10                	mov    %edx,(%eax)
 6f5:	eb 08                	jmp    6ff <free+0xd7>
  } else
    p->s.ptr = bp;
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6fd:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	a3 c8 0a 00 00       	mov    %eax,0xac8
}
 707:	c9                   	leave  
 708:	c3                   	ret    

00000709 <morecore>:

static Header*
morecore(uint nu)
{
 709:	55                   	push   %ebp
 70a:	89 e5                	mov    %esp,%ebp
 70c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 70f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 716:	77 07                	ja     71f <morecore+0x16>
    nu = 4096;
 718:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 71f:	8b 45 08             	mov    0x8(%ebp),%eax
 722:	c1 e0 03             	shl    $0x3,%eax
 725:	89 04 24             	mov    %eax,(%esp)
 728:	e8 3f fc ff ff       	call   36c <sbrk>
 72d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 730:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 734:	75 07                	jne    73d <morecore+0x34>
    return 0;
 736:	b8 00 00 00 00       	mov    $0x0,%eax
 73b:	eb 22                	jmp    75f <morecore+0x56>
  hp = (Header*)p;
 73d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 740:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 743:	8b 45 f0             	mov    -0x10(%ebp),%eax
 746:	8b 55 08             	mov    0x8(%ebp),%edx
 749:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 74c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74f:	83 c0 08             	add    $0x8,%eax
 752:	89 04 24             	mov    %eax,(%esp)
 755:	e8 ce fe ff ff       	call   628 <free>
  return freep;
 75a:	a1 c8 0a 00 00       	mov    0xac8,%eax
}
 75f:	c9                   	leave  
 760:	c3                   	ret    

00000761 <malloc>:

void*
malloc(uint nbytes)
{
 761:	55                   	push   %ebp
 762:	89 e5                	mov    %esp,%ebp
 764:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 767:	8b 45 08             	mov    0x8(%ebp),%eax
 76a:	83 c0 07             	add    $0x7,%eax
 76d:	c1 e8 03             	shr    $0x3,%eax
 770:	83 c0 01             	add    $0x1,%eax
 773:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 776:	a1 c8 0a 00 00       	mov    0xac8,%eax
 77b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 77e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 782:	75 23                	jne    7a7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 784:	c7 45 f0 c0 0a 00 00 	movl   $0xac0,-0x10(%ebp)
 78b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78e:	a3 c8 0a 00 00       	mov    %eax,0xac8
 793:	a1 c8 0a 00 00       	mov    0xac8,%eax
 798:	a3 c0 0a 00 00       	mov    %eax,0xac0
    base.s.size = 0;
 79d:	c7 05 c4 0a 00 00 00 	movl   $0x0,0xac4
 7a4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b2:	8b 40 04             	mov    0x4(%eax),%eax
 7b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b8:	72 4d                	jb     807 <malloc+0xa6>
      if(p->s.size == nunits)
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	8b 40 04             	mov    0x4(%eax),%eax
 7c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c3:	75 0c                	jne    7d1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	8b 10                	mov    (%eax),%edx
 7ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cd:	89 10                	mov    %edx,(%eax)
 7cf:	eb 26                	jmp    7f7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8b 40 04             	mov    0x4(%eax),%eax
 7d7:	89 c2                	mov    %eax,%edx
 7d9:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e5:	8b 40 04             	mov    0x4(%eax),%eax
 7e8:	c1 e0 03             	shl    $0x3,%eax
 7eb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fa:	a3 c8 0a 00 00       	mov    %eax,0xac8
      return (void*)(p + 1);
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	83 c0 08             	add    $0x8,%eax
 805:	eb 38                	jmp    83f <malloc+0xde>
    }
    if(p == freep)
 807:	a1 c8 0a 00 00       	mov    0xac8,%eax
 80c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80f:	75 1b                	jne    82c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 811:	8b 45 ec             	mov    -0x14(%ebp),%eax
 814:	89 04 24             	mov    %eax,(%esp)
 817:	e8 ed fe ff ff       	call   709 <morecore>
 81c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 823:	75 07                	jne    82c <malloc+0xcb>
        return 0;
 825:	b8 00 00 00 00       	mov    $0x0,%eax
 82a:	eb 13                	jmp    83f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 832:	8b 45 f4             	mov    -0xc(%ebp),%eax
 835:	8b 00                	mov    (%eax),%eax
 837:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 83a:	e9 70 ff ff ff       	jmp    7af <malloc+0x4e>
}
 83f:	c9                   	leave  
 840:	c3                   	ret    
