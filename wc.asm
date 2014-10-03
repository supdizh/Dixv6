
_wc：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 68                	jmp    8a <wc+0x8a>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 57                	jmp    82 <wc+0x82>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 80 0c 00 00       	add    $0xc80,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 80 0c 00 00       	add    $0xc80,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	89 44 24 04          	mov    %eax,0x4(%esp)
  54:	c7 04 24 a1 09 00 00 	movl   $0x9a1,(%esp)
  5b:	e8 61 02 00 00       	call   2c1 <strchr>
  60:	85 c0                	test   %eax,%eax
  62:	74 09                	je     6d <wc+0x6d>
        inword = 0;
  64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6b:	eb 11                	jmp    7e <wc+0x7e>
      else if(!inword){
  6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  71:	75 0b                	jne    7e <wc+0x7e>
        w++;
  73:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  77:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  85:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  88:	7c a1                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  91:	00 
  92:	c7 44 24 04 80 0c 00 	movl   $0xc80,0x4(%esp)
  99:	00 
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 b7 03 00 00       	call   45c <read>
  a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ac:	0f 8f 70 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b6:	79 19                	jns    d1 <wc+0xd1>
    printf(1, "wc: read error\n");
  b8:	c7 44 24 04 a7 09 00 	movl   $0x9a7,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 05 05 00 00       	call   5d1 <printf>
    exit();
  cc:	e8 73 03 00 00       	call   444 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  d4:	89 44 24 14          	mov    %eax,0x14(%esp)
  d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  db:	89 44 24 10          	mov    %eax,0x10(%esp)
  df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  ed:	c7 44 24 04 b7 09 00 	movl   $0x9b7,0x4(%esp)
  f4:	00 
  f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fc:	e8 d0 04 00 00       	call   5d1 <printf>
}
 101:	c9                   	leave  
 102:	c3                   	ret    

00000103 <main>:

int
main(int argc, char *argv[])
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	83 e4 f0             	and    $0xfffffff0,%esp
 109:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 10c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 110:	7f 19                	jg     12b <main+0x28>
    wc(0, "");
 112:	c7 44 24 04 c4 09 00 	movl   $0x9c4,0x4(%esp)
 119:	00 
 11a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 121:	e8 da fe ff ff       	call   0 <wc>
    exit();
 126:	e8 19 03 00 00       	call   444 <exit>
  }

  for(i = 1; i < argc; i++){
 12b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 132:	00 
 133:	e9 8f 00 00 00       	jmp    1c7 <main+0xc4>
    if((fd = open(argv[i], 0)) < 0){
 138:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 13c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 143:	8b 45 0c             	mov    0xc(%ebp),%eax
 146:	01 d0                	add    %edx,%eax
 148:	8b 00                	mov    (%eax),%eax
 14a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 151:	00 
 152:	89 04 24             	mov    %eax,(%esp)
 155:	e8 2a 03 00 00       	call   484 <open>
 15a:	89 44 24 18          	mov    %eax,0x18(%esp)
 15e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 163:	79 2f                	jns    194 <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
 165:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 170:	8b 45 0c             	mov    0xc(%ebp),%eax
 173:	01 d0                	add    %edx,%eax
 175:	8b 00                	mov    (%eax),%eax
 177:	89 44 24 08          	mov    %eax,0x8(%esp)
 17b:	c7 44 24 04 c5 09 00 	movl   $0x9c5,0x4(%esp)
 182:	00 
 183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18a:	e8 42 04 00 00       	call   5d1 <printf>
      exit();
 18f:	e8 b0 02 00 00       	call   444 <exit>
    }
    wc(fd, argv[i]);
 194:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 198:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 19f:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	8b 00                	mov    (%eax),%eax
 1a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1aa:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ae:	89 04 24             	mov    %eax,(%esp)
 1b1:	e8 4a fe ff ff       	call   0 <wc>
    close(fd);
 1b6:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ba:	89 04 24             	mov    %eax,(%esp)
 1bd:	e8 aa 02 00 00       	call   46c <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1c2:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1cb:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ce:	0f 8c 64 ff ff ff    	jl     138 <main+0x35>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1d4:	e8 6b 02 00 00       	call   444 <exit>
 1d9:	66 90                	xchg   %ax,%ax
 1db:	90                   	nop

000001dc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	57                   	push   %edi
 1e0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e4:	8b 55 10             	mov    0x10(%ebp),%edx
 1e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ea:	89 cb                	mov    %ecx,%ebx
 1ec:	89 df                	mov    %ebx,%edi
 1ee:	89 d1                	mov    %edx,%ecx
 1f0:	fc                   	cld    
 1f1:	f3 aa                	rep stos %al,%es:(%edi)
 1f3:	89 ca                	mov    %ecx,%edx
 1f5:	89 fb                	mov    %edi,%ebx
 1f7:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1fa:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1fd:	5b                   	pop    %ebx
 1fe:	5f                   	pop    %edi
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    

00000201 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 20d:	90                   	nop
 20e:	8b 45 0c             	mov    0xc(%ebp),%eax
 211:	0f b6 10             	movzbl (%eax),%edx
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	88 10                	mov    %dl,(%eax)
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	84 c0                	test   %al,%al
 221:	0f 95 c0             	setne  %al
 224:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 228:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 22c:	84 c0                	test   %al,%al
 22e:	75 de                	jne    20e <strcpy+0xd>
    ;
  return os;
 230:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 233:	c9                   	leave  
 234:	c3                   	ret    

00000235 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 238:	eb 08                	jmp    242 <strcmp+0xd>
    p++, q++;
 23a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	0f b6 00             	movzbl (%eax),%eax
 248:	84 c0                	test   %al,%al
 24a:	74 10                	je     25c <strcmp+0x27>
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	0f b6 10             	movzbl (%eax),%edx
 252:	8b 45 0c             	mov    0xc(%ebp),%eax
 255:	0f b6 00             	movzbl (%eax),%eax
 258:	38 c2                	cmp    %al,%dl
 25a:	74 de                	je     23a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f b6 d0             	movzbl %al,%edx
 265:	8b 45 0c             	mov    0xc(%ebp),%eax
 268:	0f b6 00             	movzbl (%eax),%eax
 26b:	0f b6 c0             	movzbl %al,%eax
 26e:	89 d1                	mov    %edx,%ecx
 270:	29 c1                	sub    %eax,%ecx
 272:	89 c8                	mov    %ecx,%eax
}
 274:	5d                   	pop    %ebp
 275:	c3                   	ret    

00000276 <strlen>:

uint
strlen(char *s)
{
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 27c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 283:	eb 04                	jmp    289 <strlen+0x13>
 285:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 289:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	01 d0                	add    %edx,%eax
 291:	0f b6 00             	movzbl (%eax),%eax
 294:	84 c0                	test   %al,%al
 296:	75 ed                	jne    285 <strlen+0xf>
    ;
  return n;
 298:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29b:	c9                   	leave  
 29c:	c3                   	ret    

0000029d <memset>:

void*
memset(void *dst, int c, uint n)
{
 29d:	55                   	push   %ebp
 29e:	89 e5                	mov    %esp,%ebp
 2a0:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2a3:	8b 45 10             	mov    0x10(%ebp),%eax
 2a6:	89 44 24 08          	mov    %eax,0x8(%esp)
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	89 04 24             	mov    %eax,(%esp)
 2b7:	e8 20 ff ff ff       	call   1dc <stosb>
  return dst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <strchr>:

char*
strchr(const char *s, char c)
{
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
 2c4:	83 ec 04             	sub    $0x4,%esp
 2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ca:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2cd:	eb 14                	jmp    2e3 <strchr+0x22>
    if(*s == c)
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	0f b6 00             	movzbl (%eax),%eax
 2d5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2d8:	75 05                	jne    2df <strchr+0x1e>
      return (char*)s;
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	eb 13                	jmp    2f2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2df:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	84 c0                	test   %al,%al
 2eb:	75 e2                	jne    2cf <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f2:	c9                   	leave  
 2f3:	c3                   	ret    

000002f4 <gets>:

char*
gets(char *buf, int max)
{
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 301:	eb 46                	jmp    349 <gets+0x55>
    cc = read(0, &c, 1);
 303:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 30a:	00 
 30b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 30e:	89 44 24 04          	mov    %eax,0x4(%esp)
 312:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 319:	e8 3e 01 00 00       	call   45c <read>
 31e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 321:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 325:	7e 2f                	jle    356 <gets+0x62>
      break;
    buf[i++] = c;
 327:	8b 55 f4             	mov    -0xc(%ebp),%edx
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	01 c2                	add    %eax,%edx
 32f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 333:	88 02                	mov    %al,(%edx)
 335:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 339:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 33d:	3c 0a                	cmp    $0xa,%al
 33f:	74 16                	je     357 <gets+0x63>
 341:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 345:	3c 0d                	cmp    $0xd,%al
 347:	74 0e                	je     357 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 349:	8b 45 f4             	mov    -0xc(%ebp),%eax
 34c:	83 c0 01             	add    $0x1,%eax
 34f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 352:	7c af                	jl     303 <gets+0xf>
 354:	eb 01                	jmp    357 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 356:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 357:	8b 55 f4             	mov    -0xc(%ebp),%edx
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	01 d0                	add    %edx,%eax
 35f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
}
 365:	c9                   	leave  
 366:	c3                   	ret    

00000367 <stat>:

int
stat(char *n, struct stat *st)
{
 367:	55                   	push   %ebp
 368:	89 e5                	mov    %esp,%ebp
 36a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 36d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 374:	00 
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	89 04 24             	mov    %eax,(%esp)
 37b:	e8 04 01 00 00       	call   484 <open>
 380:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 383:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 387:	79 07                	jns    390 <stat+0x29>
    return -1;
 389:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 38e:	eb 23                	jmp    3b3 <stat+0x4c>
  r = fstat(fd, st);
 390:	8b 45 0c             	mov    0xc(%ebp),%eax
 393:	89 44 24 04          	mov    %eax,0x4(%esp)
 397:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39a:	89 04 24             	mov    %eax,(%esp)
 39d:	e8 fa 00 00 00       	call   49c <fstat>
 3a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a8:	89 04 24             	mov    %eax,(%esp)
 3ab:	e8 bc 00 00 00       	call   46c <close>
  return r;
 3b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3b3:	c9                   	leave  
 3b4:	c3                   	ret    

000003b5 <atoi>:

int
atoi(const char *s)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3c2:	eb 23                	jmp    3e7 <atoi+0x32>
    n = n*10 + *s++ - '0';
 3c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c7:	89 d0                	mov    %edx,%eax
 3c9:	c1 e0 02             	shl    $0x2,%eax
 3cc:	01 d0                	add    %edx,%eax
 3ce:	01 c0                	add    %eax,%eax
 3d0:	89 c2                	mov    %eax,%edx
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	0f b6 00             	movzbl (%eax),%eax
 3d8:	0f be c0             	movsbl %al,%eax
 3db:	01 d0                	add    %edx,%eax
 3dd:	83 e8 30             	sub    $0x30,%eax
 3e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3e3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ea:	0f b6 00             	movzbl (%eax),%eax
 3ed:	3c 2f                	cmp    $0x2f,%al
 3ef:	7e 0a                	jle    3fb <atoi+0x46>
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
 3f4:	0f b6 00             	movzbl (%eax),%eax
 3f7:	3c 39                	cmp    $0x39,%al
 3f9:	7e c9                	jle    3c4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3fe:	c9                   	leave  
 3ff:	c3                   	ret    

00000400 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 40c:	8b 45 0c             	mov    0xc(%ebp),%eax
 40f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 412:	eb 13                	jmp    427 <memmove+0x27>
    *dst++ = *src++;
 414:	8b 45 f8             	mov    -0x8(%ebp),%eax
 417:	0f b6 10             	movzbl (%eax),%edx
 41a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 41d:	88 10                	mov    %dl,(%eax)
 41f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 423:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 42b:	0f 9f c0             	setg   %al
 42e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 432:	84 c0                	test   %al,%al
 434:	75 de                	jne    414 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 436:	8b 45 08             	mov    0x8(%ebp),%eax
}
 439:	c9                   	leave  
 43a:	c3                   	ret    
 43b:	90                   	nop

0000043c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 43c:	b8 01 00 00 00       	mov    $0x1,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <exit>:
SYSCALL(exit)
 444:	b8 02 00 00 00       	mov    $0x2,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <wait>:
SYSCALL(wait)
 44c:	b8 03 00 00 00       	mov    $0x3,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <pipe>:
SYSCALL(pipe)
 454:	b8 04 00 00 00       	mov    $0x4,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <read>:
SYSCALL(read)
 45c:	b8 05 00 00 00       	mov    $0x5,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <write>:
SYSCALL(write)
 464:	b8 10 00 00 00       	mov    $0x10,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <close>:
SYSCALL(close)
 46c:	b8 15 00 00 00       	mov    $0x15,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <kill>:
SYSCALL(kill)
 474:	b8 06 00 00 00       	mov    $0x6,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <exec>:
SYSCALL(exec)
 47c:	b8 07 00 00 00       	mov    $0x7,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <open>:
SYSCALL(open)
 484:	b8 0f 00 00 00       	mov    $0xf,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <mknod>:
SYSCALL(mknod)
 48c:	b8 11 00 00 00       	mov    $0x11,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <unlink>:
SYSCALL(unlink)
 494:	b8 12 00 00 00       	mov    $0x12,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <fstat>:
SYSCALL(fstat)
 49c:	b8 08 00 00 00       	mov    $0x8,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <link>:
SYSCALL(link)
 4a4:	b8 13 00 00 00       	mov    $0x13,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <mkdir>:
SYSCALL(mkdir)
 4ac:	b8 14 00 00 00       	mov    $0x14,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <chdir>:
SYSCALL(chdir)
 4b4:	b8 09 00 00 00       	mov    $0x9,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <dup>:
SYSCALL(dup)
 4bc:	b8 0a 00 00 00       	mov    $0xa,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <getpid>:
SYSCALL(getpid)
 4c4:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <sbrk>:
SYSCALL(sbrk)
 4cc:	b8 0c 00 00 00       	mov    $0xc,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <sleep>:
SYSCALL(sleep)
 4d4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <uptime>:
SYSCALL(uptime)
 4dc:	b8 0e 00 00 00       	mov    $0xe,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <halt>:
SYSCALL(halt)
 4e4:	b8 16 00 00 00       	mov    $0x16,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <alarm>:
 4ec:	b8 17 00 00 00       	mov    $0x17,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4f4:	55                   	push   %ebp
 4f5:	89 e5                	mov    %esp,%ebp
 4f7:	83 ec 28             	sub    $0x28,%esp
 4fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 500:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 507:	00 
 508:	8d 45 f4             	lea    -0xc(%ebp),%eax
 50b:	89 44 24 04          	mov    %eax,0x4(%esp)
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	89 04 24             	mov    %eax,(%esp)
 515:	e8 4a ff ff ff       	call   464 <write>
}
 51a:	c9                   	leave  
 51b:	c3                   	ret    

0000051c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51c:	55                   	push   %ebp
 51d:	89 e5                	mov    %esp,%ebp
 51f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 522:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 529:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 52d:	74 17                	je     546 <printint+0x2a>
 52f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 533:	79 11                	jns    546 <printint+0x2a>
    neg = 1;
 535:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 53c:	8b 45 0c             	mov    0xc(%ebp),%eax
 53f:	f7 d8                	neg    %eax
 541:	89 45 ec             	mov    %eax,-0x14(%ebp)
 544:	eb 06                	jmp    54c <printint+0x30>
  } else {
    x = xx;
 546:	8b 45 0c             	mov    0xc(%ebp),%eax
 549:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 54c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 553:	8b 4d 10             	mov    0x10(%ebp),%ecx
 556:	8b 45 ec             	mov    -0x14(%ebp),%eax
 559:	ba 00 00 00 00       	mov    $0x0,%edx
 55e:	f7 f1                	div    %ecx
 560:	89 d0                	mov    %edx,%eax
 562:	0f b6 80 3c 0c 00 00 	movzbl 0xc3c(%eax),%eax
 569:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 56c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 56f:	01 ca                	add    %ecx,%edx
 571:	88 02                	mov    %al,(%edx)
 573:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 577:	8b 55 10             	mov    0x10(%ebp),%edx
 57a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 57d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 580:	ba 00 00 00 00       	mov    $0x0,%edx
 585:	f7 75 d4             	divl   -0x2c(%ebp)
 588:	89 45 ec             	mov    %eax,-0x14(%ebp)
 58b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 58f:	75 c2                	jne    553 <printint+0x37>
  if(neg)
 591:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 595:	74 2e                	je     5c5 <printint+0xa9>
    buf[i++] = '-';
 597:	8d 55 dc             	lea    -0x24(%ebp),%edx
 59a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59d:	01 d0                	add    %edx,%eax
 59f:	c6 00 2d             	movb   $0x2d,(%eax)
 5a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 5a6:	eb 1d                	jmp    5c5 <printint+0xa9>
    putc(fd, buf[i]);
 5a8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ae:	01 d0                	add    %edx,%eax
 5b0:	0f b6 00             	movzbl (%eax),%eax
 5b3:	0f be c0             	movsbl %al,%eax
 5b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ba:	8b 45 08             	mov    0x8(%ebp),%eax
 5bd:	89 04 24             	mov    %eax,(%esp)
 5c0:	e8 2f ff ff ff       	call   4f4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5c5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5cd:	79 d9                	jns    5a8 <printint+0x8c>
    putc(fd, buf[i]);
}
 5cf:	c9                   	leave  
 5d0:	c3                   	ret    

000005d1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5d1:	55                   	push   %ebp
 5d2:	89 e5                	mov    %esp,%ebp
 5d4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5de:	8d 45 0c             	lea    0xc(%ebp),%eax
 5e1:	83 c0 04             	add    $0x4,%eax
 5e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5ee:	e9 7d 01 00 00       	jmp    770 <printf+0x19f>
    c = fmt[i] & 0xff;
 5f3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f9:	01 d0                	add    %edx,%eax
 5fb:	0f b6 00             	movzbl (%eax),%eax
 5fe:	0f be c0             	movsbl %al,%eax
 601:	25 ff 00 00 00       	and    $0xff,%eax
 606:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 609:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 60d:	75 2c                	jne    63b <printf+0x6a>
      if(c == '%'){
 60f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 613:	75 0c                	jne    621 <printf+0x50>
        state = '%';
 615:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 61c:	e9 4b 01 00 00       	jmp    76c <printf+0x19b>
      } else {
        putc(fd, c);
 621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 624:	0f be c0             	movsbl %al,%eax
 627:	89 44 24 04          	mov    %eax,0x4(%esp)
 62b:	8b 45 08             	mov    0x8(%ebp),%eax
 62e:	89 04 24             	mov    %eax,(%esp)
 631:	e8 be fe ff ff       	call   4f4 <putc>
 636:	e9 31 01 00 00       	jmp    76c <printf+0x19b>
      }
    } else if(state == '%'){
 63b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 63f:	0f 85 27 01 00 00    	jne    76c <printf+0x19b>
      if(c == 'd'){
 645:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 649:	75 2d                	jne    678 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 64b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 657:	00 
 658:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 65f:	00 
 660:	89 44 24 04          	mov    %eax,0x4(%esp)
 664:	8b 45 08             	mov    0x8(%ebp),%eax
 667:	89 04 24             	mov    %eax,(%esp)
 66a:	e8 ad fe ff ff       	call   51c <printint>
        ap++;
 66f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 673:	e9 ed 00 00 00       	jmp    765 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 678:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 67c:	74 06                	je     684 <printf+0xb3>
 67e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 682:	75 2d                	jne    6b1 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 684:	8b 45 e8             	mov    -0x18(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 690:	00 
 691:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 698:	00 
 699:	89 44 24 04          	mov    %eax,0x4(%esp)
 69d:	8b 45 08             	mov    0x8(%ebp),%eax
 6a0:	89 04 24             	mov    %eax,(%esp)
 6a3:	e8 74 fe ff ff       	call   51c <printint>
        ap++;
 6a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ac:	e9 b4 00 00 00       	jmp    765 <printf+0x194>
      } else if(c == 's'){
 6b1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6b5:	75 46                	jne    6fd <printf+0x12c>
        s = (char*)*ap;
 6b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6bf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6c7:	75 27                	jne    6f0 <printf+0x11f>
          s = "(null)";
 6c9:	c7 45 f4 d9 09 00 00 	movl   $0x9d9,-0xc(%ebp)
        while(*s != 0){
 6d0:	eb 1e                	jmp    6f0 <printf+0x11f>
          putc(fd, *s);
 6d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d5:	0f b6 00             	movzbl (%eax),%eax
 6d8:	0f be c0             	movsbl %al,%eax
 6db:	89 44 24 04          	mov    %eax,0x4(%esp)
 6df:	8b 45 08             	mov    0x8(%ebp),%eax
 6e2:	89 04 24             	mov    %eax,(%esp)
 6e5:	e8 0a fe ff ff       	call   4f4 <putc>
          s++;
 6ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 6ee:	eb 01                	jmp    6f1 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6f0:	90                   	nop
 6f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f4:	0f b6 00             	movzbl (%eax),%eax
 6f7:	84 c0                	test   %al,%al
 6f9:	75 d7                	jne    6d2 <printf+0x101>
 6fb:	eb 68                	jmp    765 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6fd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 701:	75 1d                	jne    720 <printf+0x14f>
        putc(fd, *ap);
 703:	8b 45 e8             	mov    -0x18(%ebp),%eax
 706:	8b 00                	mov    (%eax),%eax
 708:	0f be c0             	movsbl %al,%eax
 70b:	89 44 24 04          	mov    %eax,0x4(%esp)
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	89 04 24             	mov    %eax,(%esp)
 715:	e8 da fd ff ff       	call   4f4 <putc>
        ap++;
 71a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 71e:	eb 45                	jmp    765 <printf+0x194>
      } else if(c == '%'){
 720:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 724:	75 17                	jne    73d <printf+0x16c>
        putc(fd, c);
 726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 729:	0f be c0             	movsbl %al,%eax
 72c:	89 44 24 04          	mov    %eax,0x4(%esp)
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	89 04 24             	mov    %eax,(%esp)
 736:	e8 b9 fd ff ff       	call   4f4 <putc>
 73b:	eb 28                	jmp    765 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 73d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 744:	00 
 745:	8b 45 08             	mov    0x8(%ebp),%eax
 748:	89 04 24             	mov    %eax,(%esp)
 74b:	e8 a4 fd ff ff       	call   4f4 <putc>
        putc(fd, c);
 750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 753:	0f be c0             	movsbl %al,%eax
 756:	89 44 24 04          	mov    %eax,0x4(%esp)
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
 75d:	89 04 24             	mov    %eax,(%esp)
 760:	e8 8f fd ff ff       	call   4f4 <putc>
      }
      state = 0;
 765:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 76c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 770:	8b 55 0c             	mov    0xc(%ebp),%edx
 773:	8b 45 f0             	mov    -0x10(%ebp),%eax
 776:	01 d0                	add    %edx,%eax
 778:	0f b6 00             	movzbl (%eax),%eax
 77b:	84 c0                	test   %al,%al
 77d:	0f 85 70 fe ff ff    	jne    5f3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 783:	c9                   	leave  
 784:	c3                   	ret    
 785:	66 90                	xchg   %ax,%ax
 787:	90                   	nop

00000788 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 788:	55                   	push   %ebp
 789:	89 e5                	mov    %esp,%ebp
 78b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78e:	8b 45 08             	mov    0x8(%ebp),%eax
 791:	83 e8 08             	sub    $0x8,%eax
 794:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 797:	a1 68 0c 00 00       	mov    0xc68,%eax
 79c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 79f:	eb 24                	jmp    7c5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a9:	77 12                	ja     7bd <free+0x35>
 7ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b1:	77 24                	ja     7d7 <free+0x4f>
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7bb:	77 1a                	ja     7d7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7cb:	76 d4                	jbe    7a1 <free+0x19>
 7cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d0:	8b 00                	mov    (%eax),%eax
 7d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d5:	76 ca                	jbe    7a1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7da:	8b 40 04             	mov    0x4(%eax),%eax
 7dd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e7:	01 c2                	add    %eax,%edx
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	39 c2                	cmp    %eax,%edx
 7f0:	75 24                	jne    816 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f5:	8b 50 04             	mov    0x4(%eax),%edx
 7f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fb:	8b 00                	mov    (%eax),%eax
 7fd:	8b 40 04             	mov    0x4(%eax),%eax
 800:	01 c2                	add    %eax,%edx
 802:	8b 45 f8             	mov    -0x8(%ebp),%eax
 805:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 808:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80b:	8b 00                	mov    (%eax),%eax
 80d:	8b 10                	mov    (%eax),%edx
 80f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 812:	89 10                	mov    %edx,(%eax)
 814:	eb 0a                	jmp    820 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	8b 10                	mov    (%eax),%edx
 81b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 820:	8b 45 fc             	mov    -0x4(%ebp),%eax
 823:	8b 40 04             	mov    0x4(%eax),%eax
 826:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	01 d0                	add    %edx,%eax
 832:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 835:	75 20                	jne    857 <free+0xcf>
    p->s.size += bp->s.size;
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	8b 50 04             	mov    0x4(%eax),%edx
 83d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 840:	8b 40 04             	mov    0x4(%eax),%eax
 843:	01 c2                	add    %eax,%edx
 845:	8b 45 fc             	mov    -0x4(%ebp),%eax
 848:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 84b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84e:	8b 10                	mov    (%eax),%edx
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	89 10                	mov    %edx,(%eax)
 855:	eb 08                	jmp    85f <free+0xd7>
  } else
    p->s.ptr = bp;
 857:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 85d:	89 10                	mov    %edx,(%eax)
  freep = p;
 85f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 862:	a3 68 0c 00 00       	mov    %eax,0xc68
}
 867:	c9                   	leave  
 868:	c3                   	ret    

00000869 <morecore>:

static Header*
morecore(uint nu)
{
 869:	55                   	push   %ebp
 86a:	89 e5                	mov    %esp,%ebp
 86c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 86f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 876:	77 07                	ja     87f <morecore+0x16>
    nu = 4096;
 878:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 87f:	8b 45 08             	mov    0x8(%ebp),%eax
 882:	c1 e0 03             	shl    $0x3,%eax
 885:	89 04 24             	mov    %eax,(%esp)
 888:	e8 3f fc ff ff       	call   4cc <sbrk>
 88d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 890:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 894:	75 07                	jne    89d <morecore+0x34>
    return 0;
 896:	b8 00 00 00 00       	mov    $0x0,%eax
 89b:	eb 22                	jmp    8bf <morecore+0x56>
  hp = (Header*)p;
 89d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a6:	8b 55 08             	mov    0x8(%ebp),%edx
 8a9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8af:	83 c0 08             	add    $0x8,%eax
 8b2:	89 04 24             	mov    %eax,(%esp)
 8b5:	e8 ce fe ff ff       	call   788 <free>
  return freep;
 8ba:	a1 68 0c 00 00       	mov    0xc68,%eax
}
 8bf:	c9                   	leave  
 8c0:	c3                   	ret    

000008c1 <malloc>:

void*
malloc(uint nbytes)
{
 8c1:	55                   	push   %ebp
 8c2:	89 e5                	mov    %esp,%ebp
 8c4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ca:	83 c0 07             	add    $0x7,%eax
 8cd:	c1 e8 03             	shr    $0x3,%eax
 8d0:	83 c0 01             	add    $0x1,%eax
 8d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8d6:	a1 68 0c 00 00       	mov    0xc68,%eax
 8db:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e2:	75 23                	jne    907 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8e4:	c7 45 f0 60 0c 00 00 	movl   $0xc60,-0x10(%ebp)
 8eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ee:	a3 68 0c 00 00       	mov    %eax,0xc68
 8f3:	a1 68 0c 00 00       	mov    0xc68,%eax
 8f8:	a3 60 0c 00 00       	mov    %eax,0xc60
    base.s.size = 0;
 8fd:	c7 05 64 0c 00 00 00 	movl   $0x0,0xc64
 904:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 907:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90a:	8b 00                	mov    (%eax),%eax
 90c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 90f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 912:	8b 40 04             	mov    0x4(%eax),%eax
 915:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 918:	72 4d                	jb     967 <malloc+0xa6>
      if(p->s.size == nunits)
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	8b 40 04             	mov    0x4(%eax),%eax
 920:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 923:	75 0c                	jne    931 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 925:	8b 45 f4             	mov    -0xc(%ebp),%eax
 928:	8b 10                	mov    (%eax),%edx
 92a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92d:	89 10                	mov    %edx,(%eax)
 92f:	eb 26                	jmp    957 <malloc+0x96>
      else {
        p->s.size -= nunits;
 931:	8b 45 f4             	mov    -0xc(%ebp),%eax
 934:	8b 40 04             	mov    0x4(%eax),%eax
 937:	89 c2                	mov    %eax,%edx
 939:	2b 55 ec             	sub    -0x14(%ebp),%edx
 93c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 942:	8b 45 f4             	mov    -0xc(%ebp),%eax
 945:	8b 40 04             	mov    0x4(%eax),%eax
 948:	c1 e0 03             	shl    $0x3,%eax
 94b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 94e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 951:	8b 55 ec             	mov    -0x14(%ebp),%edx
 954:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 957:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95a:	a3 68 0c 00 00       	mov    %eax,0xc68
      return (void*)(p + 1);
 95f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 962:	83 c0 08             	add    $0x8,%eax
 965:	eb 38                	jmp    99f <malloc+0xde>
    }
    if(p == freep)
 967:	a1 68 0c 00 00       	mov    0xc68,%eax
 96c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 96f:	75 1b                	jne    98c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 971:	8b 45 ec             	mov    -0x14(%ebp),%eax
 974:	89 04 24             	mov    %eax,(%esp)
 977:	e8 ed fe ff ff       	call   869 <morecore>
 97c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 97f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 983:	75 07                	jne    98c <malloc+0xcb>
        return 0;
 985:	b8 00 00 00 00       	mov    $0x0,%eax
 98a:	eb 13                	jmp    99f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 992:	8b 45 f4             	mov    -0xc(%ebp),%eax
 995:	8b 00                	mov    (%eax),%eax
 997:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 99a:	e9 70 ff ff ff       	jmp    90f <malloc+0x4e>
}
 99f:	c9                   	leave  
 9a0:	c3                   	ret    
