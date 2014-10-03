
_sh：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;


  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 eb 0f 00 00       	call   ffc <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 9c 15 00 00 	mov    0x159c(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	c7 04 24 5c 15 00 00 	movl   $0x155c,(%esp)
      2b:	e8 5c 03 00 00       	call   38c <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      30:	8b 45 08             	mov    0x8(%ebp),%eax
      33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      36:	8b 45 f4             	mov    -0xc(%ebp),%eax
      39:	8b 40 04             	mov    0x4(%eax),%eax
      3c:	85 c0                	test   %eax,%eax
      3e:	75 05                	jne    45 <runcmd+0x45>
      exit();
      40:	e8 b7 0f 00 00       	call   ffc <exit>
    printf(2,"argv:%s %s\n",ecmd->argv[0],ecmd->argv[1]);
      45:	8b 45 f4             	mov    -0xc(%ebp),%eax
      48:	8b 50 08             	mov    0x8(%eax),%edx
      4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4e:	8b 40 04             	mov    0x4(%eax),%eax
      51:	89 54 24 0c          	mov    %edx,0xc(%esp)
      55:	89 44 24 08          	mov    %eax,0x8(%esp)
      59:	c7 44 24 04 63 15 00 	movl   $0x1563,0x4(%esp)
      60:	00 
      61:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      68:	e8 1c 11 00 00       	call   1189 <printf>
    int ret = exec(ecmd->argv[0], ecmd->argv);
      6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      70:	8d 50 04             	lea    0x4(%eax),%edx
      73:	8b 45 f4             	mov    -0xc(%ebp),%eax
      76:	8b 40 04             	mov    0x4(%eax),%eax
      79:	89 54 24 04          	mov    %edx,0x4(%esp)
      7d:	89 04 24             	mov    %eax,(%esp)
      80:	e8 af 0f 00 00       	call   1034 <exec>
      85:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(2, "exec %s failed here:%d\n", ecmd->argv[0],ret);
      88:	8b 45 f4             	mov    -0xc(%ebp),%eax
      8b:	8b 40 04             	mov    0x4(%eax),%eax
      8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
      91:	89 54 24 0c          	mov    %edx,0xc(%esp)
      95:	89 44 24 08          	mov    %eax,0x8(%esp)
      99:	c7 44 24 04 6f 15 00 	movl   $0x156f,0x4(%esp)
      a0:	00 
      a1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      a8:	e8 dc 10 00 00       	call   1189 <printf>
    break;
      ad:	e9 84 01 00 00       	jmp    236 <runcmd+0x236>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      b2:	8b 45 08             	mov    0x8(%ebp),%eax
      b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(rcmd->fd);
      b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
      bb:	8b 40 14             	mov    0x14(%eax),%eax
      be:	89 04 24             	mov    %eax,(%esp)
      c1:	e8 5e 0f 00 00       	call   1024 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
      c9:	8b 50 10             	mov    0x10(%eax),%edx
      cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
      cf:	8b 40 08             	mov    0x8(%eax),%eax
      d2:	89 54 24 04          	mov    %edx,0x4(%esp)
      d6:	89 04 24             	mov    %eax,(%esp)
      d9:	e8 5e 0f 00 00       	call   103c <open>
      de:	85 c0                	test   %eax,%eax
      e0:	79 23                	jns    105 <runcmd+0x105>
      printf(2, "open %s failed\n", rcmd->file);
      e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
      e5:	8b 40 08             	mov    0x8(%eax),%eax
      e8:	89 44 24 08          	mov    %eax,0x8(%esp)
      ec:	c7 44 24 04 87 15 00 	movl   $0x1587,0x4(%esp)
      f3:	00 
      f4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      fb:	e8 89 10 00 00       	call   1189 <printf>
      exit();
     100:	e8 f7 0e 00 00       	call   ffc <exit>
    }
    runcmd(rcmd->cmd);
     105:	8b 45 ec             	mov    -0x14(%ebp),%eax
     108:	8b 40 04             	mov    0x4(%eax),%eax
     10b:	89 04 24             	mov    %eax,(%esp)
     10e:	e8 ed fe ff ff       	call   0 <runcmd>
    break;
     113:	e9 1e 01 00 00       	jmp    236 <runcmd+0x236>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     118:	8b 45 08             	mov    0x8(%ebp),%eax
     11b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fork1() == 0)
     11e:	e8 8f 02 00 00       	call   3b2 <fork1>
     123:	85 c0                	test   %eax,%eax
     125:	75 0e                	jne    135 <runcmd+0x135>
      runcmd(lcmd->left);
     127:	8b 45 e8             	mov    -0x18(%ebp),%eax
     12a:	8b 40 04             	mov    0x4(%eax),%eax
     12d:	89 04 24             	mov    %eax,(%esp)
     130:	e8 cb fe ff ff       	call   0 <runcmd>
    wait();
     135:	e8 ca 0e 00 00       	call   1004 <wait>
    runcmd(lcmd->right);
     13a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     13d:	8b 40 08             	mov    0x8(%eax),%eax
     140:	89 04 24             	mov    %eax,(%esp)
     143:	e8 b8 fe ff ff       	call   0 <runcmd>
    break;
     148:	e9 e9 00 00 00       	jmp    236 <runcmd+0x236>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     14d:	8b 45 08             	mov    0x8(%ebp),%eax
     150:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pipe(p) < 0)
     153:	8d 45 d8             	lea    -0x28(%ebp),%eax
     156:	89 04 24             	mov    %eax,(%esp)
     159:	e8 ae 0e 00 00       	call   100c <pipe>
     15e:	85 c0                	test   %eax,%eax
     160:	79 0c                	jns    16e <runcmd+0x16e>
      panic("pipe");
     162:	c7 04 24 97 15 00 00 	movl   $0x1597,(%esp)
     169:	e8 1e 02 00 00       	call   38c <panic>
    if(fork1() == 0){
     16e:	e8 3f 02 00 00       	call   3b2 <fork1>
     173:	85 c0                	test   %eax,%eax
     175:	75 3b                	jne    1b2 <runcmd+0x1b2>
      close(1);
     177:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     17e:	e8 a1 0e 00 00       	call   1024 <close>
      dup(p[1]);
     183:	8b 45 dc             	mov    -0x24(%ebp),%eax
     186:	89 04 24             	mov    %eax,(%esp)
     189:	e8 e6 0e 00 00       	call   1074 <dup>
      close(p[0]);
     18e:	8b 45 d8             	mov    -0x28(%ebp),%eax
     191:	89 04 24             	mov    %eax,(%esp)
     194:	e8 8b 0e 00 00       	call   1024 <close>
      close(p[1]);
     199:	8b 45 dc             	mov    -0x24(%ebp),%eax
     19c:	89 04 24             	mov    %eax,(%esp)
     19f:	e8 80 0e 00 00       	call   1024 <close>
      runcmd(pcmd->left);
     1a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1a7:	8b 40 04             	mov    0x4(%eax),%eax
     1aa:	89 04 24             	mov    %eax,(%esp)
     1ad:	e8 4e fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     1b2:	e8 fb 01 00 00       	call   3b2 <fork1>
     1b7:	85 c0                	test   %eax,%eax
     1b9:	75 3b                	jne    1f6 <runcmd+0x1f6>
      close(0);
     1bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1c2:	e8 5d 0e 00 00       	call   1024 <close>
      dup(p[0]);
     1c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
     1ca:	89 04 24             	mov    %eax,(%esp)
     1cd:	e8 a2 0e 00 00       	call   1074 <dup>
      close(p[0]);
     1d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
     1d5:	89 04 24             	mov    %eax,(%esp)
     1d8:	e8 47 0e 00 00       	call   1024 <close>
      close(p[1]);
     1dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1e0:	89 04 24             	mov    %eax,(%esp)
     1e3:	e8 3c 0e 00 00       	call   1024 <close>
      runcmd(pcmd->right);
     1e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1eb:	8b 40 08             	mov    0x8(%eax),%eax
     1ee:	89 04 24             	mov    %eax,(%esp)
     1f1:	e8 0a fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
     1f9:	89 04 24             	mov    %eax,(%esp)
     1fc:	e8 23 0e 00 00       	call   1024 <close>
    close(p[1]);
     201:	8b 45 dc             	mov    -0x24(%ebp),%eax
     204:	89 04 24             	mov    %eax,(%esp)
     207:	e8 18 0e 00 00       	call   1024 <close>
    wait();
     20c:	e8 f3 0d 00 00       	call   1004 <wait>
    wait();
     211:	e8 ee 0d 00 00       	call   1004 <wait>
    break;
     216:	eb 1e                	jmp    236 <runcmd+0x236>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     218:	8b 45 08             	mov    0x8(%ebp),%eax
     21b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(fork1() == 0)
     21e:	e8 8f 01 00 00       	call   3b2 <fork1>
     223:	85 c0                	test   %eax,%eax
     225:	75 0e                	jne    235 <runcmd+0x235>
      runcmd(bcmd->cmd);
     227:	8b 45 e0             	mov    -0x20(%ebp),%eax
     22a:	8b 40 04             	mov    0x4(%eax),%eax
     22d:	89 04 24             	mov    %eax,(%esp)
     230:	e8 cb fd ff ff       	call   0 <runcmd>
    break;
     235:	90                   	nop
  }
  exit();
     236:	e8 c1 0d 00 00       	call   ffc <exit>

0000023b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     23b:	55                   	push   %ebp
     23c:	89 e5                	mov    %esp,%ebp
     23e:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     241:	c7 44 24 04 b4 15 00 	movl   $0x15b4,0x4(%esp)
     248:	00 
     249:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     250:	e8 34 0f 00 00       	call   1189 <printf>
  memset(buf, 0, nbuf);
     255:	8b 45 0c             	mov    0xc(%ebp),%eax
     258:	89 44 24 08          	mov    %eax,0x8(%esp)
     25c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     263:	00 
     264:	8b 45 08             	mov    0x8(%ebp),%eax
     267:	89 04 24             	mov    %eax,(%esp)
     26a:	e8 e6 0b 00 00       	call   e55 <memset>
  gets(buf, nbuf);
     26f:	8b 45 0c             	mov    0xc(%ebp),%eax
     272:	89 44 24 04          	mov    %eax,0x4(%esp)
     276:	8b 45 08             	mov    0x8(%ebp),%eax
     279:	89 04 24             	mov    %eax,(%esp)
     27c:	e8 2b 0c 00 00       	call   eac <gets>
  if(buf[0] == 0) // EOF
     281:	8b 45 08             	mov    0x8(%ebp),%eax
     284:	0f b6 00             	movzbl (%eax),%eax
     287:	84 c0                	test   %al,%al
     289:	75 07                	jne    292 <getcmd+0x57>
    return -1;
     28b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     290:	eb 05                	jmp    297 <getcmd+0x5c>
  return 0;
     292:	b8 00 00 00 00       	mov    $0x0,%eax
}
     297:	c9                   	leave  
     298:	c3                   	ret    

