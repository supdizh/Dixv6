
_stressfs：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 79 09 00 	movl   $0x979,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 69 05 00 00       	call   5a9 <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 19 02 00 00       	call   275 <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 11                	jmp    7a <main+0x7a>
    if(fork() > 0)
  69:	e8 a6 03 00 00       	call   414 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7f 14                	jg     86 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  72:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  79:	01 
  7a:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  81:	03 
  82:	7e e5                	jle    69 <main+0x69>
  84:	eb 01                	jmp    87 <main+0x87>
    if(fork() > 0)
      break;
  86:	90                   	nop

  printf(1, "write %d\n", i);
  87:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  92:	c7 44 24 04 8c 09 00 	movl   $0x98c,0x4(%esp)
  99:	00 
  9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a1:	e8 03 05 00 00       	call   5a9 <printf>

  path[8] += i;
  a6:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ad:	00 
  ae:	89 c2                	mov    %eax,%edx
  b0:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b7:	01 d0                	add    %edx,%eax
  b9:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  c0:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c7:	00 
  c8:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  cf:	89 04 24             	mov    %eax,(%esp)
  d2:	e8 85 03 00 00       	call   45c <open>
  d7:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  de:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e5:	00 00 00 00 
  e9:	eb 27                	jmp    112 <main+0x112>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  eb:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f2:	00 
  f3:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  fb:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 102:	89 04 24             	mov    %eax,(%esp)
 105:	e8 32 03 00 00       	call   43c <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 10a:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 111:	01 
 112:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 119:	13 
 11a:	7e cf                	jle    eb <main+0xeb>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 11c:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 123:	89 04 24             	mov    %eax,(%esp)
 126:	e8 19 03 00 00       	call   444 <close>

  printf(1, "read\n");
 12b:	c7 44 24 04 96 09 00 	movl   $0x996,0x4(%esp)
 132:	00 
 133:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13a:	e8 6a 04 00 00       	call   5a9 <printf>

  fd = open(path, O_RDONLY);
 13f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 146:	00 
 147:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14e:	89 04 24             	mov    %eax,(%esp)
 151:	e8 06 03 00 00       	call   45c <open>
 156:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15d:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 164:	00 00 00 00 
 168:	eb 27                	jmp    191 <main+0x191>
    read(fd, data, sizeof(data));
 16a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 171:	00 
 172:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 176:	89 44 24 04          	mov    %eax,0x4(%esp)
 17a:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 181:	89 04 24             	mov    %eax,(%esp)
 184:	e8 ab 02 00 00       	call   434 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 189:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 190:	01 
 191:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 198:	13 
 199:	7e cf                	jle    16a <main+0x16a>
    read(fd, data, sizeof(data));
  close(fd);
 19b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a2:	89 04 24             	mov    %eax,(%esp)
 1a5:	e8 9a 02 00 00       	call   444 <close>

  wait();
 1aa:	e8 75 02 00 00       	call   424 <wait>
  
  exit();
 1af:	e8 68 02 00 00       	call   41c <exit>

000001b4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bc:	8b 55 10             	mov    0x10(%ebp),%edx
 1bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c2:	89 cb                	mov    %ecx,%ebx
 1c4:	89 df                	mov    %ebx,%edi
 1c6:	89 d1                	mov    %edx,%ecx
 1c8:	fc                   	cld    
 1c9:	f3 aa                	rep stos %al,%es:(%edi)
 1cb:	89 ca                	mov    %ecx,%edx
 1cd:	89 fb                	mov    %edi,%ebx
 1cf:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d5:	5b                   	pop    %ebx
 1d6:	5f                   	pop    %edi
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    

000001d9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e5:	90                   	nop
 1e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e9:	0f b6 10             	movzbl (%eax),%edx
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	88 10                	mov    %dl,(%eax)
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	0f b6 00             	movzbl (%eax),%eax
 1f7:	84 c0                	test   %al,%al
 1f9:	0f 95 c0             	setne  %al
 1fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 200:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 204:	84 c0                	test   %al,%al
 206:	75 de                	jne    1e6 <strcpy+0xd>
    ;
  return os;
 208:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20b:	c9                   	leave  
 20c:	c3                   	ret    

