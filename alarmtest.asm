
_alarmtest：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <main>:

void periodic();

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 20             	sub    $0x20,%esp
  int i;
  //void (*fp)() = periodic;
  printf(1, "alarmtest starting\n");
   a:	c7 44 24 04 85 08 00 	movl   $0x885,0x4(%esp)
  11:	00 
  12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  19:	e8 97 04 00 00       	call   4b5 <printf>
  alarm(10, periodic);
  1e:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  25:	00 
  26:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  2d:	e8 9e 03 00 00       	call   3d0 <alarm>
  for(i = 0; i < 50*500000; i++){
  32:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  39:	00 
  3a:	eb 56                	jmp    92 <main+0x92>
    if((i++ % 500000) == 0){
  3c:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
  40:	ba 83 de 1b 43       	mov    $0x431bde83,%edx
  45:	89 c8                	mov    %ecx,%eax
  47:	f7 ea                	imul   %edx
  49:	c1 fa 11             	sar    $0x11,%edx
  4c:	89 c8                	mov    %ecx,%eax
  4e:	c1 f8 1f             	sar    $0x1f,%eax
  51:	89 d3                	mov    %edx,%ebx
  53:	29 c3                	sub    %eax,%ebx
  55:	89 d8                	mov    %ebx,%eax
  57:	69 c0 20 a1 07 00    	imul   $0x7a120,%eax,%eax
  5d:	89 ca                	mov    %ecx,%edx
  5f:	29 c2                	sub    %eax,%edx
  61:	89 d0                	mov    %edx,%eax
  63:	85 c0                	test   %eax,%eax
  65:	0f 94 c0             	sete   %al
  68:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  6d:	84 c0                	test   %al,%al
  6f:	74 1c                	je     8d <main+0x8d>
      write(2, ".", 1);
  71:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  78:	00 
  79:	c7 44 24 04 99 08 00 	movl   $0x899,0x4(%esp)
  80:	00 
  81:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  88:	e8 bb 02 00 00       	call   348 <write>
{
  int i;
  //void (*fp)() = periodic;
  printf(1, "alarmtest starting\n");
  alarm(10, periodic);
  for(i = 0; i < 50*500000; i++){
  8d:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  92:	81 7c 24 1c 3f 78 7d 	cmpl   $0x17d783f,0x1c(%esp)
  99:	01 
  9a:	7e a0                	jle    3c <main+0x3c>
      write(2, ".", 1);
      //printf(1, "%d\t",i/500000);
      //fp();
    }
  }
  exit();
  9c:	e8 87 02 00 00       	call   328 <exit>

000000a1 <periodic>:
}

void
periodic()
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 18             	sub    $0x18,%esp
  printf(1, "alarm!\n");
  a7:	c7 44 24 04 9b 08 00 	movl   $0x89b,0x4(%esp)
  ae:	00 
  af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b6:	e8 fa 03 00 00       	call   4b5 <printf>
  bb:	c9                   	leave  
  bc:	c3                   	ret    
  bd:	66 90                	xchg   %ax,%ax
  bf:	90                   	nop

000000c0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  c8:	8b 55 10             	mov    0x10(%ebp),%edx
  cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ce:	89 cb                	mov    %ecx,%ebx
  d0:	89 df                	mov    %ebx,%edi
  d2:	89 d1                	mov    %edx,%ecx
  d4:	fc                   	cld    
  d5:	f3 aa                	rep stos %al,%es:(%edi)
  d7:	89 ca                	mov    %ecx,%edx
  d9:	89 fb                	mov    %edi,%ebx
  db:	89 5d 08             	mov    %ebx,0x8(%ebp)
  de:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  e1:	5b                   	pop    %ebx
  e2:	5f                   	pop    %edi
  e3:	5d                   	pop    %ebp
  e4:	c3                   	ret    

000000e5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  e8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  eb:	8b 45 08             	mov    0x8(%ebp),%eax
  ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  f1:	90                   	nop
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	0f b6 10             	movzbl (%eax),%edx
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	88 10                	mov    %dl,(%eax)
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b6 00             	movzbl (%eax),%eax
 103:	84 c0                	test   %al,%al
 105:	0f 95 c0             	setne  %al
 108:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 10c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 110:	84 c0                	test   %al,%al
 112:	75 de                	jne    f2 <strcpy+0xd>
    ;
  return os;
 114:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 117:	c9                   	leave  
 118:	c3                   	ret    

00000119 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 119:	55                   	push   %ebp
 11a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 11c:	eb 08                	jmp    126 <strcmp+0xd>
    p++, q++;
 11e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 122:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 126:	8b 45 08             	mov    0x8(%ebp),%eax
 129:	0f b6 00             	movzbl (%eax),%eax
 12c:	84 c0                	test   %al,%al
 12e:	74 10                	je     140 <strcmp+0x27>
 130:	8b 45 08             	mov    0x8(%ebp),%eax
 133:	0f b6 10             	movzbl (%eax),%edx
 136:	8b 45 0c             	mov    0xc(%ebp),%eax
 139:	0f b6 00             	movzbl (%eax),%eax
 13c:	38 c2                	cmp    %al,%dl
 13e:	74 de                	je     11e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	0f b6 00             	movzbl (%eax),%eax
 146:	0f b6 d0             	movzbl %al,%edx
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	0f b6 c0             	movzbl %al,%eax
 152:	89 d1                	mov    %edx,%ecx
 154:	29 c1                	sub    %eax,%ecx
 156:	89 c8                	mov    %ecx,%eax
}
 158:	5d                   	pop    %ebp
 159:	c3                   	ret    