00000299 <main>:

int
main(void)
{
     299:	55                   	push   %ebp
     29a:	89 e5                	mov    %esp,%ebp
     29c:	83 e4 f0             	and    $0xfffffff0,%esp
     29f:	83 ec 20             	sub    $0x20,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2a2:	eb 19                	jmp    2bd <main+0x24>
    if(fd >= 3){
     2a4:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
     2a9:	7e 12                	jle    2bd <main+0x24>
      close(fd);
     2ab:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     2af:	89 04 24             	mov    %eax,(%esp)
     2b2:	e8 6d 0d 00 00       	call   1024 <close>
      break;
     2b7:	90                   	nop
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2b8:	e9 ae 00 00 00       	jmp    36b <main+0xd2>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2bd:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     2c4:	00 
     2c5:	c7 04 24 b7 15 00 00 	movl   $0x15b7,(%esp)
     2cc:	e8 6b 0d 00 00       	call   103c <open>
     2d1:	89 44 24 1c          	mov    %eax,0x1c(%esp)
     2d5:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
     2da:	79 c8                	jns    2a4 <main+0xb>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2dc:	e9 8a 00 00 00       	jmp    36b <main+0xd2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2e1:	0f b6 05 40 1b 00 00 	movzbl 0x1b40,%eax
     2e8:	3c 63                	cmp    $0x63,%al
     2ea:	75 5a                	jne    346 <main+0xad>
     2ec:	0f b6 05 41 1b 00 00 	movzbl 0x1b41,%eax
     2f3:	3c 64                	cmp    $0x64,%al
     2f5:	75 4f                	jne    346 <main+0xad>
     2f7:	0f b6 05 42 1b 00 00 	movzbl 0x1b42,%eax
     2fe:	3c 20                	cmp    $0x20,%al
     300:	75 44                	jne    346 <main+0xad>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     302:	c7 04 24 40 1b 00 00 	movl   $0x1b40,(%esp)
     309:	e8 20 0b 00 00       	call   e2e <strlen>
     30e:	83 e8 01             	sub    $0x1,%eax
     311:	c6 80 40 1b 00 00 00 	movb   $0x0,0x1b40(%eax)
      if(chdir(buf+3) < 0)
     318:	c7 04 24 43 1b 00 00 	movl   $0x1b43,(%esp)
     31f:	e8 48 0d 00 00       	call   106c <chdir>
     324:	85 c0                	test   %eax,%eax
     326:	79 42                	jns    36a <main+0xd1>
        printf(2, "cannot cd %s\n", buf+3);
     328:	c7 44 24 08 43 1b 00 	movl   $0x1b43,0x8(%esp)
     32f:	00 
     330:	c7 44 24 04 bf 15 00 	movl   $0x15bf,0x4(%esp)
     337:	00 
     338:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     33f:	e8 45 0e 00 00       	call   1189 <printf>
      continue;
     344:	eb 24                	jmp    36a <main+0xd1>
    }
    if(fork1() == 0)
     346:	e8 67 00 00 00       	call   3b2 <fork1>
     34b:	85 c0                	test   %eax,%eax
     34d:	75 14                	jne    363 <main+0xca>
      runcmd(parsecmd(buf));
     34f:	c7 04 24 40 1b 00 00 	movl   $0x1b40,(%esp)
     356:	e8 2d 04 00 00       	call   788 <parsecmd>
     35b:	89 04 24             	mov    %eax,(%esp)
     35e:	e8 9d fc ff ff       	call   0 <runcmd>
    wait();
     363:	e8 9c 0c 00 00       	call   1004 <wait>
     368:	eb 01                	jmp    36b <main+0xd2>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
     36a:	90                   	nop
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     36b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     372:	00 
     373:	c7 04 24 40 1b 00 00 	movl   $0x1b40,(%esp)
     37a:	e8 bc fe ff ff       	call   23b <getcmd>
     37f:	85 c0                	test   %eax,%eax
     381:	0f 89 5a ff ff ff    	jns    2e1 <main+0x48>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     387:	e8 70 0c 00 00       	call   ffc <exit>

0000038c <panic>:
}

void
panic(char *s)
{
     38c:	55                   	push   %ebp
     38d:	89 e5                	mov    %esp,%ebp
     38f:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     392:	8b 45 08             	mov    0x8(%ebp),%eax
     395:	89 44 24 08          	mov    %eax,0x8(%esp)
     399:	c7 44 24 04 cd 15 00 	movl   $0x15cd,0x4(%esp)
     3a0:	00 
     3a1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     3a8:	e8 dc 0d 00 00       	call   1189 <printf>
  exit();
     3ad:	e8 4a 0c 00 00       	call   ffc <exit>

000003b2 <fork1>:
}

