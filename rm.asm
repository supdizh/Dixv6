
_rm：     文件格式 elf32-i386


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

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: rm files...\n");
   f:	c7 44 24 04 55 08 00 	movl   $0x855,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 62 04 00 00       	call   485 <printf>
    exit();
  23:	e8 d0 02 00 00       	call   2f8 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4f                	jmp    81 <main+0x81>
    if(unlink(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 fc 02 00 00       	call   348 <unlink>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 69 08 00 	movl   $0x869,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 0b 04 00 00       	call   485 <printf>
      break;
  7a:	eb 0e                	jmp    8a <main+0x8a>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  7c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  81:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  85:	3b 45 08             	cmp    0x8(%ebp),%eax
  88:	7c a8                	jl     32 <main+0x32>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  8a:	e8 69 02 00 00       	call   2f8 <exit>
  8f:	90                   	nop

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	5b                   	pop    %ebx
  b2:	5f                   	pop    %edi
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c1:	90                   	nop
  c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  c5:	0f b6 10             	movzbl (%eax),%edx
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	88 10                	mov    %dl,(%eax)
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	0f b6 00             	movzbl (%eax),%eax
  d3:	84 c0                	test   %al,%al
  d5:	0f 95 c0             	setne  %al
  d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  dc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  e0:	84 c0                	test   %al,%al
  e2:	75 de                	jne    c2 <strcpy+0xd>
    ;
  return os;
  e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e7:	c9                   	leave  
  e8:	c3                   	ret    

000000e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e9:	55                   	push   %ebp
  ea:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ec:	eb 08                	jmp    f6 <strcmp+0xd>
    p++, q++;
  ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  f2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	0f b6 00             	movzbl (%eax),%eax
  fc:	84 c0                	test   %al,%al
  fe:	74 10                	je     110 <strcmp+0x27>
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	0f b6 10             	movzbl (%eax),%edx
 106:	8b 45 0c             	mov    0xc(%ebp),%eax
 109:	0f b6 00             	movzbl (%eax),%eax
 10c:	38 c2                	cmp    %al,%dl
 10e:	74 de                	je     ee <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	0f b6 d0             	movzbl %al,%edx
 119:	8b 45 0c             	mov    0xc(%ebp),%eax
 11c:	0f b6 00             	movzbl (%eax),%eax
 11f:	0f b6 c0             	movzbl %al,%eax
 122:	89 d1                	mov    %edx,%ecx
 124:	29 c1                	sub    %eax,%ecx
 126:	89 c8                	mov    %ecx,%eax
}
 128:	5d                   	pop    %ebp
 129:	c3                   	ret    

0000012a <strlen>:

uint
strlen(char *s)
{
 12a:	55                   	push   %ebp
 12b:	89 e5                	mov    %esp,%ebp
 12d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 130:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 137:	eb 04                	jmp    13d <strlen+0x13>
 139:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 13d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	01 d0                	add    %edx,%eax
 145:	0f b6 00             	movzbl (%eax),%eax
 148:	84 c0                	test   %al,%al
 14a:	75 ed                	jne    139 <strlen+0xf>
    ;
  return n;
 14c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14f:	c9                   	leave  
 150:	c3                   	ret    

00000151 <memset>:

void*
memset(void *dst, int c, uint n)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 157:	8b 45 10             	mov    0x10(%ebp),%eax
 15a:	89 44 24 08          	mov    %eax,0x8(%esp)
 15e:	8b 45 0c             	mov    0xc(%ebp),%eax
 161:	89 44 24 04          	mov    %eax,0x4(%esp)
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	89 04 24             	mov    %eax,(%esp)
 16b:	e8 20 ff ff ff       	call   90 <stosb>
  return dst;
 170:	8b 45 08             	mov    0x8(%ebp),%eax
}
 173:	c9                   	leave  
 174:	c3                   	ret    

00000175 <strchr>:

char*
strchr(const char *s, char c)
{
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
 178:	83 ec 04             	sub    $0x4,%esp
 17b:	8b 45 0c             	mov    0xc(%ebp),%eax
 17e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 181:	eb 14                	jmp    197 <strchr+0x22>
    if(*s == c)
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	0f b6 00             	movzbl (%eax),%eax
 189:	3a 45 fc             	cmp    -0x4(%ebp),%al
 18c:	75 05                	jne    193 <strchr+0x1e>
      return (char*)s;
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	eb 13                	jmp    1a6 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 193:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	0f b6 00             	movzbl (%eax),%eax
 19d:	84 c0                	test   %al,%al
 19f:	75 e2                	jne    183 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <gets>:

char*
gets(char *buf, int max)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
 1ab:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1b5:	eb 46                	jmp    1fd <gets+0x55>
    cc = read(0, &c, 1);
 1b7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1be:	00 
 1bf:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1cd:	e8 3e 01 00 00       	call   310 <read>
 1d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1d9:	7e 2f                	jle    20a <gets+0x62>
      break;
    buf[i++] = c;
 1db:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	01 c2                	add    %eax,%edx
 1e3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e7:	88 02                	mov    %al,(%edx)
 1e9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1ed:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f1:	3c 0a                	cmp    $0xa,%al
 1f3:	74 16                	je     20b <gets+0x63>
 1f5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f9:	3c 0d                	cmp    $0xd,%al
 1fb:	74 0e                	je     20b <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 200:	83 c0 01             	add    $0x1,%eax
 203:	3b 45 0c             	cmp    0xc(%ebp),%eax
 206:	7c af                	jl     1b7 <gets+0xf>
 208:	eb 01                	jmp    20b <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 20a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 20b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	01 d0                	add    %edx,%eax
 213:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 216:	8b 45 08             	mov    0x8(%ebp),%eax
}
 219:	c9                   	leave  
 21a:	c3                   	ret    

0000021b <stat>:

int
stat(char *n, struct stat *st)
{
 21b:	55                   	push   %ebp
 21c:	89 e5                	mov    %esp,%ebp
 21e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 221:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 228:	00 
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	89 04 24             	mov    %eax,(%esp)
 22f:	e8 04 01 00 00       	call   338 <open>
 234:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 237:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 23b:	79 07                	jns    244 <stat+0x29>
    return -1;
 23d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 242:	eb 23                	jmp    267 <stat+0x4c>
  r = fstat(fd, st);
 244:	8b 45 0c             	mov    0xc(%ebp),%eax
 247:	89 44 24 04          	mov    %eax,0x4(%esp)
 24b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24e:	89 04 24             	mov    %eax,(%esp)
 251:	e8 fa 00 00 00       	call   350 <fstat>
 256:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 259:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25c:	89 04 24             	mov    %eax,(%esp)
 25f:	e8 bc 00 00 00       	call   320 <close>
  return r;
 264:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 267:	c9                   	leave  
 268:	c3                   	ret    

00000269 <atoi>:

int
atoi(const char *s)
{
 269:	55                   	push   %ebp
 26a:	89 e5                	mov    %esp,%ebp
 26c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 26f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 276:	eb 23                	jmp    29b <atoi+0x32>
    n = n*10 + *s++ - '0';
 278:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27b:	89 d0                	mov    %edx,%eax
 27d:	c1 e0 02             	shl    $0x2,%eax
 280:	01 d0                	add    %edx,%eax
 282:	01 c0                	add    %eax,%eax
 284:	89 c2                	mov    %eax,%edx
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	0f b6 00             	movzbl (%eax),%eax
 28c:	0f be c0             	movsbl %al,%eax
 28f:	01 d0                	add    %edx,%eax
 291:	83 e8 30             	sub    $0x30,%eax
 294:	89 45 fc             	mov    %eax,-0x4(%ebp)
 297:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	0f b6 00             	movzbl (%eax),%eax
 2a1:	3c 2f                	cmp    $0x2f,%al
 2a3:	7e 0a                	jle    2af <atoi+0x46>
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
 2a8:	0f b6 00             	movzbl (%eax),%eax
 2ab:	3c 39                	cmp    $0x39,%al
 2ad:	7e c9                	jle    278 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c6:	eb 13                	jmp    2db <memmove+0x27>
    *dst++ = *src++;
 2c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2cb:	0f b6 10             	movzbl (%eax),%edx
 2ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d1:	88 10                	mov    %dl,(%eax)
 2d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2d7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2df:	0f 9f c0             	setg   %al
 2e2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2e6:	84 c0                	test   %al,%al
 2e8:	75 de                	jne    2c8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ed:	c9                   	leave  
 2ee:	c3                   	ret    
 2ef:	90                   	nop

000002f0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f0:	b8 01 00 00 00       	mov    $0x1,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <exit>:
SYSCALL(exit)
 2f8:	b8 02 00 00 00       	mov    $0x2,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <wait>:
SYSCALL(wait)
 300:	b8 03 00 00 00       	mov    $0x3,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <pipe>:
SYSCALL(pipe)
 308:	b8 04 00 00 00       	mov    $0x4,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <read>:
SYSCALL(read)
 310:	b8 05 00 00 00       	mov    $0x5,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <write>:
SYSCALL(write)
 318:	b8 10 00 00 00       	mov    $0x10,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <close>:
SYSCALL(close)
 320:	b8 15 00 00 00       	mov    $0x15,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <kill>:
SYSCALL(kill)
 328:	b8 06 00 00 00       	mov    $0x6,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <exec>:
SYSCALL(exec)
 330:	b8 07 00 00 00       	mov    $0x7,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <open>:
SYSCALL(open)
 338:	b8 0f 00 00 00       	mov    $0xf,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <mknod>:
SYSCALL(mknod)
 340:	b8 11 00 00 00       	mov    $0x11,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <unlink>:
SYSCALL(unlink)
 348:	b8 12 00 00 00       	mov    $0x12,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <fstat>:
SYSCALL(fstat)
 350:	b8 08 00 00 00       	mov    $0x8,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <link>:
SYSCALL(link)
 358:	b8 13 00 00 00       	mov    $0x13,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <mkdir>:
SYSCALL(mkdir)
 360:	b8 14 00 00 00       	mov    $0x14,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <chdir>:
SYSCALL(chdir)
 368:	b8 09 00 00 00       	mov    $0x9,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <dup>:
SYSCALL(dup)
 370:	b8 0a 00 00 00       	mov    $0xa,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <getpid>:
SYSCALL(getpid)
 378:	b8 0b 00 00 00       	mov    $0xb,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <sbrk>:
SYSCALL(sbrk)
 380:	b8 0c 00 00 00       	mov    $0xc,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <sleep>:
SYSCALL(sleep)
 388:	b8 0d 00 00 00       	mov    $0xd,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <uptime>:
SYSCALL(uptime)
 390:	b8 0e 00 00 00       	mov    $0xe,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <halt>:
SYSCALL(halt)
 398:	b8 16 00 00 00       	mov    $0x16,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <alarm>:
 3a0:	b8 17 00 00 00       	mov    $0x17,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	83 ec 28             	sub    $0x28,%esp
 3ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3bb:	00 
 3bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	89 04 24             	mov    %eax,(%esp)
 3c9:	e8 4a ff ff ff       	call   318 <write>
}
 3ce:	c9                   	leave  
 3cf:	c3                   	ret    

000003d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3dd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e1:	74 17                	je     3fa <printint+0x2a>
 3e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e7:	79 11                	jns    3fa <printint+0x2a>
    neg = 1;
 3e9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f3:	f7 d8                	neg    %eax
 3f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f8:	eb 06                	jmp    400 <printint+0x30>
  } else {
    x = xx;
 3fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 400:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 407:	8b 4d 10             	mov    0x10(%ebp),%ecx
 40a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40d:	ba 00 00 00 00       	mov    $0x0,%edx
 412:	f7 f1                	div    %ecx
 414:	89 d0                	mov    %edx,%eax
 416:	0f b6 80 c8 0a 00 00 	movzbl 0xac8(%eax),%eax
 41d:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 420:	8b 55 f4             	mov    -0xc(%ebp),%edx
 423:	01 ca                	add    %ecx,%edx
 425:	88 02                	mov    %al,(%edx)
 427:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 42b:	8b 55 10             	mov    0x10(%ebp),%edx
 42e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 431:	8b 45 ec             	mov    -0x14(%ebp),%eax
 434:	ba 00 00 00 00       	mov    $0x0,%edx
 439:	f7 75 d4             	divl   -0x2c(%ebp)
 43c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 43f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 443:	75 c2                	jne    407 <printint+0x37>
  if(neg)
 445:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 449:	74 2e                	je     479 <printint+0xa9>
    buf[i++] = '-';
 44b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 44e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 451:	01 d0                	add    %edx,%eax
 453:	c6 00 2d             	movb   $0x2d,(%eax)
 456:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 45a:	eb 1d                	jmp    479 <printint+0xa9>
    putc(fd, buf[i]);
 45c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 462:	01 d0                	add    %edx,%eax
 464:	0f b6 00             	movzbl (%eax),%eax
 467:	0f be c0             	movsbl %al,%eax
 46a:	89 44 24 04          	mov    %eax,0x4(%esp)
 46e:	8b 45 08             	mov    0x8(%ebp),%eax
 471:	89 04 24             	mov    %eax,(%esp)
 474:	e8 2f ff ff ff       	call   3a8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 479:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 47d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 481:	79 d9                	jns    45c <printint+0x8c>
    putc(fd, buf[i]);
}
 483:	c9                   	leave  
 484:	c3                   	ret    

00000485 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 485:	55                   	push   %ebp
 486:	89 e5                	mov    %esp,%ebp
 488:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 48b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 492:	8d 45 0c             	lea    0xc(%ebp),%eax
 495:	83 c0 04             	add    $0x4,%eax
 498:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 49b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a2:	e9 7d 01 00 00       	jmp    624 <printf+0x19f>
    c = fmt[i] & 0xff;
 4a7:	8b 55 0c             	mov    0xc(%ebp),%edx
 4aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ad:	01 d0                	add    %edx,%eax
 4af:	0f b6 00             	movzbl (%eax),%eax
 4b2:	0f be c0             	movsbl %al,%eax
 4b5:	25 ff 00 00 00       	and    $0xff,%eax
 4ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c1:	75 2c                	jne    4ef <printf+0x6a>
      if(c == '%'){
 4c3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c7:	75 0c                	jne    4d5 <printf+0x50>
        state = '%';
 4c9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d0:	e9 4b 01 00 00       	jmp    620 <printf+0x19b>
      } else {
        putc(fd, c);
 4d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d8:	0f be c0             	movsbl %al,%eax
 4db:	89 44 24 04          	mov    %eax,0x4(%esp)
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	89 04 24             	mov    %eax,(%esp)
 4e5:	e8 be fe ff ff       	call   3a8 <putc>
 4ea:	e9 31 01 00 00       	jmp    620 <printf+0x19b>
      }
    } else if(state == '%'){
 4ef:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f3:	0f 85 27 01 00 00    	jne    620 <printf+0x19b>
      if(c == 'd'){
 4f9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4fd:	75 2d                	jne    52c <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
 502:	8b 00                	mov    (%eax),%eax
 504:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 50b:	00 
 50c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 513:	00 
 514:	89 44 24 04          	mov    %eax,0x4(%esp)
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	89 04 24             	mov    %eax,(%esp)
 51e:	e8 ad fe ff ff       	call   3d0 <printint>
        ap++;
 523:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 527:	e9 ed 00 00 00       	jmp    619 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 52c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 530:	74 06                	je     538 <printf+0xb3>
 532:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 536:	75 2d                	jne    565 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 538:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53b:	8b 00                	mov    (%eax),%eax
 53d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 544:	00 
 545:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 54c:	00 
 54d:	89 44 24 04          	mov    %eax,0x4(%esp)
 551:	8b 45 08             	mov    0x8(%ebp),%eax
 554:	89 04 24             	mov    %eax,(%esp)
 557:	e8 74 fe ff ff       	call   3d0 <printint>
        ap++;
 55c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 560:	e9 b4 00 00 00       	jmp    619 <printf+0x194>
      } else if(c == 's'){
 565:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 569:	75 46                	jne    5b1 <printf+0x12c>
        s = (char*)*ap;
 56b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56e:	8b 00                	mov    (%eax),%eax
 570:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 573:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57b:	75 27                	jne    5a4 <printf+0x11f>
          s = "(null)";
 57d:	c7 45 f4 82 08 00 00 	movl   $0x882,-0xc(%ebp)
        while(*s != 0){
 584:	eb 1e                	jmp    5a4 <printf+0x11f>
          putc(fd, *s);
 586:	8b 45 f4             	mov    -0xc(%ebp),%eax
 589:	0f b6 00             	movzbl (%eax),%eax
 58c:	0f be c0             	movsbl %al,%eax
 58f:	89 44 24 04          	mov    %eax,0x4(%esp)
 593:	8b 45 08             	mov    0x8(%ebp),%eax
 596:	89 04 24             	mov    %eax,(%esp)
 599:	e8 0a fe ff ff       	call   3a8 <putc>
          s++;
 59e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 5a2:	eb 01                	jmp    5a5 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a4:	90                   	nop
 5a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a8:	0f b6 00             	movzbl (%eax),%eax
 5ab:	84 c0                	test   %al,%al
 5ad:	75 d7                	jne    586 <printf+0x101>
 5af:	eb 68                	jmp    619 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b5:	75 1d                	jne    5d4 <printf+0x14f>
        putc(fd, *ap);
 5b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ba:	8b 00                	mov    (%eax),%eax
 5bc:	0f be c0             	movsbl %al,%eax
 5bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	89 04 24             	mov    %eax,(%esp)
 5c9:	e8 da fd ff ff       	call   3a8 <putc>
        ap++;
 5ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d2:	eb 45                	jmp    619 <printf+0x194>
      } else if(c == '%'){
 5d4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d8:	75 17                	jne    5f1 <printf+0x16c>
        putc(fd, c);
 5da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5dd:	0f be c0             	movsbl %al,%eax
 5e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e4:	8b 45 08             	mov    0x8(%ebp),%eax
 5e7:	89 04 24             	mov    %eax,(%esp)
 5ea:	e8 b9 fd ff ff       	call   3a8 <putc>
 5ef:	eb 28                	jmp    619 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5f8:	00 
 5f9:	8b 45 08             	mov    0x8(%ebp),%eax
 5fc:	89 04 24             	mov    %eax,(%esp)
 5ff:	e8 a4 fd ff ff       	call   3a8 <putc>
        putc(fd, c);
 604:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 607:	0f be c0             	movsbl %al,%eax
 60a:	89 44 24 04          	mov    %eax,0x4(%esp)
 60e:	8b 45 08             	mov    0x8(%ebp),%eax
 611:	89 04 24             	mov    %eax,(%esp)
 614:	e8 8f fd ff ff       	call   3a8 <putc>
      }
      state = 0;
 619:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 620:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 624:	8b 55 0c             	mov    0xc(%ebp),%edx
 627:	8b 45 f0             	mov    -0x10(%ebp),%eax
 62a:	01 d0                	add    %edx,%eax
 62c:	0f b6 00             	movzbl (%eax),%eax
 62f:	84 c0                	test   %al,%al
 631:	0f 85 70 fe ff ff    	jne    4a7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 637:	c9                   	leave  
 638:	c3                   	ret    
 639:	66 90                	xchg   %ax,%ax
 63b:	90                   	nop

0000063c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 63c:	55                   	push   %ebp
 63d:	89 e5                	mov    %esp,%ebp
 63f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 642:	8b 45 08             	mov    0x8(%ebp),%eax
 645:	83 e8 08             	sub    $0x8,%eax
 648:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64b:	a1 e4 0a 00 00       	mov    0xae4,%eax
 650:	89 45 fc             	mov    %eax,-0x4(%ebp)
 653:	eb 24                	jmp    679 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 655:	8b 45 fc             	mov    -0x4(%ebp),%eax
 658:	8b 00                	mov    (%eax),%eax
 65a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65d:	77 12                	ja     671 <free+0x35>
 65f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 662:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 665:	77 24                	ja     68b <free+0x4f>
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66f:	77 1a                	ja     68b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	8b 00                	mov    (%eax),%eax
 676:	89 45 fc             	mov    %eax,-0x4(%ebp)
 679:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67f:	76 d4                	jbe    655 <free+0x19>
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 00                	mov    (%eax),%eax
 686:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 689:	76 ca                	jbe    655 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	8b 40 04             	mov    0x4(%eax),%eax
 691:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 698:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69b:	01 c2                	add    %eax,%edx
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 00                	mov    (%eax),%eax
 6a2:	39 c2                	cmp    %eax,%edx
 6a4:	75 24                	jne    6ca <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a9:	8b 50 04             	mov    0x4(%eax),%edx
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 00                	mov    (%eax),%eax
 6b1:	8b 40 04             	mov    0x4(%eax),%eax
 6b4:	01 c2                	add    %eax,%edx
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8b 00                	mov    (%eax),%eax
 6c1:	8b 10                	mov    (%eax),%edx
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	89 10                	mov    %edx,(%eax)
 6c8:	eb 0a                	jmp    6d4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	8b 10                	mov    (%eax),%edx
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 40 04             	mov    0x4(%eax),%eax
 6da:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	01 d0                	add    %edx,%eax
 6e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e9:	75 20                	jne    70b <free+0xcf>
    p->s.size += bp->s.size;
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	8b 50 04             	mov    0x4(%eax),%edx
 6f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f4:	8b 40 04             	mov    0x4(%eax),%eax
 6f7:	01 c2                	add    %eax,%edx
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	8b 10                	mov    (%eax),%edx
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	89 10                	mov    %edx,(%eax)
 709:	eb 08                	jmp    713 <free+0xd7>
  } else
    p->s.ptr = bp;
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 711:	89 10                	mov    %edx,(%eax)
  freep = p;
 713:	8b 45 fc             	mov    -0x4(%ebp),%eax
 716:	a3 e4 0a 00 00       	mov    %eax,0xae4
}
 71b:	c9                   	leave  
 71c:	c3                   	ret    

