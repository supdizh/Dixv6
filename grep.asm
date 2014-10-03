
_grep：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 bf 00 00 00       	jmp    d1 <grep+0xd1>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 53                	jmp    74 <grep+0x74>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  2e:	8b 45 08             	mov    0x8(%ebp),%eax
  31:	89 04 24             	mov    %eax,(%esp)
  34:	e8 c2 01 00 00       	call   1fb <match>
  39:	85 c0                	test   %eax,%eax
  3b:	74 2e                	je     6b <grep+0x6b>
        *q = '\n';
  3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  40:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  46:	83 c0 01             	add    $0x1,%eax
  49:	89 c2                	mov    %eax,%edx
  4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4e:	89 d1                	mov    %edx,%ecx
  50:	29 c1                	sub    %eax,%ecx
  52:	89 c8                	mov    %ecx,%eax
  54:	89 44 24 08          	mov    %eax,0x8(%esp)
  58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  66:	e8 81 05 00 00       	call   5ec <write>
      }
      p = q+1;
  6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6e:	83 c0 01             	add    $0x1,%eax
  71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  74:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  7b:	00 
  7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  7f:	89 04 24             	mov    %eax,(%esp)
  82:	e8 c2 03 00 00       	call   449 <strchr>
  87:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8e:	75 91                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  90:	81 7d f0 60 0e 00 00 	cmpl   $0xe60,-0x10(%ebp)
  97:	75 07                	jne    a0 <grep+0xa0>
      m = 0;
  99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a4:	7e 2b                	jle    d1 <grep+0xd1>
      m -= p - buf;
  a6:	ba 60 0e 00 00       	mov    $0xe60,%edx
  ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ae:	89 d1                	mov    %edx,%ecx
  b0:	29 c1                	sub    %eax,%ecx
  b2:	89 c8                	mov    %ecx,%eax
  b4:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  c5:	c7 04 24 60 0e 00 00 	movl   $0xe60,(%esp)
  cc:	e8 b7 04 00 00       	call   588 <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d4:	ba 00 04 00 00       	mov    $0x400,%edx
  d9:	89 d1                	mov    %edx,%ecx
  db:	29 c1                	sub    %eax,%ecx
  dd:	89 c8                	mov    %ecx,%eax
  df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  e2:	81 c2 60 0e 00 00    	add    $0xe60,%edx
  e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  f3:	89 04 24             	mov    %eax,(%esp)
  f6:	e8 e9 04 00 00       	call   5e4 <read>
  fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 102:	0f 8f 0a ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 108:	c9                   	leave  
 109:	c3                   	ret    

0000010a <main>:

int
main(int argc, char *argv[])
{
 10a:	55                   	push   %ebp
 10b:	89 e5                	mov    %esp,%ebp
 10d:	83 e4 f0             	and    $0xfffffff0,%esp
 110:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 113:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 117:	7f 19                	jg     132 <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 119:	c7 44 24 04 2c 0b 00 	movl   $0xb2c,0x4(%esp)
 120:	00 
 121:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 128:	e8 2c 06 00 00       	call   759 <printf>
    exit();
 12d:	e8 9a 04 00 00       	call   5cc <exit>
  }
  pattern = argv[1];
 132:	8b 45 0c             	mov    0xc(%ebp),%eax
 135:	8b 40 04             	mov    0x4(%eax),%eax
 138:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
 13c:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 140:	7f 19                	jg     15b <main+0x51>
    grep(pattern, 0);
 142:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 149:	00 
 14a:	8b 44 24 18          	mov    0x18(%esp),%eax
 14e:	89 04 24             	mov    %eax,(%esp)
 151:	e8 aa fe ff ff       	call   0 <grep>
    exit();
 156:	e8 71 04 00 00       	call   5cc <exit>
  }

  for(i = 2; i < argc; i++){
 15b:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 162:	00 
 163:	e9 81 00 00 00       	jmp    1e9 <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
 168:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 16c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 173:	8b 45 0c             	mov    0xc(%ebp),%eax
 176:	01 d0                	add    %edx,%eax
 178:	8b 00                	mov    (%eax),%eax
 17a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 181:	00 
 182:	89 04 24             	mov    %eax,(%esp)
 185:	e8 82 04 00 00       	call   60c <open>
 18a:	89 44 24 14          	mov    %eax,0x14(%esp)
 18e:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 193:	79 2f                	jns    1c4 <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
 195:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 199:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a3:	01 d0                	add    %edx,%eax
 1a5:	8b 00                	mov    (%eax),%eax
 1a7:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ab:	c7 44 24 04 4c 0b 00 	movl   $0xb4c,0x4(%esp)
 1b2:	00 
 1b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1ba:	e8 9a 05 00 00       	call   759 <printf>
      exit();
 1bf:	e8 08 04 00 00       	call   5cc <exit>
    }
    grep(pattern, fd);
 1c4:	8b 44 24 14          	mov    0x14(%esp),%eax
 1c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1cc:	8b 44 24 18          	mov    0x18(%esp),%eax
 1d0:	89 04 24             	mov    %eax,(%esp)
 1d3:	e8 28 fe ff ff       	call   0 <grep>
    close(fd);
 1d8:	8b 44 24 14          	mov    0x14(%esp),%eax
 1dc:	89 04 24             	mov    %eax,(%esp)
 1df:	e8 10 04 00 00       	call   5f4 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1e4:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1e9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1ed:	3b 45 08             	cmp    0x8(%ebp),%eax
 1f0:	0f 8c 72 ff ff ff    	jl     168 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1f6:	e8 d1 03 00 00       	call   5cc <exit>