int
fork1(void)
{
     3b2:	55                   	push   %ebp
     3b3:	89 e5                	mov    %esp,%ebp
     3b5:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     3b8:	e8 37 0c 00 00       	call   ff4 <fork>
     3bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     3c0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     3c4:	75 0c                	jne    3d2 <fork1+0x20>
    panic("fork");
     3c6:	c7 04 24 d1 15 00 00 	movl   $0x15d1,(%esp)
     3cd:	e8 ba ff ff ff       	call   38c <panic>
  return pid;
     3d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3d5:	c9                   	leave  
     3d6:	c3                   	ret    

000003d7 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3d7:	55                   	push   %ebp
     3d8:	89 e5                	mov    %esp,%ebp
     3da:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;
  printf(2,"execcmd\n");
     3dd:	c7 44 24 04 d6 15 00 	movl   $0x15d6,0x4(%esp)
     3e4:	00 
     3e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     3ec:	e8 98 0d 00 00       	call   1189 <printf>
  cmd = malloc(sizeof(*cmd));
     3f1:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3f8:	e8 7c 10 00 00       	call   1479 <malloc>
     3fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     400:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     407:	00 
     408:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     40f:	00 
     410:	8b 45 f4             	mov    -0xc(%ebp),%eax
     413:	89 04 24             	mov    %eax,(%esp)
     416:	e8 3a 0a 00 00       	call   e55 <memset>
  cmd->type = EXEC;
     41b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     41e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     424:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     427:	c9                   	leave  
     428:	c3                   	ret    

00000429 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     429:	55                   	push   %ebp
     42a:	89 e5                	mov    %esp,%ebp
     42c:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;
  printf(2,"redicmd\n");
     42f:	c7 44 24 04 df 15 00 	movl   $0x15df,0x4(%esp)
     436:	00 
     437:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     43e:	e8 46 0d 00 00       	call   1189 <printf>
  cmd = malloc(sizeof(*cmd));
     443:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     44a:	e8 2a 10 00 00       	call   1479 <malloc>
     44f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     452:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     459:	00 
     45a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     461:	00 
     462:	8b 45 f4             	mov    -0xc(%ebp),%eax
     465:	89 04 24             	mov    %eax,(%esp)
     468:	e8 e8 09 00 00       	call   e55 <memset>
  cmd->type = REDIR;
     46d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     470:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     476:	8b 45 f4             	mov    -0xc(%ebp),%eax
     479:	8b 55 08             	mov    0x8(%ebp),%edx
     47c:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     47f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     482:	8b 55 0c             	mov    0xc(%ebp),%edx
     485:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     488:	8b 45 f4             	mov    -0xc(%ebp),%eax
     48b:	8b 55 10             	mov    0x10(%ebp),%edx
     48e:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     491:	8b 45 f4             	mov    -0xc(%ebp),%eax
     494:	8b 55 14             	mov    0x14(%ebp),%edx
     497:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     49a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     49d:	8b 55 18             	mov    0x18(%ebp),%edx
     4a0:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     4a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4a6:	c9                   	leave  
     4a7:	c3                   	ret    

000004a8 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     4a8:	55                   	push   %ebp
     4a9:	89 e5                	mov    %esp,%ebp
     4ab:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;
  printf(2,"pipe cmd\n");
     4ae:	c7 44 24 04 e8 15 00 	movl   $0x15e8,0x4(%esp)
     4b5:	00 
     4b6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     4bd:	e8 c7 0c 00 00       	call   1189 <printf>
  cmd = malloc(sizeof(*cmd));
     4c2:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     4c9:	e8 ab 0f 00 00       	call   1479 <malloc>
     4ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4d1:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     4d8:	00 
     4d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4e0:	00 
     4e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e4:	89 04 24             	mov    %eax,(%esp)
     4e7:	e8 69 09 00 00       	call   e55 <memset>
  cmd->type = PIPE;
     4ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ef:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     4f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f8:	8b 55 08             	mov    0x8(%ebp),%edx
     4fb:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     501:	8b 55 0c             	mov    0xc(%ebp),%edx
     504:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     507:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     50a:	c9                   	leave  
     50b:	c3                   	ret    

0000050c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     50c:	55                   	push   %ebp
     50d:	89 e5                	mov    %esp,%ebp
     50f:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;
  printf(2,"listcmd\n");
     512:	c7 44 24 04 f2 15 00 	movl   $0x15f2,0x4(%esp)
     519:	00 
     51a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     521:	e8 63 0c 00 00       	call   1189 <printf>
  cmd = malloc(sizeof(*cmd));
     526:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     52d:	e8 47 0f 00 00       	call   1479 <malloc>
     532:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     535:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     53c:	00 
     53d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     544:	00 
     545:	8b 45 f4             	mov    -0xc(%ebp),%eax
     548:	89 04 24             	mov    %eax,(%esp)
     54b:	e8 05 09 00 00       	call   e55 <memset>
  cmd->type = LIST;
     550:	8b 45 f4             	mov    -0xc(%ebp),%eax
     553:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     559:	8b 45 f4             	mov    -0xc(%ebp),%eax
     55c:	8b 55 08             	mov    0x8(%ebp),%edx
     55f:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     562:	8b 45 f4             	mov    -0xc(%ebp),%eax
     565:	8b 55 0c             	mov    0xc(%ebp),%edx
     568:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     56b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     56e:	c9                   	leave  
     56f:	c3                   	ret    

00000570 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     570:	55                   	push   %ebp
     571:	89 e5                	mov    %esp,%ebp
     573:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;
  printf(2,"backcmd\n");
     576:	c7 44 24 04 fb 15 00 	movl   $0x15fb,0x4(%esp)
     57d:	00 
     57e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     585:	e8 ff 0b 00 00       	call   1189 <printf>
  cmd = malloc(sizeof(*cmd));
     58a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     591:	e8 e3 0e 00 00       	call   1479 <malloc>
     596:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     599:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     5a0:	00 
     5a1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     5a8:	00 
     5a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5ac:	89 04 24             	mov    %eax,(%esp)
     5af:	e8 a1 08 00 00       	call   e55 <memset>
  cmd->type = BACK;
     5b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5b7:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     5bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5c0:	8b 55 08             	mov    0x8(%ebp),%edx
     5c3:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     5c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     5c9:	c9                   	leave  
     5ca:	c3                   	ret    

000005cb <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     5cb:	55                   	push   %ebp
     5cc:	89 e5                	mov    %esp,%ebp
     5ce:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;
  
  s = *ps;
     5d1:	8b 45 08             	mov    0x8(%ebp),%eax
     5d4:	8b 00                	mov    (%eax),%eax
     5d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     5d9:	eb 04                	jmp    5df <gettoken+0x14>
    s++;
     5db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     5df:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5e5:	73 1d                	jae    604 <gettoken+0x39>
     5e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5ea:	0f b6 00             	movzbl (%eax),%eax
     5ed:	0f be c0             	movsbl %al,%eax
     5f0:	89 44 24 04          	mov    %eax,0x4(%esp)
     5f4:	c7 04 24 10 1b 00 00 	movl   $0x1b10,(%esp)
     5fb:	e8 79 08 00 00       	call   e79 <strchr>
     600:	85 c0                	test   %eax,%eax
     602:	75 d7                	jne    5db <gettoken+0x10>
    s++;
  if(q)
     604:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     608:	74 08                	je     612 <gettoken+0x47>
    *q = s;
     60a:	8b 45 10             	mov    0x10(%ebp),%eax
     60d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     610:	89 10                	mov    %edx,(%eax)
  ret = *s;
     612:	8b 45 f4             	mov    -0xc(%ebp),%eax
     615:	0f b6 00             	movzbl (%eax),%eax
     618:	0f be c0             	movsbl %al,%eax
     61b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     61e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     621:	0f b6 00             	movzbl (%eax),%eax
     624:	0f be c0             	movsbl %al,%eax
     627:	83 f8 3c             	cmp    $0x3c,%eax
     62a:	7f 1e                	jg     64a <gettoken+0x7f>
     62c:	83 f8 3b             	cmp    $0x3b,%eax
     62f:	7d 23                	jge    654 <gettoken+0x89>
     631:	83 f8 29             	cmp    $0x29,%eax
     634:	7f 3f                	jg     675 <gettoken+0xaa>
     636:	83 f8 28             	cmp    $0x28,%eax
     639:	7d 19                	jge    654 <gettoken+0x89>
     63b:	85 c0                	test   %eax,%eax
     63d:	0f 84 83 00 00 00    	je     6c6 <gettoken+0xfb>
     643:	83 f8 26             	cmp    $0x26,%eax
     646:	74 0c                	je     654 <gettoken+0x89>
     648:	eb 2b                	jmp    675 <gettoken+0xaa>
     64a:	83 f8 3e             	cmp    $0x3e,%eax
     64d:	74 0b                	je     65a <gettoken+0x8f>
     64f:	83 f8 7c             	cmp    $0x7c,%eax
     652:	75 21                	jne    675 <gettoken+0xaa>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     654:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     658:	eb 73                	jmp    6cd <gettoken+0x102>
  case '>':
    s++;
     65a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     65e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     661:	0f b6 00             	movzbl (%eax),%eax
     664:	3c 3e                	cmp    $0x3e,%al
     666:	75 61                	jne    6c9 <gettoken+0xfe>
      ret = '+';
     668:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     66f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     673:	eb 54                	jmp    6c9 <gettoken+0xfe>
  default:
    ret = 'a';
     675:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     67c:	eb 04                	jmp    682 <gettoken+0xb7>
      s++;
     67e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     682:	8b 45 f4             	mov    -0xc(%ebp),%eax
     685:	3b 45 0c             	cmp    0xc(%ebp),%eax
     688:	73 42                	jae    6cc <gettoken+0x101>
     68a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     68d:	0f b6 00             	movzbl (%eax),%eax
     690:	0f be c0             	movsbl %al,%eax
     693:	89 44 24 04          	mov    %eax,0x4(%esp)
     697:	c7 04 24 10 1b 00 00 	movl   $0x1b10,(%esp)
     69e:	e8 d6 07 00 00       	call   e79 <strchr>
     6a3:	85 c0                	test   %eax,%eax
     6a5:	75 25                	jne    6cc <gettoken+0x101>
     6a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6aa:	0f b6 00             	movzbl (%eax),%eax
     6ad:	0f be c0             	movsbl %al,%eax
     6b0:	89 44 24 04          	mov    %eax,0x4(%esp)
     6b4:	c7 04 24 16 1b 00 00 	movl   $0x1b16,(%esp)
     6bb:	e8 b9 07 00 00       	call   e79 <strchr>
     6c0:	85 c0                	test   %eax,%eax
     6c2:	74 ba                	je     67e <gettoken+0xb3>
      s++;
    break;
     6c4:	eb 06                	jmp    6cc <gettoken+0x101>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     6c6:	90                   	nop
     6c7:	eb 04                	jmp    6cd <gettoken+0x102>
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
     6c9:	90                   	nop
     6ca:	eb 01                	jmp    6cd <gettoken+0x102>
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
     6cc:	90                   	nop
  }
  if(eq)
     6cd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     6d1:	74 0e                	je     6e1 <gettoken+0x116>
    *eq = s;
     6d3:	8b 45 14             	mov    0x14(%ebp),%eax
     6d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6d9:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     6db:	eb 04                	jmp    6e1 <gettoken+0x116>
    s++;
     6dd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     6e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
     6e7:	73 1d                	jae    706 <gettoken+0x13b>
     6e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ec:	0f b6 00             	movzbl (%eax),%eax
     6ef:	0f be c0             	movsbl %al,%eax
     6f2:	89 44 24 04          	mov    %eax,0x4(%esp)
     6f6:	c7 04 24 10 1b 00 00 	movl   $0x1b10,(%esp)
     6fd:	e8 77 07 00 00       	call   e79 <strchr>
     702:	85 c0                	test   %eax,%eax
     704:	75 d7                	jne    6dd <gettoken+0x112>
    s++;
  *ps = s;
     706:	8b 45 08             	mov    0x8(%ebp),%eax
     709:	8b 55 f4             	mov    -0xc(%ebp),%edx
     70c:	89 10                	mov    %edx,(%eax)
  return ret;
     70e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     711:	c9                   	leave  
     712:	c3                   	ret    

00000713 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     713:	55                   	push   %ebp
     714:	89 e5                	mov    %esp,%ebp
     716:	83 ec 28             	sub    $0x28,%esp
  char *s;
  
  s = *ps;
     719:	8b 45 08             	mov    0x8(%ebp),%eax
     71c:	8b 00                	mov    (%eax),%eax
     71e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     721:	eb 04                	jmp    727 <peek+0x14>
    s++;
     723:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     727:	8b 45 f4             	mov    -0xc(%ebp),%eax
     72a:	3b 45 0c             	cmp    0xc(%ebp),%eax
     72d:	73 1d                	jae    74c <peek+0x39>
     72f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     732:	0f b6 00             	movzbl (%eax),%eax
     735:	0f be c0             	movsbl %al,%eax
     738:	89 44 24 04          	mov    %eax,0x4(%esp)
     73c:	c7 04 24 10 1b 00 00 	movl   $0x1b10,(%esp)
     743:	e8 31 07 00 00       	call   e79 <strchr>
     748:	85 c0                	test   %eax,%eax
     74a:	75 d7                	jne    723 <peek+0x10>
    s++;
  *ps = s;
     74c:	8b 45 08             	mov    0x8(%ebp),%eax
     74f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     752:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     754:	8b 45 f4             	mov    -0xc(%ebp),%eax
     757:	0f b6 00             	movzbl (%eax),%eax
     75a:	84 c0                	test   %al,%al
     75c:	74 23                	je     781 <peek+0x6e>
     75e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     761:	0f b6 00             	movzbl (%eax),%eax
     764:	0f be c0             	movsbl %al,%eax
     767:	89 44 24 04          	mov    %eax,0x4(%esp)
     76b:	8b 45 10             	mov    0x10(%ebp),%eax
     76e:	89 04 24             	mov    %eax,(%esp)
     771:	e8 03 07 00 00       	call   e79 <strchr>
     776:	85 c0                	test   %eax,%eax
     778:	74 07                	je     781 <peek+0x6e>
     77a:	b8 01 00 00 00       	mov    $0x1,%eax
     77f:	eb 05                	jmp    786 <peek+0x73>
     781:	b8 00 00 00 00       	mov    $0x0,%eax
}
     786:	c9                   	leave  
     787:	c3                   	ret    

00000788 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     788:	55                   	push   %ebp
     789:	89 e5                	mov    %esp,%ebp
     78b:	53                   	push   %ebx
     78c:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     78f:	8b 5d 08             	mov    0x8(%ebp),%ebx
     792:	8b 45 08             	mov    0x8(%ebp),%eax
     795:	89 04 24             	mov    %eax,(%esp)
     798:	e8 91 06 00 00       	call   e2e <strlen>
     79d:	01 d8                	add    %ebx,%eax
     79f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7a5:	89 44 24 04          	mov    %eax,0x4(%esp)
     7a9:	8d 45 08             	lea    0x8(%ebp),%eax
     7ac:	89 04 24             	mov    %eax,(%esp)
     7af:	e8 60 00 00 00       	call   814 <parseline>
     7b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     7b7:	c7 44 24 08 04 16 00 	movl   $0x1604,0x8(%esp)
     7be:	00 
     7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c2:	89 44 24 04          	mov    %eax,0x4(%esp)
     7c6:	8d 45 08             	lea    0x8(%ebp),%eax
     7c9:	89 04 24             	mov    %eax,(%esp)
     7cc:	e8 42 ff ff ff       	call   713 <peek>
  if(s != es){
     7d1:	8b 45 08             	mov    0x8(%ebp),%eax
     7d4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     7d7:	74 27                	je     800 <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     7d9:	8b 45 08             	mov    0x8(%ebp),%eax
     7dc:	89 44 24 08          	mov    %eax,0x8(%esp)
     7e0:	c7 44 24 04 05 16 00 	movl   $0x1605,0x4(%esp)
     7e7:	00 
     7e8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     7ef:	e8 95 09 00 00       	call   1189 <printf>
    panic("syntax");
     7f4:	c7 04 24 14 16 00 00 	movl   $0x1614,(%esp)
     7fb:	e8 8c fb ff ff       	call   38c <panic>
  }
  nulterminate(cmd);
     800:	8b 45 f0             	mov    -0x10(%ebp),%eax
     803:	89 04 24             	mov    %eax,(%esp)
     806:	e8 a5 04 00 00       	call   cb0 <nulterminate>
  return cmd;
     80b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     80e:	83 c4 24             	add    $0x24,%esp
     811:	5b                   	pop    %ebx
     812:	5d                   	pop    %ebp
     813:	c3                   	ret    