0000071d <morecore>:

static Header*
morecore(uint nu)
{
 71d:	55                   	push   %ebp
 71e:	89 e5                	mov    %esp,%ebp
 720:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 723:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 72a:	77 07                	ja     733 <morecore+0x16>
    nu = 4096;
 72c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 733:	8b 45 08             	mov    0x8(%ebp),%eax
 736:	c1 e0 03             	shl    $0x3,%eax
 739:	89 04 24             	mov    %eax,(%esp)
 73c:	e8 3f fc ff ff       	call   380 <sbrk>
 741:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 744:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 748:	75 07                	jne    751 <morecore+0x34>
    return 0;
 74a:	b8 00 00 00 00       	mov    $0x0,%eax
 74f:	eb 22                	jmp    773 <morecore+0x56>
  hp = (Header*)p;
 751:	8b 45 f4             	mov    -0xc(%ebp),%eax
 754:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 757:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75a:	8b 55 08             	mov    0x8(%ebp),%edx
 75d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 760:	8b 45 f0             	mov    -0x10(%ebp),%eax
 763:	83 c0 08             	add    $0x8,%eax
 766:	89 04 24             	mov    %eax,(%esp)
 769:	e8 ce fe ff ff       	call   63c <free>
  return freep;
 76e:	a1 e4 0a 00 00       	mov    0xae4,%eax
}
 773:	c9                   	leave  
 774:	c3                   	ret    

