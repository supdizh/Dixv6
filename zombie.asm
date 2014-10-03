
_zombie：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 76 02 00 00       	call   284 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 fe 02 00 00       	call   31c <sleep>
  exit();
  1e:	e8 69 02 00 00       	call   28c <exit>
  23:	90                   	nop

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	5b                   	pop    %ebx
  46:	5f                   	pop    %edi
  47:	5d                   	pop    %ebp
  48:	c3                   	ret    

00000049 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  49:	55                   	push   %ebp
  4a:	89 e5                	mov    %esp,%ebp
  4c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4f:	8b 45 08             	mov    0x8(%ebp),%eax
  52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  55:	90                   	nop
  56:	8b 45 0c             	mov    0xc(%ebp),%eax
  59:	0f b6 10             	movzbl (%eax),%edx
  5c:	8b 45 08             	mov    0x8(%ebp),%eax
  5f:	88 10                	mov    %dl,(%eax)
  61:	8b 45 08             	mov    0x8(%ebp),%eax
  64:	0f b6 00             	movzbl (%eax),%eax
  67:	84 c0                	test   %al,%al
  69:	0f 95 c0             	setne  %al
  6c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  70:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  74:	84 c0                	test   %al,%al
  76:	75 de                	jne    56 <strcpy+0xd>
    ;
  return os;
  78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7b:	c9                   	leave  
  7c:	c3                   	ret    

0000007d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7d:	55                   	push   %ebp
  7e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  80:	eb 08                	jmp    8a <strcmp+0xd>
    p++, q++;
  82:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  86:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8a:	8b 45 08             	mov    0x8(%ebp),%eax
  8d:	0f b6 00             	movzbl (%eax),%eax
  90:	84 c0                	test   %al,%al
  92:	74 10                	je     a4 <strcmp+0x27>
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	0f b6 10             	movzbl (%eax),%edx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	0f b6 00             	movzbl (%eax),%eax
  a0:	38 c2                	cmp    %al,%dl
  a2:	74 de                	je     82 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	0f b6 00             	movzbl (%eax),%eax
  aa:	0f b6 d0             	movzbl %al,%edx
  ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  b0:	0f b6 00             	movzbl (%eax),%eax
  b3:	0f b6 c0             	movzbl %al,%eax
  b6:	89 d1                	mov    %edx,%ecx
  b8:	29 c1                	sub    %eax,%ecx
  ba:	89 c8                	mov    %ecx,%eax
}
  bc:	5d                   	pop    %ebp
  bd:	c3                   	ret    

000000be <strlen>:

uint
strlen(char *s)
{
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  cb:	eb 04                	jmp    d1 <strlen+0x13>
  cd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	01 d0                	add    %edx,%eax
  d9:	0f b6 00             	movzbl (%eax),%eax
  dc:	84 c0                	test   %al,%al
  de:	75 ed                	jne    cd <strlen+0xf>
    ;
  return n;
  e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e3:	c9                   	leave  
  e4:	c3                   	ret    

000000e5 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  e8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
  fc:	89 04 24             	mov    %eax,(%esp)
  ff:	e8 20 ff ff ff       	call   24 <stosb>
  return dst;
 104:	8b 45 08             	mov    0x8(%ebp),%eax
}
 107:	c9                   	leave  
 108:	c3                   	ret    

00000109 <strchr>:

char*
strchr(const char *s, char c)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 04             	sub    $0x4,%esp
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 115:	eb 14                	jmp    12b <strchr+0x22>
    if(*s == c)
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	0f b6 00             	movzbl (%eax),%eax
 11d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 120:	75 05                	jne    127 <strchr+0x1e>
      return (char*)s;
 122:	8b 45 08             	mov    0x8(%ebp),%eax
 125:	eb 13                	jmp    13a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 127:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	84 c0                	test   %al,%al
 133:	75 e2                	jne    117 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 135:	b8 00 00 00 00       	mov    $0x0,%eax
}
 13a:	c9                   	leave  
 13b:	c3                   	ret    