0000015a <strlen>:

uint
strlen(char *s)
{
 15a:	55                   	push   %ebp
 15b:	89 e5                	mov    %esp,%ebp
 15d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 167:	eb 04                	jmp    16d <strlen+0x13>
 169:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 16d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	01 d0                	add    %edx,%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	75 ed                	jne    169 <strlen+0xf>
    ;
  return n;
 17c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17f:	c9                   	leave  
 180:	c3                   	ret    

00000181 <memset>:

void*
memset(void *dst, int c, uint n)
{
 181:	55                   	push   %ebp
 182:	89 e5                	mov    %esp,%ebp
 184:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 187:	8b 45 10             	mov    0x10(%ebp),%eax
 18a:	89 44 24 08          	mov    %eax,0x8(%esp)
 18e:	8b 45 0c             	mov    0xc(%ebp),%eax
 191:	89 44 24 04          	mov    %eax,0x4(%esp)
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	89 04 24             	mov    %eax,(%esp)
 19b:	e8 20 ff ff ff       	call   c0 <stosb>
  return dst;
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a3:	c9                   	leave  
 1a4:	c3                   	ret    

000001a5 <strchr>:

char*
strchr(const char *s, char c)
{
 1a5:	55                   	push   %ebp
 1a6:	89 e5                	mov    %esp,%ebp
 1a8:	83 ec 04             	sub    $0x4,%esp
 1ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ae:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b1:	eb 14                	jmp    1c7 <strchr+0x22>
    if(*s == c)
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	0f b6 00             	movzbl (%eax),%eax
 1b9:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1bc:	75 05                	jne    1c3 <strchr+0x1e>
      return (char*)s;
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	eb 13                	jmp    1d6 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	0f b6 00             	movzbl (%eax),%eax
 1cd:	84 c0                	test   %al,%al
 1cf:	75 e2                	jne    1b3 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1d6:	c9                   	leave  
 1d7:	c3                   	ret    

000001d8 <gets>:

char*
gets(char *buf, int max)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e5:	eb 46                	jmp    22d <gets+0x55>
    cc = read(0, &c, 1);
 1e7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ee:	00 
 1ef:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1fd:	e8 3e 01 00 00       	call   340 <read>
 202:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 205:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 209:	7e 2f                	jle    23a <gets+0x62>
      break;
    buf[i++] = c;
 20b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	01 c2                	add    %eax,%edx
 213:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 217:	88 02                	mov    %al,(%edx)
 219:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 21d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 221:	3c 0a                	cmp    $0xa,%al
 223:	74 16                	je     23b <gets+0x63>
 225:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 229:	3c 0d                	cmp    $0xd,%al
 22b:	74 0e                	je     23b <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 230:	83 c0 01             	add    $0x1,%eax
 233:	3b 45 0c             	cmp    0xc(%ebp),%eax
 236:	7c af                	jl     1e7 <gets+0xf>
 238:	eb 01                	jmp    23b <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 23a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 23b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	01 d0                	add    %edx,%eax
 243:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 246:	8b 45 08             	mov    0x8(%ebp),%eax
}
 249:	c9                   	leave  
 24a:	c3                   	ret    

0000024b <stat>:

int
stat(char *n, struct stat *st)
{
 24b:	55                   	push   %ebp
 24c:	89 e5                	mov    %esp,%ebp
 24e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 251:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 258:	00 
 259:	8b 45 08             	mov    0x8(%ebp),%eax
 25c:	89 04 24             	mov    %eax,(%esp)
 25f:	e8 04 01 00 00       	call   368 <open>
 264:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 267:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 26b:	79 07                	jns    274 <stat+0x29>
    return -1;
 26d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 272:	eb 23                	jmp    297 <stat+0x4c>
  r = fstat(fd, st);
 274:	8b 45 0c             	mov    0xc(%ebp),%eax
 277:	89 44 24 04          	mov    %eax,0x4(%esp)
 27b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27e:	89 04 24             	mov    %eax,(%esp)
 281:	e8 fa 00 00 00       	call   380 <fstat>
 286:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 289:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28c:	89 04 24             	mov    %eax,(%esp)
 28f:	e8 bc 00 00 00       	call   350 <close>
  return r;
 294:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 297:	c9                   	leave  
 298:	c3                   	ret    

00000299 <atoi>:

int
atoi(const char *s)
{
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 29f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2a6:	eb 23                	jmp    2cb <atoi+0x32>
    n = n*10 + *s++ - '0';
 2a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ab:	89 d0                	mov    %edx,%eax
 2ad:	c1 e0 02             	shl    $0x2,%eax
 2b0:	01 d0                	add    %edx,%eax
 2b2:	01 c0                	add    %eax,%eax
 2b4:	89 c2                	mov    %eax,%edx
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	0f b6 00             	movzbl (%eax),%eax
 2bc:	0f be c0             	movsbl %al,%eax
 2bf:	01 d0                	add    %edx,%eax
 2c1:	83 e8 30             	sub    $0x30,%eax
 2c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 2c7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	3c 2f                	cmp    $0x2f,%al
 2d3:	7e 0a                	jle    2df <atoi+0x46>
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	0f b6 00             	movzbl (%eax),%eax
 2db:	3c 39                	cmp    $0x39,%al
 2dd:	7e c9                	jle    2a8 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e2:	c9                   	leave  
 2e3:	c3                   	ret    

000002e4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2f6:	eb 13                	jmp    30b <memmove+0x27>
    *dst++ = *src++;
 2f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2fb:	0f b6 10             	movzbl (%eax),%edx
 2fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 301:	88 10                	mov    %dl,(%eax)
 303:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 307:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 30b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 30f:	0f 9f c0             	setg   %al
 312:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 316:	84 c0                	test   %al,%al
 318:	75 de                	jne    2f8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 31a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31d:	c9                   	leave  
 31e:	c3                   	ret    
 31f:	90                   	nop

00000320 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 320:	b8 01 00 00 00       	mov    $0x1,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <exit>:
SYSCALL(exit)
 328:	b8 02 00 00 00       	mov    $0x2,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <wait>:
SYSCALL(wait)
 330:	b8 03 00 00 00       	mov    $0x3,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <pipe>:
SYSCALL(pipe)
 338:	b8 04 00 00 00       	mov    $0x4,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <read>:
SYSCALL(read)
 340:	b8 05 00 00 00       	mov    $0x5,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <write>:
SYSCALL(write)
 348:	b8 10 00 00 00       	mov    $0x10,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <close>:
SYSCALL(close)
 350:	b8 15 00 00 00       	mov    $0x15,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <kill>:
SYSCALL(kill)
 358:	b8 06 00 00 00       	mov    $0x6,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <exec>:
SYSCALL(exec)
 360:	b8 07 00 00 00       	mov    $0x7,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <open>:
SYSCALL(open)
 368:	b8 0f 00 00 00       	mov    $0xf,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <mknod>:
SYSCALL(mknod)
 370:	b8 11 00 00 00       	mov    $0x11,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <unlink>:
SYSCALL(unlink)
 378:	b8 12 00 00 00       	mov    $0x12,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <fstat>:
SYSCALL(fstat)
 380:	b8 08 00 00 00       	mov    $0x8,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <link>:
SYSCALL(link)
 388:	b8 13 00 00 00       	mov    $0x13,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <mkdir>:
SYSCALL(mkdir)
 390:	b8 14 00 00 00       	mov    $0x14,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <chdir>:
SYSCALL(chdir)
 398:	b8 09 00 00 00       	mov    $0x9,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <dup>:
SYSCALL(dup)
 3a0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <getpid>:
SYSCALL(getpid)
 3a8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <sbrk>:
SYSCALL(sbrk)
 3b0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <sleep>:
SYSCALL(sleep)
 3b8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <uptime>:
SYSCALL(uptime)
 3c0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <halt>:
SYSCALL(halt)
 3c8:	b8 16 00 00 00       	mov    $0x16,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <alarm>:
 3d0:	b8 17 00 00 00       	mov    $0x17,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3d8:	55                   	push   %ebp
 3d9:	89 e5                	mov    %esp,%ebp
 3db:	83 ec 28             	sub    $0x28,%esp
 3de:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3e4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3eb:	00 
 3ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	89 04 24             	mov    %eax,(%esp)
 3f9:	e8 4a ff ff ff       	call   348 <write>
}
 3fe:	c9                   	leave  
 3ff:	c3                   	ret    

00000400 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 406:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 40d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 411:	74 17                	je     42a <printint+0x2a>
 413:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 417:	79 11                	jns    42a <printint+0x2a>
    neg = 1;
 419:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 420:	8b 45 0c             	mov    0xc(%ebp),%eax
 423:	f7 d8                	neg    %eax
 425:	89 45 ec             	mov    %eax,-0x14(%ebp)
 428:	eb 06                	jmp    430 <printint+0x30>
  } else {
    x = xx;
 42a:	8b 45 0c             	mov    0xc(%ebp),%eax
 42d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 430:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 437:	8b 4d 10             	mov    0x10(%ebp),%ecx
 43a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43d:	ba 00 00 00 00       	mov    $0x0,%edx
 442:	f7 f1                	div    %ecx
 444:	89 d0                	mov    %edx,%eax
 446:	0f b6 80 08 0b 00 00 	movzbl 0xb08(%eax),%eax
 44d:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 450:	8b 55 f4             	mov    -0xc(%ebp),%edx
 453:	01 ca                	add    %ecx,%edx
 455:	88 02                	mov    %al,(%edx)
 457:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 45b:	8b 55 10             	mov    0x10(%ebp),%edx
 45e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 461:	8b 45 ec             	mov    -0x14(%ebp),%eax
 464:	ba 00 00 00 00       	mov    $0x0,%edx
 469:	f7 75 d4             	divl   -0x2c(%ebp)
 46c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 473:	75 c2                	jne    437 <printint+0x37>
  if(neg)
 475:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 479:	74 2e                	je     4a9 <printint+0xa9>
    buf[i++] = '-';
 47b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 47e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 481:	01 d0                	add    %edx,%eax
 483:	c6 00 2d             	movb   $0x2d,(%eax)
 486:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 48a:	eb 1d                	jmp    4a9 <printint+0xa9>
    putc(fd, buf[i]);
 48c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 48f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 492:	01 d0                	add    %edx,%eax
 494:	0f b6 00             	movzbl (%eax),%eax
 497:	0f be c0             	movsbl %al,%eax
 49a:	89 44 24 04          	mov    %eax,0x4(%esp)
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
 4a1:	89 04 24             	mov    %eax,(%esp)
 4a4:	e8 2f ff ff ff       	call   3d8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4a9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b1:	79 d9                	jns    48c <printint+0x8c>
    putc(fd, buf[i]);
}
 4b3:	c9                   	leave  
 4b4:	c3                   	ret    

000004b5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4b5:	55                   	push   %ebp
 4b6:	89 e5                	mov    %esp,%ebp
 4b8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4c2:	8d 45 0c             	lea    0xc(%ebp),%eax
 4c5:	83 c0 04             	add    $0x4,%eax
 4c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d2:	e9 7d 01 00 00       	jmp    654 <printf+0x19f>
    c = fmt[i] & 0xff;
 4d7:	8b 55 0c             	mov    0xc(%ebp),%edx
 4da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4dd:	01 d0                	add    %edx,%eax
 4df:	0f b6 00             	movzbl (%eax),%eax
 4e2:	0f be c0             	movsbl %al,%eax
 4e5:	25 ff 00 00 00       	and    $0xff,%eax
 4ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f1:	75 2c                	jne    51f <printf+0x6a>
      if(c == '%'){
 4f3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4f7:	75 0c                	jne    505 <printf+0x50>
        state = '%';
 4f9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 500:	e9 4b 01 00 00       	jmp    650 <printf+0x19b>
      } else {
        putc(fd, c);
 505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 508:	0f be c0             	movsbl %al,%eax
 50b:	89 44 24 04          	mov    %eax,0x4(%esp)
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	89 04 24             	mov    %eax,(%esp)
 515:	e8 be fe ff ff       	call   3d8 <putc>
 51a:	e9 31 01 00 00       	jmp    650 <printf+0x19b>
      }
    } else if(state == '%'){
 51f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 523:	0f 85 27 01 00 00    	jne    650 <printf+0x19b>
      if(c == 'd'){
 529:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 52d:	75 2d                	jne    55c <printf+0xa7>
        printint(fd, *ap, 10, 1);
 52f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 532:	8b 00                	mov    (%eax),%eax
 534:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 53b:	00 
 53c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 543:	00 
 544:	89 44 24 04          	mov    %eax,0x4(%esp)
 548:	8b 45 08             	mov    0x8(%ebp),%eax
 54b:	89 04 24             	mov    %eax,(%esp)
 54e:	e8 ad fe ff ff       	call   400 <printint>
        ap++;
 553:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 557:	e9 ed 00 00 00       	jmp    649 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 55c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 560:	74 06                	je     568 <printf+0xb3>
 562:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 566:	75 2d                	jne    595 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 568:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56b:	8b 00                	mov    (%eax),%eax
 56d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 574:	00 
 575:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 57c:	00 
 57d:	89 44 24 04          	mov    %eax,0x4(%esp)
 581:	8b 45 08             	mov    0x8(%ebp),%eax
 584:	89 04 24             	mov    %eax,(%esp)
 587:	e8 74 fe ff ff       	call   400 <printint>
        ap++;
 58c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 590:	e9 b4 00 00 00       	jmp    649 <printf+0x194>
      } else if(c == 's'){
 595:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 599:	75 46                	jne    5e1 <printf+0x12c>
        s = (char*)*ap;
 59b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59e:	8b 00                	mov    (%eax),%eax
 5a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ab:	75 27                	jne    5d4 <printf+0x11f>
          s = "(null)";
 5ad:	c7 45 f4 a3 08 00 00 	movl   $0x8a3,-0xc(%ebp)
        while(*s != 0){
 5b4:	eb 1e                	jmp    5d4 <printf+0x11f>
          putc(fd, *s);
 5b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b9:	0f b6 00             	movzbl (%eax),%eax
 5bc:	0f be c0             	movsbl %al,%eax
 5bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	89 04 24             	mov    %eax,(%esp)
 5c9:	e8 0a fe ff ff       	call   3d8 <putc>
          s++;
 5ce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 5d2:	eb 01                	jmp    5d5 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d4:	90                   	nop
 5d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d8:	0f b6 00             	movzbl (%eax),%eax
 5db:	84 c0                	test   %al,%al
 5dd:	75 d7                	jne    5b6 <printf+0x101>
 5df:	eb 68                	jmp    649 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e5:	75 1d                	jne    604 <printf+0x14f>
        putc(fd, *ap);
 5e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	0f be c0             	movsbl %al,%eax
 5ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f3:	8b 45 08             	mov    0x8(%ebp),%eax
 5f6:	89 04 24             	mov    %eax,(%esp)
 5f9:	e8 da fd ff ff       	call   3d8 <putc>
        ap++;
 5fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 602:	eb 45                	jmp    649 <printf+0x194>
      } else if(c == '%'){
 604:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 608:	75 17                	jne    621 <printf+0x16c>
        putc(fd, c);
 60a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60d:	0f be c0             	movsbl %al,%eax
 610:	89 44 24 04          	mov    %eax,0x4(%esp)
 614:	8b 45 08             	mov    0x8(%ebp),%eax
 617:	89 04 24             	mov    %eax,(%esp)
 61a:	e8 b9 fd ff ff       	call   3d8 <putc>
 61f:	eb 28                	jmp    649 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 621:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 628:	00 
 629:	8b 45 08             	mov    0x8(%ebp),%eax
 62c:	89 04 24             	mov    %eax,(%esp)
 62f:	e8 a4 fd ff ff       	call   3d8 <putc>
        putc(fd, c);
 634:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 637:	0f be c0             	movsbl %al,%eax
 63a:	89 44 24 04          	mov    %eax,0x4(%esp)
 63e:	8b 45 08             	mov    0x8(%ebp),%eax
 641:	89 04 24             	mov    %eax,(%esp)
 644:	e8 8f fd ff ff       	call   3d8 <putc>
      }
      state = 0;
 649:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 650:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 654:	8b 55 0c             	mov    0xc(%ebp),%edx
 657:	8b 45 f0             	mov    -0x10(%ebp),%eax
 65a:	01 d0                	add    %edx,%eax
 65c:	0f b6 00             	movzbl (%eax),%eax
 65f:	84 c0                	test   %al,%al
 661:	0f 85 70 fe ff ff    	jne    4d7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 667:	c9                   	leave  
 668:	c3                   	ret    
 669:	66 90                	xchg   %ax,%ax
 66b:	90                   	nop

0000066c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 66c:	55                   	push   %ebp
 66d:	89 e5                	mov    %esp,%ebp
 66f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 672:	8b 45 08             	mov    0x8(%ebp),%eax
 675:	83 e8 08             	sub    $0x8,%eax
 678:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67b:	a1 24 0b 00 00       	mov    0xb24,%eax
 680:	89 45 fc             	mov    %eax,-0x4(%ebp)
 683:	eb 24                	jmp    6a9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68d:	77 12                	ja     6a1 <free+0x35>
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 695:	77 24                	ja     6bb <free+0x4f>
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	8b 00                	mov    (%eax),%eax
 69c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69f:	77 1a                	ja     6bb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6af:	76 d4                	jbe    685 <free+0x19>
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 00                	mov    (%eax),%eax
 6b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b9:	76 ca                	jbe    685 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	8b 40 04             	mov    0x4(%eax),%eax
 6c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cb:	01 c2                	add    %eax,%edx
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	39 c2                	cmp    %eax,%edx
 6d4:	75 24                	jne    6fa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	8b 50 04             	mov    0x4(%eax),%edx
 6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6df:	8b 00                	mov    (%eax),%eax
 6e1:	8b 40 04             	mov    0x4(%eax),%eax
 6e4:	01 c2                	add    %eax,%edx
 6e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 00                	mov    (%eax),%eax
 6f1:	8b 10                	mov    (%eax),%edx
 6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f6:	89 10                	mov    %edx,(%eax)
 6f8:	eb 0a                	jmp    704 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	8b 10                	mov    (%eax),%edx
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 40 04             	mov    0x4(%eax),%eax
 70a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	01 d0                	add    %edx,%eax
 716:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 719:	75 20                	jne    73b <free+0xcf>
    p->s.size += bp->s.size;
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 50 04             	mov    0x4(%eax),%edx
 721:	8b 45 f8             	mov    -0x8(%ebp),%eax
 724:	8b 40 04             	mov    0x4(%eax),%eax
 727:	01 c2                	add    %eax,%edx
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	8b 10                	mov    (%eax),%edx
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	89 10                	mov    %edx,(%eax)
 739:	eb 08                	jmp    743 <free+0xd7>
  } else
    p->s.ptr = bp;
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 741:	89 10                	mov    %edx,(%eax)
  freep = p;
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	a3 24 0b 00 00       	mov    %eax,0xb24
}
 74b:	c9                   	leave  
 74c:	c3                   	ret    

0000074d <morecore>:

static Header*
morecore(uint nu)
{
 74d:	55                   	push   %ebp
 74e:	89 e5                	mov    %esp,%ebp
 750:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 753:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 75a:	77 07                	ja     763 <morecore+0x16>
    nu = 4096;
 75c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 763:	8b 45 08             	mov    0x8(%ebp),%eax
 766:	c1 e0 03             	shl    $0x3,%eax
 769:	89 04 24             	mov    %eax,(%esp)
 76c:	e8 3f fc ff ff       	call   3b0 <sbrk>
 771:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 774:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 778:	75 07                	jne    781 <morecore+0x34>
    return 0;
 77a:	b8 00 00 00 00       	mov    $0x0,%eax
 77f:	eb 22                	jmp    7a3 <morecore+0x56>
  hp = (Header*)p;
 781:	8b 45 f4             	mov    -0xc(%ebp),%eax
 784:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 787:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78a:	8b 55 08             	mov    0x8(%ebp),%edx
 78d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 790:	8b 45 f0             	mov    -0x10(%ebp),%eax
 793:	83 c0 08             	add    $0x8,%eax
 796:	89 04 24             	mov    %eax,(%esp)
 799:	e8 ce fe ff ff       	call   66c <free>
  return freep;
 79e:	a1 24 0b 00 00       	mov    0xb24,%eax
}
 7a3:	c9                   	leave  
 7a4:	c3                   	ret    

000007a5 <malloc>:

void*
malloc(uint nbytes)
{
 7a5:	55                   	push   %ebp
 7a6:	89 e5                	mov    %esp,%ebp
 7a8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ab:	8b 45 08             	mov    0x8(%ebp),%eax
 7ae:	83 c0 07             	add    $0x7,%eax
 7b1:	c1 e8 03             	shr    $0x3,%eax
 7b4:	83 c0 01             	add    $0x1,%eax
 7b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7ba:	a1 24 0b 00 00       	mov    0xb24,%eax
 7bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c6:	75 23                	jne    7eb <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7c8:	c7 45 f0 1c 0b 00 00 	movl   $0xb1c,-0x10(%ebp)
 7cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d2:	a3 24 0b 00 00       	mov    %eax,0xb24
 7d7:	a1 24 0b 00 00       	mov    0xb24,%eax
 7dc:	a3 1c 0b 00 00       	mov    %eax,0xb1c
    base.s.size = 0;
 7e1:	c7 05 20 0b 00 00 00 	movl   $0x0,0xb20
 7e8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ee:	8b 00                	mov    (%eax),%eax
 7f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	8b 40 04             	mov    0x4(%eax),%eax
 7f9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7fc:	72 4d                	jb     84b <malloc+0xa6>
      if(p->s.size == nunits)
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	8b 40 04             	mov    0x4(%eax),%eax
 804:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 807:	75 0c                	jne    815 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	8b 10                	mov    (%eax),%edx
 80e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 811:	89 10                	mov    %edx,(%eax)
 813:	eb 26                	jmp    83b <malloc+0x96>
      else {
        p->s.size -= nunits;
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	8b 40 04             	mov    0x4(%eax),%eax
 81b:	89 c2                	mov    %eax,%edx
 81d:	2b 55 ec             	sub    -0x14(%ebp),%edx
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 826:	8b 45 f4             	mov    -0xc(%ebp),%eax
 829:	8b 40 04             	mov    0x4(%eax),%eax
 82c:	c1 e0 03             	shl    $0x3,%eax
 82f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 832:	8b 45 f4             	mov    -0xc(%ebp),%eax
 835:	8b 55 ec             	mov    -0x14(%ebp),%edx
 838:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83e:	a3 24 0b 00 00       	mov    %eax,0xb24
      return (void*)(p + 1);
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	83 c0 08             	add    $0x8,%eax
 849:	eb 38                	jmp    883 <malloc+0xde>
    }
    if(p == freep)
 84b:	a1 24 0b 00 00       	mov    0xb24,%eax
 850:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 853:	75 1b                	jne    870 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 855:	8b 45 ec             	mov    -0x14(%ebp),%eax
 858:	89 04 24             	mov    %eax,(%esp)
 85b:	e8 ed fe ff ff       	call   74d <morecore>
 860:	89 45 f4             	mov    %eax,-0xc(%ebp)
 863:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 867:	75 07                	jne    870 <malloc+0xcb>
        return 0;
 869:	b8 00 00 00 00       	mov    $0x0,%eax
 86e:	eb 13                	jmp    883 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	89 45 f0             	mov    %eax,-0x10(%ebp)
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	8b 00                	mov    (%eax),%eax
 87b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 87e:	e9 70 ff ff ff       	jmp    7f3 <malloc+0x4e>
}
 883:	c9                   	leave  
 884:	c3                   	ret    