00000814 <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     814:	55                   	push   %ebp
     815:	89 e5                	mov    %esp,%ebp
     817:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     81a:	8b 45 0c             	mov    0xc(%ebp),%eax
     81d:	89 44 24 04          	mov    %eax,0x4(%esp)
     821:	8b 45 08             	mov    0x8(%ebp),%eax
     824:	89 04 24             	mov    %eax,(%esp)
     827:	e8 bc 00 00 00       	call   8e8 <parsepipe>
     82c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     82f:	eb 30                	jmp    861 <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     831:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     838:	00 
     839:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     840:	00 
     841:	8b 45 0c             	mov    0xc(%ebp),%eax
     844:	89 44 24 04          	mov    %eax,0x4(%esp)
     848:	8b 45 08             	mov    0x8(%ebp),%eax
     84b:	89 04 24             	mov    %eax,(%esp)
     84e:	e8 78 fd ff ff       	call   5cb <gettoken>
    cmd = backcmd(cmd);
     853:	8b 45 f4             	mov    -0xc(%ebp),%eax
     856:	89 04 24             	mov    %eax,(%esp)
     859:	e8 12 fd ff ff       	call   570 <backcmd>
     85e:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     861:	c7 44 24 08 1b 16 00 	movl   $0x161b,0x8(%esp)
     868:	00 
     869:	8b 45 0c             	mov    0xc(%ebp),%eax
     86c:	89 44 24 04          	mov    %eax,0x4(%esp)
     870:	8b 45 08             	mov    0x8(%ebp),%eax
     873:	89 04 24             	mov    %eax,(%esp)
     876:	e8 98 fe ff ff       	call   713 <peek>
     87b:	85 c0                	test   %eax,%eax
     87d:	75 b2                	jne    831 <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     87f:	c7 44 24 08 1d 16 00 	movl   $0x161d,0x8(%esp)
     886:	00 
     887:	8b 45 0c             	mov    0xc(%ebp),%eax
     88a:	89 44 24 04          	mov    %eax,0x4(%esp)
     88e:	8b 45 08             	mov    0x8(%ebp),%eax
     891:	89 04 24             	mov    %eax,(%esp)
     894:	e8 7a fe ff ff       	call   713 <peek>
     899:	85 c0                	test   %eax,%eax
     89b:	74 46                	je     8e3 <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     89d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     8a4:	00 
     8a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     8ac:	00 
     8ad:	8b 45 0c             	mov    0xc(%ebp),%eax
     8b0:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b4:	8b 45 08             	mov    0x8(%ebp),%eax
     8b7:	89 04 24             	mov    %eax,(%esp)
     8ba:	e8 0c fd ff ff       	call   5cb <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     8bf:	8b 45 0c             	mov    0xc(%ebp),%eax
     8c2:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c6:	8b 45 08             	mov    0x8(%ebp),%eax
     8c9:	89 04 24             	mov    %eax,(%esp)
     8cc:	e8 43 ff ff ff       	call   814 <parseline>
     8d1:	89 44 24 04          	mov    %eax,0x4(%esp)
     8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8d8:	89 04 24             	mov    %eax,(%esp)
     8db:	e8 2c fc ff ff       	call   50c <listcmd>
     8e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8e6:	c9                   	leave  
     8e7:	c3                   	ret    

000008e8 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     8e8:	55                   	push   %ebp
     8e9:	89 e5                	mov    %esp,%ebp
     8eb:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     8ee:	8b 45 0c             	mov    0xc(%ebp),%eax
     8f1:	89 44 24 04          	mov    %eax,0x4(%esp)
     8f5:	8b 45 08             	mov    0x8(%ebp),%eax
     8f8:	89 04 24             	mov    %eax,(%esp)
     8fb:	e8 68 02 00 00       	call   b68 <parseexec>
     900:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     903:	c7 44 24 08 1f 16 00 	movl   $0x161f,0x8(%esp)
     90a:	00 
     90b:	8b 45 0c             	mov    0xc(%ebp),%eax
     90e:	89 44 24 04          	mov    %eax,0x4(%esp)
     912:	8b 45 08             	mov    0x8(%ebp),%eax
     915:	89 04 24             	mov    %eax,(%esp)
     918:	e8 f6 fd ff ff       	call   713 <peek>
     91d:	85 c0                	test   %eax,%eax
     91f:	74 46                	je     967 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     921:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     928:	00 
     929:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     930:	00 
     931:	8b 45 0c             	mov    0xc(%ebp),%eax
     934:	89 44 24 04          	mov    %eax,0x4(%esp)
     938:	8b 45 08             	mov    0x8(%ebp),%eax
     93b:	89 04 24             	mov    %eax,(%esp)
     93e:	e8 88 fc ff ff       	call   5cb <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     943:	8b 45 0c             	mov    0xc(%ebp),%eax
     946:	89 44 24 04          	mov    %eax,0x4(%esp)
     94a:	8b 45 08             	mov    0x8(%ebp),%eax
     94d:	89 04 24             	mov    %eax,(%esp)
     950:	e8 93 ff ff ff       	call   8e8 <parsepipe>
     955:	89 44 24 04          	mov    %eax,0x4(%esp)
     959:	8b 45 f4             	mov    -0xc(%ebp),%eax
     95c:	89 04 24             	mov    %eax,(%esp)
     95f:	e8 44 fb ff ff       	call   4a8 <pipecmd>
     964:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     967:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     96a:	c9                   	leave  
     96b:	c3                   	ret    

