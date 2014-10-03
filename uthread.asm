
_uthread：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <thread_init>:
thread_p  next_thread;
extern void thread_switch(void);

void 
thread_init(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
  current_thread = &all_thread[0];
   3:	c7 05 8c 8d 00 00 60 	movl   $0xd60,0x8d8c
   a:	0d 00 00 
  current_thread->state = RUNNING;
   d:	a1 8c 8d 00 00       	mov    0x8d8c,%eax
  12:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
  19:	00 00 00 
}
  1c:	5d                   	pop    %ebp
  1d:	c3                   	ret    

0000001e <thread_schedule>:

static void 
thread_schedule(void)
{
  1e:	55                   	push   %ebp
  1f:	89 e5                	mov    %esp,%ebp
  21:	83 ec 28             	sub    $0x28,%esp
  thread_p t;

  /* Find another runnable thread. */
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  24:	c7 45 f4 60 0d 00 00 	movl   $0xd60,-0xc(%ebp)
  2b:	eb 29                	jmp    56 <thread_schedule+0x38>
    if (t->state == RUNNABLE && t != current_thread) {
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  36:	83 f8 02             	cmp    $0x2,%eax
  39:	75 14                	jne    4f <thread_schedule+0x31>
  3b:	a1 8c 8d 00 00       	mov    0x8d8c,%eax
  40:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  43:	74 0a                	je     4f <thread_schedule+0x31>
      next_thread = t;
  45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  48:	a3 90 8d 00 00       	mov    %eax,0x8d90
      break;
  4d:	eb 10                	jmp    5f <thread_schedule+0x41>
thread_schedule(void)
{
  thread_p t;

  /* Find another runnable thread. */
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  4f:	81 45 f4 08 20 00 00 	addl   $0x2008,-0xc(%ebp)
  56:	81 7d f4 80 8d 00 00 	cmpl   $0x8d80,-0xc(%ebp)
  5d:	72 ce                	jb     2d <thread_schedule+0xf>
      next_thread = t;
      break;
    }
  }

  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
  5f:	81 7d f4 80 8d 00 00 	cmpl   $0x8d80,-0xc(%ebp)
  66:	72 1a                	jb     82 <thread_schedule+0x64>
  68:	a1 8c 8d 00 00       	mov    0x8d8c,%eax
  6d:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  73:	83 f8 02             	cmp    $0x2,%eax
  76:	75 0a                	jne    82 <thread_schedule+0x64>
    /* The current thread is the only runnable thread; run it. */
    next_thread = current_thread;
  78:	a1 8c 8d 00 00       	mov    0x8d8c,%eax
  7d:	a3 90 8d 00 00       	mov    %eax,0x8d90
  }

  if (next_thread == 0) {
  82:	a1 90 8d 00 00       	mov    0x8d90,%eax
  87:	85 c0                	test   %eax,%eax
  89:	75 19                	jne    a4 <thread_schedule+0x86>
    printf(2, "thread_schedule: no runnable threads; deadlock\n");
  8b:	c7 44 24 04 00 0a 00 	movl   $0xa00,0x4(%esp)
  92:	00 
  93:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  9a:	e8 8e 05 00 00       	call   62d <printf>
    exit();
  9f:	e8 fc 03 00 00       	call   4a0 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  a4:	8b 15 8c 8d 00 00    	mov    0x8d8c,%edx
  aa:	a1 90 8d 00 00       	mov    0x8d90,%eax
  af:	39 c2                	cmp    %eax,%edx
  b1:	74 16                	je     c9 <thread_schedule+0xab>
    next_thread->state = RUNNING;
  b3:	a1 90 8d 00 00       	mov    0x8d90,%eax
  b8:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
  bf:	00 00 00 
    thread_switch();
  c2:	e8 49 01 00 00       	call   210 <thread_switch>
  c7:	eb 0a                	jmp    d3 <thread_schedule+0xb5>
  } else
    next_thread = 0;
  c9:	c7 05 90 8d 00 00 00 	movl   $0x0,0x8d90
  d0:	00 00 00 
}
  d3:	c9                   	leave  
  d4:	c3                   	ret    

000000d5 <thread_create>:

void 
thread_create(void (*func)())
{
  d5:	55                   	push   %ebp
  d6:	89 e5                	mov    %esp,%ebp
  d8:	83 ec 10             	sub    $0x10,%esp
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  db:	c7 45 fc 60 0d 00 00 	movl   $0xd60,-0x4(%ebp)
  e2:	eb 14                	jmp    f8 <thread_create+0x23>
    if (t->state == FREE) break;
  e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  e7:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  ed:	85 c0                	test   %eax,%eax
  ef:	74 12                	je     103 <thread_create+0x2e>
void 
thread_create(void (*func)())
{
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  f1:	81 45 fc 08 20 00 00 	addl   $0x2008,-0x4(%ebp)
  f8:	81 7d fc 80 8d 00 00 	cmpl   $0x8d80,-0x4(%ebp)
  ff:	72 e3                	jb     e4 <thread_create+0xf>
 101:	eb 01                	jmp    104 <thread_create+0x2f>
    if (t->state == FREE) break;
 103:	90                   	nop
  }
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
 104:	8b 45 fc             	mov    -0x4(%ebp),%eax
 107:	05 04 20 00 00       	add    $0x2004,%eax
 10c:	89 c2                	mov    %eax,%edx
 10e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 111:	89 10                	mov    %edx,(%eax)
  t->sp -= 4;                              // space for return address
 113:	8b 45 fc             	mov    -0x4(%ebp),%eax
 116:	8b 00                	mov    (%eax),%eax
 118:	8d 50 fc             	lea    -0x4(%eax),%edx
 11b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 11e:	89 10                	mov    %edx,(%eax)
  * (int *) (t->sp) = (int)func;           // push return address on stack
 120:	8b 45 fc             	mov    -0x4(%ebp),%eax
 123:	8b 00                	mov    (%eax),%eax
 125:	8b 55 08             	mov    0x8(%ebp),%edx
 128:	89 10                	mov    %edx,(%eax)
  t->sp -= 32;                             // space for registers that thread_switch will push
 12a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 12d:	8b 00                	mov    (%eax),%eax
 12f:	8d 50 e0             	lea    -0x20(%eax),%edx
 132:	8b 45 fc             	mov    -0x4(%ebp),%eax
 135:	89 10                	mov    %edx,(%eax)
  t->state = RUNNABLE;
 137:	8b 45 fc             	mov    -0x4(%ebp),%eax
 13a:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 141:	00 00 00 
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <thread_yield>:

void 
thread_yield(void)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	83 ec 08             	sub    $0x8,%esp
  current_thread->state = RUNNABLE;
 14c:	a1 8c 8d 00 00       	mov    0x8d8c,%eax
 151:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 158:	00 00 00 
  thread_schedule();
 15b:	e8 be fe ff ff       	call   1e <thread_schedule>
}
 160:	c9                   	leave  
 161:	c3                   	ret    

00000162 <mythread>:

static void 
mythread(void)
{
 162:	55                   	push   %ebp
 163:	89 e5                	mov    %esp,%ebp
 165:	83 ec 28             	sub    $0x28,%esp
  int i;
  printf(1, "my thread running\n");
 168:	c7 44 24 04 30 0a 00 	movl   $0xa30,0x4(%esp)
 16f:	00 
 170:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 177:	e8 b1 04 00 00       	call   62d <printf>
  for (i = 0; i < 100; i++) {
 17c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 183:	eb 26                	jmp    1ab <mythread+0x49>
    printf(1, "my thread 0x%x\n", (int) current_thread);
 185:	a1 8c 8d 00 00       	mov    0x8d8c,%eax
 18a:	89 44 24 08          	mov    %eax,0x8(%esp)
 18e:	c7 44 24 04 43 0a 00 	movl   $0xa43,0x4(%esp)
 195:	00 
 196:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 19d:	e8 8b 04 00 00       	call   62d <printf>
    thread_yield();
 1a2:	e8 9f ff ff ff       	call   146 <thread_yield>
static void 
mythread(void)
{
  int i;
  printf(1, "my thread running\n");
  for (i = 0; i < 100; i++) {
 1a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ab:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
 1af:	7e d4                	jle    185 <mythread+0x23>
    printf(1, "my thread 0x%x\n", (int) current_thread);
    thread_yield();
  }
  printf(1, "my thread: exit\n");
 1b1:	c7 44 24 04 53 0a 00 	movl   $0xa53,0x4(%esp)
 1b8:	00 
 1b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c0:	e8 68 04 00 00       	call   62d <printf>
  current_thread->state = FREE;
 1c5:	a1 8c 8d 00 00       	mov    0x8d8c,%eax
 1ca:	c7 80 04 20 00 00 00 	movl   $0x0,0x2004(%eax)
 1d1:	00 00 00 
  thread_schedule();
 1d4:	e8 45 fe ff ff       	call   1e <thread_schedule>
}
 1d9:	c9                   	leave  
 1da:	c3                   	ret    

000001db <main>:


int 
main(int argc, char *argv[]) 
{
 1db:	55                   	push   %ebp
 1dc:	89 e5                	mov    %esp,%ebp
 1de:	83 e4 f0             	and    $0xfffffff0,%esp
 1e1:	83 ec 10             	sub    $0x10,%esp
  thread_init();
 1e4:	e8 17 fe ff ff       	call   0 <thread_init>
  thread_create(mythread);
 1e9:	c7 04 24 62 01 00 00 	movl   $0x162,(%esp)
 1f0:	e8 e0 fe ff ff       	call   d5 <thread_create>
  thread_create(mythread);
 1f5:	c7 04 24 62 01 00 00 	movl   $0x162,(%esp)
 1fc:	e8 d4 fe ff ff       	call   d5 <thread_create>
  thread_schedule();
 201:	e8 18 fe ff ff       	call   1e <thread_schedule>
  return 0;
 206:	b8 00 00 00 00       	mov    $0x0,%eax
}
 20b:	c9                   	leave  
 20c:	c3                   	ret    
 20d:	66 90                	xchg   %ax,%ax
 20f:	90                   	nop

00000210 <thread_switch>:
 * Use eax as a temporary register, which should be caller saved.
 */
	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	pushal			/*8register,32byte,0x20 address on to current_thread stack*/
 210:	60                   	pusha  
	movl	current_thread,%eax
 211:	a1 8c 8d 00 00       	mov    0x8d8c,%eax
	movl	%esp,(%eax)	/*save esp into sp*/
 216:	89 20                	mov    %esp,(%eax)
	movl	next_thread, %eax
 218:	a1 90 8d 00 00       	mov    0x8d90,%eax
	movl	%eax,current_thread
 21d:	a3 8c 8d 00 00       	mov    %eax,0x8d8c
	movl	$0,next_thread
 222:	c7 05 90 8d 00 00 00 	movl   $0x0,0x8d90
 229:	00 00 00 
	movl	current_thread,%eax
 22c:	a1 8c 8d 00 00       	mov    0x8d8c,%eax
	movl	(%eax),%esp
 231:	8b 20                	mov    (%eax),%esp
	popal
 233:	61                   	popa   
	ret				/* pop return address from stack */
 234:	c3                   	ret    
 235:	66 90                	xchg   %ax,%ax
 237:	90                   	nop

00000238 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	57                   	push   %edi
 23c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 23d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 240:	8b 55 10             	mov    0x10(%ebp),%edx
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	89 cb                	mov    %ecx,%ebx
 248:	89 df                	mov    %ebx,%edi
 24a:	89 d1                	mov    %edx,%ecx
 24c:	fc                   	cld    
 24d:	f3 aa                	rep stos %al,%es:(%edi)
 24f:	89 ca                	mov    %ecx,%edx
 251:	89 fb                	mov    %edi,%ebx
 253:	89 5d 08             	mov    %ebx,0x8(%ebp)
 256:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 259:	5b                   	pop    %ebx
 25a:	5f                   	pop    %edi
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    

0000025d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 269:	90                   	nop
 26a:	8b 45 0c             	mov    0xc(%ebp),%eax
 26d:	0f b6 10             	movzbl (%eax),%edx
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	88 10                	mov    %dl,(%eax)
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	84 c0                	test   %al,%al
 27d:	0f 95 c0             	setne  %al
 280:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 284:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 288:	84 c0                	test   %al,%al
 28a:	75 de                	jne    26a <strcpy+0xd>
    ;
  return os;
 28c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28f:	c9                   	leave  
 290:	c3                   	ret    

00000291 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 294:	eb 08                	jmp    29e <strcmp+0xd>
    p++, q++;
 296:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 29a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	0f b6 00             	movzbl (%eax),%eax
 2a4:	84 c0                	test   %al,%al
 2a6:	74 10                	je     2b8 <strcmp+0x27>
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 10             	movzbl (%eax),%edx
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	38 c2                	cmp    %al,%dl
 2b6:	74 de                	je     296 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	0f b6 00             	movzbl (%eax),%eax
 2be:	0f b6 d0             	movzbl %al,%edx
 2c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c4:	0f b6 00             	movzbl (%eax),%eax
 2c7:	0f b6 c0             	movzbl %al,%eax
 2ca:	89 d1                	mov    %edx,%ecx
 2cc:	29 c1                	sub    %eax,%ecx
 2ce:	89 c8                	mov    %ecx,%eax
}
 2d0:	5d                   	pop    %ebp
 2d1:	c3                   	ret    

000002d2 <strlen>:

uint
strlen(char *s)
{
 2d2:	55                   	push   %ebp
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2df:	eb 04                	jmp    2e5 <strlen+0x13>
 2e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	01 d0                	add    %edx,%eax
 2ed:	0f b6 00             	movzbl (%eax),%eax
 2f0:	84 c0                	test   %al,%al
 2f2:	75 ed                	jne    2e1 <strlen+0xf>
    ;
  return n;
 2f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2ff:	8b 45 10             	mov    0x10(%ebp),%eax
 302:	89 44 24 08          	mov    %eax,0x8(%esp)
 306:	8b 45 0c             	mov    0xc(%ebp),%eax
 309:	89 44 24 04          	mov    %eax,0x4(%esp)
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	89 04 24             	mov    %eax,(%esp)
 313:	e8 20 ff ff ff       	call   238 <stosb>
  return dst;
 318:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31b:	c9                   	leave  
 31c:	c3                   	ret    

0000031d <strchr>:

char*
strchr(const char *s, char c)
{
 31d:	55                   	push   %ebp
 31e:	89 e5                	mov    %esp,%ebp
 320:	83 ec 04             	sub    $0x4,%esp
 323:	8b 45 0c             	mov    0xc(%ebp),%eax
 326:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 329:	eb 14                	jmp    33f <strchr+0x22>
    if(*s == c)
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	0f b6 00             	movzbl (%eax),%eax
 331:	3a 45 fc             	cmp    -0x4(%ebp),%al
 334:	75 05                	jne    33b <strchr+0x1e>
      return (char*)s;
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	eb 13                	jmp    34e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 33b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	0f b6 00             	movzbl (%eax),%eax
 345:	84 c0                	test   %al,%al
 347:	75 e2                	jne    32b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 349:	b8 00 00 00 00       	mov    $0x0,%eax
}
 34e:	c9                   	leave  
 34f:	c3                   	ret    

00000350 <gets>:

char*
gets(char *buf, int max)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 356:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 35d:	eb 46                	jmp    3a5 <gets+0x55>
    cc = read(0, &c, 1);
 35f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 366:	00 
 367:	8d 45 ef             	lea    -0x11(%ebp),%eax
 36a:	89 44 24 04          	mov    %eax,0x4(%esp)
 36e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 375:	e8 3e 01 00 00       	call   4b8 <read>
 37a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 37d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 381:	7e 2f                	jle    3b2 <gets+0x62>
      break;
    buf[i++] = c;
 383:	8b 55 f4             	mov    -0xc(%ebp),%edx
 386:	8b 45 08             	mov    0x8(%ebp),%eax
 389:	01 c2                	add    %eax,%edx
 38b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 38f:	88 02                	mov    %al,(%edx)
 391:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 395:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 399:	3c 0a                	cmp    $0xa,%al
 39b:	74 16                	je     3b3 <gets+0x63>
 39d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3a1:	3c 0d                	cmp    $0xd,%al
 3a3:	74 0e                	je     3b3 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a8:	83 c0 01             	add    $0x1,%eax
 3ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3ae:	7c af                	jl     35f <gets+0xf>
 3b0:	eb 01                	jmp    3b3 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3b2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	01 d0                	add    %edx,%eax
 3bb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c1:	c9                   	leave  
 3c2:	c3                   	ret    

000003c3 <stat>:

int
stat(char *n, struct stat *st)
{
 3c3:	55                   	push   %ebp
 3c4:	89 e5                	mov    %esp,%ebp
 3c6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3d0:	00 
 3d1:	8b 45 08             	mov    0x8(%ebp),%eax
 3d4:	89 04 24             	mov    %eax,(%esp)
 3d7:	e8 04 01 00 00       	call   4e0 <open>
 3dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3e3:	79 07                	jns    3ec <stat+0x29>
    return -1;
 3e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ea:	eb 23                	jmp    40f <stat+0x4c>
  r = fstat(fd, st);
 3ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 3f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f6:	89 04 24             	mov    %eax,(%esp)
 3f9:	e8 fa 00 00 00       	call   4f8 <fstat>
 3fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 401:	8b 45 f4             	mov    -0xc(%ebp),%eax
 404:	89 04 24             	mov    %eax,(%esp)
 407:	e8 bc 00 00 00       	call   4c8 <close>
  return r;
 40c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 40f:	c9                   	leave  
 410:	c3                   	ret    

00000411 <atoi>:

int
atoi(const char *s)
{
 411:	55                   	push   %ebp
 412:	89 e5                	mov    %esp,%ebp
 414:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 417:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 41e:	eb 23                	jmp    443 <atoi+0x32>
    n = n*10 + *s++ - '0';
 420:	8b 55 fc             	mov    -0x4(%ebp),%edx
 423:	89 d0                	mov    %edx,%eax
 425:	c1 e0 02             	shl    $0x2,%eax
 428:	01 d0                	add    %edx,%eax
 42a:	01 c0                	add    %eax,%eax
 42c:	89 c2                	mov    %eax,%edx
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	0f b6 00             	movzbl (%eax),%eax
 434:	0f be c0             	movsbl %al,%eax
 437:	01 d0                	add    %edx,%eax
 439:	83 e8 30             	sub    $0x30,%eax
 43c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 43f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 443:	8b 45 08             	mov    0x8(%ebp),%eax
 446:	0f b6 00             	movzbl (%eax),%eax
 449:	3c 2f                	cmp    $0x2f,%al
 44b:	7e 0a                	jle    457 <atoi+0x46>
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	0f b6 00             	movzbl (%eax),%eax
 453:	3c 39                	cmp    $0x39,%al
 455:	7e c9                	jle    420 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 457:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 45a:	c9                   	leave  
 45b:	c3                   	ret    

0000045c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 45c:	55                   	push   %ebp
 45d:	89 e5                	mov    %esp,%ebp
 45f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 462:	8b 45 08             	mov    0x8(%ebp),%eax
 465:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 468:	8b 45 0c             	mov    0xc(%ebp),%eax
 46b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 46e:	eb 13                	jmp    483 <memmove+0x27>
    *dst++ = *src++;
 470:	8b 45 f8             	mov    -0x8(%ebp),%eax
 473:	0f b6 10             	movzbl (%eax),%edx
 476:	8b 45 fc             	mov    -0x4(%ebp),%eax
 479:	88 10                	mov    %dl,(%eax)
 47b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 47f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 483:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 487:	0f 9f c0             	setg   %al
 48a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 48e:	84 c0                	test   %al,%al
 490:	75 de                	jne    470 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 492:	8b 45 08             	mov    0x8(%ebp),%eax
}
 495:	c9                   	leave  
 496:	c3                   	ret    
 497:	90                   	nop

00000498 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 498:	b8 01 00 00 00       	mov    $0x1,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <exit>:
SYSCALL(exit)
 4a0:	b8 02 00 00 00       	mov    $0x2,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <wait>:
SYSCALL(wait)
 4a8:	b8 03 00 00 00       	mov    $0x3,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <pipe>:
SYSCALL(pipe)
 4b0:	b8 04 00 00 00       	mov    $0x4,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <read>:
SYSCALL(read)
 4b8:	b8 05 00 00 00       	mov    $0x5,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <write>:
SYSCALL(write)
 4c0:	b8 10 00 00 00       	mov    $0x10,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <close>:
SYSCALL(close)
 4c8:	b8 15 00 00 00       	mov    $0x15,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <kill>:
SYSCALL(kill)
 4d0:	b8 06 00 00 00       	mov    $0x6,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <exec>:
SYSCALL(exec)
 4d8:	b8 07 00 00 00       	mov    $0x7,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <open>:
SYSCALL(open)
 4e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <mknod>:
SYSCALL(mknod)
 4e8:	b8 11 00 00 00       	mov    $0x11,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <unlink>:
SYSCALL(unlink)
 4f0:	b8 12 00 00 00       	mov    $0x12,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <fstat>:
SYSCALL(fstat)
 4f8:	b8 08 00 00 00       	mov    $0x8,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <link>:
SYSCALL(link)
 500:	b8 13 00 00 00       	mov    $0x13,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <mkdir>:
SYSCALL(mkdir)
 508:	b8 14 00 00 00       	mov    $0x14,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <chdir>:
SYSCALL(chdir)
 510:	b8 09 00 00 00       	mov    $0x9,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <dup>:
SYSCALL(dup)
 518:	b8 0a 00 00 00       	mov    $0xa,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <getpid>:
SYSCALL(getpid)
 520:	b8 0b 00 00 00       	mov    $0xb,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <sbrk>:
SYSCALL(sbrk)
 528:	b8 0c 00 00 00       	mov    $0xc,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <sleep>:
SYSCALL(sleep)
 530:	b8 0d 00 00 00       	mov    $0xd,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <uptime>:
SYSCALL(uptime)
 538:	b8 0e 00 00 00       	mov    $0xe,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <halt>:
SYSCALL(halt)
 540:	b8 16 00 00 00       	mov    $0x16,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <alarm>:
 548:	b8 17 00 00 00       	mov    $0x17,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	83 ec 28             	sub    $0x28,%esp
 556:	8b 45 0c             	mov    0xc(%ebp),%eax
 559:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 55c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 563:	00 
 564:	8d 45 f4             	lea    -0xc(%ebp),%eax
 567:	89 44 24 04          	mov    %eax,0x4(%esp)
 56b:	8b 45 08             	mov    0x8(%ebp),%eax
 56e:	89 04 24             	mov    %eax,(%esp)
 571:	e8 4a ff ff ff       	call   4c0 <write>
}
 576:	c9                   	leave  
 577:	c3                   	ret    

00000578 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 57e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 585:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 589:	74 17                	je     5a2 <printint+0x2a>
 58b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 58f:	79 11                	jns    5a2 <printint+0x2a>
    neg = 1;
 591:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 598:	8b 45 0c             	mov    0xc(%ebp),%eax
 59b:	f7 d8                	neg    %eax
 59d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a0:	eb 06                	jmp    5a8 <printint+0x30>
  } else {
    x = xx;
 5a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5af:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b5:	ba 00 00 00 00       	mov    $0x0,%edx
 5ba:	f7 f1                	div    %ecx
 5bc:	89 d0                	mov    %edx,%eax
 5be:	0f b6 80 4c 0d 00 00 	movzbl 0xd4c(%eax),%eax
 5c5:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 5c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5cb:	01 ca                	add    %ecx,%edx
 5cd:	88 02                	mov    %al,(%edx)
 5cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 5d3:	8b 55 10             	mov    0x10(%ebp),%edx
 5d6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 5d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5dc:	ba 00 00 00 00       	mov    $0x0,%edx
 5e1:	f7 75 d4             	divl   -0x2c(%ebp)
 5e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5eb:	75 c2                	jne    5af <printint+0x37>
  if(neg)
 5ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5f1:	74 2e                	je     621 <printint+0xa9>
    buf[i++] = '-';
 5f3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f9:	01 d0                	add    %edx,%eax
 5fb:	c6 00 2d             	movb   $0x2d,(%eax)
 5fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 602:	eb 1d                	jmp    621 <printint+0xa9>
    putc(fd, buf[i]);
 604:	8d 55 dc             	lea    -0x24(%ebp),%edx
 607:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60a:	01 d0                	add    %edx,%eax
 60c:	0f b6 00             	movzbl (%eax),%eax
 60f:	0f be c0             	movsbl %al,%eax
 612:	89 44 24 04          	mov    %eax,0x4(%esp)
 616:	8b 45 08             	mov    0x8(%ebp),%eax
 619:	89 04 24             	mov    %eax,(%esp)
 61c:	e8 2f ff ff ff       	call   550 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 621:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 629:	79 d9                	jns    604 <printint+0x8c>
    putc(fd, buf[i]);
}
 62b:	c9                   	leave  
 62c:	c3                   	ret    

0000062d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 62d:	55                   	push   %ebp
 62e:	89 e5                	mov    %esp,%ebp
 630:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 633:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 63a:	8d 45 0c             	lea    0xc(%ebp),%eax
 63d:	83 c0 04             	add    $0x4,%eax
 640:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 643:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 64a:	e9 7d 01 00 00       	jmp    7cc <printf+0x19f>
    c = fmt[i] & 0xff;
 64f:	8b 55 0c             	mov    0xc(%ebp),%edx
 652:	8b 45 f0             	mov    -0x10(%ebp),%eax
 655:	01 d0                	add    %edx,%eax
 657:	0f b6 00             	movzbl (%eax),%eax
 65a:	0f be c0             	movsbl %al,%eax
 65d:	25 ff 00 00 00       	and    $0xff,%eax
 662:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 665:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 669:	75 2c                	jne    697 <printf+0x6a>
      if(c == '%'){
 66b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66f:	75 0c                	jne    67d <printf+0x50>
        state = '%';
 671:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 678:	e9 4b 01 00 00       	jmp    7c8 <printf+0x19b>
      } else {
        putc(fd, c);
 67d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 680:	0f be c0             	movsbl %al,%eax
 683:	89 44 24 04          	mov    %eax,0x4(%esp)
 687:	8b 45 08             	mov    0x8(%ebp),%eax
 68a:	89 04 24             	mov    %eax,(%esp)
 68d:	e8 be fe ff ff       	call   550 <putc>
 692:	e9 31 01 00 00       	jmp    7c8 <printf+0x19b>
      }
    } else if(state == '%'){
 697:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 69b:	0f 85 27 01 00 00    	jne    7c8 <printf+0x19b>
      if(c == 'd'){
 6a1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6a5:	75 2d                	jne    6d4 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 6a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6aa:	8b 00                	mov    (%eax),%eax
 6ac:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6b3:	00 
 6b4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6bb:	00 
 6bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c0:	8b 45 08             	mov    0x8(%ebp),%eax
 6c3:	89 04 24             	mov    %eax,(%esp)
 6c6:	e8 ad fe ff ff       	call   578 <printint>
        ap++;
 6cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cf:	e9 ed 00 00 00       	jmp    7c1 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 6d4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6d8:	74 06                	je     6e0 <printf+0xb3>
 6da:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6de:	75 2d                	jne    70d <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e3:	8b 00                	mov    (%eax),%eax
 6e5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6ec:	00 
 6ed:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6f4:	00 
 6f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f9:	8b 45 08             	mov    0x8(%ebp),%eax
 6fc:	89 04 24             	mov    %eax,(%esp)
 6ff:	e8 74 fe ff ff       	call   578 <printint>
        ap++;
 704:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 708:	e9 b4 00 00 00       	jmp    7c1 <printf+0x194>
      } else if(c == 's'){
 70d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 711:	75 46                	jne    759 <printf+0x12c>
        s = (char*)*ap;
 713:	8b 45 e8             	mov    -0x18(%ebp),%eax
 716:	8b 00                	mov    (%eax),%eax
 718:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 71b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 71f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 723:	75 27                	jne    74c <printf+0x11f>
          s = "(null)";
 725:	c7 45 f4 64 0a 00 00 	movl   $0xa64,-0xc(%ebp)
        while(*s != 0){
 72c:	eb 1e                	jmp    74c <printf+0x11f>
          putc(fd, *s);
 72e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 731:	0f b6 00             	movzbl (%eax),%eax
 734:	0f be c0             	movsbl %al,%eax
 737:	89 44 24 04          	mov    %eax,0x4(%esp)
 73b:	8b 45 08             	mov    0x8(%ebp),%eax
 73e:	89 04 24             	mov    %eax,(%esp)
 741:	e8 0a fe ff ff       	call   550 <putc>
          s++;
 746:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 74a:	eb 01                	jmp    74d <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 74c:	90                   	nop
 74d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 750:	0f b6 00             	movzbl (%eax),%eax
 753:	84 c0                	test   %al,%al
 755:	75 d7                	jne    72e <printf+0x101>
 757:	eb 68                	jmp    7c1 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 759:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 75d:	75 1d                	jne    77c <printf+0x14f>
        putc(fd, *ap);
 75f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	0f be c0             	movsbl %al,%eax
 767:	89 44 24 04          	mov    %eax,0x4(%esp)
 76b:	8b 45 08             	mov    0x8(%ebp),%eax
 76e:	89 04 24             	mov    %eax,(%esp)
 771:	e8 da fd ff ff       	call   550 <putc>
        ap++;
 776:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 77a:	eb 45                	jmp    7c1 <printf+0x194>
      } else if(c == '%'){
 77c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 780:	75 17                	jne    799 <printf+0x16c>
        putc(fd, c);
 782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 785:	0f be c0             	movsbl %al,%eax
 788:	89 44 24 04          	mov    %eax,0x4(%esp)
 78c:	8b 45 08             	mov    0x8(%ebp),%eax
 78f:	89 04 24             	mov    %eax,(%esp)
 792:	e8 b9 fd ff ff       	call   550 <putc>
 797:	eb 28                	jmp    7c1 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 799:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7a0:	00 
 7a1:	8b 45 08             	mov    0x8(%ebp),%eax
 7a4:	89 04 24             	mov    %eax,(%esp)
 7a7:	e8 a4 fd ff ff       	call   550 <putc>
        putc(fd, c);
 7ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7af:	0f be c0             	movsbl %al,%eax
 7b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 7b6:	8b 45 08             	mov    0x8(%ebp),%eax
 7b9:	89 04 24             	mov    %eax,(%esp)
 7bc:	e8 8f fd ff ff       	call   550 <putc>
      }
      state = 0;
 7c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7c8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7cc:	8b 55 0c             	mov    0xc(%ebp),%edx
 7cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d2:	01 d0                	add    %edx,%eax
 7d4:	0f b6 00             	movzbl (%eax),%eax
 7d7:	84 c0                	test   %al,%al
 7d9:	0f 85 70 fe ff ff    	jne    64f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7df:	c9                   	leave  
 7e0:	c3                   	ret    
 7e1:	66 90                	xchg   %ax,%ax
 7e3:	90                   	nop

000007e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e4:	55                   	push   %ebp
 7e5:	89 e5                	mov    %esp,%ebp
 7e7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ea:	8b 45 08             	mov    0x8(%ebp),%eax
 7ed:	83 e8 08             	sub    $0x8,%eax
 7f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f3:	a1 88 8d 00 00       	mov    0x8d88,%eax
 7f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7fb:	eb 24                	jmp    821 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	8b 00                	mov    (%eax),%eax
 802:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 805:	77 12                	ja     819 <free+0x35>
 807:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 80d:	77 24                	ja     833 <free+0x4f>
 80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 812:	8b 00                	mov    (%eax),%eax
 814:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 817:	77 1a                	ja     833 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	8b 00                	mov    (%eax),%eax
 81e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 821:	8b 45 f8             	mov    -0x8(%ebp),%eax
 824:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 827:	76 d4                	jbe    7fd <free+0x19>
 829:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 831:	76 ca                	jbe    7fd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 833:	8b 45 f8             	mov    -0x8(%ebp),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 840:	8b 45 f8             	mov    -0x8(%ebp),%eax
 843:	01 c2                	add    %eax,%edx
 845:	8b 45 fc             	mov    -0x4(%ebp),%eax
 848:	8b 00                	mov    (%eax),%eax
 84a:	39 c2                	cmp    %eax,%edx
 84c:	75 24                	jne    872 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 84e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 851:	8b 50 04             	mov    0x4(%eax),%edx
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	8b 40 04             	mov    0x4(%eax),%eax
 85c:	01 c2                	add    %eax,%edx
 85e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 861:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 864:	8b 45 fc             	mov    -0x4(%ebp),%eax
 867:	8b 00                	mov    (%eax),%eax
 869:	8b 10                	mov    (%eax),%edx
 86b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86e:	89 10                	mov    %edx,(%eax)
 870:	eb 0a                	jmp    87c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 872:	8b 45 fc             	mov    -0x4(%ebp),%eax
 875:	8b 10                	mov    (%eax),%edx
 877:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 87c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87f:	8b 40 04             	mov    0x4(%eax),%eax
 882:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 889:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88c:	01 d0                	add    %edx,%eax
 88e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 891:	75 20                	jne    8b3 <free+0xcf>
    p->s.size += bp->s.size;
 893:	8b 45 fc             	mov    -0x4(%ebp),%eax
 896:	8b 50 04             	mov    0x4(%eax),%edx
 899:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89c:	8b 40 04             	mov    0x4(%eax),%eax
 89f:	01 c2                	add    %eax,%edx
 8a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8aa:	8b 10                	mov    (%eax),%edx
 8ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8af:	89 10                	mov    %edx,(%eax)
 8b1:	eb 08                	jmp    8bb <free+0xd7>
  } else
    p->s.ptr = bp;
 8b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8b9:	89 10                	mov    %edx,(%eax)
  freep = p;
 8bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8be:	a3 88 8d 00 00       	mov    %eax,0x8d88
}
 8c3:	c9                   	leave  
 8c4:	c3                   	ret    

