
_cat：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 c0 0b 00 	movl   $0xbc0,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 85 03 00 00       	call   3a8 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 c0 0b 00 	movl   $0xbc0,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 62 03 00 00       	call   3a0 <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 e5 08 00 	movl   $0x8e5,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 b4 04 00 00       	call   515 <printf>
    exit();
  61:	e8 22 03 00 00       	call   388 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(int argc, char *argv[])
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  71:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  75:	7f 11                	jg     88 <main+0x20>
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 7d ff ff ff       	call   0 <cat>
    exit();
  83:	e8 00 03 00 00       	call   388 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 79                	jmp    10b <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  a2:	8b 00                	mov    (%eax),%eax
  a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ab:	00 
  ac:	89 04 24             	mov    %eax,(%esp)
  af:	e8 14 03 00 00       	call   3c8 <open>
  b4:	89 44 24 18          	mov    %eax,0x18(%esp)
  b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  bd:	79 2f                	jns    ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	01 d0                	add    %edx,%eax
  cf:	8b 00                	mov    (%eax),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	c7 44 24 04 f6 08 00 	movl   $0x8f6,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 2c 04 00 00       	call   515 <printf>
      exit();
  e9:	e8 9a 02 00 00       	call   388 <exit>
    }
    cat(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 06 ff ff ff       	call   0 <cat>
    close(fd);
  fa:	8b 44 24 18          	mov    0x18(%esp),%eax
  fe:	89 04 24             	mov    %eax,(%esp)
 101:	e8 aa 02 00 00       	call   3b0 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
 106:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 10b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10f:	3b 45 08             	cmp    0x8(%ebp),%eax
 112:	0f 8c 7a ff ff ff    	jl     92 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 118:	e8 6b 02 00 00       	call   388 <exit>
 11d:	66 90                	xchg   %ax,%ax
 11f:	90                   	nop

00000120 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 125:	8b 4d 08             	mov    0x8(%ebp),%ecx
 128:	8b 55 10             	mov    0x10(%ebp),%edx
 12b:	8b 45 0c             	mov    0xc(%ebp),%eax
 12e:	89 cb                	mov    %ecx,%ebx
 130:	89 df                	mov    %ebx,%edi
 132:	89 d1                	mov    %edx,%ecx
 134:	fc                   	cld    
 135:	f3 aa                	rep stos %al,%es:(%edi)
 137:	89 ca                	mov    %ecx,%edx
 139:	89 fb                	mov    %edi,%ebx
 13b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 141:	5b                   	pop    %ebx
 142:	5f                   	pop    %edi
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    

00000145 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
 148:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 151:	90                   	nop
 152:	8b 45 0c             	mov    0xc(%ebp),%eax
 155:	0f b6 10             	movzbl (%eax),%edx
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	88 10                	mov    %dl,(%eax)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	84 c0                	test   %al,%al
 165:	0f 95 c0             	setne  %al
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 170:	84 c0                	test   %al,%al
 172:	75 de                	jne    152 <strcpy+0xd>
    ;
  return os;
 174:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 177:	c9                   	leave  
 178:	c3                   	ret    

00000179 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 179:	55                   	push   %ebp
 17a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 17c:	eb 08                	jmp    186 <strcmp+0xd>
    p++, q++;
 17e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 182:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	0f b6 00             	movzbl (%eax),%eax
 18c:	84 c0                	test   %al,%al
 18e:	74 10                	je     1a0 <strcmp+0x27>
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	0f b6 10             	movzbl (%eax),%edx
 196:	8b 45 0c             	mov    0xc(%ebp),%eax
 199:	0f b6 00             	movzbl (%eax),%eax
 19c:	38 c2                	cmp    %al,%dl
 19e:	74 de                	je     17e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	0f b6 d0             	movzbl %al,%edx
 1a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ac:	0f b6 00             	movzbl (%eax),%eax
 1af:	0f b6 c0             	movzbl %al,%eax
 1b2:	89 d1                	mov    %edx,%ecx
 1b4:	29 c1                	sub    %eax,%ecx
 1b6:	89 c8                	mov    %ecx,%eax
}
 1b8:	5d                   	pop    %ebp
 1b9:	c3                   	ret    