0000020d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 20d:	55                   	push   %ebp
 20e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 210:	eb 08                	jmp    21a <strcmp+0xd>
    p++, q++;
 212:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 216:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	0f b6 00             	movzbl (%eax),%eax
 220:	84 c0                	test   %al,%al
 222:	74 10                	je     234 <strcmp+0x27>
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	0f b6 10             	movzbl (%eax),%edx
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	0f b6 00             	movzbl (%eax),%eax
 230:	38 c2                	cmp    %al,%dl
 232:	74 de                	je     212 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	0f b6 00             	movzbl (%eax),%eax
 23a:	0f b6 d0             	movzbl %al,%edx
 23d:	8b 45 0c             	mov    0xc(%ebp),%eax
 240:	0f b6 00             	movzbl (%eax),%eax
 243:	0f b6 c0             	movzbl %al,%eax
 246:	89 d1                	mov    %edx,%ecx
 248:	29 c1                	sub    %eax,%ecx
 24a:	89 c8                	mov    %ecx,%eax
}
 24c:	5d                   	pop    %ebp
 24d:	c3                   	ret    

0000024e <strlen>:

uint
strlen(char *s)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25b:	eb 04                	jmp    261 <strlen+0x13>
 25d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 261:	8b 55 fc             	mov    -0x4(%ebp),%edx
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	01 d0                	add    %edx,%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	84 c0                	test   %al,%al
 26e:	75 ed                	jne    25d <strlen+0xf>
    ;
  return n;
 270:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <memset>:

void*
memset(void *dst, int c, uint n)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 27b:	8b 45 10             	mov    0x10(%ebp),%eax
 27e:	89 44 24 08          	mov    %eax,0x8(%esp)
 282:	8b 45 0c             	mov    0xc(%ebp),%eax
 285:	89 44 24 04          	mov    %eax,0x4(%esp)
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	89 04 24             	mov    %eax,(%esp)
 28f:	e8 20 ff ff ff       	call   1b4 <stosb>
  return dst;
 294:	8b 45 08             	mov    0x8(%ebp),%eax
}
 297:	c9                   	leave  
 298:	c3                   	ret    

00000299 <strchr>:

