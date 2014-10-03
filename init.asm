
_init：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 dc 08 00 00 	movl   $0x8dc,(%esp)
  18:	e8 9f 03 00 00       	call   3bc <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 dc 08 00 00 	movl   $0x8dc,(%esp)
  38:	e8 87 03 00 00       	call   3c4 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 dc 08 00 00 	movl   $0x8dc,(%esp)
  4c:	e8 6b 03 00 00       	call   3bc <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 97 03 00 00       	call   3f4 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 8b 03 00 00       	call   3f4 <dup>
  69:	eb 01                	jmp    6c <main+0x6c>
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
  6b:	90                   	nop
  }
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
  6c:	c7 44 24 04 e4 08 00 	movl   $0x8e4,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 89 04 00 00       	call   509 <printf>
    pid = fork();
  80:	e8 ef 02 00 00       	call   374 <fork>
  85:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  89:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 f7 08 00 	movl   $0x8f7,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 65 04 00 00       	call   509 <printf>
      exit();
  a4:	e8 d3 02 00 00       	call   37c <exit>
    }
    if(pid == 0){
  a9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ae:	75 41                	jne    f1 <main+0xf1>
      exec("sh", argv);
  b0:	c7 44 24 04 6c 0b 00 	movl   $0xb6c,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 d9 08 00 00 	movl   $0x8d9,(%esp)
  bf:	e8 f0 02 00 00       	call   3b4 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 0a 09 00 	movl   $0x90a,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 31 04 00 00       	call   509 <printf>
      exit();
  d8:	e8 9f 02 00 00       	call   37c <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 20 09 00 	movl   $0x920,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 18 04 00 00       	call   509 <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f1:	e8 8e 02 00 00       	call   384 <wait>
  f6:	89 44 24 18          	mov    %eax,0x18(%esp)
  fa:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  ff:	0f 88 66 ff ff ff    	js     6b <main+0x6b>
 105:	8b 44 24 18          	mov    0x18(%esp),%eax
 109:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 10d:	75 ce                	jne    dd <main+0xdd>
      printf(1, "zombie!\n");
  }
 10f:	e9 57 ff ff ff       	jmp    6b <main+0x6b>

00000114 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 119:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11c:	8b 55 10             	mov    0x10(%ebp),%edx
 11f:	8b 45 0c             	mov    0xc(%ebp),%eax
 122:	89 cb                	mov    %ecx,%ebx
 124:	89 df                	mov    %ebx,%edi
 126:	89 d1                	mov    %edx,%ecx
 128:	fc                   	cld    
 129:	f3 aa                	rep stos %al,%es:(%edi)
 12b:	89 ca                	mov    %ecx,%edx
 12d:	89 fb                	mov    %edi,%ebx
 12f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 132:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 135:	5b                   	pop    %ebx
 136:	5f                   	pop    %edi
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    

00000139 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 145:	90                   	nop
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	0f b6 10             	movzbl (%eax),%edx
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	88 10                	mov    %dl,(%eax)
 151:	8b 45 08             	mov    0x8(%ebp),%eax
 154:	0f b6 00             	movzbl (%eax),%eax
 157:	84 c0                	test   %al,%al
 159:	0f 95 c0             	setne  %al
 15c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 160:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 164:	84 c0                	test   %al,%al
 166:	75 de                	jne    146 <strcpy+0xd>
    ;
  return os;
 168:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16b:	c9                   	leave  
 16c:	c3                   	ret    

0000016d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 16d:	55                   	push   %ebp
 16e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 170:	eb 08                	jmp    17a <strcmp+0xd>
    p++, q++;
 172:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 176:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	0f b6 00             	movzbl (%eax),%eax
 180:	84 c0                	test   %al,%al
 182:	74 10                	je     194 <strcmp+0x27>
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	0f b6 10             	movzbl (%eax),%edx
 18a:	8b 45 0c             	mov    0xc(%ebp),%eax
 18d:	0f b6 00             	movzbl (%eax),%eax
 190:	38 c2                	cmp    %al,%dl
 192:	74 de                	je     172 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	0f b6 00             	movzbl (%eax),%eax
 19a:	0f b6 d0             	movzbl %al,%edx
 19d:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a0:	0f b6 00             	movzbl (%eax),%eax
 1a3:	0f b6 c0             	movzbl %al,%eax
 1a6:	89 d1                	mov    %edx,%ecx
 1a8:	29 c1                	sub    %eax,%ecx
 1aa:	89 c8                	mov    %ecx,%eax
}
 1ac:	5d                   	pop    %ebp
 1ad:	c3                   	ret    