0000096c <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     96c:	55                   	push   %ebp
     96d:	89 e5                	mov    %esp,%ebp
     96f:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     972:	e9 f6 00 00 00       	jmp    a6d <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     977:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     97e:	00 
     97f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     986:	00 
     987:	8b 45 10             	mov    0x10(%ebp),%eax
     98a:	89 44 24 04          	mov    %eax,0x4(%esp)
     98e:	8b 45 0c             	mov    0xc(%ebp),%eax
     991:	89 04 24             	mov    %eax,(%esp)
     994:	e8 32 fc ff ff       	call   5cb <gettoken>
     999:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     99c:	8d 45 ec             	lea    -0x14(%ebp),%eax
     99f:	89 44 24 0c          	mov    %eax,0xc(%esp)
     9a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
     9a6:	89 44 24 08          	mov    %eax,0x8(%esp)
     9aa:	8b 45 10             	mov    0x10(%ebp),%eax
     9ad:	89 44 24 04          	mov    %eax,0x4(%esp)
     9b1:	8b 45 0c             	mov    0xc(%ebp),%eax
     9b4:	89 04 24             	mov    %eax,(%esp)
     9b7:	e8 0f fc ff ff       	call   5cb <gettoken>
     9bc:	83 f8 61             	cmp    $0x61,%eax
     9bf:	74 0c                	je     9cd <parseredirs+0x61>
      panic("missing file for redirection");
     9c1:	c7 04 24 21 16 00 00 	movl   $0x1621,(%esp)
     9c8:	e8 bf f9 ff ff       	call   38c <panic>
    switch(tok){
     9cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9d0:	83 f8 3c             	cmp    $0x3c,%eax
     9d3:	74 0f                	je     9e4 <parseredirs+0x78>
     9d5:	83 f8 3e             	cmp    $0x3e,%eax
     9d8:	74 38                	je     a12 <parseredirs+0xa6>
     9da:	83 f8 2b             	cmp    $0x2b,%eax
     9dd:	74 61                	je     a40 <parseredirs+0xd4>
     9df:	e9 89 00 00 00       	jmp    a6d <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     9e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
     9e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9ea:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     9f1:	00 
     9f2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     9f9:	00 
     9fa:	89 54 24 08          	mov    %edx,0x8(%esp)
     9fe:	89 44 24 04          	mov    %eax,0x4(%esp)
     a02:	8b 45 08             	mov    0x8(%ebp),%eax
     a05:	89 04 24             	mov    %eax,(%esp)
     a08:	e8 1c fa ff ff       	call   429 <redircmd>
     a0d:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a10:	eb 5b                	jmp    a6d <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a12:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a18:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     a1f:	00 
     a20:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     a27:	00 
     a28:	89 54 24 08          	mov    %edx,0x8(%esp)
     a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
     a30:	8b 45 08             	mov    0x8(%ebp),%eax
     a33:	89 04 24             	mov    %eax,(%esp)
     a36:	e8 ee f9 ff ff       	call   429 <redircmd>
     a3b:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a3e:	eb 2d                	jmp    a6d <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a40:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a46:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     a4d:	00 
     a4e:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     a55:	00 
     a56:	89 54 24 08          	mov    %edx,0x8(%esp)
     a5a:	89 44 24 04          	mov    %eax,0x4(%esp)
     a5e:	8b 45 08             	mov    0x8(%ebp),%eax
     a61:	89 04 24             	mov    %eax,(%esp)
     a64:	e8 c0 f9 ff ff       	call   429 <redircmd>
     a69:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a6c:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     a6d:	c7 44 24 08 3e 16 00 	movl   $0x163e,0x8(%esp)
     a74:	00 
     a75:	8b 45 10             	mov    0x10(%ebp),%eax
     a78:	89 44 24 04          	mov    %eax,0x4(%esp)
     a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
     a7f:	89 04 24             	mov    %eax,(%esp)
     a82:	e8 8c fc ff ff       	call   713 <peek>
     a87:	85 c0                	test   %eax,%eax
     a89:	0f 85 e8 fe ff ff    	jne    977 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     a8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
     a92:	c9                   	leave  
     a93:	c3                   	ret    

00000a94 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     a94:	55                   	push   %ebp
     a95:	89 e5                	mov    %esp,%ebp
     a97:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     a9a:	c7 44 24 08 41 16 00 	movl   $0x1641,0x8(%esp)
     aa1:	00 
     aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
     aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
     aa9:	8b 45 08             	mov    0x8(%ebp),%eax
     aac:	89 04 24             	mov    %eax,(%esp)
     aaf:	e8 5f fc ff ff       	call   713 <peek>
     ab4:	85 c0                	test   %eax,%eax
     ab6:	75 0c                	jne    ac4 <parseblock+0x30>
    panic("parseblock");
     ab8:	c7 04 24 43 16 00 00 	movl   $0x1643,(%esp)
     abf:	e8 c8 f8 ff ff       	call   38c <panic>
  gettoken(ps, es, 0, 0);
     ac4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     acb:	00 
     acc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     ad3:	00 
     ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
     ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
     adb:	8b 45 08             	mov    0x8(%ebp),%eax
     ade:	89 04 24             	mov    %eax,(%esp)
     ae1:	e8 e5 fa ff ff       	call   5cb <gettoken>
  cmd = parseline(ps, es);
     ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
     aed:	8b 45 08             	mov    0x8(%ebp),%eax
     af0:	89 04 24             	mov    %eax,(%esp)
     af3:	e8 1c fd ff ff       	call   814 <parseline>
     af8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     afb:	c7 44 24 08 4e 16 00 	movl   $0x164e,0x8(%esp)
     b02:	00 
     b03:	8b 45 0c             	mov    0xc(%ebp),%eax
     b06:	89 44 24 04          	mov    %eax,0x4(%esp)
     b0a:	8b 45 08             	mov    0x8(%ebp),%eax
     b0d:	89 04 24             	mov    %eax,(%esp)
     b10:	e8 fe fb ff ff       	call   713 <peek>
     b15:	85 c0                	test   %eax,%eax
     b17:	75 0c                	jne    b25 <parseblock+0x91>
    panic("syntax - missing )");
     b19:	c7 04 24 50 16 00 00 	movl   $0x1650,(%esp)
     b20:	e8 67 f8 ff ff       	call   38c <panic>
  gettoken(ps, es, 0, 0);
     b25:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     b2c:	00 
     b2d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     b34:	00 
     b35:	8b 45 0c             	mov    0xc(%ebp),%eax
     b38:	89 44 24 04          	mov    %eax,0x4(%esp)
     b3c:	8b 45 08             	mov    0x8(%ebp),%eax
     b3f:	89 04 24             	mov    %eax,(%esp)
     b42:	e8 84 fa ff ff       	call   5cb <gettoken>
  cmd = parseredirs(cmd, ps, es);
     b47:	8b 45 0c             	mov    0xc(%ebp),%eax
     b4a:	89 44 24 08          	mov    %eax,0x8(%esp)
     b4e:	8b 45 08             	mov    0x8(%ebp),%eax
     b51:	89 44 24 04          	mov    %eax,0x4(%esp)
     b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b58:	89 04 24             	mov    %eax,(%esp)
     b5b:	e8 0c fe ff ff       	call   96c <parseredirs>
     b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     b66:	c9                   	leave  
     b67:	c3                   	ret    

00000b68 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     b68:	55                   	push   %ebp
     b69:	89 e5                	mov    %esp,%ebp
     b6b:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     b6e:	c7 44 24 08 41 16 00 	movl   $0x1641,0x8(%esp)
     b75:	00 
     b76:	8b 45 0c             	mov    0xc(%ebp),%eax
     b79:	89 44 24 04          	mov    %eax,0x4(%esp)
     b7d:	8b 45 08             	mov    0x8(%ebp),%eax
     b80:	89 04 24             	mov    %eax,(%esp)
     b83:	e8 8b fb ff ff       	call   713 <peek>
     b88:	85 c0                	test   %eax,%eax
     b8a:	74 17                	je     ba3 <parseexec+0x3b>
    return parseblock(ps, es);
     b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
     b8f:	89 44 24 04          	mov    %eax,0x4(%esp)
     b93:	8b 45 08             	mov    0x8(%ebp),%eax
     b96:	89 04 24             	mov    %eax,(%esp)
     b99:	e8 f6 fe ff ff       	call   a94 <parseblock>
     b9e:	e9 0b 01 00 00       	jmp    cae <parseexec+0x146>

  ret = execcmd();
     ba3:	e8 2f f8 ff ff       	call   3d7 <execcmd>
     ba8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bae:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     bb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
     bbb:	89 44 24 08          	mov    %eax,0x8(%esp)
     bbf:	8b 45 08             	mov    0x8(%ebp),%eax
     bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
     bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bc9:	89 04 24             	mov    %eax,(%esp)
     bcc:	e8 9b fd ff ff       	call   96c <parseredirs>
     bd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     bd4:	e9 8e 00 00 00       	jmp    c67 <parseexec+0xff>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     bd9:	8d 45 e0             	lea    -0x20(%ebp),%eax
     bdc:	89 44 24 0c          	mov    %eax,0xc(%esp)
     be0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     be3:	89 44 24 08          	mov    %eax,0x8(%esp)
     be7:	8b 45 0c             	mov    0xc(%ebp),%eax
     bea:	89 44 24 04          	mov    %eax,0x4(%esp)
     bee:	8b 45 08             	mov    0x8(%ebp),%eax
     bf1:	89 04 24             	mov    %eax,(%esp)
     bf4:	e8 d2 f9 ff ff       	call   5cb <gettoken>
     bf9:	89 45 e8             	mov    %eax,-0x18(%ebp)
     bfc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     c00:	0f 84 85 00 00 00    	je     c8b <parseexec+0x123>
      break;
    if(tok != 'a')
     c06:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     c0a:	74 0c                	je     c18 <parseexec+0xb0>
      panic("syntax");
     c0c:	c7 04 24 14 16 00 00 	movl   $0x1614,(%esp)
     c13:	e8 74 f7 ff ff       	call   38c <panic>
    cmd->argv[argc] = q;
     c18:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c21:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     c25:	8b 55 e0             	mov    -0x20(%ebp),%edx
     c28:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c2b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     c2e:	83 c1 08             	add    $0x8,%ecx
     c31:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     c35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     c39:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     c3d:	7e 0c                	jle    c4b <parseexec+0xe3>
      panic("too many args");
     c3f:	c7 04 24 63 16 00 00 	movl   $0x1663,(%esp)
     c46:	e8 41 f7 ff ff       	call   38c <panic>
    ret = parseredirs(ret, ps, es);
     c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
     c4e:	89 44 24 08          	mov    %eax,0x8(%esp)
     c52:	8b 45 08             	mov    0x8(%ebp),%eax
     c55:	89 44 24 04          	mov    %eax,0x4(%esp)
     c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c5c:	89 04 24             	mov    %eax,(%esp)
     c5f:	e8 08 fd ff ff       	call   96c <parseredirs>
     c64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     c67:	c7 44 24 08 71 16 00 	movl   $0x1671,0x8(%esp)
     c6e:	00 
     c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
     c72:	89 44 24 04          	mov    %eax,0x4(%esp)
     c76:	8b 45 08             	mov    0x8(%ebp),%eax
     c79:	89 04 24             	mov    %eax,(%esp)
     c7c:	e8 92 fa ff ff       	call   713 <peek>
     c81:	85 c0                	test   %eax,%eax
     c83:	0f 84 50 ff ff ff    	je     bd9 <parseexec+0x71>
     c89:	eb 01                	jmp    c8c <parseexec+0x124>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
     c8b:	90                   	nop
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     c8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c92:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     c99:	00 
  cmd->eargv[argc] = 0;
     c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ca0:	83 c2 08             	add    $0x8,%edx
     ca3:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     caa:	00 
  return ret;
     cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     cae:	c9                   	leave  
     caf:	c3                   	ret    

00000cb0 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     cb0:	55                   	push   %ebp
     cb1:	89 e5                	mov    %esp,%ebp
     cb3:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     cb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     cba:	75 0a                	jne    cc6 <nulterminate+0x16>
    return 0;
     cbc:	b8 00 00 00 00       	mov    $0x0,%eax
     cc1:	e9 c9 00 00 00       	jmp    d8f <nulterminate+0xdf>
  
  switch(cmd->type){
     cc6:	8b 45 08             	mov    0x8(%ebp),%eax
     cc9:	8b 00                	mov    (%eax),%eax
     ccb:	83 f8 05             	cmp    $0x5,%eax
     cce:	0f 87 b8 00 00 00    	ja     d8c <nulterminate+0xdc>
     cd4:	8b 04 85 78 16 00 00 	mov    0x1678(,%eax,4),%eax
     cdb:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     cdd:	8b 45 08             	mov    0x8(%ebp),%eax
     ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     ce3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     cea:	eb 14                	jmp    d00 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
     cf2:	83 c2 08             	add    $0x8,%edx
     cf5:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     cf9:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     cfc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d03:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d06:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     d0a:	85 c0                	test   %eax,%eax
     d0c:	75 de                	jne    cec <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     d0e:	eb 7c                	jmp    d8c <nulterminate+0xdc>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     d10:	8b 45 08             	mov    0x8(%ebp),%eax
     d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     d16:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d19:	8b 40 04             	mov    0x4(%eax),%eax
     d1c:	89 04 24             	mov    %eax,(%esp)
     d1f:	e8 8c ff ff ff       	call   cb0 <nulterminate>
    *rcmd->efile = 0;
     d24:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d27:	8b 40 0c             	mov    0xc(%eax),%eax
     d2a:	c6 00 00             	movb   $0x0,(%eax)
    break;
     d2d:	eb 5d                	jmp    d8c <nulterminate+0xdc>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     d2f:	8b 45 08             	mov    0x8(%ebp),%eax
     d32:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     d35:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d38:	8b 40 04             	mov    0x4(%eax),%eax
     d3b:	89 04 24             	mov    %eax,(%esp)
     d3e:	e8 6d ff ff ff       	call   cb0 <nulterminate>
    nulterminate(pcmd->right);
     d43:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d46:	8b 40 08             	mov    0x8(%eax),%eax
     d49:	89 04 24             	mov    %eax,(%esp)
     d4c:	e8 5f ff ff ff       	call   cb0 <nulterminate>
    break;
     d51:	eb 39                	jmp    d8c <nulterminate+0xdc>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     d53:	8b 45 08             	mov    0x8(%ebp),%eax
     d56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     d59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     d5c:	8b 40 04             	mov    0x4(%eax),%eax
     d5f:	89 04 24             	mov    %eax,(%esp)
     d62:	e8 49 ff ff ff       	call   cb0 <nulterminate>
    nulterminate(lcmd->right);
     d67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     d6a:	8b 40 08             	mov    0x8(%eax),%eax
     d6d:	89 04 24             	mov    %eax,(%esp)
     d70:	e8 3b ff ff ff       	call   cb0 <nulterminate>
    break;
     d75:	eb 15                	jmp    d8c <nulterminate+0xdc>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     d77:	8b 45 08             	mov    0x8(%ebp),%eax
     d7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
     d80:	8b 40 04             	mov    0x4(%eax),%eax
     d83:	89 04 24             	mov    %eax,(%esp)
     d86:	e8 25 ff ff ff       	call   cb0 <nulterminate>
    break;
     d8b:	90                   	nop
  }
  return cmd;
     d8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d8f:	c9                   	leave  
     d90:	c3                   	ret    
     d91:	66 90                	xchg   %ax,%ax
     d93:	90                   	nop

00000d94 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     d94:	55                   	push   %ebp
     d95:	89 e5                	mov    %esp,%ebp
     d97:	57                   	push   %edi
     d98:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     d99:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d9c:	8b 55 10             	mov    0x10(%ebp),%edx
     d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
     da2:	89 cb                	mov    %ecx,%ebx
     da4:	89 df                	mov    %ebx,%edi
     da6:	89 d1                	mov    %edx,%ecx
     da8:	fc                   	cld    
     da9:	f3 aa                	rep stos %al,%es:(%edi)
     dab:	89 ca                	mov    %ecx,%edx
     dad:	89 fb                	mov    %edi,%ebx
     daf:	89 5d 08             	mov    %ebx,0x8(%ebp)
     db2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     db5:	5b                   	pop    %ebx
     db6:	5f                   	pop    %edi
     db7:	5d                   	pop    %ebp
     db8:	c3                   	ret    

00000db9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     db9:	55                   	push   %ebp
     dba:	89 e5                	mov    %esp,%ebp
     dbc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     dbf:	8b 45 08             	mov    0x8(%ebp),%eax
     dc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     dc5:	90                   	nop
     dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
     dc9:	0f b6 10             	movzbl (%eax),%edx
     dcc:	8b 45 08             	mov    0x8(%ebp),%eax
     dcf:	88 10                	mov    %dl,(%eax)
     dd1:	8b 45 08             	mov    0x8(%ebp),%eax
     dd4:	0f b6 00             	movzbl (%eax),%eax
     dd7:	84 c0                	test   %al,%al
     dd9:	0f 95 c0             	setne  %al
     ddc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     de0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     de4:	84 c0                	test   %al,%al
     de6:	75 de                	jne    dc6 <strcpy+0xd>
    ;
  return os;
     de8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     deb:	c9                   	leave  
     dec:	c3                   	ret    

00000ded <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ded:	55                   	push   %ebp
     dee:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     df0:	eb 08                	jmp    dfa <strcmp+0xd>
    p++, q++;
     df2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     df6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     dfa:	8b 45 08             	mov    0x8(%ebp),%eax
     dfd:	0f b6 00             	movzbl (%eax),%eax
     e00:	84 c0                	test   %al,%al
     e02:	74 10                	je     e14 <strcmp+0x27>
     e04:	8b 45 08             	mov    0x8(%ebp),%eax
     e07:	0f b6 10             	movzbl (%eax),%edx
     e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
     e0d:	0f b6 00             	movzbl (%eax),%eax
     e10:	38 c2                	cmp    %al,%dl
     e12:	74 de                	je     df2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     e14:	8b 45 08             	mov    0x8(%ebp),%eax
     e17:	0f b6 00             	movzbl (%eax),%eax
     e1a:	0f b6 d0             	movzbl %al,%edx
     e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
     e20:	0f b6 00             	movzbl (%eax),%eax
     e23:	0f b6 c0             	movzbl %al,%eax
     e26:	89 d1                	mov    %edx,%ecx
     e28:	29 c1                	sub    %eax,%ecx
     e2a:	89 c8                	mov    %ecx,%eax
}
     e2c:	5d                   	pop    %ebp
     e2d:	c3                   	ret    