000008c5 <morecore>:

static Header*
morecore(uint nu)
{
 8c5:	55                   	push   %ebp
 8c6:	89 e5                	mov    %esp,%ebp
 8c8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8cb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8d2:	77 07                	ja     8db <morecore+0x16>
    nu = 4096;
 8d4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8db:	8b 45 08             	mov    0x8(%ebp),%eax
 8de:	c1 e0 03             	shl    $0x3,%eax
 8e1:	89 04 24             	mov    %eax,(%esp)
 8e4:	e8 3f fc ff ff       	call   528 <sbrk>
 8e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8ec:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8f0:	75 07                	jne    8f9 <morecore+0x34>
    return 0;
 8f2:	b8 00 00 00 00       	mov    $0x0,%eax
 8f7:	eb 22                	jmp    91b <morecore+0x56>
  hp = (Header*)p;
 8f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 902:	8b 55 08             	mov    0x8(%ebp),%edx
 905:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 908:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90b:	83 c0 08             	add    $0x8,%eax
 90e:	89 04 24             	mov    %eax,(%esp)
 911:	e8 ce fe ff ff       	call   7e4 <free>
  return freep;
 916:	a1 88 8d 00 00       	mov    0x8d88,%eax
}
 91b:	c9                   	leave  
 91c:	c3                   	ret    

