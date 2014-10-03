
_echo：     文件格式 elf32-i386


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
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 4b                	jmp    5e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 31 08 00 00       	mov    $0x831,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 33 08 00 00       	mov    $0x833,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  39:	01 ca                	add    %ecx,%edx
  3b:	8b 12                	mov    (%edx),%edx
  3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  41:	89 54 24 08          	mov    %edx,0x8(%esp)
  45:	c7 44 24 04 35 08 00 	movl   $0x835,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 08 04 00 00       	call   461 <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  59:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  5e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  62:	3b 45 08             	cmp    0x8(%ebp),%eax
  65:	7c ac                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  67:	e8 68 02 00 00       	call   2d4 <exit>

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9d:	90                   	nop
  9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  a1:	0f b6 10             	movzbl (%eax),%edx
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	88 10                	mov    %dl,(%eax)
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	84 c0                	test   %al,%al
  b1:	0f 95 c0             	setne  %al
  b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  bc:	84 c0                	test   %al,%al
  be:	75 de                	jne    9e <strcpy+0xd>
    ;
  return os;
  c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c3:	c9                   	leave  
  c4:	c3                   	ret    

000000c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c8:	eb 08                	jmp    d2 <strcmp+0xd>
    p++, q++;
  ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ce:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 00             	movzbl (%eax),%eax
  d8:	84 c0                	test   %al,%al
  da:	74 10                	je     ec <strcmp+0x27>
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	0f b6 10             	movzbl (%eax),%edx
  e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	38 c2                	cmp    %al,%dl
  ea:	74 de                	je     ca <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	0f b6 d0             	movzbl %al,%edx
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	0f b6 c0             	movzbl %al,%eax
  fe:	89 d1                	mov    %edx,%ecx
 100:	29 c1                	sub    %eax,%ecx
 102:	89 c8                	mov    %ecx,%eax
}
 104:	5d                   	pop    %ebp
 105:	c3                   	ret    

00000106 <strlen>:

uint
strlen(char *s)
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 113:	eb 04                	jmp    119 <strlen+0x13>
 115:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 119:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	01 d0                	add    %edx,%eax
 121:	0f b6 00             	movzbl (%eax),%eax
 124:	84 c0                	test   %al,%al
 126:	75 ed                	jne    115 <strlen+0xf>
    ;
  return n;
 128:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12b:	c9                   	leave  
 12c:	c3                   	ret    

0000012d <memset>:

void*
memset(void *dst, int c, uint n)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	89 44 24 08          	mov    %eax,0x8(%esp)
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	89 44 24 04          	mov    %eax,0x4(%esp)
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	89 04 24             	mov    %eax,(%esp)
 147:	e8 20 ff ff ff       	call   6c <stosb>
  return dst;
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14f:	c9                   	leave  
 150:	c3                   	ret    

00000151 <strchr>:

char*
strchr(const char *s, char c)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 04             	sub    $0x4,%esp
 157:	8b 45 0c             	mov    0xc(%ebp),%eax
 15a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15d:	eb 14                	jmp    173 <strchr+0x22>
    if(*s == c)
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	0f b6 00             	movzbl (%eax),%eax
 165:	3a 45 fc             	cmp    -0x4(%ebp),%al
 168:	75 05                	jne    16f <strchr+0x1e>
      return (char*)s;
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	eb 13                	jmp    182 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 16f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	84 c0                	test   %al,%al
 17b:	75 e2                	jne    15f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 17d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 182:	c9                   	leave  
 183:	c3                   	ret    

00000184 <gets>:

char*
gets(char *buf, int max)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 191:	eb 46                	jmp    1d9 <gets+0x55>
    cc = read(0, &c, 1);
 193:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 19a:	00 
 19b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 19e:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a9:	e8 3e 01 00 00       	call   2ec <read>
 1ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b5:	7e 2f                	jle    1e6 <gets+0x62>
      break;
    buf[i++] = c;
 1b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 c2                	add    %eax,%edx
 1bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c3:	88 02                	mov    %al,(%edx)
 1c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cd:	3c 0a                	cmp    $0xa,%al
 1cf:	74 16                	je     1e7 <gets+0x63>
 1d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d5:	3c 0d                	cmp    $0xd,%al
 1d7:	74 0e                	je     1e7 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1dc:	83 c0 01             	add    $0x1,%eax
 1df:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e2:	7c af                	jl     193 <gets+0xf>
 1e4:	eb 01                	jmp    1e7 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1e6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	01 d0                	add    %edx,%eax
 1ef:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f5:	c9                   	leave  
 1f6:	c3                   	ret    