00000e2e <strlen>:

uint
strlen(char *s)
{
     e2e:	55                   	push   %ebp
     e2f:	89 e5                	mov    %esp,%ebp
     e31:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     e34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     e3b:	eb 04                	jmp    e41 <strlen+0x13>
     e3d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     e41:	8b 55 fc             	mov    -0x4(%ebp),%edx
     e44:	8b 45 08             	mov    0x8(%ebp),%eax
     e47:	01 d0                	add    %edx,%eax
     e49:	0f b6 00             	movzbl (%eax),%eax
     e4c:	84 c0                	test   %al,%al
     e4e:	75 ed                	jne    e3d <strlen+0xf>
    ;
  return n;
     e50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     e53:	c9                   	leave  
     e54:	c3                   	ret    

00000e55 <memset>:

void*
memset(void *dst, int c, uint n)
{
     e55:	55                   	push   %ebp
     e56:	89 e5                	mov    %esp,%ebp
     e58:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     e5b:	8b 45 10             	mov    0x10(%ebp),%eax
     e5e:	89 44 24 08          	mov    %eax,0x8(%esp)
     e62:	8b 45 0c             	mov    0xc(%ebp),%eax
     e65:	89 44 24 04          	mov    %eax,0x4(%esp)
     e69:	8b 45 08             	mov    0x8(%ebp),%eax
     e6c:	89 04 24             	mov    %eax,(%esp)
     e6f:	e8 20 ff ff ff       	call   d94 <stosb>
  return dst;
     e74:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e77:	c9                   	leave  
     e78:	c3                   	ret    

00000e79 <strchr>:

char*
strchr(const char *s, char c)
{
     e79:	55                   	push   %ebp
     e7a:	89 e5                	mov    %esp,%ebp
     e7c:	83 ec 04             	sub    $0x4,%esp
     e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
     e82:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     e85:	eb 14                	jmp    e9b <strchr+0x22>
    if(*s == c)
     e87:	8b 45 08             	mov    0x8(%ebp),%eax
     e8a:	0f b6 00             	movzbl (%eax),%eax
     e8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
     e90:	75 05                	jne    e97 <strchr+0x1e>
      return (char*)s;
     e92:	8b 45 08             	mov    0x8(%ebp),%eax
     e95:	eb 13                	jmp    eaa <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     e97:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     e9b:	8b 45 08             	mov    0x8(%ebp),%eax
     e9e:	0f b6 00             	movzbl (%eax),%eax
     ea1:	84 c0                	test   %al,%al
     ea3:	75 e2                	jne    e87 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     ea5:	b8 00 00 00 00       	mov    $0x0,%eax
}
     eaa:	c9                   	leave  
     eab:	c3                   	ret    

00000eac <gets>:

char*
gets(char *buf, int max)
{
     eac:	55                   	push   %ebp
     ead:	89 e5                	mov    %esp,%ebp
     eaf:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     eb9:	eb 46                	jmp    f01 <gets+0x55>
    cc = read(0, &c, 1);
     ebb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     ec2:	00 
     ec3:	8d 45 ef             	lea    -0x11(%ebp),%eax
     ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
     eca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     ed1:	e8 3e 01 00 00       	call   1014 <read>
     ed6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     ed9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     edd:	7e 2f                	jle    f0e <gets+0x62>
      break;
    buf[i++] = c;
     edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ee2:	8b 45 08             	mov    0x8(%ebp),%eax
     ee5:	01 c2                	add    %eax,%edx
     ee7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     eeb:	88 02                	mov    %al,(%edx)
     eed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     ef1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     ef5:	3c 0a                	cmp    $0xa,%al
     ef7:	74 16                	je     f0f <gets+0x63>
     ef9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     efd:	3c 0d                	cmp    $0xd,%al
     eff:	74 0e                	je     f0f <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f04:	83 c0 01             	add    $0x1,%eax
     f07:	3b 45 0c             	cmp    0xc(%ebp),%eax
     f0a:	7c af                	jl     ebb <gets+0xf>
     f0c:	eb 01                	jmp    f0f <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     f0e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     f0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f12:	8b 45 08             	mov    0x8(%ebp),%eax
     f15:	01 d0                	add    %edx,%eax
     f17:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     f1a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f1d:	c9                   	leave  
     f1e:	c3                   	ret    

00000f1f <stat>:

int
stat(char *n, struct stat *st)
{
     f1f:	55                   	push   %ebp
     f20:	89 e5                	mov    %esp,%ebp
     f22:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     f25:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     f2c:	00 
     f2d:	8b 45 08             	mov    0x8(%ebp),%eax
     f30:	89 04 24             	mov    %eax,(%esp)
     f33:	e8 04 01 00 00       	call   103c <open>
     f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     f3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f3f:	79 07                	jns    f48 <stat+0x29>
    return -1;
     f41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f46:	eb 23                	jmp    f6b <stat+0x4c>
  r = fstat(fd, st);
     f48:	8b 45 0c             	mov    0xc(%ebp),%eax
     f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
     f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f52:	89 04 24             	mov    %eax,(%esp)
     f55:	e8 fa 00 00 00       	call   1054 <fstat>
     f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f60:	89 04 24             	mov    %eax,(%esp)
     f63:	e8 bc 00 00 00       	call   1024 <close>
  return r;
     f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f6b:	c9                   	leave  
     f6c:	c3                   	ret    

00000f6d <atoi>:

int
atoi(const char *s)
{
     f6d:	55                   	push   %ebp
     f6e:	89 e5                	mov    %esp,%ebp
     f70:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     f73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     f7a:	eb 23                	jmp    f9f <atoi+0x32>
    n = n*10 + *s++ - '0';
     f7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
     f7f:	89 d0                	mov    %edx,%eax
     f81:	c1 e0 02             	shl    $0x2,%eax
     f84:	01 d0                	add    %edx,%eax
     f86:	01 c0                	add    %eax,%eax
     f88:	89 c2                	mov    %eax,%edx
     f8a:	8b 45 08             	mov    0x8(%ebp),%eax
     f8d:	0f b6 00             	movzbl (%eax),%eax
     f90:	0f be c0             	movsbl %al,%eax
     f93:	01 d0                	add    %edx,%eax
     f95:	83 e8 30             	sub    $0x30,%eax
     f98:	89 45 fc             	mov    %eax,-0x4(%ebp)
     f9b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     f9f:	8b 45 08             	mov    0x8(%ebp),%eax
     fa2:	0f b6 00             	movzbl (%eax),%eax
     fa5:	3c 2f                	cmp    $0x2f,%al
     fa7:	7e 0a                	jle    fb3 <atoi+0x46>
     fa9:	8b 45 08             	mov    0x8(%ebp),%eax
     fac:	0f b6 00             	movzbl (%eax),%eax
     faf:	3c 39                	cmp    $0x39,%al
     fb1:	7e c9                	jle    f7c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     fb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     fb6:	c9                   	leave  
     fb7:	c3                   	ret    

00000fb8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     fb8:	55                   	push   %ebp
     fb9:	89 e5                	mov    %esp,%ebp
     fbb:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     fbe:	8b 45 08             	mov    0x8(%ebp),%eax
     fc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
     fc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     fca:	eb 13                	jmp    fdf <memmove+0x27>
    *dst++ = *src++;
     fcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
     fcf:	0f b6 10             	movzbl (%eax),%edx
     fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
     fd5:	88 10                	mov    %dl,(%eax)
     fd7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     fdb:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     fe3:	0f 9f c0             	setg   %al
     fe6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     fea:	84 c0                	test   %al,%al
     fec:	75 de                	jne    fcc <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     fee:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ff1:	c9                   	leave  
     ff2:	c3                   	ret    
     ff3:	90                   	nop

00000ff4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     ff4:	b8 01 00 00 00       	mov    $0x1,%eax
     ff9:	cd 40                	int    $0x40
     ffb:	c3                   	ret    

00000ffc <exit>:
SYSCALL(exit)
     ffc:	b8 02 00 00 00       	mov    $0x2,%eax
    1001:	cd 40                	int    $0x40
    1003:	c3                   	ret    

00001004 <wait>:
SYSCALL(wait)
    1004:	b8 03 00 00 00       	mov    $0x3,%eax
    1009:	cd 40                	int    $0x40
    100b:	c3                   	ret    

0000100c <pipe>:
SYSCALL(pipe)
    100c:	b8 04 00 00 00       	mov    $0x4,%eax
    1011:	cd 40                	int    $0x40
    1013:	c3                   	ret    

00001014 <read>:
SYSCALL(read)
    1014:	b8 05 00 00 00       	mov    $0x5,%eax
    1019:	cd 40                	int    $0x40
    101b:	c3                   	ret    

0000101c <write>:
SYSCALL(write)
    101c:	b8 10 00 00 00       	mov    $0x10,%eax
    1021:	cd 40                	int    $0x40
    1023:	c3                   	ret    

00001024 <close>:
SYSCALL(close)
    1024:	b8 15 00 00 00       	mov    $0x15,%eax
    1029:	cd 40                	int    $0x40
    102b:	c3                   	ret    

0000102c <kill>:
SYSCALL(kill)
    102c:	b8 06 00 00 00       	mov    $0x6,%eax
    1031:	cd 40                	int    $0x40
    1033:	c3                   	ret    

00001034 <exec>:
SYSCALL(exec)
    1034:	b8 07 00 00 00       	mov    $0x7,%eax
    1039:	cd 40                	int    $0x40
    103b:	c3                   	ret    

0000103c <open>:
SYSCALL(open)
    103c:	b8 0f 00 00 00       	mov    $0xf,%eax
    1041:	cd 40                	int    $0x40
    1043:	c3                   	ret    

00001044 <mknod>:
SYSCALL(mknod)
    1044:	b8 11 00 00 00       	mov    $0x11,%eax
    1049:	cd 40                	int    $0x40
    104b:	c3                   	ret    

0000104c <unlink>:
SYSCALL(unlink)
    104c:	b8 12 00 00 00       	mov    $0x12,%eax
    1051:	cd 40                	int    $0x40
    1053:	c3                   	ret    

00001054 <fstat>:
SYSCALL(fstat)
    1054:	b8 08 00 00 00       	mov    $0x8,%eax
    1059:	cd 40                	int    $0x40
    105b:	c3                   	ret    

0000105c <link>:
SYSCALL(link)
    105c:	b8 13 00 00 00       	mov    $0x13,%eax
    1061:	cd 40                	int    $0x40
    1063:	c3                   	ret    

00001064 <mkdir>:
SYSCALL(mkdir)
    1064:	b8 14 00 00 00       	mov    $0x14,%eax
    1069:	cd 40                	int    $0x40
    106b:	c3                   	ret    

0000106c <chdir>:
SYSCALL(chdir)
    106c:	b8 09 00 00 00       	mov    $0x9,%eax
    1071:	cd 40                	int    $0x40
    1073:	c3                   	ret    

00001074 <dup>:
SYSCALL(dup)
    1074:	b8 0a 00 00 00       	mov    $0xa,%eax
    1079:	cd 40                	int    $0x40
    107b:	c3                   	ret    

0000107c <getpid>:
SYSCALL(getpid)
    107c:	b8 0b 00 00 00       	mov    $0xb,%eax
    1081:	cd 40                	int    $0x40
    1083:	c3                   	ret    

00001084 <sbrk>:
SYSCALL(sbrk)
    1084:	b8 0c 00 00 00       	mov    $0xc,%eax
    1089:	cd 40                	int    $0x40
    108b:	c3                   	ret    

0000108c <sleep>:
SYSCALL(sleep)
    108c:	b8 0d 00 00 00       	mov    $0xd,%eax
    1091:	cd 40                	int    $0x40
    1093:	c3                   	ret    

00001094 <uptime>:
SYSCALL(uptime)
    1094:	b8 0e 00 00 00       	mov    $0xe,%eax
    1099:	cd 40                	int    $0x40
    109b:	c3                   	ret    

0000109c <halt>:
SYSCALL(halt)
    109c:	b8 16 00 00 00       	mov    $0x16,%eax
    10a1:	cd 40                	int    $0x40
    10a3:	c3                   	ret    

000010a4 <alarm>:
    10a4:	b8 17 00 00 00       	mov    $0x17,%eax
    10a9:	cd 40                	int    $0x40
    10ab:	c3                   	ret    

000010ac <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    10ac:	55                   	push   %ebp
    10ad:	89 e5                	mov    %esp,%ebp
    10af:	83 ec 28             	sub    $0x28,%esp
    10b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    10b5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    10b8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    10bf:	00 
    10c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
    10c3:	89 44 24 04          	mov    %eax,0x4(%esp)
    10c7:	8b 45 08             	mov    0x8(%ebp),%eax
    10ca:	89 04 24             	mov    %eax,(%esp)
    10cd:	e8 4a ff ff ff       	call   101c <write>
}
    10d2:	c9                   	leave  
    10d3:	c3                   	ret    

000010d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    10d4:	55                   	push   %ebp
    10d5:	89 e5                	mov    %esp,%ebp
    10d7:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    10da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    10e1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    10e5:	74 17                	je     10fe <printint+0x2a>
    10e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    10eb:	79 11                	jns    10fe <printint+0x2a>
    neg = 1;
    10ed:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    10f4:	8b 45 0c             	mov    0xc(%ebp),%eax
    10f7:	f7 d8                	neg    %eax
    10f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    10fc:	eb 06                	jmp    1104 <printint+0x30>
  } else {
    x = xx;
    10fe:	8b 45 0c             	mov    0xc(%ebp),%eax
    1101:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1104:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    110b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    110e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1111:	ba 00 00 00 00       	mov    $0x0,%edx
    1116:	f7 f1                	div    %ecx
    1118:	89 d0                	mov    %edx,%eax
    111a:	0f b6 80 20 1b 00 00 	movzbl 0x1b20(%eax),%eax
    1121:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    1124:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1127:	01 ca                	add    %ecx,%edx
    1129:	88 02                	mov    %al,(%edx)
    112b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
    112f:	8b 55 10             	mov    0x10(%ebp),%edx
    1132:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    1135:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1138:	ba 00 00 00 00       	mov    $0x0,%edx
    113d:	f7 75 d4             	divl   -0x2c(%ebp)
    1140:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1143:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1147:	75 c2                	jne    110b <printint+0x37>
  if(neg)
    1149:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    114d:	74 2e                	je     117d <printint+0xa9>
    buf[i++] = '-';
    114f:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1152:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1155:	01 d0                	add    %edx,%eax
    1157:	c6 00 2d             	movb   $0x2d,(%eax)
    115a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
    115e:	eb 1d                	jmp    117d <printint+0xa9>
    putc(fd, buf[i]);
    1160:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1163:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1166:	01 d0                	add    %edx,%eax
    1168:	0f b6 00             	movzbl (%eax),%eax
    116b:	0f be c0             	movsbl %al,%eax
    116e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1172:	8b 45 08             	mov    0x8(%ebp),%eax
    1175:	89 04 24             	mov    %eax,(%esp)
    1178:	e8 2f ff ff ff       	call   10ac <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    117d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1181:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1185:	79 d9                	jns    1160 <printint+0x8c>
    putc(fd, buf[i]);
}
    1187:	c9                   	leave  
    1188:	c3                   	ret    

00001189 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1189:	55                   	push   %ebp
    118a:	89 e5                	mov    %esp,%ebp
    118c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    118f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1196:	8d 45 0c             	lea    0xc(%ebp),%eax
    1199:	83 c0 04             	add    $0x4,%eax
    119c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    119f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    11a6:	e9 7d 01 00 00       	jmp    1328 <printf+0x19f>
    c = fmt[i] & 0xff;
    11ab:	8b 55 0c             	mov    0xc(%ebp),%edx
    11ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11b1:	01 d0                	add    %edx,%eax
    11b3:	0f b6 00             	movzbl (%eax),%eax
    11b6:	0f be c0             	movsbl %al,%eax
    11b9:	25 ff 00 00 00       	and    $0xff,%eax
    11be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    11c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    11c5:	75 2c                	jne    11f3 <printf+0x6a>
      if(c == '%'){
    11c7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    11cb:	75 0c                	jne    11d9 <printf+0x50>
        state = '%';
    11cd:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    11d4:	e9 4b 01 00 00       	jmp    1324 <printf+0x19b>
      } else {
        putc(fd, c);
    11d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11dc:	0f be c0             	movsbl %al,%eax
    11df:	89 44 24 04          	mov    %eax,0x4(%esp)
    11e3:	8b 45 08             	mov    0x8(%ebp),%eax
    11e6:	89 04 24             	mov    %eax,(%esp)
    11e9:	e8 be fe ff ff       	call   10ac <putc>
    11ee:	e9 31 01 00 00       	jmp    1324 <printf+0x19b>
      }
    } else if(state == '%'){
    11f3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    11f7:	0f 85 27 01 00 00    	jne    1324 <printf+0x19b>
      if(c == 'd'){
    11fd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1201:	75 2d                	jne    1230 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1203:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1206:	8b 00                	mov    (%eax),%eax
    1208:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    120f:	00 
    1210:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1217:	00 
    1218:	89 44 24 04          	mov    %eax,0x4(%esp)
    121c:	8b 45 08             	mov    0x8(%ebp),%eax
    121f:	89 04 24             	mov    %eax,(%esp)
    1222:	e8 ad fe ff ff       	call   10d4 <printint>
        ap++;
    1227:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    122b:	e9 ed 00 00 00       	jmp    131d <printf+0x194>
      } else if(c == 'x' || c == 'p'){
    1230:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1234:	74 06                	je     123c <printf+0xb3>
    1236:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    123a:	75 2d                	jne    1269 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    123c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    123f:	8b 00                	mov    (%eax),%eax
    1241:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1248:	00 
    1249:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1250:	00 
    1251:	89 44 24 04          	mov    %eax,0x4(%esp)
    1255:	8b 45 08             	mov    0x8(%ebp),%eax
    1258:	89 04 24             	mov    %eax,(%esp)
    125b:	e8 74 fe ff ff       	call   10d4 <printint>
        ap++;
    1260:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1264:	e9 b4 00 00 00       	jmp    131d <printf+0x194>
      } else if(c == 's'){
    1269:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    126d:	75 46                	jne    12b5 <printf+0x12c>
        s = (char*)*ap;
    126f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1272:	8b 00                	mov    (%eax),%eax
    1274:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1277:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    127b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    127f:	75 27                	jne    12a8 <printf+0x11f>
          s = "(null)";
    1281:	c7 45 f4 90 16 00 00 	movl   $0x1690,-0xc(%ebp)
        while(*s != 0){
    1288:	eb 1e                	jmp    12a8 <printf+0x11f>
          putc(fd, *s);
    128a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    128d:	0f b6 00             	movzbl (%eax),%eax
    1290:	0f be c0             	movsbl %al,%eax
    1293:	89 44 24 04          	mov    %eax,0x4(%esp)
    1297:	8b 45 08             	mov    0x8(%ebp),%eax
    129a:	89 04 24             	mov    %eax,(%esp)
    129d:	e8 0a fe ff ff       	call   10ac <putc>
          s++;
    12a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    12a6:	eb 01                	jmp    12a9 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    12a8:	90                   	nop
    12a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ac:	0f b6 00             	movzbl (%eax),%eax
    12af:	84 c0                	test   %al,%al
    12b1:	75 d7                	jne    128a <printf+0x101>
    12b3:	eb 68                	jmp    131d <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    12b5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    12b9:	75 1d                	jne    12d8 <printf+0x14f>
        putc(fd, *ap);
    12bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    12be:	8b 00                	mov    (%eax),%eax
    12c0:	0f be c0             	movsbl %al,%eax
    12c3:	89 44 24 04          	mov    %eax,0x4(%esp)
    12c7:	8b 45 08             	mov    0x8(%ebp),%eax
    12ca:	89 04 24             	mov    %eax,(%esp)
    12cd:	e8 da fd ff ff       	call   10ac <putc>
        ap++;
    12d2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    12d6:	eb 45                	jmp    131d <printf+0x194>
      } else if(c == '%'){
    12d8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    12dc:	75 17                	jne    12f5 <printf+0x16c>
        putc(fd, c);
    12de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12e1:	0f be c0             	movsbl %al,%eax
    12e4:	89 44 24 04          	mov    %eax,0x4(%esp)
    12e8:	8b 45 08             	mov    0x8(%ebp),%eax
    12eb:	89 04 24             	mov    %eax,(%esp)
    12ee:	e8 b9 fd ff ff       	call   10ac <putc>
    12f3:	eb 28                	jmp    131d <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    12f5:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    12fc:	00 
    12fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1300:	89 04 24             	mov    %eax,(%esp)
    1303:	e8 a4 fd ff ff       	call   10ac <putc>
        putc(fd, c);
    1308:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    130b:	0f be c0             	movsbl %al,%eax
    130e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1312:	8b 45 08             	mov    0x8(%ebp),%eax
    1315:	89 04 24             	mov    %eax,(%esp)
    1318:	e8 8f fd ff ff       	call   10ac <putc>
      }
      state = 0;
    131d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1324:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1328:	8b 55 0c             	mov    0xc(%ebp),%edx
    132b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    132e:	01 d0                	add    %edx,%eax
    1330:	0f b6 00             	movzbl (%eax),%eax
    1333:	84 c0                	test   %al,%al
    1335:	0f 85 70 fe ff ff    	jne    11ab <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    133b:	c9                   	leave  
    133c:	c3                   	ret    
    133d:	66 90                	xchg   %ax,%ax
    133f:	90                   	nop

00001340 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1340:	55                   	push   %ebp
    1341:	89 e5                	mov    %esp,%ebp
    1343:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1346:	8b 45 08             	mov    0x8(%ebp),%eax
    1349:	83 e8 08             	sub    $0x8,%eax
    134c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    134f:	a1 ac 1b 00 00       	mov    0x1bac,%eax
    1354:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1357:	eb 24                	jmp    137d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1359:	8b 45 fc             	mov    -0x4(%ebp),%eax
    135c:	8b 00                	mov    (%eax),%eax
    135e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1361:	77 12                	ja     1375 <free+0x35>
    1363:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1366:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1369:	77 24                	ja     138f <free+0x4f>
    136b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    136e:	8b 00                	mov    (%eax),%eax
    1370:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1373:	77 1a                	ja     138f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1375:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1378:	8b 00                	mov    (%eax),%eax
    137a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    137d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1380:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1383:	76 d4                	jbe    1359 <free+0x19>
    1385:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1388:	8b 00                	mov    (%eax),%eax
    138a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    138d:	76 ca                	jbe    1359 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    138f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1392:	8b 40 04             	mov    0x4(%eax),%eax
    1395:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    139c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    139f:	01 c2                	add    %eax,%edx
    13a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13a4:	8b 00                	mov    (%eax),%eax
    13a6:	39 c2                	cmp    %eax,%edx
    13a8:	75 24                	jne    13ce <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    13aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13ad:	8b 50 04             	mov    0x4(%eax),%edx
    13b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13b3:	8b 00                	mov    (%eax),%eax
    13b5:	8b 40 04             	mov    0x4(%eax),%eax
    13b8:	01 c2                	add    %eax,%edx
    13ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13bd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    13c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13c3:	8b 00                	mov    (%eax),%eax
    13c5:	8b 10                	mov    (%eax),%edx
    13c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13ca:	89 10                	mov    %edx,(%eax)
    13cc:	eb 0a                	jmp    13d8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    13ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13d1:	8b 10                	mov    (%eax),%edx
    13d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13d6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    13d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13db:	8b 40 04             	mov    0x4(%eax),%eax
    13de:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    13e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13e8:	01 d0                	add    %edx,%eax
    13ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    13ed:	75 20                	jne    140f <free+0xcf>
    p->s.size += bp->s.size;
    13ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13f2:	8b 50 04             	mov    0x4(%eax),%edx
    13f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13f8:	8b 40 04             	mov    0x4(%eax),%eax
    13fb:	01 c2                	add    %eax,%edx
    13fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1400:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1403:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1406:	8b 10                	mov    (%eax),%edx
    1408:	8b 45 fc             	mov    -0x4(%ebp),%eax
    140b:	89 10                	mov    %edx,(%eax)
    140d:	eb 08                	jmp    1417 <free+0xd7>
  } else
    p->s.ptr = bp;
    140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1412:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1415:	89 10                	mov    %edx,(%eax)
  freep = p;
    1417:	8b 45 fc             	mov    -0x4(%ebp),%eax
    141a:	a3 ac 1b 00 00       	mov    %eax,0x1bac
}
    141f:	c9                   	leave  
    1420:	c3                   	ret    

00001421 <morecore>:

static Header*
morecore(uint nu)
{
    1421:	55                   	push   %ebp
    1422:	89 e5                	mov    %esp,%ebp
    1424:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1427:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    142e:	77 07                	ja     1437 <morecore+0x16>
    nu = 4096;
    1430:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1437:	8b 45 08             	mov    0x8(%ebp),%eax
    143a:	c1 e0 03             	shl    $0x3,%eax
    143d:	89 04 24             	mov    %eax,(%esp)
    1440:	e8 3f fc ff ff       	call   1084 <sbrk>
    1445:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1448:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    144c:	75 07                	jne    1455 <morecore+0x34>
    return 0;
    144e:	b8 00 00 00 00       	mov    $0x0,%eax
    1453:	eb 22                	jmp    1477 <morecore+0x56>
  hp = (Header*)p;
    1455:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1458:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    145b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    145e:	8b 55 08             	mov    0x8(%ebp),%edx
    1461:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1464:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1467:	83 c0 08             	add    $0x8,%eax
    146a:	89 04 24             	mov    %eax,(%esp)
    146d:	e8 ce fe ff ff       	call   1340 <free>
  return freep;
    1472:	a1 ac 1b 00 00       	mov    0x1bac,%eax
}
    1477:	c9                   	leave  
    1478:	c3                   	ret    

00001479 <malloc>:

void*
malloc(uint nbytes)
{
    1479:	55                   	push   %ebp
    147a:	89 e5                	mov    %esp,%ebp
    147c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    147f:	8b 45 08             	mov    0x8(%ebp),%eax
    1482:	83 c0 07             	add    $0x7,%eax
    1485:	c1 e8 03             	shr    $0x3,%eax
    1488:	83 c0 01             	add    $0x1,%eax
    148b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    148e:	a1 ac 1b 00 00       	mov    0x1bac,%eax
    1493:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1496:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    149a:	75 23                	jne    14bf <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    149c:	c7 45 f0 a4 1b 00 00 	movl   $0x1ba4,-0x10(%ebp)
    14a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14a6:	a3 ac 1b 00 00       	mov    %eax,0x1bac
    14ab:	a1 ac 1b 00 00       	mov    0x1bac,%eax
    14b0:	a3 a4 1b 00 00       	mov    %eax,0x1ba4
    base.s.size = 0;
    14b5:	c7 05 a8 1b 00 00 00 	movl   $0x0,0x1ba8
    14bc:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14c2:	8b 00                	mov    (%eax),%eax
    14c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    14c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ca:	8b 40 04             	mov    0x4(%eax),%eax
    14cd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    14d0:	72 4d                	jb     151f <malloc+0xa6>
      if(p->s.size == nunits)
    14d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d5:	8b 40 04             	mov    0x4(%eax),%eax
    14d8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    14db:	75 0c                	jne    14e9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    14dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e0:	8b 10                	mov    (%eax),%edx
    14e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14e5:	89 10                	mov    %edx,(%eax)
    14e7:	eb 26                	jmp    150f <malloc+0x96>
      else {
        p->s.size -= nunits;
    14e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ec:	8b 40 04             	mov    0x4(%eax),%eax
    14ef:	89 c2                	mov    %eax,%edx
    14f1:	2b 55 ec             	sub    -0x14(%ebp),%edx
    14f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14f7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    14fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14fd:	8b 40 04             	mov    0x4(%eax),%eax
    1500:	c1 e0 03             	shl    $0x3,%eax
    1503:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1506:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1509:	8b 55 ec             	mov    -0x14(%ebp),%edx
    150c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    150f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1512:	a3 ac 1b 00 00       	mov    %eax,0x1bac
      return (void*)(p + 1);
    1517:	8b 45 f4             	mov    -0xc(%ebp),%eax
    151a:	83 c0 08             	add    $0x8,%eax
    151d:	eb 38                	jmp    1557 <malloc+0xde>
    }
    if(p == freep)
    151f:	a1 ac 1b 00 00       	mov    0x1bac,%eax
    1524:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1527:	75 1b                	jne    1544 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1529:	8b 45 ec             	mov    -0x14(%ebp),%eax
    152c:	89 04 24             	mov    %eax,(%esp)
    152f:	e8 ed fe ff ff       	call   1421 <morecore>
    1534:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    153b:	75 07                	jne    1544 <malloc+0xcb>
        return 0;
    153d:	b8 00 00 00 00       	mov    $0x0,%eax
    1542:	eb 13                	jmp    1557 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1544:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1547:	89 45 f0             	mov    %eax,-0x10(%ebp)
    154a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    154d:	8b 00                	mov    (%eax),%eax
    154f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1552:	e9 70 ff ff ff       	jmp    14c7 <malloc+0x4e>
}
    1557:	c9                   	leave  
    1558:	c3                   	ret    