0000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 142:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 149:	eb 46                	jmp    191 <gets+0x55>
    cc = read(0, &c, 1);
 14b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 152:	00 
 153:	8d 45 ef             	lea    -0x11(%ebp),%eax
 156:	89 44 24 04          	mov    %eax,0x4(%esp)
 15a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 161:	e8 3e 01 00 00       	call   2a4 <read>
 166:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 169:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 16d:	7e 2f                	jle    19e <gets+0x62>
      break;
    buf[i++] = c;
 16f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	01 c2                	add    %eax,%edx
 177:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17b:	88 02                	mov    %al,(%edx)
 17d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 181:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 185:	3c 0a                	cmp    $0xa,%al
 187:	74 16                	je     19f <gets+0x63>
 189:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18d:	3c 0d                	cmp    $0xd,%al
 18f:	74 0e                	je     19f <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 191:	8b 45 f4             	mov    -0xc(%ebp),%eax
 194:	83 c0 01             	add    $0x1,%eax
 197:	3b 45 0c             	cmp    0xc(%ebp),%eax
 19a:	7c af                	jl     14b <gets+0xf>
 19c:	eb 01                	jmp    19f <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 19e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	01 d0                	add    %edx,%eax
 1a7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ad:	c9                   	leave  
 1ae:	c3                   	ret    

000001af <stat>:

int
stat(char *n, struct stat *st)
{
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
 1b2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1bc:	00 
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
 1c0:	89 04 24             	mov    %eax,(%esp)
 1c3:	e8 04 01 00 00       	call   2cc <open>
 1c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1cf:	79 07                	jns    1d8 <stat+0x29>
    return -1;
 1d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1d6:	eb 23                	jmp    1fb <stat+0x4c>
  r = fstat(fd, st);
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	89 44 24 04          	mov    %eax,0x4(%esp)
 1df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e2:	89 04 24             	mov    %eax,(%esp)
 1e5:	e8 fa 00 00 00       	call   2e4 <fstat>
 1ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f0:	89 04 24             	mov    %eax,(%esp)
 1f3:	e8 bc 00 00 00       	call   2b4 <close>
  return r;
 1f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1fb:	c9                   	leave  
 1fc:	c3                   	ret    

000001fd <atoi>:

int
atoi(const char *s)
{
 1fd:	55                   	push   %ebp
 1fe:	89 e5                	mov    %esp,%ebp
 200:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 203:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 20a:	eb 23                	jmp    22f <atoi+0x32>
    n = n*10 + *s++ - '0';
 20c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20f:	89 d0                	mov    %edx,%eax
 211:	c1 e0 02             	shl    $0x2,%eax
 214:	01 d0                	add    %edx,%eax
 216:	01 c0                	add    %eax,%eax
 218:	89 c2                	mov    %eax,%edx
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	0f b6 00             	movzbl (%eax),%eax
 220:	0f be c0             	movsbl %al,%eax
 223:	01 d0                	add    %edx,%eax
 225:	83 e8 30             	sub    $0x30,%eax
 228:	89 45 fc             	mov    %eax,-0x4(%ebp)
 22b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3c 2f                	cmp    $0x2f,%al
 237:	7e 0a                	jle    243 <atoi+0x46>
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	0f b6 00             	movzbl (%eax),%eax
 23f:	3c 39                	cmp    $0x39,%al
 241:	7e c9                	jle    20c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 243:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 246:	c9                   	leave  
 247:	c3                   	ret    

00000248 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 254:	8b 45 0c             	mov    0xc(%ebp),%eax
 257:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 25a:	eb 13                	jmp    26f <memmove+0x27>
    *dst++ = *src++;
 25c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 25f:	0f b6 10             	movzbl (%eax),%edx
 262:	8b 45 fc             	mov    -0x4(%ebp),%eax
 265:	88 10                	mov    %dl,(%eax)
 267:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 26b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 26f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 273:	0f 9f c0             	setg   %al
 276:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 27a:	84 c0                	test   %al,%al
 27c:	75 de                	jne    25c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    
 283:	90                   	nop

00000284 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 284:	b8 01 00 00 00       	mov    $0x1,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <exit>:
SYSCALL(exit)
 28c:	b8 02 00 00 00       	mov    $0x2,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <wait>:
SYSCALL(wait)
 294:	b8 03 00 00 00       	mov    $0x3,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <pipe>:
SYSCALL(pipe)
 29c:	b8 04 00 00 00       	mov    $0x4,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <read>:
SYSCALL(read)
 2a4:	b8 05 00 00 00       	mov    $0x5,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <write>:
SYSCALL(write)
 2ac:	b8 10 00 00 00       	mov    $0x10,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <close>:
SYSCALL(close)
 2b4:	b8 15 00 00 00       	mov    $0x15,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <kill>:
SYSCALL(kill)
 2bc:	b8 06 00 00 00       	mov    $0x6,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <exec>:
SYSCALL(exec)
 2c4:	b8 07 00 00 00       	mov    $0x7,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <open>:
SYSCALL(open)
 2cc:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <mknod>:
SYSCALL(mknod)
 2d4:	b8 11 00 00 00       	mov    $0x11,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <unlink>:
SYSCALL(unlink)
 2dc:	b8 12 00 00 00       	mov    $0x12,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <fstat>:
SYSCALL(fstat)
 2e4:	b8 08 00 00 00       	mov    $0x8,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <link>:
SYSCALL(link)
 2ec:	b8 13 00 00 00       	mov    $0x13,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <mkdir>:
SYSCALL(mkdir)
 2f4:	b8 14 00 00 00       	mov    $0x14,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <chdir>:
SYSCALL(chdir)
 2fc:	b8 09 00 00 00       	mov    $0x9,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <dup>:
SYSCALL(dup)
 304:	b8 0a 00 00 00       	mov    $0xa,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <getpid>:
SYSCALL(getpid)
 30c:	b8 0b 00 00 00       	mov    $0xb,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <sbrk>:
SYSCALL(sbrk)
 314:	b8 0c 00 00 00       	mov    $0xc,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <sleep>:
SYSCALL(sleep)
 31c:	b8 0d 00 00 00       	mov    $0xd,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <uptime>:
SYSCALL(uptime)
 324:	b8 0e 00 00 00       	mov    $0xe,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <halt>:
SYSCALL(halt)
 32c:	b8 16 00 00 00       	mov    $0x16,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <alarm>:
 334:	b8 17 00 00 00       	mov    $0x17,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	83 ec 28             	sub    $0x28,%esp
 342:	8b 45 0c             	mov    0xc(%ebp),%eax
 345:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 348:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 34f:	00 
 350:	8d 45 f4             	lea    -0xc(%ebp),%eax
 353:	89 44 24 04          	mov    %eax,0x4(%esp)
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	89 04 24             	mov    %eax,(%esp)
 35d:	e8 4a ff ff ff       	call   2ac <write>
}
 362:	c9                   	leave  
 363:	c3                   	ret    

00000364 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 36a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 371:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 375:	74 17                	je     38e <printint+0x2a>
 377:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 37b:	79 11                	jns    38e <printint+0x2a>
    neg = 1;
 37d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 384:	8b 45 0c             	mov    0xc(%ebp),%eax
 387:	f7 d8                	neg    %eax
 389:	89 45 ec             	mov    %eax,-0x14(%ebp)
 38c:	eb 06                	jmp    394 <printint+0x30>
  } else {
    x = xx;
 38e:	8b 45 0c             	mov    0xc(%ebp),%eax
 391:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 394:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 39b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 39e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a1:	ba 00 00 00 00       	mov    $0x0,%edx
 3a6:	f7 f1                	div    %ecx
 3a8:	89 d0                	mov    %edx,%eax
 3aa:	0f b6 80 2c 0a 00 00 	movzbl 0xa2c(%eax),%eax
 3b1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3b7:	01 ca                	add    %ecx,%edx
 3b9:	88 02                	mov    %al,(%edx)
 3bb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 3bf:	8b 55 10             	mov    0x10(%ebp),%edx
 3c2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c8:	ba 00 00 00 00       	mov    $0x0,%edx
 3cd:	f7 75 d4             	divl   -0x2c(%ebp)
 3d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3d7:	75 c2                	jne    39b <printint+0x37>
  if(neg)
 3d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3dd:	74 2e                	je     40d <printint+0xa9>
    buf[i++] = '-';
 3df:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e5:	01 d0                	add    %edx,%eax
 3e7:	c6 00 2d             	movb   $0x2d,(%eax)
 3ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 3ee:	eb 1d                	jmp    40d <printint+0xa9>
    putc(fd, buf[i]);
 3f0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f6:	01 d0                	add    %edx,%eax
 3f8:	0f b6 00             	movzbl (%eax),%eax
 3fb:	0f be c0             	movsbl %al,%eax
 3fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 402:	8b 45 08             	mov    0x8(%ebp),%eax
 405:	89 04 24             	mov    %eax,(%esp)
 408:	e8 2f ff ff ff       	call   33c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 40d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 411:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 415:	79 d9                	jns    3f0 <printint+0x8c>
    putc(fd, buf[i]);
}
 417:	c9                   	leave  
 418:	c3                   	ret    