000001ba <strlen>:

uint
strlen(char *s)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
 1bd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c7:	eb 04                	jmp    1cd <strlen+0x13>
 1c9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	0f b6 00             	movzbl (%eax),%eax
 1d8:	84 c0                	test   %al,%al
 1da:	75 ed                	jne    1c9 <strlen+0xf>
    ;
  return n;
 1dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1df:	c9                   	leave  
 1e0:	c3                   	ret    

000001e1 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1e7:	8b 45 10             	mov    0x10(%ebp),%eax
 1ea:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f1:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	89 04 24             	mov    %eax,(%esp)
 1fb:	e8 20 ff ff ff       	call   120 <stosb>
  return dst;
 200:	8b 45 08             	mov    0x8(%ebp),%eax
}
 203:	c9                   	leave  
 204:	c3                   	ret    

00000205 <strchr>:

char*
strchr(const char *s, char c)
{
 205:	55                   	push   %ebp
 206:	89 e5                	mov    %esp,%ebp
 208:	83 ec 04             	sub    $0x4,%esp
 20b:	8b 45 0c             	mov    0xc(%ebp),%eax
 20e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 211:	eb 14                	jmp    227 <strchr+0x22>
    if(*s == c)
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	0f b6 00             	movzbl (%eax),%eax
 219:	3a 45 fc             	cmp    -0x4(%ebp),%al
 21c:	75 05                	jne    223 <strchr+0x1e>
      return (char*)s;
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	eb 13                	jmp    236 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 223:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	0f b6 00             	movzbl (%eax),%eax
 22d:	84 c0                	test   %al,%al
 22f:	75 e2                	jne    213 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 231:	b8 00 00 00 00       	mov    $0x0,%eax
}
 236:	c9                   	leave  
 237:	c3                   	ret    

00000238 <gets>:

char*
gets(char *buf, int max)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 245:	eb 46                	jmp    28d <gets+0x55>
    cc = read(0, &c, 1);
 247:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 24e:	00 
 24f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 252:	89 44 24 04          	mov    %eax,0x4(%esp)
 256:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 25d:	e8 3e 01 00 00       	call   3a0 <read>
 262:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 265:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 269:	7e 2f                	jle    29a <gets+0x62>
      break;
    buf[i++] = c;
 26b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	01 c2                	add    %eax,%edx
 273:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 277:	88 02                	mov    %al,(%edx)
 279:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 27d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 281:	3c 0a                	cmp    $0xa,%al
 283:	74 16                	je     29b <gets+0x63>
 285:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 289:	3c 0d                	cmp    $0xd,%al
 28b:	74 0e                	je     29b <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 290:	83 c0 01             	add    $0x1,%eax
 293:	3b 45 0c             	cmp    0xc(%ebp),%eax
 296:	7c af                	jl     247 <gets+0xf>
 298:	eb 01                	jmp    29b <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 29a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 29b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	01 d0                	add    %edx,%eax
 2a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a9:	c9                   	leave  
 2aa:	c3                   	ret    

000002ab <stat>:

int
stat(char *n, struct stat *st)
{
 2ab:	55                   	push   %ebp
 2ac:	89 e5                	mov    %esp,%ebp
 2ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2b8:	00 
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	89 04 24             	mov    %eax,(%esp)
 2bf:	e8 04 01 00 00       	call   3c8 <open>
 2c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2cb:	79 07                	jns    2d4 <stat+0x29>
    return -1;
 2cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2d2:	eb 23                	jmp    2f7 <stat+0x4c>
  r = fstat(fd, st);
 2d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 2db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2de:	89 04 24             	mov    %eax,(%esp)
 2e1:	e8 fa 00 00 00       	call   3e0 <fstat>
 2e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ec:	89 04 24             	mov    %eax,(%esp)
 2ef:	e8 bc 00 00 00       	call   3b0 <close>
  return r;
 2f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <atoi>:

int
atoi(const char *s)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 306:	eb 23                	jmp    32b <atoi+0x32>
    n = n*10 + *s++ - '0';
 308:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30b:	89 d0                	mov    %edx,%eax
 30d:	c1 e0 02             	shl    $0x2,%eax
 310:	01 d0                	add    %edx,%eax
 312:	01 c0                	add    %eax,%eax
 314:	89 c2                	mov    %eax,%edx
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	0f be c0             	movsbl %al,%eax
 31f:	01 d0                	add    %edx,%eax
 321:	83 e8 30             	sub    $0x30,%eax
 324:	89 45 fc             	mov    %eax,-0x4(%ebp)
 327:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	0f b6 00             	movzbl (%eax),%eax
 331:	3c 2f                	cmp    $0x2f,%al
 333:	7e 0a                	jle    33f <atoi+0x46>
 335:	8b 45 08             	mov    0x8(%ebp),%eax
 338:	0f b6 00             	movzbl (%eax),%eax
 33b:	3c 39                	cmp    $0x39,%al
 33d:	7e c9                	jle    308 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 33f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 342:	c9                   	leave  
 343:	c3                   	ret    

00000344 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 350:	8b 45 0c             	mov    0xc(%ebp),%eax
 353:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 356:	eb 13                	jmp    36b <memmove+0x27>
    *dst++ = *src++;
 358:	8b 45 f8             	mov    -0x8(%ebp),%eax
 35b:	0f b6 10             	movzbl (%eax),%edx
 35e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 361:	88 10                	mov    %dl,(%eax)
 363:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 367:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 36b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 36f:	0f 9f c0             	setg   %al
 372:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 376:	84 c0                	test   %al,%al
 378:	75 de                	jne    358 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 37a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37d:	c9                   	leave  
 37e:	c3                   	ret    
 37f:	90                   	nop

00000380 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 380:	b8 01 00 00 00       	mov    $0x1,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <exit>:
SYSCALL(exit)
 388:	b8 02 00 00 00       	mov    $0x2,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <wait>:
SYSCALL(wait)
 390:	b8 03 00 00 00       	mov    $0x3,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <pipe>:
SYSCALL(pipe)
 398:	b8 04 00 00 00       	mov    $0x4,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <read>:
SYSCALL(read)
 3a0:	b8 05 00 00 00       	mov    $0x5,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <write>:
SYSCALL(write)
 3a8:	b8 10 00 00 00       	mov    $0x10,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <close>:
SYSCALL(close)
 3b0:	b8 15 00 00 00       	mov    $0x15,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <kill>:
SYSCALL(kill)
 3b8:	b8 06 00 00 00       	mov    $0x6,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <exec>:
SYSCALL(exec)
 3c0:	b8 07 00 00 00       	mov    $0x7,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <open>:
SYSCALL(open)
 3c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <mknod>:
SYSCALL(mknod)
 3d0:	b8 11 00 00 00       	mov    $0x11,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <unlink>:
SYSCALL(unlink)
 3d8:	b8 12 00 00 00       	mov    $0x12,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <fstat>:
SYSCALL(fstat)
 3e0:	b8 08 00 00 00       	mov    $0x8,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <link>:
SYSCALL(link)
 3e8:	b8 13 00 00 00       	mov    $0x13,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <mkdir>:
SYSCALL(mkdir)
 3f0:	b8 14 00 00 00       	mov    $0x14,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <chdir>:
SYSCALL(chdir)
 3f8:	b8 09 00 00 00       	mov    $0x9,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <dup>:
SYSCALL(dup)
 400:	b8 0a 00 00 00       	mov    $0xa,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <getpid>:
SYSCALL(getpid)
 408:	b8 0b 00 00 00       	mov    $0xb,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <sbrk>:
SYSCALL(sbrk)
 410:	b8 0c 00 00 00       	mov    $0xc,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <sleep>:
SYSCALL(sleep)
 418:	b8 0d 00 00 00       	mov    $0xd,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <uptime>:
SYSCALL(uptime)
 420:	b8 0e 00 00 00       	mov    $0xe,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <halt>:
SYSCALL(halt)
 428:	b8 16 00 00 00       	mov    $0x16,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <alarm>:
 430:	b8 17 00 00 00       	mov    $0x17,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 438:	55                   	push   %ebp
 439:	89 e5                	mov    %esp,%ebp
 43b:	83 ec 28             	sub    $0x28,%esp
 43e:	8b 45 0c             	mov    0xc(%ebp),%eax
 441:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 444:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 44b:	00 
 44c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 44f:	89 44 24 04          	mov    %eax,0x4(%esp)
 453:	8b 45 08             	mov    0x8(%ebp),%eax
 456:	89 04 24             	mov    %eax,(%esp)
 459:	e8 4a ff ff ff       	call   3a8 <write>
}
 45e:	c9                   	leave  
 45f:	c3                   	ret    