000001ae <strlen>:

uint
strlen(char *s)
{
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1bb:	eb 04                	jmp    1c1 <strlen+0x13>
 1bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	01 d0                	add    %edx,%eax
 1c9:	0f b6 00             	movzbl (%eax),%eax
 1cc:	84 c0                	test   %al,%al
 1ce:	75 ed                	jne    1bd <strlen+0xf>
    ;
  return n;
 1d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d3:	c9                   	leave  
 1d4:	c3                   	ret    

000001d5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d5:	55                   	push   %ebp
 1d6:	89 e5                	mov    %esp,%ebp
 1d8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1db:	8b 45 10             	mov    0x10(%ebp),%eax
 1de:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 04 24             	mov    %eax,(%esp)
 1ef:	e8 20 ff ff ff       	call   114 <stosb>
  return dst;
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f7:	c9                   	leave  
 1f8:	c3                   	ret    

000001f9 <strchr>:

char*
strchr(const char *s, char c)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 04             	sub    $0x4,%esp
 1ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 202:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 205:	eb 14                	jmp    21b <strchr+0x22>
    if(*s == c)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 210:	75 05                	jne    217 <strchr+0x1e>
      return (char*)s;
 212:	8b 45 08             	mov    0x8(%ebp),%eax
 215:	eb 13                	jmp    22a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 217:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
 21e:	0f b6 00             	movzbl (%eax),%eax
 221:	84 c0                	test   %al,%al
 223:	75 e2                	jne    207 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 225:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22a:	c9                   	leave  
 22b:	c3                   	ret    

0000022c <gets>:

char*
gets(char *buf, int max)
{
 22c:	55                   	push   %ebp
 22d:	89 e5                	mov    %esp,%ebp
 22f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 232:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 239:	eb 46                	jmp    281 <gets+0x55>
    cc = read(0, &c, 1);
 23b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 242:	00 
 243:	8d 45 ef             	lea    -0x11(%ebp),%eax
 246:	89 44 24 04          	mov    %eax,0x4(%esp)
 24a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 251:	e8 3e 01 00 00       	call   394 <read>
 256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 259:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25d:	7e 2f                	jle    28e <gets+0x62>
      break;
    buf[i++] = c;
 25f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	01 c2                	add    %eax,%edx
 267:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26b:	88 02                	mov    %al,(%edx)
 26d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 271:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 275:	3c 0a                	cmp    $0xa,%al
 277:	74 16                	je     28f <gets+0x63>
 279:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27d:	3c 0d                	cmp    $0xd,%al
 27f:	74 0e                	je     28f <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 281:	8b 45 f4             	mov    -0xc(%ebp),%eax
 284:	83 c0 01             	add    $0x1,%eax
 287:	3b 45 0c             	cmp    0xc(%ebp),%eax
 28a:	7c af                	jl     23b <gets+0xf>
 28c:	eb 01                	jmp    28f <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 28e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	01 d0                	add    %edx,%eax
 297:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29d:	c9                   	leave  
 29e:	c3                   	ret    

0000029f <stat>:

int
stat(char *n, struct stat *st)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
 2a2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2ac:	00 
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	89 04 24             	mov    %eax,(%esp)
 2b3:	e8 04 01 00 00       	call   3bc <open>
 2b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2bf:	79 07                	jns    2c8 <stat+0x29>
    return -1;
 2c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c6:	eb 23                	jmp    2eb <stat+0x4c>
  r = fstat(fd, st);
 2c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 2cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d2:	89 04 24             	mov    %eax,(%esp)
 2d5:	e8 fa 00 00 00       	call   3d4 <fstat>
 2da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e0:	89 04 24             	mov    %eax,(%esp)
 2e3:	e8 bc 00 00 00       	call   3a4 <close>
  return r;
 2e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    

000002ed <atoi>:

int
atoi(const char *s)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2fa:	eb 23                	jmp    31f <atoi+0x32>
    n = n*10 + *s++ - '0';
 2fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ff:	89 d0                	mov    %edx,%eax
 301:	c1 e0 02             	shl    $0x2,%eax
 304:	01 d0                	add    %edx,%eax
 306:	01 c0                	add    %eax,%eax
 308:	89 c2                	mov    %eax,%edx
 30a:	8b 45 08             	mov    0x8(%ebp),%eax
 30d:	0f b6 00             	movzbl (%eax),%eax
 310:	0f be c0             	movsbl %al,%eax
 313:	01 d0                	add    %edx,%eax
 315:	83 e8 30             	sub    $0x30,%eax
 318:	89 45 fc             	mov    %eax,-0x4(%ebp)
 31b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	0f b6 00             	movzbl (%eax),%eax
 325:	3c 2f                	cmp    $0x2f,%al
 327:	7e 0a                	jle    333 <atoi+0x46>
 329:	8b 45 08             	mov    0x8(%ebp),%eax
 32c:	0f b6 00             	movzbl (%eax),%eax
 32f:	3c 39                	cmp    $0x39,%al
 331:	7e c9                	jle    2fc <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 333:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 336:	c9                   	leave  
 337:	c3                   	ret    

00000338 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
 341:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 344:	8b 45 0c             	mov    0xc(%ebp),%eax
 347:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 34a:	eb 13                	jmp    35f <memmove+0x27>
    *dst++ = *src++;
 34c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 34f:	0f b6 10             	movzbl (%eax),%edx
 352:	8b 45 fc             	mov    -0x4(%ebp),%eax
 355:	88 10                	mov    %dl,(%eax)
 357:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 35b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 363:	0f 9f c0             	setg   %al
 366:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 36a:	84 c0                	test   %al,%al
 36c:	75 de                	jne    34c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 371:	c9                   	leave  
 372:	c3                   	ret    
 373:	90                   	nop

00000374 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 374:	b8 01 00 00 00       	mov    $0x1,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exit>:
SYSCALL(exit)
 37c:	b8 02 00 00 00       	mov    $0x2,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <wait>:
SYSCALL(wait)
 384:	b8 03 00 00 00       	mov    $0x3,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <pipe>:
SYSCALL(pipe)
 38c:	b8 04 00 00 00       	mov    $0x4,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <read>:
SYSCALL(read)
 394:	b8 05 00 00 00       	mov    $0x5,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <write>:
SYSCALL(write)
 39c:	b8 10 00 00 00       	mov    $0x10,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <close>:
SYSCALL(close)
 3a4:	b8 15 00 00 00       	mov    $0x15,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <kill>:
SYSCALL(kill)
 3ac:	b8 06 00 00 00       	mov    $0x6,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <exec>:
SYSCALL(exec)
 3b4:	b8 07 00 00 00       	mov    $0x7,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <open>:
SYSCALL(open)
 3bc:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <mknod>:
SYSCALL(mknod)
 3c4:	b8 11 00 00 00       	mov    $0x11,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <unlink>:
SYSCALL(unlink)
 3cc:	b8 12 00 00 00       	mov    $0x12,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <fstat>:
SYSCALL(fstat)
 3d4:	b8 08 00 00 00       	mov    $0x8,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <link>:
SYSCALL(link)
 3dc:	b8 13 00 00 00       	mov    $0x13,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <mkdir>:
SYSCALL(mkdir)
 3e4:	b8 14 00 00 00       	mov    $0x14,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <chdir>:
SYSCALL(chdir)
 3ec:	b8 09 00 00 00       	mov    $0x9,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <dup>:
SYSCALL(dup)
 3f4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <getpid>:
SYSCALL(getpid)
 3fc:	b8 0b 00 00 00       	mov    $0xb,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <sbrk>:
SYSCALL(sbrk)
 404:	b8 0c 00 00 00       	mov    $0xc,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <sleep>:
SYSCALL(sleep)
 40c:	b8 0d 00 00 00       	mov    $0xd,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <uptime>:
SYSCALL(uptime)
 414:	b8 0e 00 00 00       	mov    $0xe,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <halt>:
SYSCALL(halt)
 41c:	b8 16 00 00 00       	mov    $0x16,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <alarm>:
 424:	b8 17 00 00 00       	mov    $0x17,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	83 ec 28             	sub    $0x28,%esp
 432:	8b 45 0c             	mov    0xc(%ebp),%eax
 435:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 438:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 43f:	00 
 440:	8d 45 f4             	lea    -0xc(%ebp),%eax
 443:	89 44 24 04          	mov    %eax,0x4(%esp)
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	89 04 24             	mov    %eax,(%esp)
 44d:	e8 4a ff ff ff       	call   39c <write>
}
 452:	c9                   	leave  
 453:	c3                   	ret    

00000454 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
 457:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 45a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 461:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 465:	74 17                	je     47e <printint+0x2a>
 467:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 46b:	79 11                	jns    47e <printint+0x2a>
    neg = 1;
 46d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 474:	8b 45 0c             	mov    0xc(%ebp),%eax
 477:	f7 d8                	neg    %eax
 479:	89 45 ec             	mov    %eax,-0x14(%ebp)
 47c:	eb 06                	jmp    484 <printint+0x30>
  } else {
    x = xx;
 47e:	8b 45 0c             	mov    0xc(%ebp),%eax
 481:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 484:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 48b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 48e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 491:	ba 00 00 00 00       	mov    $0x0,%edx
 496:	f7 f1                	div    %ecx
 498:	89 d0                	mov    %edx,%eax
 49a:	0f b6 80 74 0b 00 00 	movzbl 0xb74(%eax),%eax
 4a1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 4a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4a7:	01 ca                	add    %ecx,%edx
 4a9:	88 02                	mov    %al,(%edx)
 4ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 4af:	8b 55 10             	mov    0x10(%ebp),%edx
 4b2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b8:	ba 00 00 00 00       	mov    $0x0,%edx
 4bd:	f7 75 d4             	divl   -0x2c(%ebp)
 4c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c7:	75 c2                	jne    48b <printint+0x37>
  if(neg)
 4c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4cd:	74 2e                	je     4fd <printint+0xa9>
    buf[i++] = '-';
 4cf:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d5:	01 d0                	add    %edx,%eax
 4d7:	c6 00 2d             	movb   $0x2d,(%eax)
 4da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 4de:	eb 1d                	jmp    4fd <printint+0xa9>
    putc(fd, buf[i]);
 4e0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e6:	01 d0                	add    %edx,%eax
 4e8:	0f b6 00             	movzbl (%eax),%eax
 4eb:	0f be c0             	movsbl %al,%eax
 4ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f2:	8b 45 08             	mov    0x8(%ebp),%eax
 4f5:	89 04 24             	mov    %eax,(%esp)
 4f8:	e8 2f ff ff ff       	call   42c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4fd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 501:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 505:	79 d9                	jns    4e0 <printint+0x8c>
    putc(fd, buf[i]);
}
 507:	c9                   	leave  
 508:	c3                   	ret    

