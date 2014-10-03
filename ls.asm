
_ls：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	89 04 24             	mov    %eax,(%esp)
   d:	e8 e4 03 00 00       	call   3f6 <strlen>
  12:	8b 55 08             	mov    0x8(%ebp),%edx
  15:	01 d0                	add    %edx,%eax
  17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1a:	eb 04                	jmp    20 <fmtname+0x20>
  1c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  23:	3b 45 08             	cmp    0x8(%ebp),%eax
  26:	72 0a                	jb     32 <fmtname+0x32>
  28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2b:	0f b6 00             	movzbl (%eax),%eax
  2e:	3c 2f                	cmp    $0x2f,%al
  30:	75 ea                	jne    1c <fmtname+0x1c>
    ;
  p++;
  32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  39:	89 04 24             	mov    %eax,(%esp)
  3c:	e8 b5 03 00 00       	call   3f6 <strlen>
  41:	83 f8 0d             	cmp    $0xd,%eax
  44:	76 05                	jbe    4b <fmtname+0x4b>
    return p;
  46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  49:	eb 5f                	jmp    aa <fmtname+0xaa>
  memmove(buf, p, strlen(p));
  4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4e:	89 04 24             	mov    %eax,(%esp)
  51:	e8 a0 03 00 00       	call   3f6 <strlen>
  56:	89 44 24 08          	mov    %eax,0x8(%esp)
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  61:	c7 04 24 18 0e 00 00 	movl   $0xe18,(%esp)
  68:	e8 13 05 00 00       	call   580 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  70:	89 04 24             	mov    %eax,(%esp)
  73:	e8 7e 03 00 00       	call   3f6 <strlen>
  78:	ba 0e 00 00 00       	mov    $0xe,%edx
  7d:	89 d3                	mov    %edx,%ebx
  7f:	29 c3                	sub    %eax,%ebx
  81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  84:	89 04 24             	mov    %eax,(%esp)
  87:	e8 6a 03 00 00       	call   3f6 <strlen>
  8c:	05 18 0e 00 00       	add    $0xe18,%eax
  91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  95:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  9c:	00 
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 78 03 00 00       	call   41d <memset>
  return buf;
  a5:	b8 18 0e 00 00       	mov    $0xe18,%eax
}
  aa:	83 c4 24             	add    $0x24,%esp
  ad:	5b                   	pop    %ebx
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <ls>:

void
ls(char *path)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	57                   	push   %edi
  b4:	56                   	push   %esi
  b5:	53                   	push   %ebx
  b6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c3:	00 
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 04 24             	mov    %eax,(%esp)
  ca:	e8 35 05 00 00       	call   604 <open>
  cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d6:	79 20                	jns    f8 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	89 44 24 08          	mov    %eax,0x8(%esp)
  df:	c7 44 24 04 21 0b 00 	movl   $0xb21,0x4(%esp)
  e6:	00 
  e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ee:	e8 5e 06 00 00       	call   751 <printf>
  f3:	e9 01 02 00 00       	jmp    2f9 <ls+0x249>
    return;
  }
  
  if(fstat(fd, &st) < 0){
  f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 105:	89 04 24             	mov    %eax,(%esp)
 108:	e8 0f 05 00 00       	call   61c <fstat>
 10d:	85 c0                	test   %eax,%eax
 10f:	79 2b                	jns    13c <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	89 44 24 08          	mov    %eax,0x8(%esp)
 118:	c7 44 24 04 35 0b 00 	movl   $0xb35,0x4(%esp)
 11f:	00 
 120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 127:	e8 25 06 00 00       	call   751 <printf>
    close(fd);
 12c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12f:	89 04 24             	mov    %eax,(%esp)
 132:	e8 b5 04 00 00       	call   5ec <close>
 137:	e9 bd 01 00 00       	jmp    2f9 <ls+0x249>
    return;
  }
  
  switch(st.type){
 13c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 143:	98                   	cwtl   
 144:	83 f8 01             	cmp    $0x1,%eax
 147:	74 53                	je     19c <ls+0xec>
 149:	83 f8 02             	cmp    $0x2,%eax
 14c:	0f 85 9c 01 00 00    	jne    2ee <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 152:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 158:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15e:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 165:	0f bf d8             	movswl %ax,%ebx
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	89 04 24             	mov    %eax,(%esp)
 16e:	e8 8d fe ff ff       	call   0 <fmtname>
 173:	89 7c 24 14          	mov    %edi,0x14(%esp)
 177:	89 74 24 10          	mov    %esi,0x10(%esp)
 17b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 17f:	89 44 24 08          	mov    %eax,0x8(%esp)
 183:	c7 44 24 04 49 0b 00 	movl   $0xb49,0x4(%esp)
 18a:	00 
 18b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 192:	e8 ba 05 00 00       	call   751 <printf>
    break;
 197:	e9 52 01 00 00       	jmp    2ee <ls+0x23e>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	89 04 24             	mov    %eax,(%esp)
 1a2:	e8 4f 02 00 00       	call   3f6 <strlen>
 1a7:	83 c0 10             	add    $0x10,%eax
 1aa:	3d 00 02 00 00       	cmp    $0x200,%eax
 1af:	76 19                	jbe    1ca <ls+0x11a>
      printf(1, "ls: path too long\n");
 1b1:	c7 44 24 04 56 0b 00 	movl   $0xb56,0x4(%esp)
 1b8:	00 
 1b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c0:	e8 8c 05 00 00       	call   751 <printf>
      break;
 1c5:	e9 24 01 00 00       	jmp    2ee <ls+0x23e>
    }
    strcpy(buf, path);
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d7:	89 04 24             	mov    %eax,(%esp)
 1da:	e8 a2 01 00 00       	call   381 <strcpy>
    p = buf+strlen(buf);
 1df:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e5:	89 04 24             	mov    %eax,(%esp)
 1e8:	e8 09 02 00 00       	call   3f6 <strlen>
 1ed:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1f3:	01 d0                	add    %edx,%eax
 1f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1fb:	c6 00 2f             	movb   $0x2f,(%eax)
 1fe:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 202:	e9 c0 00 00 00       	jmp    2c7 <ls+0x217>
      if(de.inum == 0)
 207:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 20e:	66 85 c0             	test   %ax,%ax
 211:	0f 84 af 00 00 00    	je     2c6 <ls+0x216>
        continue;
      memmove(p, de.name, DIRSIZ);
 217:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 21e:	00 
 21f:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 225:	83 c0 02             	add    $0x2,%eax
 228:	89 44 24 04          	mov    %eax,0x4(%esp)
 22c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22f:	89 04 24             	mov    %eax,(%esp)
 232:	e8 49 03 00 00       	call   580 <memmove>
      p[DIRSIZ] = 0;
 237:	8b 45 e0             	mov    -0x20(%ebp),%eax
 23a:	83 c0 0e             	add    $0xe,%eax
 23d:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 240:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 246:	89 44 24 04          	mov    %eax,0x4(%esp)
 24a:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 250:	89 04 24             	mov    %eax,(%esp)
 253:	e8 8f 02 00 00       	call   4e7 <stat>
 258:	85 c0                	test   %eax,%eax
 25a:	79 20                	jns    27c <ls+0x1cc>
        printf(1, "ls: cannot stat %s\n", buf);
 25c:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 262:	89 44 24 08          	mov    %eax,0x8(%esp)
 266:	c7 44 24 04 35 0b 00 	movl   $0xb35,0x4(%esp)
 26d:	00 
 26e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 275:	e8 d7 04 00 00       	call   751 <printf>
        continue;
 27a:	eb 4b                	jmp    2c7 <ls+0x217>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 27c:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 282:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 288:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 28f:	0f bf d8             	movswl %ax,%ebx
 292:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 298:	89 04 24             	mov    %eax,(%esp)
 29b:	e8 60 fd ff ff       	call   0 <fmtname>
 2a0:	89 7c 24 14          	mov    %edi,0x14(%esp)
 2a4:	89 74 24 10          	mov    %esi,0x10(%esp)
 2a8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2ac:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b0:	c7 44 24 04 49 0b 00 	movl   $0xb49,0x4(%esp)
 2b7:	00 
 2b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2bf:	e8 8d 04 00 00       	call   751 <printf>
 2c4:	eb 01                	jmp    2c7 <ls+0x217>
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
 2c6:	90                   	nop
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 2ce:	00 
 2cf:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2dc:	89 04 24             	mov    %eax,(%esp)
 2df:	e8 f8 02 00 00       	call   5dc <read>
 2e4:	83 f8 10             	cmp    $0x10,%eax
 2e7:	0f 84 1a ff ff ff    	je     207 <ls+0x157>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2ed:	90                   	nop
  }
  close(fd);
 2ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2f1:	89 04 24             	mov    %eax,(%esp)
 2f4:	e8 f3 02 00 00       	call   5ec <close>
}
 2f9:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2ff:	5b                   	pop    %ebx
 300:	5e                   	pop    %esi
 301:	5f                   	pop    %edi
 302:	5d                   	pop    %ebp
 303:	c3                   	ret    

00000304 <main>:

int
main(int argc, char *argv[])
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	83 e4 f0             	and    $0xfffffff0,%esp
 30a:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
 30d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 311:	7f 11                	jg     324 <main+0x20>
    ls(".");
 313:	c7 04 24 69 0b 00 00 	movl   $0xb69,(%esp)
 31a:	e8 91 fd ff ff       	call   b0 <ls>
    exit();
 31f:	e8 a0 02 00 00       	call   5c4 <exit>
  }
  for(i=1; i<argc; i++)
 324:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 32b:	00 
 32c:	eb 1f                	jmp    34d <main+0x49>
    ls(argv[i]);
 32e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 339:	8b 45 0c             	mov    0xc(%ebp),%eax
 33c:	01 d0                	add    %edx,%eax
 33e:	8b 00                	mov    (%eax),%eax
 340:	89 04 24             	mov    %eax,(%esp)
 343:	e8 68 fd ff ff       	call   b0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 348:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 34d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 351:	3b 45 08             	cmp    0x8(%ebp),%eax
 354:	7c d8                	jl     32e <main+0x2a>
    ls(argv[i]);
  exit();
 356:	e8 69 02 00 00       	call   5c4 <exit>
 35b:	90                   	nop