00000460 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 466:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 46d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 471:	74 17                	je     48a <printint+0x2a>
 473:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 477:	79 11                	jns    48a <printint+0x2a>
    neg = 1;
 479:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 480:	8b 45 0c             	mov    0xc(%ebp),%eax
 483:	f7 d8                	neg    %eax
 485:	89 45 ec             	mov    %eax,-0x14(%ebp)
 488:	eb 06                	jmp    490 <printint+0x30>
  } else {
    x = xx;
 48a:	8b 45 0c             	mov    0xc(%ebp),%eax
 48d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 490:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 497:	8b 4d 10             	mov    0x10(%ebp),%ecx
 49a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 49d:	ba 00 00 00 00       	mov    $0x0,%edx
 4a2:	f7 f1                	div    %ecx
 4a4:	89 d0                	mov    %edx,%eax
 4a6:	0f b6 80 70 0b 00 00 	movzbl 0xb70(%eax),%eax
 4ad:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 4b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4b3:	01 ca                	add    %ecx,%edx
 4b5:	88 02                	mov    %al,(%edx)
 4b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 4bb:	8b 55 10             	mov    0x10(%ebp),%edx
 4be:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c4:	ba 00 00 00 00       	mov    $0x0,%edx
 4c9:	f7 75 d4             	divl   -0x2c(%ebp)
 4cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d3:	75 c2                	jne    497 <printint+0x37>
  if(neg)
 4d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4d9:	74 2e                	je     509 <printint+0xa9>
    buf[i++] = '-';
 4db:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e1:	01 d0                	add    %edx,%eax
 4e3:	c6 00 2d             	movb   $0x2d,(%eax)
 4e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 4ea:	eb 1d                	jmp    509 <printint+0xa9>
    putc(fd, buf[i]);
 4ec:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f2:	01 d0                	add    %edx,%eax
 4f4:	0f b6 00             	movzbl (%eax),%eax
 4f7:	0f be c0             	movsbl %al,%eax
 4fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fe:	8b 45 08             	mov    0x8(%ebp),%eax
 501:	89 04 24             	mov    %eax,(%esp)
 504:	e8 2f ff ff ff       	call   438 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 509:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 50d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 511:	79 d9                	jns    4ec <printint+0x8c>
    putc(fd, buf[i]);
}
 513:	c9                   	leave  
 514:	c3                   	ret    