0000091d <malloc>:

void*
malloc(uint nbytes)
{
 91d:	55                   	push   %ebp
 91e:	89 e5                	mov    %esp,%ebp
 920:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 923:	8b 45 08             	mov    0x8(%ebp),%eax
 926:	83 c0 07             	add    $0x7,%eax
 929:	c1 e8 03             	shr    $0x3,%eax
 92c:	83 c0 01             	add    $0x1,%eax
 92f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 932:	a1 88 8d 00 00       	mov    0x8d88,%eax
 937:	89 45 f0             	mov    %eax,-0x10(%ebp)
 93a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 93e:	75 23                	jne    963 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 940:	c7 45 f0 80 8d 00 00 	movl   $0x8d80,-0x10(%ebp)
 947:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94a:	a3 88 8d 00 00       	mov    %eax,0x8d88
 94f:	a1 88 8d 00 00       	mov    0x8d88,%eax
 954:	a3 80 8d 00 00       	mov    %eax,0x8d80
    base.s.size = 0;
 959:	c7 05 84 8d 00 00 00 	movl   $0x0,0x8d84
 960:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 963:	8b 45 f0             	mov    -0x10(%ebp),%eax
 966:	8b 00                	mov    (%eax),%eax
 968:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 96b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96e:	8b 40 04             	mov    0x4(%eax),%eax
 971:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 974:	72 4d                	jb     9c3 <malloc+0xa6>
      if(p->s.size == nunits)
 976:	8b 45 f4             	mov    -0xc(%ebp),%eax
 979:	8b 40 04             	mov    0x4(%eax),%eax
 97c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 97f:	75 0c                	jne    98d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 981:	8b 45 f4             	mov    -0xc(%ebp),%eax
 984:	8b 10                	mov    (%eax),%edx
 986:	8b 45 f0             	mov    -0x10(%ebp),%eax
 989:	89 10                	mov    %edx,(%eax)
 98b:	eb 26                	jmp    9b3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 98d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 990:	8b 40 04             	mov    0x4(%eax),%eax
 993:	89 c2                	mov    %eax,%edx
 995:	2b 55 ec             	sub    -0x14(%ebp),%edx
 998:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 99e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a1:	8b 40 04             	mov    0x4(%eax),%eax
 9a4:	c1 e0 03             	shl    $0x3,%eax
 9a7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9b0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b6:	a3 88 8d 00 00       	mov    %eax,0x8d88
      return (void*)(p + 1);
 9bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9be:	83 c0 08             	add    $0x8,%eax
 9c1:	eb 38                	jmp    9fb <malloc+0xde>
    }
    if(p == freep)
 9c3:	a1 88 8d 00 00       	mov    0x8d88,%eax
 9c8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9cb:	75 1b                	jne    9e8 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 9cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9d0:	89 04 24             	mov    %eax,(%esp)
 9d3:	e8 ed fe ff ff       	call   8c5 <morecore>
 9d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9df:	75 07                	jne    9e8 <malloc+0xcb>
        return 0;
 9e1:	b8 00 00 00 00       	mov    $0x0,%eax
 9e6:	eb 13                	jmp    9fb <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f1:	8b 00                	mov    (%eax),%eax
 9f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9f6:	e9 70 ff ff ff       	jmp    96b <malloc+0x4e>
}
 9fb:	c9                   	leave  
 9fc:	c3                   	ret    