00000509 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 509:	55                   	push   %ebp
 50a:	89 e5                	mov    %esp,%ebp
 50c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 50f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 516:	8d 45 0c             	lea    0xc(%ebp),%eax
 519:	83 c0 04             	add    $0x4,%eax
 51c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 51f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 526:	e9 7d 01 00 00       	jmp    6a8 <printf+0x19f>
    c = fmt[i] & 0xff;
 52b:	8b 55 0c             	mov    0xc(%ebp),%edx
 52e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 531:	01 d0                	add    %edx,%eax
 533:	0f b6 00             	movzbl (%eax),%eax
 536:	0f be c0             	movsbl %al,%eax
 539:	25 ff 00 00 00       	and    $0xff,%eax
 53e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 541:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 545:	75 2c                	jne    573 <printf+0x6a>
      if(c == '%'){
 547:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 54b:	75 0c                	jne    559 <printf+0x50>
        state = '%';
 54d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 554:	e9 4b 01 00 00       	jmp    6a4 <printf+0x19b>
      } else {
        putc(fd, c);
 559:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55c:	0f be c0             	movsbl %al,%eax
 55f:	89 44 24 04          	mov    %eax,0x4(%esp)
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	89 04 24             	mov    %eax,(%esp)
 569:	e8 be fe ff ff       	call   42c <putc>
 56e:	e9 31 01 00 00       	jmp    6a4 <printf+0x19b>
      }
    } else if(state == '%'){
 573:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 577:	0f 85 27 01 00 00    	jne    6a4 <printf+0x19b>
      if(c == 'd'){
 57d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 581:	75 2d                	jne    5b0 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 583:	8b 45 e8             	mov    -0x18(%ebp),%eax
 586:	8b 00                	mov    (%eax),%eax
 588:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 58f:	00 
 590:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 597:	00 
 598:	89 44 24 04          	mov    %eax,0x4(%esp)
 59c:	8b 45 08             	mov    0x8(%ebp),%eax
 59f:	89 04 24             	mov    %eax,(%esp)
 5a2:	e8 ad fe ff ff       	call   454 <printint>
        ap++;
 5a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ab:	e9 ed 00 00 00       	jmp    69d <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 5b0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5b4:	74 06                	je     5bc <printf+0xb3>
 5b6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5ba:	75 2d                	jne    5e9 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bf:	8b 00                	mov    (%eax),%eax
 5c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5c8:	00 
 5c9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5d0:	00 
 5d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
 5d8:	89 04 24             	mov    %eax,(%esp)
 5db:	e8 74 fe ff ff       	call   454 <printint>
        ap++;
 5e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e4:	e9 b4 00 00 00       	jmp    69d <printf+0x194>
      } else if(c == 's'){
 5e9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ed:	75 46                	jne    635 <printf+0x12c>
        s = (char*)*ap;
 5ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f2:	8b 00                	mov    (%eax),%eax
 5f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ff:	75 27                	jne    628 <printf+0x11f>
          s = "(null)";
 601:	c7 45 f4 29 09 00 00 	movl   $0x929,-0xc(%ebp)
        while(*s != 0){
 608:	eb 1e                	jmp    628 <printf+0x11f>
          putc(fd, *s);
 60a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60d:	0f b6 00             	movzbl (%eax),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	89 44 24 04          	mov    %eax,0x4(%esp)
 617:	8b 45 08             	mov    0x8(%ebp),%eax
 61a:	89 04 24             	mov    %eax,(%esp)
 61d:	e8 0a fe ff ff       	call   42c <putc>
          s++;
 622:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 626:	eb 01                	jmp    629 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 628:	90                   	nop
 629:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62c:	0f b6 00             	movzbl (%eax),%eax
 62f:	84 c0                	test   %al,%al
 631:	75 d7                	jne    60a <printf+0x101>
 633:	eb 68                	jmp    69d <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 635:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 639:	75 1d                	jne    658 <printf+0x14f>
        putc(fd, *ap);
 63b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63e:	8b 00                	mov    (%eax),%eax
 640:	0f be c0             	movsbl %al,%eax
 643:	89 44 24 04          	mov    %eax,0x4(%esp)
 647:	8b 45 08             	mov    0x8(%ebp),%eax
 64a:	89 04 24             	mov    %eax,(%esp)
 64d:	e8 da fd ff ff       	call   42c <putc>
        ap++;
 652:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 656:	eb 45                	jmp    69d <printf+0x194>
      } else if(c == '%'){
 658:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 65c:	75 17                	jne    675 <printf+0x16c>
        putc(fd, c);
 65e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 661:	0f be c0             	movsbl %al,%eax
 664:	89 44 24 04          	mov    %eax,0x4(%esp)
 668:	8b 45 08             	mov    0x8(%ebp),%eax
 66b:	89 04 24             	mov    %eax,(%esp)
 66e:	e8 b9 fd ff ff       	call   42c <putc>
 673:	eb 28                	jmp    69d <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 675:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 67c:	00 
 67d:	8b 45 08             	mov    0x8(%ebp),%eax
 680:	89 04 24             	mov    %eax,(%esp)
 683:	e8 a4 fd ff ff       	call   42c <putc>
        putc(fd, c);
 688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68b:	0f be c0             	movsbl %al,%eax
 68e:	89 44 24 04          	mov    %eax,0x4(%esp)
 692:	8b 45 08             	mov    0x8(%ebp),%eax
 695:	89 04 24             	mov    %eax,(%esp)
 698:	e8 8f fd ff ff       	call   42c <putc>
      }
      state = 0;
 69d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ae:	01 d0                	add    %edx,%eax
 6b0:	0f b6 00             	movzbl (%eax),%eax
 6b3:	84 c0                	test   %al,%al
 6b5:	0f 85 70 fe ff ff    	jne    52b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6bb:	c9                   	leave  
 6bc:	c3                   	ret    
 6bd:	66 90                	xchg   %ax,%ax
 6bf:	90                   	nop

000006c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c6:	8b 45 08             	mov    0x8(%ebp),%eax
 6c9:	83 e8 08             	sub    $0x8,%eax
 6cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6cf:	a1 90 0b 00 00       	mov    0xb90,%eax
 6d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d7:	eb 24                	jmp    6fd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	8b 00                	mov    (%eax),%eax
 6de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e1:	77 12                	ja     6f5 <free+0x35>
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e9:	77 24                	ja     70f <free+0x4f>
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	8b 00                	mov    (%eax),%eax
 6f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f3:	77 1a                	ja     70f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 700:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 703:	76 d4                	jbe    6d9 <free+0x19>
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70d:	76 ca                	jbe    6d9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	8b 40 04             	mov    0x4(%eax),%eax
 715:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 71c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71f:	01 c2                	add    %eax,%edx
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	8b 00                	mov    (%eax),%eax
 726:	39 c2                	cmp    %eax,%edx
 728:	75 24                	jne    74e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 72a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72d:	8b 50 04             	mov    0x4(%eax),%edx
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 00                	mov    (%eax),%eax
 735:	8b 40 04             	mov    0x4(%eax),%eax
 738:	01 c2                	add    %eax,%edx
 73a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 00                	mov    (%eax),%eax
 745:	8b 10                	mov    (%eax),%edx
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	89 10                	mov    %edx,(%eax)
 74c:	eb 0a                	jmp    758 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	8b 10                	mov    (%eax),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 40 04             	mov    0x4(%eax),%eax
 75e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	01 d0                	add    %edx,%eax
 76a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76d:	75 20                	jne    78f <free+0xcf>
    p->s.size += bp->s.size;
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	8b 50 04             	mov    0x4(%eax),%edx
 775:	8b 45 f8             	mov    -0x8(%ebp),%eax
 778:	8b 40 04             	mov    0x4(%eax),%eax
 77b:	01 c2                	add    %eax,%edx
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	8b 10                	mov    (%eax),%edx
 788:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78b:	89 10                	mov    %edx,(%eax)
 78d:	eb 08                	jmp    797 <free+0xd7>
  } else
    p->s.ptr = bp;
 78f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 792:	8b 55 f8             	mov    -0x8(%ebp),%edx
 795:	89 10                	mov    %edx,(%eax)
  freep = p;
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	a3 90 0b 00 00       	mov    %eax,0xb90
}
 79f:	c9                   	leave  
 7a0:	c3                   	ret    