00000419 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 419:	55                   	push   %ebp
 41a:	89 e5                	mov    %esp,%ebp
 41c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 41f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 426:	8d 45 0c             	lea    0xc(%ebp),%eax
 429:	83 c0 04             	add    $0x4,%eax
 42c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 42f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 436:	e9 7d 01 00 00       	jmp    5b8 <printf+0x19f>
    c = fmt[i] & 0xff;
 43b:	8b 55 0c             	mov    0xc(%ebp),%edx
 43e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 441:	01 d0                	add    %edx,%eax
 443:	0f b6 00             	movzbl (%eax),%eax
 446:	0f be c0             	movsbl %al,%eax
 449:	25 ff 00 00 00       	and    $0xff,%eax
 44e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 451:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 455:	75 2c                	jne    483 <printf+0x6a>
      if(c == '%'){
 457:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 45b:	75 0c                	jne    469 <printf+0x50>
        state = '%';
 45d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 464:	e9 4b 01 00 00       	jmp    5b4 <printf+0x19b>
      } else {
        putc(fd, c);
 469:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 46c:	0f be c0             	movsbl %al,%eax
 46f:	89 44 24 04          	mov    %eax,0x4(%esp)
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	89 04 24             	mov    %eax,(%esp)
 479:	e8 be fe ff ff       	call   33c <putc>
 47e:	e9 31 01 00 00       	jmp    5b4 <printf+0x19b>
      }
    } else if(state == '%'){
 483:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 487:	0f 85 27 01 00 00    	jne    5b4 <printf+0x19b>
      if(c == 'd'){
 48d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 491:	75 2d                	jne    4c0 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 493:	8b 45 e8             	mov    -0x18(%ebp),%eax
 496:	8b 00                	mov    (%eax),%eax
 498:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 49f:	00 
 4a0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4a7:	00 
 4a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ac:	8b 45 08             	mov    0x8(%ebp),%eax
 4af:	89 04 24             	mov    %eax,(%esp)
 4b2:	e8 ad fe ff ff       	call   364 <printint>
        ap++;
 4b7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4bb:	e9 ed 00 00 00       	jmp    5ad <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 4c0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4c4:	74 06                	je     4cc <printf+0xb3>
 4c6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ca:	75 2d                	jne    4f9 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4cf:	8b 00                	mov    (%eax),%eax
 4d1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4d8:	00 
 4d9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4e0:	00 
 4e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e5:	8b 45 08             	mov    0x8(%ebp),%eax
 4e8:	89 04 24             	mov    %eax,(%esp)
 4eb:	e8 74 fe ff ff       	call   364 <printint>
        ap++;
 4f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f4:	e9 b4 00 00 00       	jmp    5ad <printf+0x194>
      } else if(c == 's'){
 4f9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4fd:	75 46                	jne    545 <printf+0x12c>
        s = (char*)*ap;
 4ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
 502:	8b 00                	mov    (%eax),%eax
 504:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 507:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 50b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50f:	75 27                	jne    538 <printf+0x11f>
          s = "(null)";
 511:	c7 45 f4 e9 07 00 00 	movl   $0x7e9,-0xc(%ebp)
        while(*s != 0){
 518:	eb 1e                	jmp    538 <printf+0x11f>
          putc(fd, *s);
 51a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51d:	0f b6 00             	movzbl (%eax),%eax
 520:	0f be c0             	movsbl %al,%eax
 523:	89 44 24 04          	mov    %eax,0x4(%esp)
 527:	8b 45 08             	mov    0x8(%ebp),%eax
 52a:	89 04 24             	mov    %eax,(%esp)
 52d:	e8 0a fe ff ff       	call   33c <putc>
          s++;
 532:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 536:	eb 01                	jmp    539 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 538:	90                   	nop
 539:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53c:	0f b6 00             	movzbl (%eax),%eax
 53f:	84 c0                	test   %al,%al
 541:	75 d7                	jne    51a <printf+0x101>
 543:	eb 68                	jmp    5ad <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 545:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 549:	75 1d                	jne    568 <printf+0x14f>
        putc(fd, *ap);
 54b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54e:	8b 00                	mov    (%eax),%eax
 550:	0f be c0             	movsbl %al,%eax
 553:	89 44 24 04          	mov    %eax,0x4(%esp)
 557:	8b 45 08             	mov    0x8(%ebp),%eax
 55a:	89 04 24             	mov    %eax,(%esp)
 55d:	e8 da fd ff ff       	call   33c <putc>
        ap++;
 562:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 566:	eb 45                	jmp    5ad <printf+0x194>
      } else if(c == '%'){
 568:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 56c:	75 17                	jne    585 <printf+0x16c>
        putc(fd, c);
 56e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 571:	0f be c0             	movsbl %al,%eax
 574:	89 44 24 04          	mov    %eax,0x4(%esp)
 578:	8b 45 08             	mov    0x8(%ebp),%eax
 57b:	89 04 24             	mov    %eax,(%esp)
 57e:	e8 b9 fd ff ff       	call   33c <putc>
 583:	eb 28                	jmp    5ad <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 585:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 58c:	00 
 58d:	8b 45 08             	mov    0x8(%ebp),%eax
 590:	89 04 24             	mov    %eax,(%esp)
 593:	e8 a4 fd ff ff       	call   33c <putc>
        putc(fd, c);
 598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59b:	0f be c0             	movsbl %al,%eax
 59e:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a2:	8b 45 08             	mov    0x8(%ebp),%eax
 5a5:	89 04 24             	mov    %eax,(%esp)
 5a8:	e8 8f fd ff ff       	call   33c <putc>
      }
      state = 0;
 5ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5b8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5be:	01 d0                	add    %edx,%eax
 5c0:	0f b6 00             	movzbl (%eax),%eax
 5c3:	84 c0                	test   %al,%al
 5c5:	0f 85 70 fe ff ff    	jne    43b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5cb:	c9                   	leave  
 5cc:	c3                   	ret    
 5cd:	66 90                	xchg   %ax,%ax
 5cf:	90                   	nop

000005d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d6:	8b 45 08             	mov    0x8(%ebp),%eax
 5d9:	83 e8 08             	sub    $0x8,%eax
 5dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5df:	a1 48 0a 00 00       	mov    0xa48,%eax
 5e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e7:	eb 24                	jmp    60d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ec:	8b 00                	mov    (%eax),%eax
 5ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f1:	77 12                	ja     605 <free+0x35>
 5f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f9:	77 24                	ja     61f <free+0x4f>
 5fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fe:	8b 00                	mov    (%eax),%eax
 600:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 603:	77 1a                	ja     61f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 605:	8b 45 fc             	mov    -0x4(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 610:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 613:	76 d4                	jbe    5e9 <free+0x19>
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61d:	76 ca                	jbe    5e9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 61f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 622:	8b 40 04             	mov    0x4(%eax),%eax
 625:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 62c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62f:	01 c2                	add    %eax,%edx
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	39 c2                	cmp    %eax,%edx
 638:	75 24                	jne    65e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 63a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63d:	8b 50 04             	mov    0x4(%eax),%edx
 640:	8b 45 fc             	mov    -0x4(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	8b 40 04             	mov    0x4(%eax),%eax
 648:	01 c2                	add    %eax,%edx
 64a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	8b 10                	mov    (%eax),%edx
 657:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65a:	89 10                	mov    %edx,(%eax)
 65c:	eb 0a                	jmp    668 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 65e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 661:	8b 10                	mov    (%eax),%edx
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 40 04             	mov    0x4(%eax),%eax
 66e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	01 d0                	add    %edx,%eax
 67a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67d:	75 20                	jne    69f <free+0xcf>
    p->s.size += bp->s.size;
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 50 04             	mov    0x4(%eax),%edx
 685:	8b 45 f8             	mov    -0x8(%ebp),%eax
 688:	8b 40 04             	mov    0x4(%eax),%eax
 68b:	01 c2                	add    %eax,%edx
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	8b 10                	mov    (%eax),%edx
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	89 10                	mov    %edx,(%eax)
 69d:	eb 08                	jmp    6a7 <free+0xd7>
  } else
    p->s.ptr = bp;
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a5:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	a3 48 0a 00 00       	mov    %eax,0xa48
}
 6af:	c9                   	leave  
 6b0:	c3                   	ret    

000006b1 <morecore>:

static Header*
morecore(uint nu)
{
 6b1:	55                   	push   %ebp
 6b2:	89 e5                	mov    %esp,%ebp
 6b4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6b7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6be:	77 07                	ja     6c7 <morecore+0x16>
    nu = 4096;
 6c0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6c7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ca:	c1 e0 03             	shl    $0x3,%eax
 6cd:	89 04 24             	mov    %eax,(%esp)
 6d0:	e8 3f fc ff ff       	call   314 <sbrk>
 6d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6d8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6dc:	75 07                	jne    6e5 <morecore+0x34>
    return 0;
 6de:	b8 00 00 00 00       	mov    $0x0,%eax
 6e3:	eb 22                	jmp    707 <morecore+0x56>
  hp = (Header*)p;
 6e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ee:	8b 55 08             	mov    0x8(%ebp),%edx
 6f1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f7:	83 c0 08             	add    $0x8,%eax
 6fa:	89 04 24             	mov    %eax,(%esp)
 6fd:	e8 ce fe ff ff       	call   5d0 <free>
  return freep;
 702:	a1 48 0a 00 00       	mov    0xa48,%eax
}
 707:	c9                   	leave  
 708:	c3                   	ret    

00000709 <malloc>:

void*
malloc(uint nbytes)
{
 709:	55                   	push   %ebp
 70a:	89 e5                	mov    %esp,%ebp
 70c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	83 c0 07             	add    $0x7,%eax
 715:	c1 e8 03             	shr    $0x3,%eax
 718:	83 c0 01             	add    $0x1,%eax
 71b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 71e:	a1 48 0a 00 00       	mov    0xa48,%eax
 723:	89 45 f0             	mov    %eax,-0x10(%ebp)
 726:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 72a:	75 23                	jne    74f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 72c:	c7 45 f0 40 0a 00 00 	movl   $0xa40,-0x10(%ebp)
 733:	8b 45 f0             	mov    -0x10(%ebp),%eax
 736:	a3 48 0a 00 00       	mov    %eax,0xa48
 73b:	a1 48 0a 00 00       	mov    0xa48,%eax
 740:	a3 40 0a 00 00       	mov    %eax,0xa40
    base.s.size = 0;
 745:	c7 05 44 0a 00 00 00 	movl   $0x0,0xa44
 74c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 752:	8b 00                	mov    (%eax),%eax
 754:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 757:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75a:	8b 40 04             	mov    0x4(%eax),%eax
 75d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 760:	72 4d                	jb     7af <malloc+0xa6>
      if(p->s.size == nunits)
 762:	8b 45 f4             	mov    -0xc(%ebp),%eax
 765:	8b 40 04             	mov    0x4(%eax),%eax
 768:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76b:	75 0c                	jne    779 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 770:	8b 10                	mov    (%eax),%edx
 772:	8b 45 f0             	mov    -0x10(%ebp),%eax
 775:	89 10                	mov    %edx,(%eax)
 777:	eb 26                	jmp    79f <malloc+0x96>
      else {
        p->s.size -= nunits;
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	89 c2                	mov    %eax,%edx
 781:	2b 55 ec             	sub    -0x14(%ebp),%edx
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 78a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78d:	8b 40 04             	mov    0x4(%eax),%eax
 790:	c1 e0 03             	shl    $0x3,%eax
 793:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 796:	8b 45 f4             	mov    -0xc(%ebp),%eax
 799:	8b 55 ec             	mov    -0x14(%ebp),%edx
 79c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 79f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a2:	a3 48 0a 00 00       	mov    %eax,0xa48
      return (void*)(p + 1);
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	83 c0 08             	add    $0x8,%eax
 7ad:	eb 38                	jmp    7e7 <malloc+0xde>
    }
    if(p == freep)
 7af:	a1 48 0a 00 00       	mov    0xa48,%eax
 7b4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7b7:	75 1b                	jne    7d4 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7bc:	89 04 24             	mov    %eax,(%esp)
 7bf:	e8 ed fe ff ff       	call   6b1 <morecore>
 7c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7cb:	75 07                	jne    7d4 <malloc+0xcb>
        return 0;
 7cd:	b8 00 00 00 00       	mov    $0x0,%eax
 7d2:	eb 13                	jmp    7e7 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	8b 00                	mov    (%eax),%eax
 7df:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7e2:	e9 70 ff ff ff       	jmp    757 <malloc+0x4e>
}
 7e7:	c9                   	leave  
 7e8:	c3                   	ret    