0000035c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	57                   	push   %edi
 360:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 361:	8b 4d 08             	mov    0x8(%ebp),%ecx
 364:	8b 55 10             	mov    0x10(%ebp),%edx
 367:	8b 45 0c             	mov    0xc(%ebp),%eax
 36a:	89 cb                	mov    %ecx,%ebx
 36c:	89 df                	mov    %ebx,%edi
 36e:	89 d1                	mov    %edx,%ecx
 370:	fc                   	cld    
 371:	f3 aa                	rep stos %al,%es:(%edi)
 373:	89 ca                	mov    %ecx,%edx
 375:	89 fb                	mov    %edi,%ebx
 377:	89 5d 08             	mov    %ebx,0x8(%ebp)
 37a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 37d:	5b                   	pop    %ebx
 37e:	5f                   	pop    %edi
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    

00000381 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
 384:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 38d:	90                   	nop
 38e:	8b 45 0c             	mov    0xc(%ebp),%eax
 391:	0f b6 10             	movzbl (%eax),%edx
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	88 10                	mov    %dl,(%eax)
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	0f b6 00             	movzbl (%eax),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	0f 95 c0             	setne  %al
 3a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3ac:	84 c0                	test   %al,%al
 3ae:	75 de                	jne    38e <strcpy+0xd>
    ;
  return os;
 3b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b3:	c9                   	leave  
 3b4:	c3                   	ret    

000003b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3b8:	eb 08                	jmp    3c2 <strcmp+0xd>
    p++, q++;
 3ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3be:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	0f b6 00             	movzbl (%eax),%eax
 3c8:	84 c0                	test   %al,%al
 3ca:	74 10                	je     3dc <strcmp+0x27>
 3cc:	8b 45 08             	mov    0x8(%ebp),%eax
 3cf:	0f b6 10             	movzbl (%eax),%edx
 3d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d5:	0f b6 00             	movzbl (%eax),%eax
 3d8:	38 c2                	cmp    %al,%dl
 3da:	74 de                	je     3ba <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	0f b6 00             	movzbl (%eax),%eax
 3e2:	0f b6 d0             	movzbl %al,%edx
 3e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e8:	0f b6 00             	movzbl (%eax),%eax
 3eb:	0f b6 c0             	movzbl %al,%eax
 3ee:	89 d1                	mov    %edx,%ecx
 3f0:	29 c1                	sub    %eax,%ecx
 3f2:	89 c8                	mov    %ecx,%eax
}
 3f4:	5d                   	pop    %ebp
 3f5:	c3                   	ret    

000003f6 <strlen>:

uint
strlen(char *s)
{
 3f6:	55                   	push   %ebp
 3f7:	89 e5                	mov    %esp,%ebp
 3f9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 403:	eb 04                	jmp    409 <strlen+0x13>
 405:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 409:	8b 55 fc             	mov    -0x4(%ebp),%edx
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
 40f:	01 d0                	add    %edx,%eax
 411:	0f b6 00             	movzbl (%eax),%eax
 414:	84 c0                	test   %al,%al
 416:	75 ed                	jne    405 <strlen+0xf>
    ;
  return n;
 418:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 41b:	c9                   	leave  
 41c:	c3                   	ret    

0000041d <memset>:

void*
memset(void *dst, int c, uint n)
{
 41d:	55                   	push   %ebp
 41e:	89 e5                	mov    %esp,%ebp
 420:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 423:	8b 45 10             	mov    0x10(%ebp),%eax
 426:	89 44 24 08          	mov    %eax,0x8(%esp)
 42a:	8b 45 0c             	mov    0xc(%ebp),%eax
 42d:	89 44 24 04          	mov    %eax,0x4(%esp)
 431:	8b 45 08             	mov    0x8(%ebp),%eax
 434:	89 04 24             	mov    %eax,(%esp)
 437:	e8 20 ff ff ff       	call   35c <stosb>
  return dst;
 43c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 43f:	c9                   	leave  
 440:	c3                   	ret    

00000441 <strchr>:

char*
strchr(const char *s, char c)
{
 441:	55                   	push   %ebp
 442:	89 e5                	mov    %esp,%ebp
 444:	83 ec 04             	sub    $0x4,%esp
 447:	8b 45 0c             	mov    0xc(%ebp),%eax
 44a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 44d:	eb 14                	jmp    463 <strchr+0x22>
    if(*s == c)
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	0f b6 00             	movzbl (%eax),%eax
 455:	3a 45 fc             	cmp    -0x4(%ebp),%al
 458:	75 05                	jne    45f <strchr+0x1e>
      return (char*)s;
 45a:	8b 45 08             	mov    0x8(%ebp),%eax
 45d:	eb 13                	jmp    472 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 45f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 463:	8b 45 08             	mov    0x8(%ebp),%eax
 466:	0f b6 00             	movzbl (%eax),%eax
 469:	84 c0                	test   %al,%al
 46b:	75 e2                	jne    44f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 46d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 472:	c9                   	leave  
 473:	c3                   	ret    

00000474 <gets>:

char*
gets(char *buf, int max)
{
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 47a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 481:	eb 46                	jmp    4c9 <gets+0x55>
    cc = read(0, &c, 1);
 483:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 48a:	00 
 48b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 48e:	89 44 24 04          	mov    %eax,0x4(%esp)
 492:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 499:	e8 3e 01 00 00       	call   5dc <read>
 49e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a5:	7e 2f                	jle    4d6 <gets+0x62>
      break;
    buf[i++] = c;
 4a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4aa:	8b 45 08             	mov    0x8(%ebp),%eax
 4ad:	01 c2                	add    %eax,%edx
 4af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b3:	88 02                	mov    %al,(%edx)
 4b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 4b9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4bd:	3c 0a                	cmp    $0xa,%al
 4bf:	74 16                	je     4d7 <gets+0x63>
 4c1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c5:	3c 0d                	cmp    $0xd,%al
 4c7:	74 0e                	je     4d7 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cc:	83 c0 01             	add    $0x1,%eax
 4cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4d2:	7c af                	jl     483 <gets+0xf>
 4d4:	eb 01                	jmp    4d7 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4d6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4da:	8b 45 08             	mov    0x8(%ebp),%eax
 4dd:	01 d0                	add    %edx,%eax
 4df:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4e5:	c9                   	leave  
 4e6:	c3                   	ret    

000004e7 <stat>:

int
stat(char *n, struct stat *st)
{
 4e7:	55                   	push   %ebp
 4e8:	89 e5                	mov    %esp,%ebp
 4ea:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4f4:	00 
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	89 04 24             	mov    %eax,(%esp)
 4fb:	e8 04 01 00 00       	call   604 <open>
 500:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 503:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 507:	79 07                	jns    510 <stat+0x29>
    return -1;
 509:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 50e:	eb 23                	jmp    533 <stat+0x4c>
  r = fstat(fd, st);
 510:	8b 45 0c             	mov    0xc(%ebp),%eax
 513:	89 44 24 04          	mov    %eax,0x4(%esp)
 517:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51a:	89 04 24             	mov    %eax,(%esp)
 51d:	e8 fa 00 00 00       	call   61c <fstat>
 522:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 525:	8b 45 f4             	mov    -0xc(%ebp),%eax
 528:	89 04 24             	mov    %eax,(%esp)
 52b:	e8 bc 00 00 00       	call   5ec <close>
  return r;
 530:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 533:	c9                   	leave  
 534:	c3                   	ret    

00000535 <atoi>:

int
atoi(const char *s)
{
 535:	55                   	push   %ebp
 536:	89 e5                	mov    %esp,%ebp
 538:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 53b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 542:	eb 23                	jmp    567 <atoi+0x32>
    n = n*10 + *s++ - '0';
 544:	8b 55 fc             	mov    -0x4(%ebp),%edx
 547:	89 d0                	mov    %edx,%eax
 549:	c1 e0 02             	shl    $0x2,%eax
 54c:	01 d0                	add    %edx,%eax
 54e:	01 c0                	add    %eax,%eax
 550:	89 c2                	mov    %eax,%edx
 552:	8b 45 08             	mov    0x8(%ebp),%eax
 555:	0f b6 00             	movzbl (%eax),%eax
 558:	0f be c0             	movsbl %al,%eax
 55b:	01 d0                	add    %edx,%eax
 55d:	83 e8 30             	sub    $0x30,%eax
 560:	89 45 fc             	mov    %eax,-0x4(%ebp)
 563:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 567:	8b 45 08             	mov    0x8(%ebp),%eax
 56a:	0f b6 00             	movzbl (%eax),%eax
 56d:	3c 2f                	cmp    $0x2f,%al
 56f:	7e 0a                	jle    57b <atoi+0x46>
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	0f b6 00             	movzbl (%eax),%eax
 577:	3c 39                	cmp    $0x39,%al
 579:	7e c9                	jle    544 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 57b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 57e:	c9                   	leave  
 57f:	c3                   	ret    

00000580 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 586:	8b 45 08             	mov    0x8(%ebp),%eax
 589:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 58c:	8b 45 0c             	mov    0xc(%ebp),%eax
 58f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 592:	eb 13                	jmp    5a7 <memmove+0x27>
    *dst++ = *src++;
 594:	8b 45 f8             	mov    -0x8(%ebp),%eax
 597:	0f b6 10             	movzbl (%eax),%edx
 59a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 59d:	88 10                	mov    %dl,(%eax)
 59f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 5a3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5ab:	0f 9f c0             	setg   %al
 5ae:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 5b2:	84 c0                	test   %al,%al
 5b4:	75 de                	jne    594 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5b9:	c9                   	leave  
 5ba:	c3                   	ret    
 5bb:	90                   	nop

000005bc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5bc:	b8 01 00 00 00       	mov    $0x1,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <exit>:
SYSCALL(exit)
 5c4:	b8 02 00 00 00       	mov    $0x2,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <wait>:
SYSCALL(wait)
 5cc:	b8 03 00 00 00       	mov    $0x3,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <pipe>:
SYSCALL(pipe)
 5d4:	b8 04 00 00 00       	mov    $0x4,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <read>:
SYSCALL(read)
 5dc:	b8 05 00 00 00       	mov    $0x5,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <write>:
SYSCALL(write)
 5e4:	b8 10 00 00 00       	mov    $0x10,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <close>:
SYSCALL(close)
 5ec:	b8 15 00 00 00       	mov    $0x15,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <kill>:
SYSCALL(kill)
 5f4:	b8 06 00 00 00       	mov    $0x6,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <exec>:
SYSCALL(exec)
 5fc:	b8 07 00 00 00       	mov    $0x7,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <open>:
SYSCALL(open)
 604:	b8 0f 00 00 00       	mov    $0xf,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <mknod>:
SYSCALL(mknod)
 60c:	b8 11 00 00 00       	mov    $0x11,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <unlink>:
SYSCALL(unlink)
 614:	b8 12 00 00 00       	mov    $0x12,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <fstat>:
SYSCALL(fstat)
 61c:	b8 08 00 00 00       	mov    $0x8,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <link>:
SYSCALL(link)
 624:	b8 13 00 00 00       	mov    $0x13,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <mkdir>:
SYSCALL(mkdir)
 62c:	b8 14 00 00 00       	mov    $0x14,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <chdir>:
SYSCALL(chdir)
 634:	b8 09 00 00 00       	mov    $0x9,%eax
 639:	cd 40                	int    $0x40
 63b:	c3                   	ret    

0000063c <dup>:
SYSCALL(dup)
 63c:	b8 0a 00 00 00       	mov    $0xa,%eax
 641:	cd 40                	int    $0x40
 643:	c3                   	ret    

00000644 <getpid>:
SYSCALL(getpid)
 644:	b8 0b 00 00 00       	mov    $0xb,%eax
 649:	cd 40                	int    $0x40
 64b:	c3                   	ret    

0000064c <sbrk>:
SYSCALL(sbrk)
 64c:	b8 0c 00 00 00       	mov    $0xc,%eax
 651:	cd 40                	int    $0x40
 653:	c3                   	ret    

00000654 <sleep>:
SYSCALL(sleep)
 654:	b8 0d 00 00 00       	mov    $0xd,%eax
 659:	cd 40                	int    $0x40
 65b:	c3                   	ret    

0000065c <uptime>:
SYSCALL(uptime)
 65c:	b8 0e 00 00 00       	mov    $0xe,%eax
 661:	cd 40                	int    $0x40
 663:	c3                   	ret    

00000664 <halt>:
SYSCALL(halt)
 664:	b8 16 00 00 00       	mov    $0x16,%eax
 669:	cd 40                	int    $0x40
 66b:	c3                   	ret    

0000066c <alarm>:
 66c:	b8 17 00 00 00       	mov    $0x17,%eax
 671:	cd 40                	int    $0x40
 673:	c3                   	ret    

00000674 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 674:	55                   	push   %ebp
 675:	89 e5                	mov    %esp,%ebp
 677:	83 ec 28             	sub    $0x28,%esp
 67a:	8b 45 0c             	mov    0xc(%ebp),%eax
 67d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 680:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 687:	00 
 688:	8d 45 f4             	lea    -0xc(%ebp),%eax
 68b:	89 44 24 04          	mov    %eax,0x4(%esp)
 68f:	8b 45 08             	mov    0x8(%ebp),%eax
 692:	89 04 24             	mov    %eax,(%esp)
 695:	e8 4a ff ff ff       	call   5e4 <write>
}
 69a:	c9                   	leave  
 69b:	c3                   	ret    

0000069c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 69c:	55                   	push   %ebp
 69d:	89 e5                	mov    %esp,%ebp
 69f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6a9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6ad:	74 17                	je     6c6 <printint+0x2a>
 6af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6b3:	79 11                	jns    6c6 <printint+0x2a>
    neg = 1;
 6b5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 6bf:	f7 d8                	neg    %eax
 6c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6c4:	eb 06                	jmp    6cc <printint+0x30>
  } else {
    x = xx;
 6c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6d9:	ba 00 00 00 00       	mov    $0x0,%edx
 6de:	f7 f1                	div    %ecx
 6e0:	89 d0                	mov    %edx,%eax
 6e2:	0f b6 80 04 0e 00 00 	movzbl 0xe04(%eax),%eax
 6e9:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 6ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6ef:	01 ca                	add    %ecx,%edx
 6f1:	88 02                	mov    %al,(%edx)
 6f3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 6f7:	8b 55 10             	mov    0x10(%ebp),%edx
 6fa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 700:	ba 00 00 00 00       	mov    $0x0,%edx
 705:	f7 75 d4             	divl   -0x2c(%ebp)
 708:	89 45 ec             	mov    %eax,-0x14(%ebp)
 70b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 70f:	75 c2                	jne    6d3 <printint+0x37>
  if(neg)
 711:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 715:	74 2e                	je     745 <printint+0xa9>
    buf[i++] = '-';
 717:	8d 55 dc             	lea    -0x24(%ebp),%edx
 71a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71d:	01 d0                	add    %edx,%eax
 71f:	c6 00 2d             	movb   $0x2d,(%eax)
 722:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 726:	eb 1d                	jmp    745 <printint+0xa9>
    putc(fd, buf[i]);
 728:	8d 55 dc             	lea    -0x24(%ebp),%edx
 72b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72e:	01 d0                	add    %edx,%eax
 730:	0f b6 00             	movzbl (%eax),%eax
 733:	0f be c0             	movsbl %al,%eax
 736:	89 44 24 04          	mov    %eax,0x4(%esp)
 73a:	8b 45 08             	mov    0x8(%ebp),%eax
 73d:	89 04 24             	mov    %eax,(%esp)
 740:	e8 2f ff ff ff       	call   674 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 745:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 749:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 74d:	79 d9                	jns    728 <printint+0x8c>
    putc(fd, buf[i]);
}
 74f:	c9                   	leave  
 750:	c3                   	ret    

00000751 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 751:	55                   	push   %ebp
 752:	89 e5                	mov    %esp,%ebp
 754:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 757:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 75e:	8d 45 0c             	lea    0xc(%ebp),%eax
 761:	83 c0 04             	add    $0x4,%eax
 764:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 767:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 76e:	e9 7d 01 00 00       	jmp    8f0 <printf+0x19f>
    c = fmt[i] & 0xff;
 773:	8b 55 0c             	mov    0xc(%ebp),%edx
 776:	8b 45 f0             	mov    -0x10(%ebp),%eax
 779:	01 d0                	add    %edx,%eax
 77b:	0f b6 00             	movzbl (%eax),%eax
 77e:	0f be c0             	movsbl %al,%eax
 781:	25 ff 00 00 00       	and    $0xff,%eax
 786:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 789:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 78d:	75 2c                	jne    7bb <printf+0x6a>
      if(c == '%'){
 78f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 793:	75 0c                	jne    7a1 <printf+0x50>
        state = '%';
 795:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 79c:	e9 4b 01 00 00       	jmp    8ec <printf+0x19b>
      } else {
        putc(fd, c);
 7a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a4:	0f be c0             	movsbl %al,%eax
 7a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ab:	8b 45 08             	mov    0x8(%ebp),%eax
 7ae:	89 04 24             	mov    %eax,(%esp)
 7b1:	e8 be fe ff ff       	call   674 <putc>
 7b6:	e9 31 01 00 00       	jmp    8ec <printf+0x19b>
      }
    } else if(state == '%'){
 7bb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7bf:	0f 85 27 01 00 00    	jne    8ec <printf+0x19b>
      if(c == 'd'){
 7c5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7c9:	75 2d                	jne    7f8 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 7cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ce:	8b 00                	mov    (%eax),%eax
 7d0:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7d7:	00 
 7d8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7df:	00 
 7e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e4:	8b 45 08             	mov    0x8(%ebp),%eax
 7e7:	89 04 24             	mov    %eax,(%esp)
 7ea:	e8 ad fe ff ff       	call   69c <printint>
        ap++;
 7ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7f3:	e9 ed 00 00 00       	jmp    8e5 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 7f8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7fc:	74 06                	je     804 <printf+0xb3>
 7fe:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 802:	75 2d                	jne    831 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 804:	8b 45 e8             	mov    -0x18(%ebp),%eax
 807:	8b 00                	mov    (%eax),%eax
 809:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 810:	00 
 811:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 818:	00 
 819:	89 44 24 04          	mov    %eax,0x4(%esp)
 81d:	8b 45 08             	mov    0x8(%ebp),%eax
 820:	89 04 24             	mov    %eax,(%esp)
 823:	e8 74 fe ff ff       	call   69c <printint>
        ap++;
 828:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 82c:	e9 b4 00 00 00       	jmp    8e5 <printf+0x194>
      } else if(c == 's'){
 831:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 835:	75 46                	jne    87d <printf+0x12c>
        s = (char*)*ap;
 837:	8b 45 e8             	mov    -0x18(%ebp),%eax
 83a:	8b 00                	mov    (%eax),%eax
 83c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 83f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 843:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 847:	75 27                	jne    870 <printf+0x11f>
          s = "(null)";
 849:	c7 45 f4 6b 0b 00 00 	movl   $0xb6b,-0xc(%ebp)
        while(*s != 0){
 850:	eb 1e                	jmp    870 <printf+0x11f>
          putc(fd, *s);
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	0f b6 00             	movzbl (%eax),%eax
 858:	0f be c0             	movsbl %al,%eax
 85b:	89 44 24 04          	mov    %eax,0x4(%esp)
 85f:	8b 45 08             	mov    0x8(%ebp),%eax
 862:	89 04 24             	mov    %eax,(%esp)
 865:	e8 0a fe ff ff       	call   674 <putc>
          s++;
 86a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 86e:	eb 01                	jmp    871 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 870:	90                   	nop
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	0f b6 00             	movzbl (%eax),%eax
 877:	84 c0                	test   %al,%al
 879:	75 d7                	jne    852 <printf+0x101>
 87b:	eb 68                	jmp    8e5 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 87d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 881:	75 1d                	jne    8a0 <printf+0x14f>
        putc(fd, *ap);
 883:	8b 45 e8             	mov    -0x18(%ebp),%eax
 886:	8b 00                	mov    (%eax),%eax
 888:	0f be c0             	movsbl %al,%eax
 88b:	89 44 24 04          	mov    %eax,0x4(%esp)
 88f:	8b 45 08             	mov    0x8(%ebp),%eax
 892:	89 04 24             	mov    %eax,(%esp)
 895:	e8 da fd ff ff       	call   674 <putc>
        ap++;
 89a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 89e:	eb 45                	jmp    8e5 <printf+0x194>
      } else if(c == '%'){
 8a0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8a4:	75 17                	jne    8bd <printf+0x16c>
        putc(fd, c);
 8a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8a9:	0f be c0             	movsbl %al,%eax
 8ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 8b0:	8b 45 08             	mov    0x8(%ebp),%eax
 8b3:	89 04 24             	mov    %eax,(%esp)
 8b6:	e8 b9 fd ff ff       	call   674 <putc>
 8bb:	eb 28                	jmp    8e5 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8bd:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8c4:	00 
 8c5:	8b 45 08             	mov    0x8(%ebp),%eax
 8c8:	89 04 24             	mov    %eax,(%esp)
 8cb:	e8 a4 fd ff ff       	call   674 <putc>
        putc(fd, c);
 8d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8d3:	0f be c0             	movsbl %al,%eax
 8d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 8da:	8b 45 08             	mov    0x8(%ebp),%eax
 8dd:	89 04 24             	mov    %eax,(%esp)
 8e0:	e8 8f fd ff ff       	call   674 <putc>
      }
      state = 0;
 8e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8ec:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8f0:	8b 55 0c             	mov    0xc(%ebp),%edx
 8f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f6:	01 d0                	add    %edx,%eax
 8f8:	0f b6 00             	movzbl (%eax),%eax
 8fb:	84 c0                	test   %al,%al
 8fd:	0f 85 70 fe ff ff    	jne    773 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 903:	c9                   	leave  
 904:	c3                   	ret    
 905:	66 90                	xchg   %ax,%ax
 907:	90                   	nop

00000908 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 908:	55                   	push   %ebp
 909:	89 e5                	mov    %esp,%ebp
 90b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 90e:	8b 45 08             	mov    0x8(%ebp),%eax
 911:	83 e8 08             	sub    $0x8,%eax
 914:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 917:	a1 30 0e 00 00       	mov    0xe30,%eax
 91c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 91f:	eb 24                	jmp    945 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 921:	8b 45 fc             	mov    -0x4(%ebp),%eax
 924:	8b 00                	mov    (%eax),%eax
 926:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 929:	77 12                	ja     93d <free+0x35>
 92b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 931:	77 24                	ja     957 <free+0x4f>
 933:	8b 45 fc             	mov    -0x4(%ebp),%eax
 936:	8b 00                	mov    (%eax),%eax
 938:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 93b:	77 1a                	ja     957 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 940:	8b 00                	mov    (%eax),%eax
 942:	89 45 fc             	mov    %eax,-0x4(%ebp)
 945:	8b 45 f8             	mov    -0x8(%ebp),%eax
 948:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 94b:	76 d4                	jbe    921 <free+0x19>
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	8b 00                	mov    (%eax),%eax
 952:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 955:	76 ca                	jbe    921 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 957:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95a:	8b 40 04             	mov    0x4(%eax),%eax
 95d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 964:	8b 45 f8             	mov    -0x8(%ebp),%eax
 967:	01 c2                	add    %eax,%edx
 969:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96c:	8b 00                	mov    (%eax),%eax
 96e:	39 c2                	cmp    %eax,%edx
 970:	75 24                	jne    996 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 972:	8b 45 f8             	mov    -0x8(%ebp),%eax
 975:	8b 50 04             	mov    0x4(%eax),%edx
 978:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97b:	8b 00                	mov    (%eax),%eax
 97d:	8b 40 04             	mov    0x4(%eax),%eax
 980:	01 c2                	add    %eax,%edx
 982:	8b 45 f8             	mov    -0x8(%ebp),%eax
 985:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 988:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98b:	8b 00                	mov    (%eax),%eax
 98d:	8b 10                	mov    (%eax),%edx
 98f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 992:	89 10                	mov    %edx,(%eax)
 994:	eb 0a                	jmp    9a0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 996:	8b 45 fc             	mov    -0x4(%ebp),%eax
 999:	8b 10                	mov    (%eax),%edx
 99b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a3:	8b 40 04             	mov    0x4(%eax),%eax
 9a6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b0:	01 d0                	add    %edx,%eax
 9b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9b5:	75 20                	jne    9d7 <free+0xcf>
    p->s.size += bp->s.size;
 9b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ba:	8b 50 04             	mov    0x4(%eax),%edx
 9bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c0:	8b 40 04             	mov    0x4(%eax),%eax
 9c3:	01 c2                	add    %eax,%edx
 9c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ce:	8b 10                	mov    (%eax),%edx
 9d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d3:	89 10                	mov    %edx,(%eax)
 9d5:	eb 08                	jmp    9df <free+0xd7>
  } else
    p->s.ptr = bp;
 9d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9da:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9dd:	89 10                	mov    %edx,(%eax)
  freep = p;
 9df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e2:	a3 30 0e 00 00       	mov    %eax,0xe30
}
 9e7:	c9                   	leave  
 9e8:	c3                   	ret    

000009e9 <morecore>:

static Header*
morecore(uint nu)
{
 9e9:	55                   	push   %ebp
 9ea:	89 e5                	mov    %esp,%ebp
 9ec:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9ef:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9f6:	77 07                	ja     9ff <morecore+0x16>
    nu = 4096;
 9f8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9ff:	8b 45 08             	mov    0x8(%ebp),%eax
 a02:	c1 e0 03             	shl    $0x3,%eax
 a05:	89 04 24             	mov    %eax,(%esp)
 a08:	e8 3f fc ff ff       	call   64c <sbrk>
 a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a10:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a14:	75 07                	jne    a1d <morecore+0x34>
    return 0;
 a16:	b8 00 00 00 00       	mov    $0x0,%eax
 a1b:	eb 22                	jmp    a3f <morecore+0x56>
  hp = (Header*)p;
 a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a26:	8b 55 08             	mov    0x8(%ebp),%edx
 a29:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2f:	83 c0 08             	add    $0x8,%eax
 a32:	89 04 24             	mov    %eax,(%esp)
 a35:	e8 ce fe ff ff       	call   908 <free>
  return freep;
 a3a:	a1 30 0e 00 00       	mov    0xe30,%eax
}
 a3f:	c9                   	leave  
 a40:	c3                   	ret    

00000a41 <malloc>:

void*
malloc(uint nbytes)
{
 a41:	55                   	push   %ebp
 a42:	89 e5                	mov    %esp,%ebp
 a44:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a47:	8b 45 08             	mov    0x8(%ebp),%eax
 a4a:	83 c0 07             	add    $0x7,%eax
 a4d:	c1 e8 03             	shr    $0x3,%eax
 a50:	83 c0 01             	add    $0x1,%eax
 a53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a56:	a1 30 0e 00 00       	mov    0xe30,%eax
 a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a62:	75 23                	jne    a87 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a64:	c7 45 f0 28 0e 00 00 	movl   $0xe28,-0x10(%ebp)
 a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6e:	a3 30 0e 00 00       	mov    %eax,0xe30
 a73:	a1 30 0e 00 00       	mov    0xe30,%eax
 a78:	a3 28 0e 00 00       	mov    %eax,0xe28
    base.s.size = 0;
 a7d:	c7 05 2c 0e 00 00 00 	movl   $0x0,0xe2c
 a84:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a8a:	8b 00                	mov    (%eax),%eax
 a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a92:	8b 40 04             	mov    0x4(%eax),%eax
 a95:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a98:	72 4d                	jb     ae7 <malloc+0xa6>
      if(p->s.size == nunits)
 a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9d:	8b 40 04             	mov    0x4(%eax),%eax
 aa0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aa3:	75 0c                	jne    ab1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa8:	8b 10                	mov    (%eax),%edx
 aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aad:	89 10                	mov    %edx,(%eax)
 aaf:	eb 26                	jmp    ad7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab4:	8b 40 04             	mov    0x4(%eax),%eax
 ab7:	89 c2                	mov    %eax,%edx
 ab9:	2b 55 ec             	sub    -0x14(%ebp),%edx
 abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac5:	8b 40 04             	mov    0x4(%eax),%eax
 ac8:	c1 e0 03             	shl    $0x3,%eax
 acb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ad4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ada:	a3 30 0e 00 00       	mov    %eax,0xe30
      return (void*)(p + 1);
 adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae2:	83 c0 08             	add    $0x8,%eax
 ae5:	eb 38                	jmp    b1f <malloc+0xde>
    }
    if(p == freep)
 ae7:	a1 30 0e 00 00       	mov    0xe30,%eax
 aec:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aef:	75 1b                	jne    b0c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 af4:	89 04 24             	mov    %eax,(%esp)
 af7:	e8 ed fe ff ff       	call   9e9 <morecore>
 afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b03:	75 07                	jne    b0c <malloc+0xcb>
        return 0;
 b05:	b8 00 00 00 00       	mov    $0x0,%eax
 b0a:	eb 13                	jmp    b1f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b15:	8b 00                	mov    (%eax),%eax
 b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b1a:	e9 70 ff ff ff       	jmp    a8f <malloc+0x4e>
}
 b1f:	c9                   	leave  
 b20:	c3                   	ret    