000001fb <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	0f b6 00             	movzbl (%eax),%eax
 207:	3c 5e                	cmp    $0x5e,%al
 209:	75 17                	jne    222 <match+0x27>
    return matchhere(re+1, text);
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	8d 50 01             	lea    0x1(%eax),%edx
 211:	8b 45 0c             	mov    0xc(%ebp),%eax
 214:	89 44 24 04          	mov    %eax,0x4(%esp)
 218:	89 14 24             	mov    %edx,(%esp)
 21b:	e8 39 00 00 00       	call   259 <matchhere>
 220:	eb 35                	jmp    257 <match+0x5c>
  do{  // must look at empty string
    if(matchhere(re, text))
 222:	8b 45 0c             	mov    0xc(%ebp),%eax
 225:	89 44 24 04          	mov    %eax,0x4(%esp)
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	89 04 24             	mov    %eax,(%esp)
 22f:	e8 25 00 00 00       	call   259 <matchhere>
 234:	85 c0                	test   %eax,%eax
 236:	74 07                	je     23f <match+0x44>
      return 1;
 238:	b8 01 00 00 00       	mov    $0x1,%eax
 23d:	eb 18                	jmp    257 <match+0x5c>
  }while(*text++ != '\0');
 23f:	8b 45 0c             	mov    0xc(%ebp),%eax
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	84 c0                	test   %al,%al
 247:	0f 95 c0             	setne  %al
 24a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 24e:	84 c0                	test   %al,%al
 250:	75 d0                	jne    222 <match+0x27>
  return 0;
 252:	b8 00 00 00 00       	mov    $0x0,%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 259:	55                   	push   %ebp
 25a:	89 e5                	mov    %esp,%ebp
 25c:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	0f b6 00             	movzbl (%eax),%eax
 265:	84 c0                	test   %al,%al
 267:	75 0a                	jne    273 <matchhere+0x1a>
    return 1;
 269:	b8 01 00 00 00       	mov    $0x1,%eax
 26e:	e9 9b 00 00 00       	jmp    30e <matchhere+0xb5>
  if(re[1] == '*')
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	83 c0 01             	add    $0x1,%eax
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	3c 2a                	cmp    $0x2a,%al
 27e:	75 24                	jne    2a4 <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	8d 48 02             	lea    0x2(%eax),%ecx
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	0f b6 00             	movzbl (%eax),%eax
 28c:	0f be c0             	movsbl %al,%eax
 28f:	8b 55 0c             	mov    0xc(%ebp),%edx
 292:	89 54 24 08          	mov    %edx,0x8(%esp)
 296:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 29a:	89 04 24             	mov    %eax,(%esp)
 29d:	e8 6e 00 00 00       	call   310 <matchstar>
 2a2:	eb 6a                	jmp    30e <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	0f b6 00             	movzbl (%eax),%eax
 2aa:	3c 24                	cmp    $0x24,%al
 2ac:	75 1d                	jne    2cb <matchhere+0x72>
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	83 c0 01             	add    $0x1,%eax
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	84 c0                	test   %al,%al
 2b9:	75 10                	jne    2cb <matchhere+0x72>
    return *text == '\0';
 2bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	84 c0                	test   %al,%al
 2c3:	0f 94 c0             	sete   %al
 2c6:	0f b6 c0             	movzbl %al,%eax
 2c9:	eb 43                	jmp    30e <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	84 c0                	test   %al,%al
 2d3:	74 34                	je     309 <matchhere+0xb0>
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	0f b6 00             	movzbl (%eax),%eax
 2db:	3c 2e                	cmp    $0x2e,%al
 2dd:	74 10                	je     2ef <matchhere+0x96>
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	0f b6 10             	movzbl (%eax),%edx
 2e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	38 c2                	cmp    %al,%dl
 2ed:	75 1a                	jne    309 <matchhere+0xb0>
    return matchhere(re+1, text+1);
 2ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f2:	8d 50 01             	lea    0x1(%eax),%edx
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
 2f8:	83 c0 01             	add    $0x1,%eax
 2fb:	89 54 24 04          	mov    %edx,0x4(%esp)
 2ff:	89 04 24             	mov    %eax,(%esp)
 302:	e8 52 ff ff ff       	call   259 <matchhere>
 307:	eb 05                	jmp    30e <matchhere+0xb5>
  return 0;
 309:	b8 00 00 00 00       	mov    $0x0,%eax
}
 30e:	c9                   	leave  
 30f:	c3                   	ret    