000007a1 <morecore>:

static Header*
morecore(uint nu)
{
 7a1:	55                   	push   %ebp
 7a2:	89 e5                	mov    %esp,%ebp
 7a4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7a7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ae:	77 07                	ja     7b7 <morecore+0x16>
    nu = 4096;
 7b0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7b7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ba:	c1 e0 03             	shl    $0x3,%eax
 7bd:	89 04 24             	mov    %eax,(%esp)
 7c0:	e8 3f fc ff ff       	call   404 <sbrk>
 7c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7c8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7cc:	75 07                	jne    7d5 <morecore+0x34>
    return 0;
 7ce:	b8 00 00 00 00       	mov    $0x0,%eax
 7d3:	eb 22                	jmp    7f7 <morecore+0x56>
  hp = (Header*)p;
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7de:	8b 55 08             	mov    0x8(%ebp),%edx
 7e1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e7:	83 c0 08             	add    $0x8,%eax
 7ea:	89 04 24             	mov    %eax,(%esp)
 7ed:	e8 ce fe ff ff       	call   6c0 <free>
  return freep;
 7f2:	a1 90 0b 00 00       	mov    0xb90,%eax
}
 7f7:	c9                   	leave  
 7f8:	c3                   	ret    

000007f9 <malloc>:

void*
malloc(uint nbytes)
{
 7f9:	55                   	push   %ebp
 7fa:	89 e5                	mov    %esp,%ebp
 7fc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ff:	8b 45 08             	mov    0x8(%ebp),%eax
 802:	83 c0 07             	add    $0x7,%eax
 805:	c1 e8 03             	shr    $0x3,%eax
 808:	83 c0 01             	add    $0x1,%eax
 80b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 80e:	a1 90 0b 00 00       	mov    0xb90,%eax
 813:	89 45 f0             	mov    %eax,-0x10(%ebp)
 816:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 81a:	75 23                	jne    83f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 81c:	c7 45 f0 88 0b 00 00 	movl   $0xb88,-0x10(%ebp)
 823:	8b 45 f0             	mov    -0x10(%ebp),%eax
 826:	a3 90 0b 00 00       	mov    %eax,0xb90
 82b:	a1 90 0b 00 00       	mov    0xb90,%eax
 830:	a3 88 0b 00 00       	mov    %eax,0xb88
    base.s.size = 0;
 835:	c7 05 8c 0b 00 00 00 	movl   $0x0,0xb8c
 83c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 842:	8b 00                	mov    (%eax),%eax
 844:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	8b 40 04             	mov    0x4(%eax),%eax
 84d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 850:	72 4d                	jb     89f <malloc+0xa6>
      if(p->s.size == nunits)
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	8b 40 04             	mov    0x4(%eax),%eax
 858:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85b:	75 0c                	jne    869 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	8b 10                	mov    (%eax),%edx
 862:	8b 45 f0             	mov    -0x10(%ebp),%eax
 865:	89 10                	mov    %edx,(%eax)
 867:	eb 26                	jmp    88f <malloc+0x96>
      else {
        p->s.size -= nunits;
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8b 40 04             	mov    0x4(%eax),%eax
 86f:	89 c2                	mov    %eax,%edx
 871:	2b 55 ec             	sub    -0x14(%ebp),%edx
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	8b 40 04             	mov    0x4(%eax),%eax
 880:	c1 e0 03             	shl    $0x3,%eax
 883:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	8b 55 ec             	mov    -0x14(%ebp),%edx
 88c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 88f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 892:	a3 90 0b 00 00       	mov    %eax,0xb90
      return (void*)(p + 1);
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	83 c0 08             	add    $0x8,%eax
 89d:	eb 38                	jmp    8d7 <malloc+0xde>
    }
    if(p == freep)
 89f:	a1 90 0b 00 00       	mov    0xb90,%eax
 8a4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a7:	75 1b                	jne    8c4 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ac:	89 04 24             	mov    %eax,(%esp)
 8af:	e8 ed fe ff ff       	call   7a1 <morecore>
 8b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8bb:	75 07                	jne    8c4 <malloc+0xcb>
        return 0;
 8bd:	b8 00 00 00 00       	mov    $0x0,%eax
 8c2:	eb 13                	jmp    8d7 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cd:	8b 00                	mov    (%eax),%eax
 8cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8d2:	e9 70 ff ff ff       	jmp    847 <malloc+0x4e>
}
 8d7:	c9                   	leave  
 8d8:	c3                   	ret    