000001f7 <stat>:

int
stat(char *n, struct stat *st)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 204:	00 
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	89 04 24             	mov    %eax,(%esp)
 20b:	e8 04 01 00 00       	call   314 <open>
 210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 217:	79 07                	jns    220 <stat+0x29>
    return -1;
 219:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21e:	eb 23                	jmp    243 <stat+0x4c>
  r = fstat(fd, st);
 220:	8b 45 0c             	mov    0xc(%ebp),%eax
 223:	89 44 24 04          	mov    %eax,0x4(%esp)
 227:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22a:	89 04 24             	mov    %eax,(%esp)
 22d:	e8 fa 00 00 00       	call   32c <fstat>
 232:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	89 04 24             	mov    %eax,(%esp)
 23b:	e8 bc 00 00 00       	call   2fc <close>
  return r;
 240:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 243:	c9                   	leave  
 244:	c3                   	ret    

00000245 <atoi>:

int
atoi(const char *s)
{
 245:	55                   	push   %ebp
 246:	89 e5                	mov    %esp,%ebp
 248:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 24b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 252:	eb 23                	jmp    277 <atoi+0x32>
    n = n*10 + *s++ - '0';
 254:	8b 55 fc             	mov    -0x4(%ebp),%edx
 257:	89 d0                	mov    %edx,%eax
 259:	c1 e0 02             	shl    $0x2,%eax
 25c:	01 d0                	add    %edx,%eax
 25e:	01 c0                	add    %eax,%eax
 260:	89 c2                	mov    %eax,%edx
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	0f b6 00             	movzbl (%eax),%eax
 268:	0f be c0             	movsbl %al,%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	83 e8 30             	sub    $0x30,%eax
 270:	89 45 fc             	mov    %eax,-0x4(%ebp)
 273:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 2f                	cmp    $0x2f,%al
 27f:	7e 0a                	jle    28b <atoi+0x46>
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	3c 39                	cmp    $0x39,%al
 289:	7e c9                	jle    254 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 28b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28e:	c9                   	leave  
 28f:	c3                   	ret    

00000290 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 29c:	8b 45 0c             	mov    0xc(%ebp),%eax
 29f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2a2:	eb 13                	jmp    2b7 <memmove+0x27>
    *dst++ = *src++;
 2a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2a7:	0f b6 10             	movzbl (%eax),%edx
 2aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ad:	88 10                	mov    %dl,(%eax)
 2af:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2b3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2bb:	0f 9f c0             	setg   %al
 2be:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2c2:	84 c0                	test   %al,%al
 2c4:	75 de                	jne    2a4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c9:	c9                   	leave  
 2ca:	c3                   	ret    
 2cb:	90                   	nop

000002cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cc:	b8 01 00 00 00       	mov    $0x1,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <exit>:
SYSCALL(exit)
 2d4:	b8 02 00 00 00       	mov    $0x2,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <wait>:
SYSCALL(wait)
 2dc:	b8 03 00 00 00       	mov    $0x3,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <pipe>:
SYSCALL(pipe)
 2e4:	b8 04 00 00 00       	mov    $0x4,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <read>:
SYSCALL(read)
 2ec:	b8 05 00 00 00       	mov    $0x5,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <write>:
SYSCALL(write)
 2f4:	b8 10 00 00 00       	mov    $0x10,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <close>:
SYSCALL(close)
 2fc:	b8 15 00 00 00       	mov    $0x15,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <kill>:
SYSCALL(kill)
 304:	b8 06 00 00 00       	mov    $0x6,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <exec>:
SYSCALL(exec)
 30c:	b8 07 00 00 00       	mov    $0x7,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <open>:
SYSCALL(open)
 314:	b8 0f 00 00 00       	mov    $0xf,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <mknod>:
SYSCALL(mknod)
 31c:	b8 11 00 00 00       	mov    $0x11,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <unlink>:
SYSCALL(unlink)
 324:	b8 12 00 00 00       	mov    $0x12,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <fstat>:
SYSCALL(fstat)
 32c:	b8 08 00 00 00       	mov    $0x8,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <link>:
SYSCALL(link)
 334:	b8 13 00 00 00       	mov    $0x13,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <mkdir>:
SYSCALL(mkdir)
 33c:	b8 14 00 00 00       	mov    $0x14,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <chdir>:
SYSCALL(chdir)
 344:	b8 09 00 00 00       	mov    $0x9,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <dup>:
SYSCALL(dup)
 34c:	b8 0a 00 00 00       	mov    $0xa,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <getpid>:
SYSCALL(getpid)
 354:	b8 0b 00 00 00       	mov    $0xb,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <sbrk>:
SYSCALL(sbrk)
 35c:	b8 0c 00 00 00       	mov    $0xc,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <sleep>:
SYSCALL(sleep)
 364:	b8 0d 00 00 00       	mov    $0xd,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <uptime>:
SYSCALL(uptime)
 36c:	b8 0e 00 00 00       	mov    $0xe,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <halt>:
SYSCALL(halt)
 374:	b8 16 00 00 00       	mov    $0x16,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <alarm>:
 37c:	b8 17 00 00 00       	mov    $0x17,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	83 ec 28             	sub    $0x28,%esp
 38a:	8b 45 0c             	mov    0xc(%ebp),%eax
 38d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 390:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 397:	00 
 398:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39b:	89 44 24 04          	mov    %eax,0x4(%esp)
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	89 04 24             	mov    %eax,(%esp)
 3a5:	e8 4a ff ff ff       	call   2f4 <write>
}
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3bd:	74 17                	je     3d6 <printint+0x2a>
 3bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c3:	79 11                	jns    3d6 <printint+0x2a>
    neg = 1;
 3c5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cf:	f7 d8                	neg    %eax
 3d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d4:	eb 06                	jmp    3dc <printint+0x30>
  } else {
    x = xx;
 3d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e9:	ba 00 00 00 00       	mov    $0x0,%edx
 3ee:	f7 f1                	div    %ecx
 3f0:	89 d0                	mov    %edx,%eax
 3f2:	0f b6 80 80 0a 00 00 	movzbl 0xa80(%eax),%eax
 3f9:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3ff:	01 ca                	add    %ecx,%edx
 401:	88 02                	mov    %al,(%edx)
 403:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 407:	8b 55 10             	mov    0x10(%ebp),%edx
 40a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 40d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 410:	ba 00 00 00 00       	mov    $0x0,%edx
 415:	f7 75 d4             	divl   -0x2c(%ebp)
 418:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 41f:	75 c2                	jne    3e3 <printint+0x37>
  if(neg)
 421:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 425:	74 2e                	je     455 <printint+0xa9>
    buf[i++] = '-';
 427:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42d:	01 d0                	add    %edx,%eax
 42f:	c6 00 2d             	movb   $0x2d,(%eax)
 432:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 436:	eb 1d                	jmp    455 <printint+0xa9>
    putc(fd, buf[i]);
 438:	8d 55 dc             	lea    -0x24(%ebp),%edx
 43b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43e:	01 d0                	add    %edx,%eax
 440:	0f b6 00             	movzbl (%eax),%eax
 443:	0f be c0             	movsbl %al,%eax
 446:	89 44 24 04          	mov    %eax,0x4(%esp)
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	89 04 24             	mov    %eax,(%esp)
 450:	e8 2f ff ff ff       	call   384 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 455:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 45d:	79 d9                	jns    438 <printint+0x8c>
    putc(fd, buf[i]);
}
 45f:	c9                   	leave  
 460:	c3                   	ret    