00000775 <malloc>:

void*
malloc(uint nbytes)
{
 775:	55                   	push   %ebp
 776:	89 e5                	mov    %esp,%ebp
 778:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77b:	8b 45 08             	mov    0x8(%ebp),%eax
 77e:	83 c0 07             	add    $0x7,%eax
 781:	c1 e8 03             	shr    $0x3,%eax
 784:	83 c0 01             	add    $0x1,%eax
 787:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 78a:	a1 e4 0a 00 00       	mov    0xae4,%eax
 78f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 792:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 796:	75 23                	jne    7bb <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 798:	c7 45 f0 dc 0a 00 00 	movl   $0xadc,-0x10(%ebp)
 79f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a2:	a3 e4 0a 00 00       	mov    %eax,0xae4
 7a7:	a1 e4 0a 00 00       	mov    0xae4,%eax
 7ac:	a3 dc 0a 00 00       	mov    %eax,0xadc
    base.s.size = 0;
 7b1:	c7 05 e0 0a 00 00 00 	movl   $0x0,0xae0
 7b8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7be:	8b 00                	mov    (%eax),%eax
 7c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c6:	8b 40 04             	mov    0x4(%eax),%eax
 7c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7cc:	72 4d                	jb     81b <malloc+0xa6>
      if(p->s.size == nunits)
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	8b 40 04             	mov    0x4(%eax),%eax
 7d4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d7:	75 0c                	jne    7e5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	8b 10                	mov    (%eax),%edx
 7de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e1:	89 10                	mov    %edx,(%eax)
 7e3:	eb 26                	jmp    80b <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	8b 40 04             	mov    0x4(%eax),%eax
 7eb:	89 c2                	mov    %eax,%edx
 7ed:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	8b 40 04             	mov    0x4(%eax),%eax
 7fc:	c1 e0 03             	shl    $0x3,%eax
 7ff:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	8b 55 ec             	mov    -0x14(%ebp),%edx
 808:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 80b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80e:	a3 e4 0a 00 00       	mov    %eax,0xae4
      return (void*)(p + 1);
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	83 c0 08             	add    $0x8,%eax
 819:	eb 38                	jmp    853 <malloc+0xde>
    }
    if(p == freep)
 81b:	a1 e4 0a 00 00       	mov    0xae4,%eax
 820:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 823:	75 1b                	jne    840 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 825:	8b 45 ec             	mov    -0x14(%ebp),%eax
 828:	89 04 24             	mov    %eax,(%esp)
 82b:	e8 ed fe ff ff       	call   71d <morecore>
 830:	89 45 f4             	mov    %eax,-0xc(%ebp)
 833:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 837:	75 07                	jne    840 <malloc+0xcb>
        return 0;
 839:	b8 00 00 00 00       	mov    $0x0,%eax
 83e:	eb 13                	jmp    853 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	89 45 f0             	mov    %eax,-0x10(%ebp)
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	8b 00                	mov    (%eax),%eax
 84b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 84e:	e9 70 ff ff ff       	jmp    7c3 <malloc+0x4e>
}
 853:	c9                   	leave  
 854:	c3                   	ret    