00000515 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 515:	55                   	push   %ebp
 516:	89 e5                	mov    %esp,%ebp
 518:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 51b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 522:	8d 45 0c             	lea    0xc(%ebp),%eax
 525:	83 c0 04             	add    $0x4,%eax
 528:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 52b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 532:	e9 7d 01 00 00       	jmp    6b4 <printf+0x19f>
    c = fmt[i] & 0xff;
 537:	8b 55 0c             	mov    0xc(%ebp),%edx
 53a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 53d:	01 d0                	add    %edx,%eax
 53f:	0f b6 00             	movzbl (%eax),%eax
 542:	0f be c0             	movsbl %al,%eax
 545:	25 ff 00 00 00       	and    $0xff,%eax
 54a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 54d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 551:	75 2c                	jne    57f <printf+0x6a>
      if(c == '%'){
 553:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 557:	75 0c                	jne    565 <printf+0x50>
        state = '%';
 559:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 560:	e9 4b 01 00 00       	jmp    6b0 <printf+0x19b>
      } else {
        putc(fd, c);
 565:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 568:	0f be c0             	movsbl %al,%eax
 56b:	89 44 24 04          	mov    %eax,0x4(%esp)
 56f:	8b 45 08             	mov    0x8(%ebp),%eax
 572:	89 04 24             	mov    %eax,(%esp)
 575:	e8 be fe ff ff       	call   438 <putc>
 57a:	e9 31 01 00 00       	jmp    6b0 <printf+0x19b>
      }
    } else if(state == '%'){
 57f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 583:	0f 85 27 01 00 00    	jne    6b0 <printf+0x19b>
      if(c == 'd'){
 589:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 58d:	75 2d                	jne    5bc <printf+0xa7>
        printint(fd, *ap, 10, 1);
 58f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 592:	8b 00                	mov    (%eax),%eax
 594:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 59b:	00 
 59c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5a3:	00 
 5a4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	89 04 24             	mov    %eax,(%esp)
 5ae:	e8 ad fe ff ff       	call   460 <printint>
        ap++;
 5b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b7:	e9 ed 00 00 00       	jmp    6a9 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 5bc:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5c0:	74 06                	je     5c8 <printf+0xb3>
 5c2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5c6:	75 2d                	jne    5f5 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cb:	8b 00                	mov    (%eax),%eax
 5cd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5d4:	00 
 5d5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5dc:	00 
 5dd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e1:	8b 45 08             	mov    0x8(%ebp),%eax
 5e4:	89 04 24             	mov    %eax,(%esp)
 5e7:	e8 74 fe ff ff       	call   460 <printint>
        ap++;
 5ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f0:	e9 b4 00 00 00       	jmp    6a9 <printf+0x194>
      } else if(c == 's'){
 5f5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5f9:	75 46                	jne    641 <printf+0x12c>
        s = (char*)*ap;
 5fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fe:	8b 00                	mov    (%eax),%eax
 600:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 603:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 60b:	75 27                	jne    634 <printf+0x11f>
          s = "(null)";
 60d:	c7 45 f4 0b 09 00 00 	movl   $0x90b,-0xc(%ebp)
        while(*s != 0){
 614:	eb 1e                	jmp    634 <printf+0x11f>
          putc(fd, *s);
 616:	8b 45 f4             	mov    -0xc(%ebp),%eax
 619:	0f b6 00             	movzbl (%eax),%eax
 61c:	0f be c0             	movsbl %al,%eax
 61f:	89 44 24 04          	mov    %eax,0x4(%esp)
 623:	8b 45 08             	mov    0x8(%ebp),%eax
 626:	89 04 24             	mov    %eax,(%esp)
 629:	e8 0a fe ff ff       	call   438 <putc>
          s++;
 62e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 632:	eb 01                	jmp    635 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 634:	90                   	nop
 635:	8b 45 f4             	mov    -0xc(%ebp),%eax
 638:	0f b6 00             	movzbl (%eax),%eax
 63b:	84 c0                	test   %al,%al
 63d:	75 d7                	jne    616 <printf+0x101>
 63f:	eb 68                	jmp    6a9 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 641:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 645:	75 1d                	jne    664 <printf+0x14f>
        putc(fd, *ap);
 647:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	0f be c0             	movsbl %al,%eax
 64f:	89 44 24 04          	mov    %eax,0x4(%esp)
 653:	8b 45 08             	mov    0x8(%ebp),%eax
 656:	89 04 24             	mov    %eax,(%esp)
 659:	e8 da fd ff ff       	call   438 <putc>
        ap++;
 65e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 662:	eb 45                	jmp    6a9 <printf+0x194>
      } else if(c == '%'){
 664:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 668:	75 17                	jne    681 <printf+0x16c>
        putc(fd, c);
 66a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66d:	0f be c0             	movsbl %al,%eax
 670:	89 44 24 04          	mov    %eax,0x4(%esp)
 674:	8b 45 08             	mov    0x8(%ebp),%eax
 677:	89 04 24             	mov    %eax,(%esp)
 67a:	e8 b9 fd ff ff       	call   438 <putc>
 67f:	eb 28                	jmp    6a9 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 681:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 688:	00 
 689:	8b 45 08             	mov    0x8(%ebp),%eax
 68c:	89 04 24             	mov    %eax,(%esp)
 68f:	e8 a4 fd ff ff       	call   438 <putc>
        putc(fd, c);
 694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 697:	0f be c0             	movsbl %al,%eax
 69a:	89 44 24 04          	mov    %eax,0x4(%esp)
 69e:	8b 45 08             	mov    0x8(%ebp),%eax
 6a1:	89 04 24             	mov    %eax,(%esp)
 6a4:	e8 8f fd ff ff       	call   438 <putc>
      }
      state = 0;
 6a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6b4:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ba:	01 d0                	add    %edx,%eax
 6bc:	0f b6 00             	movzbl (%eax),%eax
 6bf:	84 c0                	test   %al,%al
 6c1:	0f 85 70 fe ff ff    	jne    537 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c7:	c9                   	leave  
 6c8:	c3                   	ret    
 6c9:	66 90                	xchg   %ax,%ax
 6cb:	90                   	nop

000006cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6cc:	55                   	push   %ebp
 6cd:	89 e5                	mov    %esp,%ebp
 6cf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d2:	8b 45 08             	mov    0x8(%ebp),%eax
 6d5:	83 e8 08             	sub    $0x8,%eax
 6d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6db:	a1 a8 0b 00 00       	mov    0xba8,%eax
 6e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e3:	eb 24                	jmp    709 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ed:	77 12                	ja     701 <free+0x35>
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f5:	77 24                	ja     71b <free+0x4f>
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ff:	77 1a                	ja     71b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	89 45 fc             	mov    %eax,-0x4(%ebp)
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70f:	76 d4                	jbe    6e5 <free+0x19>
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 719:	76 ca                	jbe    6e5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	8b 40 04             	mov    0x4(%eax),%eax
 721:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	01 c2                	add    %eax,%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	39 c2                	cmp    %eax,%edx
 734:	75 24                	jne    75a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	8b 50 04             	mov    0x4(%eax),%edx
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	8b 40 04             	mov    0x4(%eax),%eax
 744:	01 c2                	add    %eax,%edx
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	8b 10                	mov    (%eax),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	89 10                	mov    %edx,(%eax)
 758:	eb 0a                	jmp    764 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 10                	mov    (%eax),%edx
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 40 04             	mov    0x4(%eax),%eax
 76a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	01 d0                	add    %edx,%eax
 776:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 779:	75 20                	jne    79b <free+0xcf>
    p->s.size += bp->s.size;
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 50 04             	mov    0x4(%eax),%edx
 781:	8b 45 f8             	mov    -0x8(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	01 c2                	add    %eax,%edx
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 78f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 792:	8b 10                	mov    (%eax),%edx
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	89 10                	mov    %edx,(%eax)
 799:	eb 08                	jmp    7a3 <free+0xd7>
  } else
    p->s.ptr = bp;
 79b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a1:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	a3 a8 0b 00 00       	mov    %eax,0xba8
}
 7ab:	c9                   	leave  
 7ac:	c3                   	ret    

000007ad <morecore>:

static Header*
morecore(uint nu)
{
 7ad:	55                   	push   %ebp
 7ae:	89 e5                	mov    %esp,%ebp
 7b0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ba:	77 07                	ja     7c3 <morecore+0x16>
    nu = 4096;
 7bc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c3:	8b 45 08             	mov    0x8(%ebp),%eax
 7c6:	c1 e0 03             	shl    $0x3,%eax
 7c9:	89 04 24             	mov    %eax,(%esp)
 7cc:	e8 3f fc ff ff       	call   410 <sbrk>
 7d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7d8:	75 07                	jne    7e1 <morecore+0x34>
    return 0;
 7da:	b8 00 00 00 00       	mov    $0x0,%eax
 7df:	eb 22                	jmp    803 <morecore+0x56>
  hp = (Header*)p;
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ea:	8b 55 08             	mov    0x8(%ebp),%edx
 7ed:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f3:	83 c0 08             	add    $0x8,%eax
 7f6:	89 04 24             	mov    %eax,(%esp)
 7f9:	e8 ce fe ff ff       	call   6cc <free>
  return freep;
 7fe:	a1 a8 0b 00 00       	mov    0xba8,%eax
}
 803:	c9                   	leave  
 804:	c3                   	ret    

00000805 <malloc>:

void*
malloc(uint nbytes)
{
 805:	55                   	push   %ebp
 806:	89 e5                	mov    %esp,%ebp
 808:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80b:	8b 45 08             	mov    0x8(%ebp),%eax
 80e:	83 c0 07             	add    $0x7,%eax
 811:	c1 e8 03             	shr    $0x3,%eax
 814:	83 c0 01             	add    $0x1,%eax
 817:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 81a:	a1 a8 0b 00 00       	mov    0xba8,%eax
 81f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 822:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 826:	75 23                	jne    84b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 828:	c7 45 f0 a0 0b 00 00 	movl   $0xba0,-0x10(%ebp)
 82f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 832:	a3 a8 0b 00 00       	mov    %eax,0xba8
 837:	a1 a8 0b 00 00       	mov    0xba8,%eax
 83c:	a3 a0 0b 00 00       	mov    %eax,0xba0
    base.s.size = 0;
 841:	c7 05 a4 0b 00 00 00 	movl   $0x0,0xba4
 848:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84e:	8b 00                	mov    (%eax),%eax
 850:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 40 04             	mov    0x4(%eax),%eax
 859:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85c:	72 4d                	jb     8ab <malloc+0xa6>
      if(p->s.size == nunits)
 85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 861:	8b 40 04             	mov    0x4(%eax),%eax
 864:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 867:	75 0c                	jne    875 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8b 10                	mov    (%eax),%edx
 86e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 871:	89 10                	mov    %edx,(%eax)
 873:	eb 26                	jmp    89b <malloc+0x96>
      else {
        p->s.size -= nunits;
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	8b 40 04             	mov    0x4(%eax),%eax
 87b:	89 c2                	mov    %eax,%edx
 87d:	2b 55 ec             	sub    -0x14(%ebp),%edx
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	8b 40 04             	mov    0x4(%eax),%eax
 88c:	c1 e0 03             	shl    $0x3,%eax
 88f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	8b 55 ec             	mov    -0x14(%ebp),%edx
 898:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 89b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89e:	a3 a8 0b 00 00       	mov    %eax,0xba8
      return (void*)(p + 1);
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	83 c0 08             	add    $0x8,%eax
 8a9:	eb 38                	jmp    8e3 <malloc+0xde>
    }
    if(p == freep)
 8ab:	a1 a8 0b 00 00       	mov    0xba8,%eax
 8b0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b3:	75 1b                	jne    8d0 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8b8:	89 04 24             	mov    %eax,(%esp)
 8bb:	e8 ed fe ff ff       	call   7ad <morecore>
 8c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8c7:	75 07                	jne    8d0 <malloc+0xcb>
        return 0;
 8c9:	b8 00 00 00 00       	mov    $0x0,%eax
 8ce:	eb 13                	jmp    8e3 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	8b 00                	mov    (%eax),%eax
 8db:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8de:	e9 70 ff ff ff       	jmp    853 <malloc+0x4e>
}
 8e3:	c9                   	leave  
 8e4:	c3                   	ret    