00000310 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 316:	8b 45 10             	mov    0x10(%ebp),%eax
 319:	89 44 24 04          	mov    %eax,0x4(%esp)
 31d:	8b 45 0c             	mov    0xc(%ebp),%eax
 320:	89 04 24             	mov    %eax,(%esp)
 323:	e8 31 ff ff ff       	call   259 <matchhere>
 328:	85 c0                	test   %eax,%eax
 32a:	74 07                	je     333 <matchstar+0x23>
      return 1;
 32c:	b8 01 00 00 00       	mov    $0x1,%eax
 331:	eb 2c                	jmp    35f <matchstar+0x4f>
  }while(*text!='\0' && (*text++==c || c=='.'));
 333:	8b 45 10             	mov    0x10(%ebp),%eax
 336:	0f b6 00             	movzbl (%eax),%eax
 339:	84 c0                	test   %al,%al
 33b:	74 1d                	je     35a <matchstar+0x4a>
 33d:	8b 45 10             	mov    0x10(%ebp),%eax
 340:	0f b6 00             	movzbl (%eax),%eax
 343:	0f be c0             	movsbl %al,%eax
 346:	3b 45 08             	cmp    0x8(%ebp),%eax
 349:	0f 94 c0             	sete   %al
 34c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
 350:	84 c0                	test   %al,%al
 352:	75 c2                	jne    316 <matchstar+0x6>
 354:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 358:	74 bc                	je     316 <matchstar+0x6>
  return 0;
 35a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 35f:	c9                   	leave  
 360:	c3                   	ret    
 361:	66 90                	xchg   %ax,%ax
 363:	90                   	nop

00000364 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	57                   	push   %edi
 368:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 369:	8b 4d 08             	mov    0x8(%ebp),%ecx
 36c:	8b 55 10             	mov    0x10(%ebp),%edx
 36f:	8b 45 0c             	mov    0xc(%ebp),%eax
 372:	89 cb                	mov    %ecx,%ebx
 374:	89 df                	mov    %ebx,%edi
 376:	89 d1                	mov    %edx,%ecx
 378:	fc                   	cld    
 379:	f3 aa                	rep stos %al,%es:(%edi)
 37b:	89 ca                	mov    %ecx,%edx
 37d:	89 fb                	mov    %edi,%ebx
 37f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 382:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 385:	5b                   	pop    %ebx
 386:	5f                   	pop    %edi
 387:	5d                   	pop    %ebp
 388:	c3                   	ret    

00000389 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 395:	90                   	nop
 396:	8b 45 0c             	mov    0xc(%ebp),%eax
 399:	0f b6 10             	movzbl (%eax),%edx
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	88 10                	mov    %dl,(%eax)
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	0f b6 00             	movzbl (%eax),%eax
 3a7:	84 c0                	test   %al,%al
 3a9:	0f 95 c0             	setne  %al
 3ac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3b4:	84 c0                	test   %al,%al
 3b6:	75 de                	jne    396 <strcpy+0xd>
    ;
  return os;
 3b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3bb:	c9                   	leave  
 3bc:	c3                   	ret    

000003bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3bd:	55                   	push   %ebp
 3be:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3c0:	eb 08                	jmp    3ca <strcmp+0xd>
    p++, q++;
 3c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3c6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3ca:	8b 45 08             	mov    0x8(%ebp),%eax
 3cd:	0f b6 00             	movzbl (%eax),%eax
 3d0:	84 c0                	test   %al,%al
 3d2:	74 10                	je     3e4 <strcmp+0x27>
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	0f b6 10             	movzbl (%eax),%edx
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	0f b6 00             	movzbl (%eax),%eax
 3e0:	38 c2                	cmp    %al,%dl
 3e2:	74 de                	je     3c2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
 3e7:	0f b6 00             	movzbl (%eax),%eax
 3ea:	0f b6 d0             	movzbl %al,%edx
 3ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f0:	0f b6 00             	movzbl (%eax),%eax
 3f3:	0f b6 c0             	movzbl %al,%eax
 3f6:	89 d1                	mov    %edx,%ecx
 3f8:	29 c1                	sub    %eax,%ecx
 3fa:	89 c8                	mov    %ecx,%eax
}
 3fc:	5d                   	pop    %ebp
 3fd:	c3                   	ret    

000003fe <strlen>:

uint
strlen(char *s)
{
 3fe:	55                   	push   %ebp
 3ff:	89 e5                	mov    %esp,%ebp
 401:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 404:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 40b:	eb 04                	jmp    411 <strlen+0x13>
 40d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 411:	8b 55 fc             	mov    -0x4(%ebp),%edx
 414:	8b 45 08             	mov    0x8(%ebp),%eax
 417:	01 d0                	add    %edx,%eax
 419:	0f b6 00             	movzbl (%eax),%eax
 41c:	84 c0                	test   %al,%al
 41e:	75 ed                	jne    40d <strlen+0xf>
    ;
  return n;
 420:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 423:	c9                   	leave  
 424:	c3                   	ret    

00000425 <memset>:

void*
memset(void *dst, int c, uint n)
{
 425:	55                   	push   %ebp
 426:	89 e5                	mov    %esp,%ebp
 428:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 42b:	8b 45 10             	mov    0x10(%ebp),%eax
 42e:	89 44 24 08          	mov    %eax,0x8(%esp)
 432:	8b 45 0c             	mov    0xc(%ebp),%eax
 435:	89 44 24 04          	mov    %eax,0x4(%esp)
 439:	8b 45 08             	mov    0x8(%ebp),%eax
 43c:	89 04 24             	mov    %eax,(%esp)
 43f:	e8 20 ff ff ff       	call   364 <stosb>
  return dst;
 444:	8b 45 08             	mov    0x8(%ebp),%eax
}
 447:	c9                   	leave  
 448:	c3                   	ret    

00000449 <strchr>:

char*
strchr(const char *s, char c)
{
 449:	55                   	push   %ebp
 44a:	89 e5                	mov    %esp,%ebp
 44c:	83 ec 04             	sub    $0x4,%esp
 44f:	8b 45 0c             	mov    0xc(%ebp),%eax
 452:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 455:	eb 14                	jmp    46b <strchr+0x22>
    if(*s == c)
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	0f b6 00             	movzbl (%eax),%eax
 45d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 460:	75 05                	jne    467 <strchr+0x1e>
      return (char*)s;
 462:	8b 45 08             	mov    0x8(%ebp),%eax
 465:	eb 13                	jmp    47a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 467:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 46b:	8b 45 08             	mov    0x8(%ebp),%eax
 46e:	0f b6 00             	movzbl (%eax),%eax
 471:	84 c0                	test   %al,%al
 473:	75 e2                	jne    457 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 475:	b8 00 00 00 00       	mov    $0x0,%eax
}
 47a:	c9                   	leave  
 47b:	c3                   	ret    

0000047c <gets>:

char*
gets(char *buf, int max)
{
 47c:	55                   	push   %ebp
 47d:	89 e5                	mov    %esp,%ebp
 47f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 489:	eb 46                	jmp    4d1 <gets+0x55>
    cc = read(0, &c, 1);
 48b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 492:	00 
 493:	8d 45 ef             	lea    -0x11(%ebp),%eax
 496:	89 44 24 04          	mov    %eax,0x4(%esp)
 49a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4a1:	e8 3e 01 00 00       	call   5e4 <read>
 4a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ad:	7e 2f                	jle    4de <gets+0x62>
      break;
    buf[i++] = c;
 4af:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4b2:	8b 45 08             	mov    0x8(%ebp),%eax
 4b5:	01 c2                	add    %eax,%edx
 4b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4bb:	88 02                	mov    %al,(%edx)
 4bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 4c1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c5:	3c 0a                	cmp    $0xa,%al
 4c7:	74 16                	je     4df <gets+0x63>
 4c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4cd:	3c 0d                	cmp    $0xd,%al
 4cf:	74 0e                	je     4df <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d4:	83 c0 01             	add    $0x1,%eax
 4d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4da:	7c af                	jl     48b <gets+0xf>
 4dc:	eb 01                	jmp    4df <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4de:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4df:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
 4e5:	01 d0                	add    %edx,%eax
 4e7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ed:	c9                   	leave  
 4ee:	c3                   	ret    

000004ef <stat>:

int
stat(char *n, struct stat *st)
{
 4ef:	55                   	push   %ebp
 4f0:	89 e5                	mov    %esp,%ebp
 4f2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4fc:	00 
 4fd:	8b 45 08             	mov    0x8(%ebp),%eax
 500:	89 04 24             	mov    %eax,(%esp)
 503:	e8 04 01 00 00       	call   60c <open>
 508:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 50b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50f:	79 07                	jns    518 <stat+0x29>
    return -1;
 511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 516:	eb 23                	jmp    53b <stat+0x4c>
  r = fstat(fd, st);
 518:	8b 45 0c             	mov    0xc(%ebp),%eax
 51b:	89 44 24 04          	mov    %eax,0x4(%esp)
 51f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 522:	89 04 24             	mov    %eax,(%esp)
 525:	e8 fa 00 00 00       	call   624 <fstat>
 52a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 52d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 530:	89 04 24             	mov    %eax,(%esp)
 533:	e8 bc 00 00 00       	call   5f4 <close>
  return r;
 538:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 53b:	c9                   	leave  
 53c:	c3                   	ret    

0000053d <atoi>:

int
atoi(const char *s)
{
 53d:	55                   	push   %ebp
 53e:	89 e5                	mov    %esp,%ebp
 540:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 543:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 54a:	eb 23                	jmp    56f <atoi+0x32>
    n = n*10 + *s++ - '0';
 54c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 54f:	89 d0                	mov    %edx,%eax
 551:	c1 e0 02             	shl    $0x2,%eax
 554:	01 d0                	add    %edx,%eax
 556:	01 c0                	add    %eax,%eax
 558:	89 c2                	mov    %eax,%edx
 55a:	8b 45 08             	mov    0x8(%ebp),%eax
 55d:	0f b6 00             	movzbl (%eax),%eax
 560:	0f be c0             	movsbl %al,%eax
 563:	01 d0                	add    %edx,%eax
 565:	83 e8 30             	sub    $0x30,%eax
 568:	89 45 fc             	mov    %eax,-0x4(%ebp)
 56b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 56f:	8b 45 08             	mov    0x8(%ebp),%eax
 572:	0f b6 00             	movzbl (%eax),%eax
 575:	3c 2f                	cmp    $0x2f,%al
 577:	7e 0a                	jle    583 <atoi+0x46>
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	0f b6 00             	movzbl (%eax),%eax
 57f:	3c 39                	cmp    $0x39,%al
 581:	7e c9                	jle    54c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 583:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 586:	c9                   	leave  
 587:	c3                   	ret    

00000588 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 588:	55                   	push   %ebp
 589:	89 e5                	mov    %esp,%ebp
 58b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
 591:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 594:	8b 45 0c             	mov    0xc(%ebp),%eax
 597:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 59a:	eb 13                	jmp    5af <memmove+0x27>
    *dst++ = *src++;
 59c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 59f:	0f b6 10             	movzbl (%eax),%edx
 5a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a5:	88 10                	mov    %dl,(%eax)
 5a7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 5ab:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5b3:	0f 9f c0             	setg   %al
 5b6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 5ba:	84 c0                	test   %al,%al
 5bc:	75 de                	jne    59c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5c1:	c9                   	leave  
 5c2:	c3                   	ret    
 5c3:	90                   	nop

000005c4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5c4:	b8 01 00 00 00       	mov    $0x1,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <exit>:
SYSCALL(exit)
 5cc:	b8 02 00 00 00       	mov    $0x2,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <wait>:
SYSCALL(wait)
 5d4:	b8 03 00 00 00       	mov    $0x3,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <pipe>:
SYSCALL(pipe)
 5dc:	b8 04 00 00 00       	mov    $0x4,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <read>:
SYSCALL(read)
 5e4:	b8 05 00 00 00       	mov    $0x5,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <write>:
SYSCALL(write)
 5ec:	b8 10 00 00 00       	mov    $0x10,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <close>:
SYSCALL(close)
 5f4:	b8 15 00 00 00       	mov    $0x15,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <kill>:
SYSCALL(kill)
 5fc:	b8 06 00 00 00       	mov    $0x6,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <exec>:
SYSCALL(exec)
 604:	b8 07 00 00 00       	mov    $0x7,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <open>:
SYSCALL(open)
 60c:	b8 0f 00 00 00       	mov    $0xf,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <mknod>:
SYSCALL(mknod)
 614:	b8 11 00 00 00       	mov    $0x11,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <unlink>:
SYSCALL(unlink)
 61c:	b8 12 00 00 00       	mov    $0x12,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <fstat>:
SYSCALL(fstat)
 624:	b8 08 00 00 00       	mov    $0x8,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <link>:
SYSCALL(link)
 62c:	b8 13 00 00 00       	mov    $0x13,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <mkdir>:
SYSCALL(mkdir)
 634:	b8 14 00 00 00       	mov    $0x14,%eax
 639:	cd 40                	int    $0x40
 63b:	c3                   	ret    

0000063c <chdir>:
SYSCALL(chdir)
 63c:	b8 09 00 00 00       	mov    $0x9,%eax
 641:	cd 40                	int    $0x40
 643:	c3                   	ret    

00000644 <dup>:
SYSCALL(dup)
 644:	b8 0a 00 00 00       	mov    $0xa,%eax
 649:	cd 40                	int    $0x40
 64b:	c3                   	ret    

0000064c <getpid>:
SYSCALL(getpid)
 64c:	b8 0b 00 00 00       	mov    $0xb,%eax
 651:	cd 40                	int    $0x40
 653:	c3                   	ret    

00000654 <sbrk>:
SYSCALL(sbrk)
 654:	b8 0c 00 00 00       	mov    $0xc,%eax
 659:	cd 40                	int    $0x40
 65b:	c3                   	ret    

0000065c <sleep>:
SYSCALL(sleep)
 65c:	b8 0d 00 00 00       	mov    $0xd,%eax
 661:	cd 40                	int    $0x40
 663:	c3                   	ret    

00000664 <uptime>:
SYSCALL(uptime)
 664:	b8 0e 00 00 00       	mov    $0xe,%eax
 669:	cd 40                	int    $0x40
 66b:	c3                   	ret    

0000066c <halt>:
SYSCALL(halt)
 66c:	b8 16 00 00 00       	mov    $0x16,%eax
 671:	cd 40                	int    $0x40
 673:	c3                   	ret    

00000674 <alarm>:
 674:	b8 17 00 00 00       	mov    $0x17,%eax
 679:	cd 40                	int    $0x40
 67b:	c3                   	ret    

0000067c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 67c:	55                   	push   %ebp
 67d:	89 e5                	mov    %esp,%ebp
 67f:	83 ec 28             	sub    $0x28,%esp
 682:	8b 45 0c             	mov    0xc(%ebp),%eax
 685:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 688:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 68f:	00 
 690:	8d 45 f4             	lea    -0xc(%ebp),%eax
 693:	89 44 24 04          	mov    %eax,0x4(%esp)
 697:	8b 45 08             	mov    0x8(%ebp),%eax
 69a:	89 04 24             	mov    %eax,(%esp)
 69d:	e8 4a ff ff ff       	call   5ec <write>
}
 6a2:	c9                   	leave  
 6a3:	c3                   	ret    

000006a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6a4:	55                   	push   %ebp
 6a5:	89 e5                	mov    %esp,%ebp
 6a7:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6b1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6b5:	74 17                	je     6ce <printint+0x2a>
 6b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6bb:	79 11                	jns    6ce <printint+0x2a>
    neg = 1;
 6bd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c7:	f7 d8                	neg    %eax
 6c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6cc:	eb 06                	jmp    6d4 <printint+0x30>
  } else {
    x = xx;
 6ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6db:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6de:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6e1:	ba 00 00 00 00       	mov    $0x0,%edx
 6e6:	f7 f1                	div    %ecx
 6e8:	89 d0                	mov    %edx,%eax
 6ea:	0f b6 80 28 0e 00 00 	movzbl 0xe28(%eax),%eax
 6f1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 6f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6f7:	01 ca                	add    %ecx,%edx
 6f9:	88 02                	mov    %al,(%edx)
 6fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 6ff:	8b 55 10             	mov    0x10(%ebp),%edx
 702:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 705:	8b 45 ec             	mov    -0x14(%ebp),%eax
 708:	ba 00 00 00 00       	mov    $0x0,%edx
 70d:	f7 75 d4             	divl   -0x2c(%ebp)
 710:	89 45 ec             	mov    %eax,-0x14(%ebp)
 713:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 717:	75 c2                	jne    6db <printint+0x37>
  if(neg)
 719:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 71d:	74 2e                	je     74d <printint+0xa9>
    buf[i++] = '-';
 71f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 722:	8b 45 f4             	mov    -0xc(%ebp),%eax
 725:	01 d0                	add    %edx,%eax
 727:	c6 00 2d             	movb   $0x2d,(%eax)
 72a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 72e:	eb 1d                	jmp    74d <printint+0xa9>
    putc(fd, buf[i]);
 730:	8d 55 dc             	lea    -0x24(%ebp),%edx
 733:	8b 45 f4             	mov    -0xc(%ebp),%eax
 736:	01 d0                	add    %edx,%eax
 738:	0f b6 00             	movzbl (%eax),%eax
 73b:	0f be c0             	movsbl %al,%eax
 73e:	89 44 24 04          	mov    %eax,0x4(%esp)
 742:	8b 45 08             	mov    0x8(%ebp),%eax
 745:	89 04 24             	mov    %eax,(%esp)
 748:	e8 2f ff ff ff       	call   67c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 74d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 751:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 755:	79 d9                	jns    730 <printint+0x8c>
    putc(fd, buf[i]);
}
 757:	c9                   	leave  
 758:	c3                   	ret    

00000759 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 759:	55                   	push   %ebp
 75a:	89 e5                	mov    %esp,%ebp
 75c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 75f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 766:	8d 45 0c             	lea    0xc(%ebp),%eax
 769:	83 c0 04             	add    $0x4,%eax
 76c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 76f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 776:	e9 7d 01 00 00       	jmp    8f8 <printf+0x19f>
    c = fmt[i] & 0xff;
 77b:	8b 55 0c             	mov    0xc(%ebp),%edx
 77e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 781:	01 d0                	add    %edx,%eax
 783:	0f b6 00             	movzbl (%eax),%eax
 786:	0f be c0             	movsbl %al,%eax
 789:	25 ff 00 00 00       	and    $0xff,%eax
 78e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 791:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 795:	75 2c                	jne    7c3 <printf+0x6a>
      if(c == '%'){
 797:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 79b:	75 0c                	jne    7a9 <printf+0x50>
        state = '%';
 79d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7a4:	e9 4b 01 00 00       	jmp    8f4 <printf+0x19b>
      } else {
        putc(fd, c);
 7a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ac:	0f be c0             	movsbl %al,%eax
 7af:	89 44 24 04          	mov    %eax,0x4(%esp)
 7b3:	8b 45 08             	mov    0x8(%ebp),%eax
 7b6:	89 04 24             	mov    %eax,(%esp)
 7b9:	e8 be fe ff ff       	call   67c <putc>
 7be:	e9 31 01 00 00       	jmp    8f4 <printf+0x19b>
      }
    } else if(state == '%'){
 7c3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7c7:	0f 85 27 01 00 00    	jne    8f4 <printf+0x19b>
      if(c == 'd'){
 7cd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7d1:	75 2d                	jne    800 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 7d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d6:	8b 00                	mov    (%eax),%eax
 7d8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7df:	00 
 7e0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7e7:	00 
 7e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ec:	8b 45 08             	mov    0x8(%ebp),%eax
 7ef:	89 04 24             	mov    %eax,(%esp)
 7f2:	e8 ad fe ff ff       	call   6a4 <printint>
        ap++;
 7f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7fb:	e9 ed 00 00 00       	jmp    8ed <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 800:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 804:	74 06                	je     80c <printf+0xb3>
 806:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 80a:	75 2d                	jne    839 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 80c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80f:	8b 00                	mov    (%eax),%eax
 811:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 818:	00 
 819:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 820:	00 
 821:	89 44 24 04          	mov    %eax,0x4(%esp)
 825:	8b 45 08             	mov    0x8(%ebp),%eax
 828:	89 04 24             	mov    %eax,(%esp)
 82b:	e8 74 fe ff ff       	call   6a4 <printint>
        ap++;
 830:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 834:	e9 b4 00 00 00       	jmp    8ed <printf+0x194>
      } else if(c == 's'){
 839:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 83d:	75 46                	jne    885 <printf+0x12c>
        s = (char*)*ap;
 83f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 842:	8b 00                	mov    (%eax),%eax
 844:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 847:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 84b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 84f:	75 27                	jne    878 <printf+0x11f>
          s = "(null)";
 851:	c7 45 f4 62 0b 00 00 	movl   $0xb62,-0xc(%ebp)
        while(*s != 0){
 858:	eb 1e                	jmp    878 <printf+0x11f>
          putc(fd, *s);
 85a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85d:	0f b6 00             	movzbl (%eax),%eax
 860:	0f be c0             	movsbl %al,%eax
 863:	89 44 24 04          	mov    %eax,0x4(%esp)
 867:	8b 45 08             	mov    0x8(%ebp),%eax
 86a:	89 04 24             	mov    %eax,(%esp)
 86d:	e8 0a fe ff ff       	call   67c <putc>
          s++;
 872:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 876:	eb 01                	jmp    879 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 878:	90                   	nop
 879:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87c:	0f b6 00             	movzbl (%eax),%eax
 87f:	84 c0                	test   %al,%al
 881:	75 d7                	jne    85a <printf+0x101>
 883:	eb 68                	jmp    8ed <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 885:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 889:	75 1d                	jne    8a8 <printf+0x14f>
        putc(fd, *ap);
 88b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 88e:	8b 00                	mov    (%eax),%eax
 890:	0f be c0             	movsbl %al,%eax
 893:	89 44 24 04          	mov    %eax,0x4(%esp)
 897:	8b 45 08             	mov    0x8(%ebp),%eax
 89a:	89 04 24             	mov    %eax,(%esp)
 89d:	e8 da fd ff ff       	call   67c <putc>
        ap++;
 8a2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8a6:	eb 45                	jmp    8ed <printf+0x194>
      } else if(c == '%'){
 8a8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8ac:	75 17                	jne    8c5 <printf+0x16c>
        putc(fd, c);
 8ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b1:	0f be c0             	movsbl %al,%eax
 8b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 8b8:	8b 45 08             	mov    0x8(%ebp),%eax
 8bb:	89 04 24             	mov    %eax,(%esp)
 8be:	e8 b9 fd ff ff       	call   67c <putc>
 8c3:	eb 28                	jmp    8ed <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8c5:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8cc:	00 
 8cd:	8b 45 08             	mov    0x8(%ebp),%eax
 8d0:	89 04 24             	mov    %eax,(%esp)
 8d3:	e8 a4 fd ff ff       	call   67c <putc>
        putc(fd, c);
 8d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8db:	0f be c0             	movsbl %al,%eax
 8de:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e2:	8b 45 08             	mov    0x8(%ebp),%eax
 8e5:	89 04 24             	mov    %eax,(%esp)
 8e8:	e8 8f fd ff ff       	call   67c <putc>
      }
      state = 0;
 8ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8f4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8f8:	8b 55 0c             	mov    0xc(%ebp),%edx
 8fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fe:	01 d0                	add    %edx,%eax
 900:	0f b6 00             	movzbl (%eax),%eax
 903:	84 c0                	test   %al,%al
 905:	0f 85 70 fe ff ff    	jne    77b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 90b:	c9                   	leave  
 90c:	c3                   	ret    
 90d:	66 90                	xchg   %ax,%ax
 90f:	90                   	nop

00000910 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 910:	55                   	push   %ebp
 911:	89 e5                	mov    %esp,%ebp
 913:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 916:	8b 45 08             	mov    0x8(%ebp),%eax
 919:	83 e8 08             	sub    $0x8,%eax
 91c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91f:	a1 48 0e 00 00       	mov    0xe48,%eax
 924:	89 45 fc             	mov    %eax,-0x4(%ebp)
 927:	eb 24                	jmp    94d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 929:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92c:	8b 00                	mov    (%eax),%eax
 92e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 931:	77 12                	ja     945 <free+0x35>
 933:	8b 45 f8             	mov    -0x8(%ebp),%eax
 936:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 939:	77 24                	ja     95f <free+0x4f>
 93b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93e:	8b 00                	mov    (%eax),%eax
 940:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 943:	77 1a                	ja     95f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 945:	8b 45 fc             	mov    -0x4(%ebp),%eax
 948:	8b 00                	mov    (%eax),%eax
 94a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 94d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 950:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 953:	76 d4                	jbe    929 <free+0x19>
 955:	8b 45 fc             	mov    -0x4(%ebp),%eax
 958:	8b 00                	mov    (%eax),%eax
 95a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 95d:	76 ca                	jbe    929 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 95f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 962:	8b 40 04             	mov    0x4(%eax),%eax
 965:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 96c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96f:	01 c2                	add    %eax,%edx
 971:	8b 45 fc             	mov    -0x4(%ebp),%eax
 974:	8b 00                	mov    (%eax),%eax
 976:	39 c2                	cmp    %eax,%edx
 978:	75 24                	jne    99e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 97a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97d:	8b 50 04             	mov    0x4(%eax),%edx
 980:	8b 45 fc             	mov    -0x4(%ebp),%eax
 983:	8b 00                	mov    (%eax),%eax
 985:	8b 40 04             	mov    0x4(%eax),%eax
 988:	01 c2                	add    %eax,%edx
 98a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 990:	8b 45 fc             	mov    -0x4(%ebp),%eax
 993:	8b 00                	mov    (%eax),%eax
 995:	8b 10                	mov    (%eax),%edx
 997:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99a:	89 10                	mov    %edx,(%eax)
 99c:	eb 0a                	jmp    9a8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 99e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a1:	8b 10                	mov    (%eax),%edx
 9a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ab:	8b 40 04             	mov    0x4(%eax),%eax
 9ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b8:	01 d0                	add    %edx,%eax
 9ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9bd:	75 20                	jne    9df <free+0xcf>
    p->s.size += bp->s.size;
 9bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c2:	8b 50 04             	mov    0x4(%eax),%edx
 9c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c8:	8b 40 04             	mov    0x4(%eax),%eax
 9cb:	01 c2                	add    %eax,%edx
 9cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d6:	8b 10                	mov    (%eax),%edx
 9d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9db:	89 10                	mov    %edx,(%eax)
 9dd:	eb 08                	jmp    9e7 <free+0xd7>
  } else
    p->s.ptr = bp;
 9df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9e5:	89 10                	mov    %edx,(%eax)
  freep = p;
 9e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ea:	a3 48 0e 00 00       	mov    %eax,0xe48
}
 9ef:	c9                   	leave  
 9f0:	c3                   	ret    

000009f1 <morecore>:

static Header*
morecore(uint nu)
{
 9f1:	55                   	push   %ebp
 9f2:	89 e5                	mov    %esp,%ebp
 9f4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9f7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9fe:	77 07                	ja     a07 <morecore+0x16>
    nu = 4096;
 a00:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a07:	8b 45 08             	mov    0x8(%ebp),%eax
 a0a:	c1 e0 03             	shl    $0x3,%eax
 a0d:	89 04 24             	mov    %eax,(%esp)
 a10:	e8 3f fc ff ff       	call   654 <sbrk>
 a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a18:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a1c:	75 07                	jne    a25 <morecore+0x34>
    return 0;
 a1e:	b8 00 00 00 00       	mov    $0x0,%eax
 a23:	eb 22                	jmp    a47 <morecore+0x56>
  hp = (Header*)p;
 a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2e:	8b 55 08             	mov    0x8(%ebp),%edx
 a31:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a37:	83 c0 08             	add    $0x8,%eax
 a3a:	89 04 24             	mov    %eax,(%esp)
 a3d:	e8 ce fe ff ff       	call   910 <free>
  return freep;
 a42:	a1 48 0e 00 00       	mov    0xe48,%eax
}
 a47:	c9                   	leave  
 a48:	c3                   	ret    

00000a49 <malloc>:

void*
malloc(uint nbytes)
{
 a49:	55                   	push   %ebp
 a4a:	89 e5                	mov    %esp,%ebp
 a4c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a4f:	8b 45 08             	mov    0x8(%ebp),%eax
 a52:	83 c0 07             	add    $0x7,%eax
 a55:	c1 e8 03             	shr    $0x3,%eax
 a58:	83 c0 01             	add    $0x1,%eax
 a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a5e:	a1 48 0e 00 00       	mov    0xe48,%eax
 a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a6a:	75 23                	jne    a8f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a6c:	c7 45 f0 40 0e 00 00 	movl   $0xe40,-0x10(%ebp)
 a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a76:	a3 48 0e 00 00       	mov    %eax,0xe48
 a7b:	a1 48 0e 00 00       	mov    0xe48,%eax
 a80:	a3 40 0e 00 00       	mov    %eax,0xe40
    base.s.size = 0;
 a85:	c7 05 44 0e 00 00 00 	movl   $0x0,0xe44
 a8c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a92:	8b 00                	mov    (%eax),%eax
 a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9a:	8b 40 04             	mov    0x4(%eax),%eax
 a9d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aa0:	72 4d                	jb     aef <malloc+0xa6>
      if(p->s.size == nunits)
 aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa5:	8b 40 04             	mov    0x4(%eax),%eax
 aa8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aab:	75 0c                	jne    ab9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab0:	8b 10                	mov    (%eax),%edx
 ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab5:	89 10                	mov    %edx,(%eax)
 ab7:	eb 26                	jmp    adf <malloc+0x96>
      else {
        p->s.size -= nunits;
 ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abc:	8b 40 04             	mov    0x4(%eax),%eax
 abf:	89 c2                	mov    %eax,%edx
 ac1:	2b 55 ec             	sub    -0x14(%ebp),%edx
 ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acd:	8b 40 04             	mov    0x4(%eax),%eax
 ad0:	c1 e0 03             	shl    $0x3,%eax
 ad3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 adc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae2:	a3 48 0e 00 00       	mov    %eax,0xe48
      return (void*)(p + 1);
 ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aea:	83 c0 08             	add    $0x8,%eax
 aed:	eb 38                	jmp    b27 <malloc+0xde>
    }
    if(p == freep)
 aef:	a1 48 0e 00 00       	mov    0xe48,%eax
 af4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 af7:	75 1b                	jne    b14 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 af9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 afc:	89 04 24             	mov    %eax,(%esp)
 aff:	e8 ed fe ff ff       	call   9f1 <morecore>
 b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b0b:	75 07                	jne    b14 <malloc+0xcb>
        return 0;
 b0d:	b8 00 00 00 00       	mov    $0x0,%eax
 b12:	eb 13                	jmp    b27 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1d:	8b 00                	mov    (%eax),%eax
 b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b22:	e9 70 ff ff ff       	jmp    a97 <malloc+0x4e>
}
 b27:	c9                   	leave  
 b28:	c3                   	ret    