00000461 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 461:	55                   	push   %ebp
 462:	89 e5                	mov    %esp,%ebp
 464:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 467:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46e:	8d 45 0c             	lea    0xc(%ebp),%eax
 471:	83 c0 04             	add    $0x4,%eax
 474:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 477:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47e:	e9 7d 01 00 00       	jmp    600 <printf+0x19f>
    c = fmt[i] & 0xff;
 483:	8b 55 0c             	mov    0xc(%ebp),%edx
 486:	8b 45 f0             	mov    -0x10(%ebp),%eax
 489:	01 d0                	add    %edx,%eax
 48b:	0f b6 00             	movzbl (%eax),%eax
 48e:	0f be c0             	movsbl %al,%eax
 491:	25 ff 00 00 00       	and    $0xff,%eax
 496:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 499:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49d:	75 2c                	jne    4cb <printf+0x6a>
      if(c == '%'){
 49f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a3:	75 0c                	jne    4b1 <printf+0x50>
        state = '%';
 4a5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ac:	e9 4b 01 00 00       	jmp    5fc <printf+0x19b>
      } else {
        putc(fd, c);
 4b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b4:	0f be c0             	movsbl %al,%eax
 4b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	89 04 24             	mov    %eax,(%esp)
 4c1:	e8 be fe ff ff       	call   384 <putc>
 4c6:	e9 31 01 00 00       	jmp    5fc <printf+0x19b>
      }
    } else if(state == '%'){
 4cb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4cf:	0f 85 27 01 00 00    	jne    5fc <printf+0x19b>
      if(c == 'd'){
 4d5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d9:	75 2d                	jne    508 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4db:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4de:	8b 00                	mov    (%eax),%eax
 4e0:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4e7:	00 
 4e8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4ef:	00 
 4f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	89 04 24             	mov    %eax,(%esp)
 4fa:	e8 ad fe ff ff       	call   3ac <printint>
        ap++;
 4ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 503:	e9 ed 00 00 00       	jmp    5f5 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 508:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 50c:	74 06                	je     514 <printf+0xb3>
 50e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 512:	75 2d                	jne    541 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 514:	8b 45 e8             	mov    -0x18(%ebp),%eax
 517:	8b 00                	mov    (%eax),%eax
 519:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 520:	00 
 521:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 528:	00 
 529:	89 44 24 04          	mov    %eax,0x4(%esp)
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	89 04 24             	mov    %eax,(%esp)
 533:	e8 74 fe ff ff       	call   3ac <printint>
        ap++;
 538:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53c:	e9 b4 00 00 00       	jmp    5f5 <printf+0x194>
      } else if(c == 's'){
 541:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 545:	75 46                	jne    58d <printf+0x12c>
        s = (char*)*ap;
 547:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54a:	8b 00                	mov    (%eax),%eax
 54c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 54f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 553:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 557:	75 27                	jne    580 <printf+0x11f>
          s = "(null)";
 559:	c7 45 f4 3a 08 00 00 	movl   $0x83a,-0xc(%ebp)
        while(*s != 0){
 560:	eb 1e                	jmp    580 <printf+0x11f>
          putc(fd, *s);
 562:	8b 45 f4             	mov    -0xc(%ebp),%eax
 565:	0f b6 00             	movzbl (%eax),%eax
 568:	0f be c0             	movsbl %al,%eax
 56b:	89 44 24 04          	mov    %eax,0x4(%esp)
 56f:	8b 45 08             	mov    0x8(%ebp),%eax
 572:	89 04 24             	mov    %eax,(%esp)
 575:	e8 0a fe ff ff       	call   384 <putc>
          s++;
 57a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 57e:	eb 01                	jmp    581 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 580:	90                   	nop
 581:	8b 45 f4             	mov    -0xc(%ebp),%eax
 584:	0f b6 00             	movzbl (%eax),%eax
 587:	84 c0                	test   %al,%al
 589:	75 d7                	jne    562 <printf+0x101>
 58b:	eb 68                	jmp    5f5 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 591:	75 1d                	jne    5b0 <printf+0x14f>
        putc(fd, *ap);
 593:	8b 45 e8             	mov    -0x18(%ebp),%eax
 596:	8b 00                	mov    (%eax),%eax
 598:	0f be c0             	movsbl %al,%eax
 59b:	89 44 24 04          	mov    %eax,0x4(%esp)
 59f:	8b 45 08             	mov    0x8(%ebp),%eax
 5a2:	89 04 24             	mov    %eax,(%esp)
 5a5:	e8 da fd ff ff       	call   384 <putc>
        ap++;
 5aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ae:	eb 45                	jmp    5f5 <printf+0x194>
      } else if(c == '%'){
 5b0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b4:	75 17                	jne    5cd <printf+0x16c>
        putc(fd, c);
 5b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b9:	0f be c0             	movsbl %al,%eax
 5bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	89 04 24             	mov    %eax,(%esp)
 5c6:	e8 b9 fd ff ff       	call   384 <putc>
 5cb:	eb 28                	jmp    5f5 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5cd:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5d4:	00 
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
 5d8:	89 04 24             	mov    %eax,(%esp)
 5db:	e8 a4 fd ff ff       	call   384 <putc>
        putc(fd, c);
 5e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e3:	0f be c0             	movsbl %al,%eax
 5e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ea:	8b 45 08             	mov    0x8(%ebp),%eax
 5ed:	89 04 24             	mov    %eax,(%esp)
 5f0:	e8 8f fd ff ff       	call   384 <putc>
      }
      state = 0;
 5f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5fc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 600:	8b 55 0c             	mov    0xc(%ebp),%edx
 603:	8b 45 f0             	mov    -0x10(%ebp),%eax
 606:	01 d0                	add    %edx,%eax
 608:	0f b6 00             	movzbl (%eax),%eax
 60b:	84 c0                	test   %al,%al
 60d:	0f 85 70 fe ff ff    	jne    483 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 613:	c9                   	leave  
 614:	c3                   	ret    
 615:	66 90                	xchg   %ax,%ax
 617:	90                   	nop

00000618 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 618:	55                   	push   %ebp
 619:	89 e5                	mov    %esp,%ebp
 61b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61e:	8b 45 08             	mov    0x8(%ebp),%eax
 621:	83 e8 08             	sub    $0x8,%eax
 624:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 627:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 62c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62f:	eb 24                	jmp    655 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 639:	77 12                	ja     64d <free+0x35>
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 641:	77 24                	ja     667 <free+0x4f>
 643:	8b 45 fc             	mov    -0x4(%ebp),%eax
 646:	8b 00                	mov    (%eax),%eax
 648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64b:	77 1a                	ja     667 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	89 45 fc             	mov    %eax,-0x4(%ebp)
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65b:	76 d4                	jbe    631 <free+0x19>
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 665:	76 ca                	jbe    631 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	8b 40 04             	mov    0x4(%eax),%eax
 66d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	01 c2                	add    %eax,%edx
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	8b 00                	mov    (%eax),%eax
 67e:	39 c2                	cmp    %eax,%edx
 680:	75 24                	jne    6a6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	8b 50 04             	mov    0x4(%eax),%edx
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	8b 40 04             	mov    0x4(%eax),%eax
 690:	01 c2                	add    %eax,%edx
 692:	8b 45 f8             	mov    -0x8(%ebp),%eax
 695:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 00                	mov    (%eax),%eax
 69d:	8b 10                	mov    (%eax),%edx
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	89 10                	mov    %edx,(%eax)
 6a4:	eb 0a                	jmp    6b0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 10                	mov    (%eax),%edx
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 40 04             	mov    0x4(%eax),%eax
 6b6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	01 d0                	add    %edx,%eax
 6c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c5:	75 20                	jne    6e7 <free+0xcf>
    p->s.size += bp->s.size;
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 50 04             	mov    0x4(%eax),%edx
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	8b 40 04             	mov    0x4(%eax),%eax
 6d3:	01 c2                	add    %eax,%edx
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	8b 10                	mov    (%eax),%edx
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	89 10                	mov    %edx,(%eax)
 6e5:	eb 08                	jmp    6ef <free+0xd7>
  } else
    p->s.ptr = bp;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ed:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	a3 9c 0a 00 00       	mov    %eax,0xa9c
}
 6f7:	c9                   	leave  
 6f8:	c3                   	ret    