char*
strchr(const char *s, char c)
{
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	83 ec 04             	sub    $0x4,%esp
 29f:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2a5:	eb 14                	jmp    2bb <strchr+0x22>
    if(*s == c)
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	0f b6 00             	movzbl (%eax),%eax
 2ad:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b0:	75 05                	jne    2b7 <strchr+0x1e>
      return (char*)s;
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	eb 13                	jmp    2ca <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	84 c0                	test   %al,%al
 2c3:	75 e2                	jne    2a7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    

000002cc <gets>:

char*
gets(char *buf, int max)
{
 2cc:	55                   	push   %ebp
 2cd:	89 e5                	mov    %esp,%ebp
 2cf:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d9:	eb 46                	jmp    321 <gets+0x55>
    cc = read(0, &c, 1);
 2db:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2e2:	00 
 2e3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2f1:	e8 3e 01 00 00       	call   434 <read>
 2f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2fd:	7e 2f                	jle    32e <gets+0x62>
      break;
    buf[i++] = c;
 2ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	01 c2                	add    %eax,%edx
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	88 02                	mov    %al,(%edx)
 30d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 311:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 315:	3c 0a                	cmp    $0xa,%al
 317:	74 16                	je     32f <gets+0x63>
 319:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31d:	3c 0d                	cmp    $0xd,%al
 31f:	74 0e                	je     32f <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 321:	8b 45 f4             	mov    -0xc(%ebp),%eax
 324:	83 c0 01             	add    $0x1,%eax
 327:	3b 45 0c             	cmp    0xc(%ebp),%eax
 32a:	7c af                	jl     2db <gets+0xf>
 32c:	eb 01                	jmp    32f <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 32e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 32f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	01 d0                	add    %edx,%eax
 337:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33d:	c9                   	leave  
 33e:	c3                   	ret    

0000033f <stat>:

int
stat(char *n, struct stat *st)
{
 33f:	55                   	push   %ebp
 340:	89 e5                	mov    %esp,%ebp
 342:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 345:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 34c:	00 
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
 350:	89 04 24             	mov    %eax,(%esp)
 353:	e8 04 01 00 00       	call   45c <open>
 358:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 35b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 35f:	79 07                	jns    368 <stat+0x29>
    return -1;
 361:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 366:	eb 23                	jmp    38b <stat+0x4c>
  r = fstat(fd, st);
 368:	8b 45 0c             	mov    0xc(%ebp),%eax
 36b:	89 44 24 04          	mov    %eax,0x4(%esp)
 36f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 372:	89 04 24             	mov    %eax,(%esp)
 375:	e8 fa 00 00 00       	call   474 <fstat>
 37a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 37d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 380:	89 04 24             	mov    %eax,(%esp)
 383:	e8 bc 00 00 00       	call   444 <close>
  return r;
 388:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 38b:	c9                   	leave  
 38c:	c3                   	ret    

0000038d <atoi>:

int
atoi(const char *s)
{
 38d:	55                   	push   %ebp
 38e:	89 e5                	mov    %esp,%ebp
 390:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 393:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 39a:	eb 23                	jmp    3bf <atoi+0x32>
    n = n*10 + *s++ - '0';
 39c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39f:	89 d0                	mov    %edx,%eax
 3a1:	c1 e0 02             	shl    $0x2,%eax
 3a4:	01 d0                	add    %edx,%eax
 3a6:	01 c0                	add    %eax,%eax
 3a8:	89 c2                	mov    %eax,%edx
 3aa:	8b 45 08             	mov    0x8(%ebp),%eax
 3ad:	0f b6 00             	movzbl (%eax),%eax
 3b0:	0f be c0             	movsbl %al,%eax
 3b3:	01 d0                	add    %edx,%eax
 3b5:	83 e8 30             	sub    $0x30,%eax
 3b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
 3c2:	0f b6 00             	movzbl (%eax),%eax
 3c5:	3c 2f                	cmp    $0x2f,%al
 3c7:	7e 0a                	jle    3d3 <atoi+0x46>
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	3c 39                	cmp    $0x39,%al
 3d1:	7e c9                	jle    39c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d6:	c9                   	leave  
 3d7:	c3                   	ret    

000003d8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3d8:	55                   	push   %ebp
 3d9:	89 e5                	mov    %esp,%ebp
 3db:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3ea:	eb 13                	jmp    3ff <memmove+0x27>
    *dst++ = *src++;
 3ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ef:	0f b6 10             	movzbl (%eax),%edx
 3f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3f5:	88 10                	mov    %dl,(%eax)
 3f7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3fb:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 403:	0f 9f c0             	setg   %al
 406:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 40a:	84 c0                	test   %al,%al
 40c:	75 de                	jne    3ec <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 411:	c9                   	leave  
 412:	c3                   	ret    
 413:	90                   	nop

00000414 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 414:	b8 01 00 00 00       	mov    $0x1,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <exit>:
SYSCALL(exit)
 41c:	b8 02 00 00 00       	mov    $0x2,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <wait>:
SYSCALL(wait)
 424:	b8 03 00 00 00       	mov    $0x3,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <pipe>:
SYSCALL(pipe)
 42c:	b8 04 00 00 00       	mov    $0x4,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <read>:
SYSCALL(read)
 434:	b8 05 00 00 00       	mov    $0x5,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <write>:
SYSCALL(write)
 43c:	b8 10 00 00 00       	mov    $0x10,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <close>:
SYSCALL(close)
 444:	b8 15 00 00 00       	mov    $0x15,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <kill>:
SYSCALL(kill)
 44c:	b8 06 00 00 00       	mov    $0x6,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <exec>:
SYSCALL(exec)
 454:	b8 07 00 00 00       	mov    $0x7,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <open>:
SYSCALL(open)
 45c:	b8 0f 00 00 00       	mov    $0xf,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <mknod>:
SYSCALL(mknod)
 464:	b8 11 00 00 00       	mov    $0x11,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <unlink>:
SYSCALL(unlink)
 46c:	b8 12 00 00 00       	mov    $0x12,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <fstat>:
SYSCALL(fstat)
 474:	b8 08 00 00 00       	mov    $0x8,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <link>:
SYSCALL(link)
 47c:	b8 13 00 00 00       	mov    $0x13,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <mkdir>:
SYSCALL(mkdir)
 484:	b8 14 00 00 00       	mov    $0x14,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <chdir>:
SYSCALL(chdir)
 48c:	b8 09 00 00 00       	mov    $0x9,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <dup>:
SYSCALL(dup)
 494:	b8 0a 00 00 00       	mov    $0xa,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <getpid>:
SYSCALL(getpid)
 49c:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <sbrk>:
SYSCALL(sbrk)
 4a4:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <sleep>:
SYSCALL(sleep)
 4ac:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <uptime>:
SYSCALL(uptime)
 4b4:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <halt>:
SYSCALL(halt)
 4bc:	b8 16 00 00 00       	mov    $0x16,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <alarm>:
 4c4:	b8 17 00 00 00       	mov    $0x17,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4cc:	55                   	push   %ebp
 4cd:	89 e5                	mov    %esp,%ebp
 4cf:	83 ec 28             	sub    $0x28,%esp
 4d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4df:	00 
 4e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ea:	89 04 24             	mov    %eax,(%esp)
 4ed:	e8 4a ff ff ff       	call   43c <write>
}
 4f2:	c9                   	leave  
 4f3:	c3                   	ret    

000004f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f4:	55                   	push   %ebp
 4f5:	89 e5                	mov    %esp,%ebp
 4f7:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 501:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 505:	74 17                	je     51e <printint+0x2a>
 507:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 50b:	79 11                	jns    51e <printint+0x2a>
    neg = 1;
 50d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 514:	8b 45 0c             	mov    0xc(%ebp),%eax
 517:	f7 d8                	neg    %eax
 519:	89 45 ec             	mov    %eax,-0x14(%ebp)
 51c:	eb 06                	jmp    524 <printint+0x30>
  } else {
    x = xx;
 51e:	8b 45 0c             	mov    0xc(%ebp),%eax
 521:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 52b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 52e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 531:	ba 00 00 00 00       	mov    $0x0,%edx
 536:	f7 f1                	div    %ecx
 538:	89 d0                	mov    %edx,%eax
 53a:	0f b6 80 e0 0b 00 00 	movzbl 0xbe0(%eax),%eax
 541:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 544:	8b 55 f4             	mov    -0xc(%ebp),%edx
 547:	01 ca                	add    %ecx,%edx
 549:	88 02                	mov    %al,(%edx)
 54b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 54f:	8b 55 10             	mov    0x10(%ebp),%edx
 552:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 555:	8b 45 ec             	mov    -0x14(%ebp),%eax
 558:	ba 00 00 00 00       	mov    $0x0,%edx
 55d:	f7 75 d4             	divl   -0x2c(%ebp)
 560:	89 45 ec             	mov    %eax,-0x14(%ebp)
 563:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 567:	75 c2                	jne    52b <printint+0x37>
  if(neg)
 569:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 56d:	74 2e                	je     59d <printint+0xa9>
    buf[i++] = '-';
 56f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 572:	8b 45 f4             	mov    -0xc(%ebp),%eax
 575:	01 d0                	add    %edx,%eax
 577:	c6 00 2d             	movb   $0x2d,(%eax)
 57a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 57e:	eb 1d                	jmp    59d <printint+0xa9>
    putc(fd, buf[i]);
 580:	8d 55 dc             	lea    -0x24(%ebp),%edx
 583:	8b 45 f4             	mov    -0xc(%ebp),%eax
 586:	01 d0                	add    %edx,%eax
 588:	0f b6 00             	movzbl (%eax),%eax
 58b:	0f be c0             	movsbl %al,%eax
 58e:	89 44 24 04          	mov    %eax,0x4(%esp)
 592:	8b 45 08             	mov    0x8(%ebp),%eax
 595:	89 04 24             	mov    %eax,(%esp)
 598:	e8 2f ff ff ff       	call   4cc <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 59d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a5:	79 d9                	jns    580 <printint+0x8c>
    putc(fd, buf[i]);
}
 5a7:	c9                   	leave  
 5a8:	c3                   	ret    

000005a9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a9:	55                   	push   %ebp
 5aa:	89 e5                	mov    %esp,%ebp
 5ac:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5b6:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b9:	83 c0 04             	add    $0x4,%eax
 5bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5c6:	e9 7d 01 00 00       	jmp    748 <printf+0x19f>
    c = fmt[i] & 0xff;
 5cb:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d1:	01 d0                	add    %edx,%eax
 5d3:	0f b6 00             	movzbl (%eax),%eax
 5d6:	0f be c0             	movsbl %al,%eax
 5d9:	25 ff 00 00 00       	and    $0xff,%eax
 5de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e5:	75 2c                	jne    613 <printf+0x6a>
      if(c == '%'){
 5e7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5eb:	75 0c                	jne    5f9 <printf+0x50>
        state = '%';
 5ed:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5f4:	e9 4b 01 00 00       	jmp    744 <printf+0x19b>
      } else {
        putc(fd, c);
 5f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fc:	0f be c0             	movsbl %al,%eax
 5ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 603:	8b 45 08             	mov    0x8(%ebp),%eax
 606:	89 04 24             	mov    %eax,(%esp)
 609:	e8 be fe ff ff       	call   4cc <putc>
 60e:	e9 31 01 00 00       	jmp    744 <printf+0x19b>
      }
    } else if(state == '%'){
 613:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 617:	0f 85 27 01 00 00    	jne    744 <printf+0x19b>
      if(c == 'd'){
 61d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 621:	75 2d                	jne    650 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 623:	8b 45 e8             	mov    -0x18(%ebp),%eax
 626:	8b 00                	mov    (%eax),%eax
 628:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 62f:	00 
 630:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 637:	00 
 638:	89 44 24 04          	mov    %eax,0x4(%esp)
 63c:	8b 45 08             	mov    0x8(%ebp),%eax
 63f:	89 04 24             	mov    %eax,(%esp)
 642:	e8 ad fe ff ff       	call   4f4 <printint>
        ap++;
 647:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64b:	e9 ed 00 00 00       	jmp    73d <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 650:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 654:	74 06                	je     65c <printf+0xb3>
 656:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 65a:	75 2d                	jne    689 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 65c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 668:	00 
 669:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 670:	00 
 671:	89 44 24 04          	mov    %eax,0x4(%esp)
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	89 04 24             	mov    %eax,(%esp)
 67b:	e8 74 fe ff ff       	call   4f4 <printint>
        ap++;
 680:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 684:	e9 b4 00 00 00       	jmp    73d <printf+0x194>
      } else if(c == 's'){
 689:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 68d:	75 46                	jne    6d5 <printf+0x12c>
        s = (char*)*ap;
 68f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 697:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 69b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 69f:	75 27                	jne    6c8 <printf+0x11f>
          s = "(null)";
 6a1:	c7 45 f4 9c 09 00 00 	movl   $0x99c,-0xc(%ebp)
        while(*s != 0){
 6a8:	eb 1e                	jmp    6c8 <printf+0x11f>
          putc(fd, *s);
 6aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ad:	0f b6 00             	movzbl (%eax),%eax
 6b0:	0f be c0             	movsbl %al,%eax
 6b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ba:	89 04 24             	mov    %eax,(%esp)
 6bd:	e8 0a fe ff ff       	call   4cc <putc>
          s++;
 6c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 6c6:	eb 01                	jmp    6c9 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c8:	90                   	nop
 6c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6cc:	0f b6 00             	movzbl (%eax),%eax
 6cf:	84 c0                	test   %al,%al
 6d1:	75 d7                	jne    6aa <printf+0x101>
 6d3:	eb 68                	jmp    73d <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6d9:	75 1d                	jne    6f8 <printf+0x14f>
        putc(fd, *ap);
 6db:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	0f be c0             	movsbl %al,%eax
 6e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ea:	89 04 24             	mov    %eax,(%esp)
 6ed:	e8 da fd ff ff       	call   4cc <putc>
        ap++;
 6f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f6:	eb 45                	jmp    73d <printf+0x194>
      } else if(c == '%'){
 6f8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6fc:	75 17                	jne    715 <printf+0x16c>
        putc(fd, c);
 6fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 701:	0f be c0             	movsbl %al,%eax
 704:	89 44 24 04          	mov    %eax,0x4(%esp)
 708:	8b 45 08             	mov    0x8(%ebp),%eax
 70b:	89 04 24             	mov    %eax,(%esp)
 70e:	e8 b9 fd ff ff       	call   4cc <putc>
 713:	eb 28                	jmp    73d <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 715:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 71c:	00 
 71d:	8b 45 08             	mov    0x8(%ebp),%eax
 720:	89 04 24             	mov    %eax,(%esp)
 723:	e8 a4 fd ff ff       	call   4cc <putc>
        putc(fd, c);
 728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72b:	0f be c0             	movsbl %al,%eax
 72e:	89 44 24 04          	mov    %eax,0x4(%esp)
 732:	8b 45 08             	mov    0x8(%ebp),%eax
 735:	89 04 24             	mov    %eax,(%esp)
 738:	e8 8f fd ff ff       	call   4cc <putc>
      }
      state = 0;
 73d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 744:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 748:	8b 55 0c             	mov    0xc(%ebp),%edx
 74b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74e:	01 d0                	add    %edx,%eax
 750:	0f b6 00             	movzbl (%eax),%eax
 753:	84 c0                	test   %al,%al
 755:	0f 85 70 fe ff ff    	jne    5cb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 75b:	c9                   	leave  
 75c:	c3                   	ret    
 75d:	66 90                	xchg   %ax,%ax
 75f:	90                   	nop

00000760 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 766:	8b 45 08             	mov    0x8(%ebp),%eax
 769:	83 e8 08             	sub    $0x8,%eax
 76c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76f:	a1 fc 0b 00 00       	mov    0xbfc,%eax
 774:	89 45 fc             	mov    %eax,-0x4(%ebp)
 777:	eb 24                	jmp    79d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 781:	77 12                	ja     795 <free+0x35>
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 789:	77 24                	ja     7af <free+0x4f>
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	8b 00                	mov    (%eax),%eax
 790:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 793:	77 1a                	ja     7af <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 00                	mov    (%eax),%eax
 79a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a3:	76 d4                	jbe    779 <free+0x19>
 7a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a8:	8b 00                	mov    (%eax),%eax
 7aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ad:	76 ca                	jbe    779 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b2:	8b 40 04             	mov    0x4(%eax),%eax
 7b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bf:	01 c2                	add    %eax,%edx
 7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c4:	8b 00                	mov    (%eax),%eax
 7c6:	39 c2                	cmp    %eax,%edx
 7c8:	75 24                	jne    7ee <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cd:	8b 50 04             	mov    0x4(%eax),%edx
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	8b 00                	mov    (%eax),%eax
 7d5:	8b 40 04             	mov    0x4(%eax),%eax
 7d8:	01 c2                	add    %eax,%edx
 7da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7dd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	8b 10                	mov    (%eax),%edx
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	89 10                	mov    %edx,(%eax)
 7ec:	eb 0a                	jmp    7f8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f1:	8b 10                	mov    (%eax),%edx
 7f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fb:	8b 40 04             	mov    0x4(%eax),%eax
 7fe:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 805:	8b 45 fc             	mov    -0x4(%ebp),%eax
 808:	01 d0                	add    %edx,%eax
 80a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 80d:	75 20                	jne    82f <free+0xcf>
    p->s.size += bp->s.size;
 80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 812:	8b 50 04             	mov    0x4(%eax),%edx
 815:	8b 45 f8             	mov    -0x8(%ebp),%eax
 818:	8b 40 04             	mov    0x4(%eax),%eax
 81b:	01 c2                	add    %eax,%edx
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 823:	8b 45 f8             	mov    -0x8(%ebp),%eax
 826:	8b 10                	mov    (%eax),%edx
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	89 10                	mov    %edx,(%eax)
 82d:	eb 08                	jmp    837 <free+0xd7>
  } else
    p->s.ptr = bp;
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 832:	8b 55 f8             	mov    -0x8(%ebp),%edx
 835:	89 10                	mov    %edx,(%eax)
  freep = p;
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	a3 fc 0b 00 00       	mov    %eax,0xbfc
}
 83f:	c9                   	leave  
 840:	c3                   	ret    

00000841 <morecore>:

static Header*
morecore(uint nu)
{
 841:	55                   	push   %ebp
 842:	89 e5                	mov    %esp,%ebp
 844:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 847:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 84e:	77 07                	ja     857 <morecore+0x16>
    nu = 4096;
 850:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 857:	8b 45 08             	mov    0x8(%ebp),%eax
 85a:	c1 e0 03             	shl    $0x3,%eax
 85d:	89 04 24             	mov    %eax,(%esp)
 860:	e8 3f fc ff ff       	call   4a4 <sbrk>
 865:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 868:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 86c:	75 07                	jne    875 <morecore+0x34>
    return 0;
 86e:	b8 00 00 00 00       	mov    $0x0,%eax
 873:	eb 22                	jmp    897 <morecore+0x56>
  hp = (Header*)p;
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 87b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87e:	8b 55 08             	mov    0x8(%ebp),%edx
 881:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 884:	8b 45 f0             	mov    -0x10(%ebp),%eax
 887:	83 c0 08             	add    $0x8,%eax
 88a:	89 04 24             	mov    %eax,(%esp)
 88d:	e8 ce fe ff ff       	call   760 <free>
  return freep;
 892:	a1 fc 0b 00 00       	mov    0xbfc,%eax
}
 897:	c9                   	leave  
 898:	c3                   	ret    

00000899 <malloc>:

void*
malloc(uint nbytes)
{
 899:	55                   	push   %ebp
 89a:	89 e5                	mov    %esp,%ebp
 89c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 89f:	8b 45 08             	mov    0x8(%ebp),%eax
 8a2:	83 c0 07             	add    $0x7,%eax
 8a5:	c1 e8 03             	shr    $0x3,%eax
 8a8:	83 c0 01             	add    $0x1,%eax
 8ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8ae:	a1 fc 0b 00 00       	mov    0xbfc,%eax
 8b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8ba:	75 23                	jne    8df <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8bc:	c7 45 f0 f4 0b 00 00 	movl   $0xbf4,-0x10(%ebp)
 8c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c6:	a3 fc 0b 00 00       	mov    %eax,0xbfc
 8cb:	a1 fc 0b 00 00       	mov    0xbfc,%eax
 8d0:	a3 f4 0b 00 00       	mov    %eax,0xbf4
    base.s.size = 0;
 8d5:	c7 05 f8 0b 00 00 00 	movl   $0x0,0xbf8
 8dc:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e2:	8b 00                	mov    (%eax),%eax
 8e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ea:	8b 40 04             	mov    0x4(%eax),%eax
 8ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f0:	72 4d                	jb     93f <malloc+0xa6>
      if(p->s.size == nunits)
 8f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f5:	8b 40 04             	mov    0x4(%eax),%eax
 8f8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8fb:	75 0c                	jne    909 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	8b 10                	mov    (%eax),%edx
 902:	8b 45 f0             	mov    -0x10(%ebp),%eax
 905:	89 10                	mov    %edx,(%eax)
 907:	eb 26                	jmp    92f <malloc+0x96>
      else {
        p->s.size -= nunits;
 909:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90c:	8b 40 04             	mov    0x4(%eax),%eax
 90f:	89 c2                	mov    %eax,%edx
 911:	2b 55 ec             	sub    -0x14(%ebp),%edx
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	8b 40 04             	mov    0x4(%eax),%eax
 920:	c1 e0 03             	shl    $0x3,%eax
 923:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 926:	8b 45 f4             	mov    -0xc(%ebp),%eax
 929:	8b 55 ec             	mov    -0x14(%ebp),%edx
 92c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 92f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 932:	a3 fc 0b 00 00       	mov    %eax,0xbfc
      return (void*)(p + 1);
 937:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93a:	83 c0 08             	add    $0x8,%eax
 93d:	eb 38                	jmp    977 <malloc+0xde>
    }
    if(p == freep)
 93f:	a1 fc 0b 00 00       	mov    0xbfc,%eax
 944:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 947:	75 1b                	jne    964 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 949:	8b 45 ec             	mov    -0x14(%ebp),%eax
 94c:	89 04 24             	mov    %eax,(%esp)
 94f:	e8 ed fe ff ff       	call   841 <morecore>
 954:	89 45 f4             	mov    %eax,-0xc(%ebp)
 957:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 95b:	75 07                	jne    964 <malloc+0xcb>
        return 0;
 95d:	b8 00 00 00 00       	mov    $0x0,%eax
 962:	eb 13                	jmp    977 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 964:	8b 45 f4             	mov    -0xc(%ebp),%eax
 967:	89 45 f0             	mov    %eax,-0x10(%ebp)
 96a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96d:	8b 00                	mov    (%eax),%eax
 96f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 972:	e9 70 ff ff ff       	jmp    8e7 <malloc+0x4e>
}
 977:	c9                   	leave  
 978:	c3                   	ret    