000006f9 <morecore>:

static Header*
morecore(uint nu)
{
 6f9:	55                   	push   %ebp
 6fa:	89 e5                	mov    %esp,%ebp
 6fc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ff:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 706:	77 07                	ja     70f <morecore+0x16>
    nu = 4096;
 708:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	c1 e0 03             	shl    $0x3,%eax
 715:	89 04 24             	mov    %eax,(%esp)
 718:	e8 3f fc ff ff       	call   35c <sbrk>
 71d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 720:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 724:	75 07                	jne    72d <morecore+0x34>
    return 0;
 726:	b8 00 00 00 00       	mov    $0x0,%eax
 72b:	eb 22                	jmp    74f <morecore+0x56>
  hp = (Header*)p;
 72d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 730:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 733:	8b 45 f0             	mov    -0x10(%ebp),%eax
 736:	8b 55 08             	mov    0x8(%ebp),%edx
 739:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 73c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73f:	83 c0 08             	add    $0x8,%eax
 742:	89 04 24             	mov    %eax,(%esp)
 745:	e8 ce fe ff ff       	call   618 <free>
  return freep;
 74a:	a1 9c 0a 00 00       	mov    0xa9c,%eax
}
 74f:	c9                   	leave  
 750:	c3                   	ret    

00000751 <malloc>:

void*
malloc(uint nbytes)
{
 751:	55                   	push   %ebp
 752:	89 e5                	mov    %esp,%ebp
 754:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 757:	8b 45 08             	mov    0x8(%ebp),%eax
 75a:	83 c0 07             	add    $0x7,%eax
 75d:	c1 e8 03             	shr    $0x3,%eax
 760:	83 c0 01             	add    $0x1,%eax
 763:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 766:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 76b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 76e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 772:	75 23                	jne    797 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 774:	c7 45 f0 94 0a 00 00 	movl   $0xa94,-0x10(%ebp)
 77b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77e:	a3 9c 0a 00 00       	mov    %eax,0xa9c
 783:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 788:	a3 94 0a 00 00       	mov    %eax,0xa94
    base.s.size = 0;
 78d:	c7 05 98 0a 00 00 00 	movl   $0x0,0xa98
 794:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 797:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a8:	72 4d                	jb     7f7 <malloc+0xa6>
      if(p->s.size == nunits)
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	8b 40 04             	mov    0x4(%eax),%eax
 7b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b3:	75 0c                	jne    7c1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	8b 10                	mov    (%eax),%edx
 7ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bd:	89 10                	mov    %edx,(%eax)
 7bf:	eb 26                	jmp    7e7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	8b 40 04             	mov    0x4(%eax),%eax
 7c7:	89 c2                	mov    %eax,%edx
 7c9:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d5:	8b 40 04             	mov    0x4(%eax),%eax
 7d8:	c1 e0 03             	shl    $0x3,%eax
 7db:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ea:	a3 9c 0a 00 00       	mov    %eax,0xa9c
      return (void*)(p + 1);
 7ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f2:	83 c0 08             	add    $0x8,%eax
 7f5:	eb 38                	jmp    82f <malloc+0xde>
    }
    if(p == freep)
 7f7:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 7fc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ff:	75 1b                	jne    81c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 801:	8b 45 ec             	mov    -0x14(%ebp),%eax
 804:	89 04 24             	mov    %eax,(%esp)
 807:	e8 ed fe ff ff       	call   6f9 <morecore>
 80c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 813:	75 07                	jne    81c <malloc+0xcb>
        return 0;
 815:	b8 00 00 00 00       	mov    $0x0,%eax
 81a:	eb 13                	jmp    82f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	8b 00                	mov    (%eax),%eax
 827:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 82a:	e9 70 ff ff ff       	jmp    79f <malloc+0x4e>
}
 82f:	c9                   	leave  
 830:	c3                   	ret    
