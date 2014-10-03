
_usertests：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <opentest>:

// simple file system tests

void
opentest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(stdout, "open test\n");
       6:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
       b:	c7 44 24 04 b2 41 00 	movl   $0x41b2,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 ae 3d 00 00       	call   3dc9 <printf>
  fd = open("echo", 0);
      1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      22:	00 
      23:	c7 04 24 9c 41 00 00 	movl   $0x419c,(%esp)
      2a:	e8 4d 3c 00 00       	call   3c7c <open>
      2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
      32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      36:	79 1a                	jns    52 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
      38:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
      3d:	c7 44 24 04 bd 41 00 	movl   $0x41bd,0x4(%esp)
      44:	00 
      45:	89 04 24             	mov    %eax,(%esp)
      48:	e8 7c 3d 00 00       	call   3dc9 <printf>
    exit();
      4d:	e8 ea 3b 00 00       	call   3c3c <exit>
  }
  close(fd);
      52:	8b 45 f4             	mov    -0xc(%ebp),%eax
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 07 3c 00 00       	call   3c64 <close>
  fd = open("doesnotexist", 0);
      5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      64:	00 
      65:	c7 04 24 d0 41 00 00 	movl   $0x41d0,(%esp)
      6c:	e8 0b 3c 00 00       	call   3c7c <open>
      71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
      74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      78:	78 1a                	js     94 <opentest+0x94>
    printf(stdout, "open doesnotexist succeeded!\n");
      7a:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
      7f:	c7 44 24 04 dd 41 00 	movl   $0x41dd,0x4(%esp)
      86:	00 
      87:	89 04 24             	mov    %eax,(%esp)
      8a:	e8 3a 3d 00 00       	call   3dc9 <printf>
    exit();
      8f:	e8 a8 3b 00 00       	call   3c3c <exit>
  }
  printf(stdout, "open test ok\n");
      94:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
      99:	c7 44 24 04 fb 41 00 	movl   $0x41fb,0x4(%esp)
      a0:	00 
      a1:	89 04 24             	mov    %eax,(%esp)
      a4:	e8 20 3d 00 00       	call   3dc9 <printf>
}
      a9:	c9                   	leave  
      aa:	c3                   	ret    

000000ab <writetest>:

void
writetest(void)
{
      ab:	55                   	push   %ebp
      ac:	89 e5                	mov    %esp,%ebp
      ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
      b1:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
      b6:	c7 44 24 04 09 42 00 	movl   $0x4209,0x4(%esp)
      bd:	00 
      be:	89 04 24             	mov    %eax,(%esp)
      c1:	e8 03 3d 00 00       	call   3dc9 <printf>
  fd = open("small", O_CREATE|O_RDWR);
      c6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
      cd:	00 
      ce:	c7 04 24 1a 42 00 00 	movl   $0x421a,(%esp)
      d5:	e8 a2 3b 00 00       	call   3c7c <open>
      da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
      dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
      e1:	78 21                	js     104 <writetest+0x59>
    printf(stdout, "creat small succeeded; ok\n");
      e3:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
      e8:	c7 44 24 04 20 42 00 	movl   $0x4220,0x4(%esp)
      ef:	00 
      f0:	89 04 24             	mov    %eax,(%esp)
      f3:	e8 d1 3c 00 00       	call   3dc9 <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
      f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      ff:	e9 a0 00 00 00       	jmp    1a4 <writetest+0xf9>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     104:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     109:	c7 44 24 04 3b 42 00 	movl   $0x423b,0x4(%esp)
     110:	00 
     111:	89 04 24             	mov    %eax,(%esp)
     114:	e8 b0 3c 00 00       	call   3dc9 <printf>
    exit();
     119:	e8 1e 3b 00 00       	call   3c3c <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     11e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     125:	00 
     126:	c7 44 24 04 57 42 00 	movl   $0x4257,0x4(%esp)
     12d:	00 
     12e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     131:	89 04 24             	mov    %eax,(%esp)
     134:	e8 23 3b 00 00       	call   3c5c <write>
     139:	83 f8 0a             	cmp    $0xa,%eax
     13c:	74 21                	je     15f <writetest+0xb4>
      printf(stdout, "error: write aa %d new file failed\n", i);
     13e:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     143:	8b 55 f4             	mov    -0xc(%ebp),%edx
     146:	89 54 24 08          	mov    %edx,0x8(%esp)
     14a:	c7 44 24 04 64 42 00 	movl   $0x4264,0x4(%esp)
     151:	00 
     152:	89 04 24             	mov    %eax,(%esp)
     155:	e8 6f 3c 00 00       	call   3dc9 <printf>
      exit();
     15a:	e8 dd 3a 00 00       	call   3c3c <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     15f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     166:	00 
     167:	c7 44 24 04 88 42 00 	movl   $0x4288,0x4(%esp)
     16e:	00 
     16f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     172:	89 04 24             	mov    %eax,(%esp)
     175:	e8 e2 3a 00 00       	call   3c5c <write>
     17a:	83 f8 0a             	cmp    $0xa,%eax
     17d:	74 21                	je     1a0 <writetest+0xf5>
      printf(stdout, "error: write bb %d new file failed\n", i);
     17f:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     184:	8b 55 f4             	mov    -0xc(%ebp),%edx
     187:	89 54 24 08          	mov    %edx,0x8(%esp)
     18b:	c7 44 24 04 94 42 00 	movl   $0x4294,0x4(%esp)
     192:	00 
     193:	89 04 24             	mov    %eax,(%esp)
     196:	e8 2e 3c 00 00       	call   3dc9 <printf>
      exit();
     19b:	e8 9c 3a 00 00       	call   3c3c <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     1a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     1a4:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     1a8:	0f 8e 70 ff ff ff    	jle    11e <writetest+0x73>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     1ae:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     1b3:	c7 44 24 04 b8 42 00 	movl   $0x42b8,0x4(%esp)
     1ba:	00 
     1bb:	89 04 24             	mov    %eax,(%esp)
     1be:	e8 06 3c 00 00       	call   3dc9 <printf>
  close(fd);
     1c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     1c6:	89 04 24             	mov    %eax,(%esp)
     1c9:	e8 96 3a 00 00       	call   3c64 <close>
  fd = open("small", O_RDONLY);
     1ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     1d5:	00 
     1d6:	c7 04 24 1a 42 00 00 	movl   $0x421a,(%esp)
     1dd:	e8 9a 3a 00 00       	call   3c7c <open>
     1e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     1e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1e9:	78 3e                	js     229 <writetest+0x17e>
    printf(stdout, "open small succeeded ok\n");
     1eb:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     1f0:	c7 44 24 04 c3 42 00 	movl   $0x42c3,0x4(%esp)
     1f7:	00 
     1f8:	89 04 24             	mov    %eax,(%esp)
     1fb:	e8 c9 3b 00 00       	call   3dc9 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     200:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
     207:	00 
     208:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
     20f:	00 
     210:	8b 45 f0             	mov    -0x10(%ebp),%eax
     213:	89 04 24             	mov    %eax,(%esp)
     216:	e8 39 3a 00 00       	call   3c54 <read>
     21b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     21e:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     225:	74 1c                	je     243 <writetest+0x198>
     227:	eb 4c                	jmp    275 <writetest+0x1ca>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     229:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     22e:	c7 44 24 04 dc 42 00 	movl   $0x42dc,0x4(%esp)
     235:	00 
     236:	89 04 24             	mov    %eax,(%esp)
     239:	e8 8b 3b 00 00       	call   3dc9 <printf>
    exit();
     23e:	e8 f9 39 00 00       	call   3c3c <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     243:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     248:	c7 44 24 04 f7 42 00 	movl   $0x42f7,0x4(%esp)
     24f:	00 
     250:	89 04 24             	mov    %eax,(%esp)
     253:	e8 71 3b 00 00       	call   3dc9 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     258:	8b 45 f0             	mov    -0x10(%ebp),%eax
     25b:	89 04 24             	mov    %eax,(%esp)
     25e:	e8 01 3a 00 00       	call   3c64 <close>

  if(unlink("small") < 0){
     263:	c7 04 24 1a 42 00 00 	movl   $0x421a,(%esp)
     26a:	e8 1d 3a 00 00       	call   3c8c <unlink>
     26f:	85 c0                	test   %eax,%eax
     271:	78 1c                	js     28f <writetest+0x1e4>
     273:	eb 34                	jmp    2a9 <writetest+0x1fe>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     275:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     27a:	c7 44 24 04 0a 43 00 	movl   $0x430a,0x4(%esp)
     281:	00 
     282:	89 04 24             	mov    %eax,(%esp)
     285:	e8 3f 3b 00 00       	call   3dc9 <printf>
    exit();
     28a:	e8 ad 39 00 00       	call   3c3c <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     28f:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     294:	c7 44 24 04 17 43 00 	movl   $0x4317,0x4(%esp)
     29b:	00 
     29c:	89 04 24             	mov    %eax,(%esp)
     29f:	e8 25 3b 00 00       	call   3dc9 <printf>
    exit();
     2a4:	e8 93 39 00 00       	call   3c3c <exit>
  }
  printf(stdout, "small file test ok\n");
     2a9:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     2ae:	c7 44 24 04 2c 43 00 	movl   $0x432c,0x4(%esp)
     2b5:	00 
     2b6:	89 04 24             	mov    %eax,(%esp)
     2b9:	e8 0b 3b 00 00       	call   3dc9 <printf>
}
     2be:	c9                   	leave  
     2bf:	c3                   	ret    

000002c0 <writetest1>:

void
writetest1(void)
{
     2c0:	55                   	push   %ebp
     2c1:	89 e5                	mov    %esp,%ebp
     2c3:	83 ec 28             	sub    $0x28,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     2c6:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     2cb:	c7 44 24 04 40 43 00 	movl   $0x4340,0x4(%esp)
     2d2:	00 
     2d3:	89 04 24             	mov    %eax,(%esp)
     2d6:	e8 ee 3a 00 00       	call   3dc9 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     2db:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     2e2:	00 
     2e3:	c7 04 24 50 43 00 00 	movl   $0x4350,(%esp)
     2ea:	e8 8d 39 00 00       	call   3c7c <open>
     2ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     2f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     2f6:	79 1a                	jns    312 <writetest1+0x52>
    printf(stdout, "error: creat big failed!\n");
     2f8:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     2fd:	c7 44 24 04 54 43 00 	movl   $0x4354,0x4(%esp)
     304:	00 
     305:	89 04 24             	mov    %eax,(%esp)
     308:	e8 bc 3a 00 00       	call   3dc9 <printf>
    exit();
     30d:	e8 2a 39 00 00       	call   3c3c <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     319:	eb 51                	jmp    36c <writetest1+0xac>
    ((int*)buf)[0] = i;
     31b:	b8 e0 86 00 00       	mov    $0x86e0,%eax
     320:	8b 55 f4             	mov    -0xc(%ebp),%edx
     323:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
     325:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     32c:	00 
     32d:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
     334:	00 
     335:	8b 45 ec             	mov    -0x14(%ebp),%eax
     338:	89 04 24             	mov    %eax,(%esp)
     33b:	e8 1c 39 00 00       	call   3c5c <write>
     340:	3d 00 02 00 00       	cmp    $0x200,%eax
     345:	74 21                	je     368 <writetest1+0xa8>
      printf(stdout, "error: write big file failed\n", i);
     347:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     34c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     34f:	89 54 24 08          	mov    %edx,0x8(%esp)
     353:	c7 44 24 04 6e 43 00 	movl   $0x436e,0x4(%esp)
     35a:	00 
     35b:	89 04 24             	mov    %eax,(%esp)
     35e:	e8 66 3a 00 00       	call   3dc9 <printf>
      exit();
     363:	e8 d4 38 00 00       	call   3c3c <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     368:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     36c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     36f:	3d 8a 40 00 00       	cmp    $0x408a,%eax
     374:	76 a5                	jbe    31b <writetest1+0x5b>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     376:	8b 45 ec             	mov    -0x14(%ebp),%eax
     379:	89 04 24             	mov    %eax,(%esp)
     37c:	e8 e3 38 00 00       	call   3c64 <close>

  fd = open("big", O_RDONLY);
     381:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     388:	00 
     389:	c7 04 24 50 43 00 00 	movl   $0x4350,(%esp)
     390:	e8 e7 38 00 00       	call   3c7c <open>
     395:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     398:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     39c:	79 1a                	jns    3b8 <writetest1+0xf8>
    printf(stdout, "error: open big failed!\n");
     39e:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     3a3:	c7 44 24 04 8c 43 00 	movl   $0x438c,0x4(%esp)
     3aa:	00 
     3ab:	89 04 24             	mov    %eax,(%esp)
     3ae:	e8 16 3a 00 00       	call   3dc9 <printf>
    exit();
     3b3:	e8 84 38 00 00       	call   3c3c <exit>
  }

  n = 0;
     3b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     3bf:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     3c6:	00 
     3c7:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
     3ce:	00 
     3cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
     3d2:	89 04 24             	mov    %eax,(%esp)
     3d5:	e8 7a 38 00 00       	call   3c54 <read>
     3da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     3dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     3e1:	75 2e                	jne    411 <writetest1+0x151>
      if(n == MAXFILE - 1){
     3e3:	81 7d f0 8a 40 00 00 	cmpl   $0x408a,-0x10(%ebp)
     3ea:	0f 85 8c 00 00 00    	jne    47c <writetest1+0x1bc>
        printf(stdout, "read only %d blocks from big", n);
     3f0:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     3f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
     3f8:	89 54 24 08          	mov    %edx,0x8(%esp)
     3fc:	c7 44 24 04 a5 43 00 	movl   $0x43a5,0x4(%esp)
     403:	00 
     404:	89 04 24             	mov    %eax,(%esp)
     407:	e8 bd 39 00 00       	call   3dc9 <printf>
        exit();
     40c:	e8 2b 38 00 00       	call   3c3c <exit>
      }
      break;
    } else if(i != 512){
     411:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     418:	74 21                	je     43b <writetest1+0x17b>
      printf(stdout, "read failed %d\n", i);
     41a:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     41f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     422:	89 54 24 08          	mov    %edx,0x8(%esp)
     426:	c7 44 24 04 c2 43 00 	movl   $0x43c2,0x4(%esp)
     42d:	00 
     42e:	89 04 24             	mov    %eax,(%esp)
     431:	e8 93 39 00 00       	call   3dc9 <printf>
      exit();
     436:	e8 01 38 00 00       	call   3c3c <exit>
    }
    if(((int*)buf)[0] != n){
     43b:	b8 e0 86 00 00       	mov    $0x86e0,%eax
     440:	8b 00                	mov    (%eax),%eax
     442:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     445:	74 2c                	je     473 <writetest1+0x1b3>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     447:	b8 e0 86 00 00       	mov    $0x86e0,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     44c:	8b 10                	mov    (%eax),%edx
     44e:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     453:	89 54 24 0c          	mov    %edx,0xc(%esp)
     457:	8b 55 f0             	mov    -0x10(%ebp),%edx
     45a:	89 54 24 08          	mov    %edx,0x8(%esp)
     45e:	c7 44 24 04 d4 43 00 	movl   $0x43d4,0x4(%esp)
     465:	00 
     466:	89 04 24             	mov    %eax,(%esp)
     469:	e8 5b 39 00 00       	call   3dc9 <printf>
             n, ((int*)buf)[0]);
      exit();
     46e:	e8 c9 37 00 00       	call   3c3c <exit>
    }
    n++;
     473:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }
     477:	e9 43 ff ff ff       	jmp    3bf <writetest1+0xff>
    if(i == 0){
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
     47c:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     47d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     480:	89 04 24             	mov    %eax,(%esp)
     483:	e8 dc 37 00 00       	call   3c64 <close>
  if(unlink("big") < 0){
     488:	c7 04 24 50 43 00 00 	movl   $0x4350,(%esp)
     48f:	e8 f8 37 00 00       	call   3c8c <unlink>
     494:	85 c0                	test   %eax,%eax
     496:	79 1a                	jns    4b2 <writetest1+0x1f2>
    printf(stdout, "unlink big failed\n");
     498:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     49d:	c7 44 24 04 f4 43 00 	movl   $0x43f4,0x4(%esp)
     4a4:	00 
     4a5:	89 04 24             	mov    %eax,(%esp)
     4a8:	e8 1c 39 00 00       	call   3dc9 <printf>
    exit();
     4ad:	e8 8a 37 00 00       	call   3c3c <exit>
  }
  printf(stdout, "big files ok\n");
     4b2:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     4b7:	c7 44 24 04 07 44 00 	movl   $0x4407,0x4(%esp)
     4be:	00 
     4bf:	89 04 24             	mov    %eax,(%esp)
     4c2:	e8 02 39 00 00       	call   3dc9 <printf>
}
     4c7:	c9                   	leave  
     4c8:	c3                   	ret    

000004c9 <createtest>:

void
createtest(void)
{
     4c9:	55                   	push   %ebp
     4ca:	89 e5                	mov    %esp,%ebp
     4cc:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     4cf:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     4d4:	c7 44 24 04 18 44 00 	movl   $0x4418,0x4(%esp)
     4db:	00 
     4dc:	89 04 24             	mov    %eax,(%esp)
     4df:	e8 e5 38 00 00       	call   3dc9 <printf>

  name[0] = 'a';
     4e4:	c6 05 e0 a6 00 00 61 	movb   $0x61,0xa6e0
  name[2] = '\0';
     4eb:	c6 05 e2 a6 00 00 00 	movb   $0x0,0xa6e2
  for(i = 0; i < 52; i++){
     4f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4f9:	eb 31                	jmp    52c <createtest+0x63>
    name[1] = '0' + i;
     4fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4fe:	83 c0 30             	add    $0x30,%eax
     501:	a2 e1 a6 00 00       	mov    %al,0xa6e1
    fd = open(name, O_CREATE|O_RDWR);
     506:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     50d:	00 
     50e:	c7 04 24 e0 a6 00 00 	movl   $0xa6e0,(%esp)
     515:	e8 62 37 00 00       	call   3c7c <open>
     51a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     51d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     520:	89 04 24             	mov    %eax,(%esp)
     523:	e8 3c 37 00 00       	call   3c64 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     528:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     52c:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     530:	7e c9                	jle    4fb <createtest+0x32>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     532:	c6 05 e0 a6 00 00 61 	movb   $0x61,0xa6e0
  name[2] = '\0';
     539:	c6 05 e2 a6 00 00 00 	movb   $0x0,0xa6e2
  for(i = 0; i < 52; i++){
     540:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     547:	eb 1b                	jmp    564 <createtest+0x9b>
    name[1] = '0' + i;
     549:	8b 45 f4             	mov    -0xc(%ebp),%eax
     54c:	83 c0 30             	add    $0x30,%eax
     54f:	a2 e1 a6 00 00       	mov    %al,0xa6e1
    unlink(name);
     554:	c7 04 24 e0 a6 00 00 	movl   $0xa6e0,(%esp)
     55b:	e8 2c 37 00 00       	call   3c8c <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     560:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     564:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     568:	7e df                	jle    549 <createtest+0x80>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     56a:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     56f:	c7 44 24 04 40 44 00 	movl   $0x4440,0x4(%esp)
     576:	00 
     577:	89 04 24             	mov    %eax,(%esp)
     57a:	e8 4a 38 00 00       	call   3dc9 <printf>
}
     57f:	c9                   	leave  
     580:	c3                   	ret    

00000581 <dirtest>:

void dirtest(void)
{
     581:	55                   	push   %ebp
     582:	89 e5                	mov    %esp,%ebp
     584:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
     587:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     58c:	c7 44 24 04 66 44 00 	movl   $0x4466,0x4(%esp)
     593:	00 
     594:	89 04 24             	mov    %eax,(%esp)
     597:	e8 2d 38 00 00       	call   3dc9 <printf>

  if(mkdir("dir0") < 0){
     59c:	c7 04 24 72 44 00 00 	movl   $0x4472,(%esp)
     5a3:	e8 fc 36 00 00       	call   3ca4 <mkdir>
     5a8:	85 c0                	test   %eax,%eax
     5aa:	79 1a                	jns    5c6 <dirtest+0x45>
    printf(stdout, "mkdir failed\n");
     5ac:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     5b1:	c7 44 24 04 77 44 00 	movl   $0x4477,0x4(%esp)
     5b8:	00 
     5b9:	89 04 24             	mov    %eax,(%esp)
     5bc:	e8 08 38 00 00       	call   3dc9 <printf>
    exit();
     5c1:	e8 76 36 00 00       	call   3c3c <exit>
  }

  if(chdir("dir0") < 0){
     5c6:	c7 04 24 72 44 00 00 	movl   $0x4472,(%esp)
     5cd:	e8 da 36 00 00       	call   3cac <chdir>
     5d2:	85 c0                	test   %eax,%eax
     5d4:	79 1a                	jns    5f0 <dirtest+0x6f>
    printf(stdout, "chdir dir0 failed\n");
     5d6:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     5db:	c7 44 24 04 85 44 00 	movl   $0x4485,0x4(%esp)
     5e2:	00 
     5e3:	89 04 24             	mov    %eax,(%esp)
     5e6:	e8 de 37 00 00       	call   3dc9 <printf>
    exit();
     5eb:	e8 4c 36 00 00       	call   3c3c <exit>
  }

  if(chdir("..") < 0){
     5f0:	c7 04 24 98 44 00 00 	movl   $0x4498,(%esp)
     5f7:	e8 b0 36 00 00       	call   3cac <chdir>
     5fc:	85 c0                	test   %eax,%eax
     5fe:	79 1a                	jns    61a <dirtest+0x99>
    printf(stdout, "chdir .. failed\n");
     600:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     605:	c7 44 24 04 9b 44 00 	movl   $0x449b,0x4(%esp)
     60c:	00 
     60d:	89 04 24             	mov    %eax,(%esp)
     610:	e8 b4 37 00 00       	call   3dc9 <printf>
    exit();
     615:	e8 22 36 00 00       	call   3c3c <exit>
  }

  if(unlink("dir0") < 0){
     61a:	c7 04 24 72 44 00 00 	movl   $0x4472,(%esp)
     621:	e8 66 36 00 00       	call   3c8c <unlink>
     626:	85 c0                	test   %eax,%eax
     628:	79 1a                	jns    644 <dirtest+0xc3>
    printf(stdout, "unlink dir0 failed\n");
     62a:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     62f:	c7 44 24 04 ac 44 00 	movl   $0x44ac,0x4(%esp)
     636:	00 
     637:	89 04 24             	mov    %eax,(%esp)
     63a:	e8 8a 37 00 00       	call   3dc9 <printf>
    exit();
     63f:	e8 f8 35 00 00       	call   3c3c <exit>
  }
  printf(stdout, "mkdir test\n");
     644:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     649:	c7 44 24 04 66 44 00 	movl   $0x4466,0x4(%esp)
     650:	00 
     651:	89 04 24             	mov    %eax,(%esp)
     654:	e8 70 37 00 00       	call   3dc9 <printf>
}
     659:	c9                   	leave  
     65a:	c3                   	ret    

0000065b <exectest>:

void
exectest(void)
{
     65b:	55                   	push   %ebp
     65c:	89 e5                	mov    %esp,%ebp
     65e:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
     661:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     666:	c7 44 24 04 c0 44 00 	movl   $0x44c0,0x4(%esp)
     66d:	00 
     66e:	89 04 24             	mov    %eax,(%esp)
     671:	e8 53 37 00 00       	call   3dc9 <printf>
  if(exec("echo", echoargv) < 0){
     676:	c7 44 24 04 dc 5e 00 	movl   $0x5edc,0x4(%esp)
     67d:	00 
     67e:	c7 04 24 9c 41 00 00 	movl   $0x419c,(%esp)
     685:	e8 ea 35 00 00       	call   3c74 <exec>
     68a:	85 c0                	test   %eax,%eax
     68c:	79 1a                	jns    6a8 <exectest+0x4d>
    printf(stdout, "exec echo failed\n");
     68e:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
     693:	c7 44 24 04 cb 44 00 	movl   $0x44cb,0x4(%esp)
     69a:	00 
     69b:	89 04 24             	mov    %eax,(%esp)
     69e:	e8 26 37 00 00       	call   3dc9 <printf>
    exit();
     6a3:	e8 94 35 00 00       	call   3c3c <exit>
  }
}
     6a8:	c9                   	leave  
     6a9:	c3                   	ret    

000006aa <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     6aa:	55                   	push   %ebp
     6ab:	89 e5                	mov    %esp,%ebp
     6ad:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     6b0:	8d 45 d8             	lea    -0x28(%ebp),%eax
     6b3:	89 04 24             	mov    %eax,(%esp)
     6b6:	e8 91 35 00 00       	call   3c4c <pipe>
     6bb:	85 c0                	test   %eax,%eax
     6bd:	74 19                	je     6d8 <pipe1+0x2e>
    printf(1, "pipe() failed\n");
     6bf:	c7 44 24 04 dd 44 00 	movl   $0x44dd,0x4(%esp)
     6c6:	00 
     6c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6ce:	e8 f6 36 00 00       	call   3dc9 <printf>
    exit();
     6d3:	e8 64 35 00 00       	call   3c3c <exit>
  }
  pid = fork();
     6d8:	e8 57 35 00 00       	call   3c34 <fork>
     6dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     6e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     6e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     6eb:	0f 85 86 00 00 00    	jne    777 <pipe1+0xcd>
    close(fds[0]);
     6f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
     6f4:	89 04 24             	mov    %eax,(%esp)
     6f7:	e8 68 35 00 00       	call   3c64 <close>
    for(n = 0; n < 5; n++){
     6fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     703:	eb 67                	jmp    76c <pipe1+0xc2>
      for(i = 0; i < 1033; i++)
     705:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     70c:	eb 16                	jmp    724 <pipe1+0x7a>
        buf[i] = seq++;
     70e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     711:	8b 55 f0             	mov    -0x10(%ebp),%edx
     714:	81 c2 e0 86 00 00    	add    $0x86e0,%edx
     71a:	88 02                	mov    %al,(%edx)
     71c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     720:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     724:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     72b:	7e e1                	jle    70e <pipe1+0x64>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     72d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     730:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
     737:	00 
     738:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
     73f:	00 
     740:	89 04 24             	mov    %eax,(%esp)
     743:	e8 14 35 00 00       	call   3c5c <write>
     748:	3d 09 04 00 00       	cmp    $0x409,%eax
     74d:	74 19                	je     768 <pipe1+0xbe>
        printf(1, "pipe1 oops 1\n");
     74f:	c7 44 24 04 ec 44 00 	movl   $0x44ec,0x4(%esp)
     756:	00 
     757:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     75e:	e8 66 36 00 00       	call   3dc9 <printf>
        exit();
     763:	e8 d4 34 00 00       	call   3c3c <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     768:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     76c:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     770:	7e 93                	jle    705 <pipe1+0x5b>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     772:	e8 c5 34 00 00       	call   3c3c <exit>
  } else if(pid > 0){
     777:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     77b:	0f 8e fc 00 00 00    	jle    87d <pipe1+0x1d3>
    close(fds[1]);
     781:	8b 45 dc             	mov    -0x24(%ebp),%eax
     784:	89 04 24             	mov    %eax,(%esp)
     787:	e8 d8 34 00 00       	call   3c64 <close>
    total = 0;
     78c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     793:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     79a:	eb 6b                	jmp    807 <pipe1+0x15d>
      for(i = 0; i < n; i++){
     79c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     7a3:	eb 40                	jmp    7e5 <pipe1+0x13b>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7a8:	05 e0 86 00 00       	add    $0x86e0,%eax
     7ad:	0f b6 00             	movzbl (%eax),%eax
     7b0:	0f be c0             	movsbl %al,%eax
     7b3:	33 45 f4             	xor    -0xc(%ebp),%eax
     7b6:	25 ff 00 00 00       	and    $0xff,%eax
     7bb:	85 c0                	test   %eax,%eax
     7bd:	0f 95 c0             	setne  %al
     7c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     7c4:	84 c0                	test   %al,%al
     7c6:	74 19                	je     7e1 <pipe1+0x137>
          printf(1, "pipe1 oops 2\n");
     7c8:	c7 44 24 04 fa 44 00 	movl   $0x44fa,0x4(%esp)
     7cf:	00 
     7d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     7d7:	e8 ed 35 00 00       	call   3dc9 <printf>
     7dc:	e9 b5 00 00 00       	jmp    896 <pipe1+0x1ec>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     7e1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     7e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7e8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     7eb:	7c b8                	jl     7a5 <pipe1+0xfb>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     7ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
     7f0:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     7f3:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     7f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7f9:	3d 00 20 00 00       	cmp    $0x2000,%eax
     7fe:	76 07                	jbe    807 <pipe1+0x15d>
        cc = sizeof(buf);
     800:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     807:	8b 45 d8             	mov    -0x28(%ebp),%eax
     80a:	8b 55 e8             	mov    -0x18(%ebp),%edx
     80d:	89 54 24 08          	mov    %edx,0x8(%esp)
     811:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
     818:	00 
     819:	89 04 24             	mov    %eax,(%esp)
     81c:	e8 33 34 00 00       	call   3c54 <read>
     821:	89 45 ec             	mov    %eax,-0x14(%ebp)
     824:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     828:	0f 8f 6e ff ff ff    	jg     79c <pipe1+0xf2>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     82e:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     835:	74 20                	je     857 <pipe1+0x1ad>
      printf(1, "pipe1 oops 3 total %d\n", total);
     837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     83a:	89 44 24 08          	mov    %eax,0x8(%esp)
     83e:	c7 44 24 04 08 45 00 	movl   $0x4508,0x4(%esp)
     845:	00 
     846:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     84d:	e8 77 35 00 00       	call   3dc9 <printf>
      exit();
     852:	e8 e5 33 00 00       	call   3c3c <exit>
    }
    close(fds[0]);
     857:	8b 45 d8             	mov    -0x28(%ebp),%eax
     85a:	89 04 24             	mov    %eax,(%esp)
     85d:	e8 02 34 00 00       	call   3c64 <close>
    wait();
     862:	e8 dd 33 00 00       	call   3c44 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     867:	c7 44 24 04 1f 45 00 	movl   $0x451f,0x4(%esp)
     86e:	00 
     86f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     876:	e8 4e 35 00 00       	call   3dc9 <printf>
     87b:	eb 19                	jmp    896 <pipe1+0x1ec>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     87d:	c7 44 24 04 29 45 00 	movl   $0x4529,0x4(%esp)
     884:	00 
     885:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     88c:	e8 38 35 00 00       	call   3dc9 <printf>
    exit();
     891:	e8 a6 33 00 00       	call   3c3c <exit>
  }
  printf(1, "pipe1 ok\n");
}
     896:	c9                   	leave  
     897:	c3                   	ret    

00000898 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     898:	55                   	push   %ebp
     899:	89 e5                	mov    %esp,%ebp
     89b:	83 ec 38             	sub    $0x38,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     89e:	c7 44 24 04 38 45 00 	movl   $0x4538,0x4(%esp)
     8a5:	00 
     8a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8ad:	e8 17 35 00 00       	call   3dc9 <printf>
  pid1 = fork();
     8b2:	e8 7d 33 00 00       	call   3c34 <fork>
     8b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     8ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     8be:	75 02                	jne    8c2 <preempt+0x2a>
    for(;;)
      ;
     8c0:	eb fe                	jmp    8c0 <preempt+0x28>

  pid2 = fork();
     8c2:	e8 6d 33 00 00       	call   3c34 <fork>
     8c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     8ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8ce:	75 02                	jne    8d2 <preempt+0x3a>
    for(;;)
      ;
     8d0:	eb fe                	jmp    8d0 <preempt+0x38>

  pipe(pfds);
     8d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     8d5:	89 04 24             	mov    %eax,(%esp)
     8d8:	e8 6f 33 00 00       	call   3c4c <pipe>
  pid3 = fork();
     8dd:	e8 52 33 00 00       	call   3c34 <fork>
     8e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     8e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     8e9:	75 4c                	jne    937 <preempt+0x9f>
    close(pfds[0]);
     8eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8ee:	89 04 24             	mov    %eax,(%esp)
     8f1:	e8 6e 33 00 00       	call   3c64 <close>
    if(write(pfds[1], "x", 1) != 1)
     8f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8f9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     900:	00 
     901:	c7 44 24 04 42 45 00 	movl   $0x4542,0x4(%esp)
     908:	00 
     909:	89 04 24             	mov    %eax,(%esp)
     90c:	e8 4b 33 00 00       	call   3c5c <write>
     911:	83 f8 01             	cmp    $0x1,%eax
     914:	74 14                	je     92a <preempt+0x92>
      printf(1, "preempt write error");
     916:	c7 44 24 04 44 45 00 	movl   $0x4544,0x4(%esp)
     91d:	00 
     91e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     925:	e8 9f 34 00 00       	call   3dc9 <printf>
    close(pfds[1]);
     92a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     92d:	89 04 24             	mov    %eax,(%esp)
     930:	e8 2f 33 00 00       	call   3c64 <close>
    for(;;)
      ;
     935:	eb fe                	jmp    935 <preempt+0x9d>
  }

  close(pfds[1]);
     937:	8b 45 e8             	mov    -0x18(%ebp),%eax
     93a:	89 04 24             	mov    %eax,(%esp)
     93d:	e8 22 33 00 00       	call   3c64 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     945:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     94c:	00 
     94d:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
     954:	00 
     955:	89 04 24             	mov    %eax,(%esp)
     958:	e8 f7 32 00 00       	call   3c54 <read>
     95d:	83 f8 01             	cmp    $0x1,%eax
     960:	74 16                	je     978 <preempt+0xe0>
    printf(1, "preempt read error");
     962:	c7 44 24 04 58 45 00 	movl   $0x4558,0x4(%esp)
     969:	00 
     96a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     971:	e8 53 34 00 00       	call   3dc9 <printf>
     976:	eb 77                	jmp    9ef <preempt+0x157>
    return;
  }
  close(pfds[0]);
     978:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     97b:	89 04 24             	mov    %eax,(%esp)
     97e:	e8 e1 32 00 00       	call   3c64 <close>
  printf(1, "kill... ");
     983:	c7 44 24 04 6b 45 00 	movl   $0x456b,0x4(%esp)
     98a:	00 
     98b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     992:	e8 32 34 00 00       	call   3dc9 <printf>
  kill(pid1);
     997:	8b 45 f4             	mov    -0xc(%ebp),%eax
     99a:	89 04 24             	mov    %eax,(%esp)
     99d:	e8 ca 32 00 00       	call   3c6c <kill>
  kill(pid2);
     9a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9a5:	89 04 24             	mov    %eax,(%esp)
     9a8:	e8 bf 32 00 00       	call   3c6c <kill>
  kill(pid3);
     9ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
     9b0:	89 04 24             	mov    %eax,(%esp)
     9b3:	e8 b4 32 00 00       	call   3c6c <kill>
  printf(1, "wait... ");
     9b8:	c7 44 24 04 74 45 00 	movl   $0x4574,0x4(%esp)
     9bf:	00 
     9c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9c7:	e8 fd 33 00 00       	call   3dc9 <printf>
  wait();
     9cc:	e8 73 32 00 00       	call   3c44 <wait>
  wait();
     9d1:	e8 6e 32 00 00       	call   3c44 <wait>
  wait();
     9d6:	e8 69 32 00 00       	call   3c44 <wait>
  printf(1, "preempt ok\n");
     9db:	c7 44 24 04 7d 45 00 	movl   $0x457d,0x4(%esp)
     9e2:	00 
     9e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9ea:	e8 da 33 00 00       	call   3dc9 <printf>
}
     9ef:	c9                   	leave  
     9f0:	c3                   	ret    

000009f1 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     9f1:	55                   	push   %ebp
     9f2:	89 e5                	mov    %esp,%ebp
     9f4:	83 ec 28             	sub    $0x28,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     9f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9fe:	eb 53                	jmp    a53 <exitwait+0x62>
    pid = fork();
     a00:	e8 2f 32 00 00       	call   3c34 <fork>
     a05:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     a08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a0c:	79 16                	jns    a24 <exitwait+0x33>
      printf(1, "fork failed\n");
     a0e:	c7 44 24 04 89 45 00 	movl   $0x4589,0x4(%esp)
     a15:	00 
     a16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a1d:	e8 a7 33 00 00       	call   3dc9 <printf>
      return;
     a22:	eb 49                	jmp    a6d <exitwait+0x7c>
    }
    if(pid){
     a24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a28:	74 20                	je     a4a <exitwait+0x59>
      if(wait() != pid){
     a2a:	e8 15 32 00 00       	call   3c44 <wait>
     a2f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     a32:	74 1b                	je     a4f <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
     a34:	c7 44 24 04 96 45 00 	movl   $0x4596,0x4(%esp)
     a3b:	00 
     a3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a43:	e8 81 33 00 00       	call   3dc9 <printf>
        return;
     a48:	eb 23                	jmp    a6d <exitwait+0x7c>
      }
    } else {
      exit();
     a4a:	e8 ed 31 00 00       	call   3c3c <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     a4f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a53:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     a57:	7e a7                	jle    a00 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     a59:	c7 44 24 04 a6 45 00 	movl   $0x45a6,0x4(%esp)
     a60:	00 
     a61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a68:	e8 5c 33 00 00       	call   3dc9 <printf>
}
     a6d:	c9                   	leave  
     a6e:	c3                   	ret    

00000a6f <mem>:

void
mem(void)
{
     a6f:	55                   	push   %ebp
     a70:	89 e5                	mov    %esp,%ebp
     a72:	83 ec 28             	sub    $0x28,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     a75:	c7 44 24 04 b3 45 00 	movl   $0x45b3,0x4(%esp)
     a7c:	00 
     a7d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a84:	e8 40 33 00 00       	call   3dc9 <printf>
  ppid = getpid();
     a89:	e8 2e 32 00 00       	call   3cbc <getpid>
     a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     a91:	e8 9e 31 00 00       	call   3c34 <fork>
     a96:	89 45 ec             	mov    %eax,-0x14(%ebp)
     a99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     a9d:	0f 85 aa 00 00 00    	jne    b4d <mem+0xde>
    m1 = 0;
     aa3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     aaa:	eb 0e                	jmp    aba <mem+0x4b>
      *(char**)m2 = m1;
     aac:	8b 45 e8             	mov    -0x18(%ebp),%eax
     aaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ab2:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     aba:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
     ac1:	e8 f3 35 00 00       	call   40b9 <malloc>
     ac6:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ac9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     acd:	75 dd                	jne    aac <mem+0x3d>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     acf:	eb 19                	jmp    aea <mem+0x7b>
      m2 = *(char**)m1;
     ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad4:	8b 00                	mov    (%eax),%eax
     ad6:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     adc:	89 04 24             	mov    %eax,(%esp)
     adf:	e8 9c 34 00 00       	call   3f80 <free>
      m1 = m2;
     ae4:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     aea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     aee:	75 e1                	jne    ad1 <mem+0x62>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     af0:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
     af7:	e8 bd 35 00 00       	call   40b9 <malloc>
     afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b03:	75 24                	jne    b29 <mem+0xba>
      printf(1, "couldn't allocate mem?!!\n");
     b05:	c7 44 24 04 bd 45 00 	movl   $0x45bd,0x4(%esp)
     b0c:	00 
     b0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b14:	e8 b0 32 00 00       	call   3dc9 <printf>
      kill(ppid);
     b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b1c:	89 04 24             	mov    %eax,(%esp)
     b1f:	e8 48 31 00 00       	call   3c6c <kill>
      exit();
     b24:	e8 13 31 00 00       	call   3c3c <exit>
    }
    free(m1);
     b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b2c:	89 04 24             	mov    %eax,(%esp)
     b2f:	e8 4c 34 00 00       	call   3f80 <free>
    printf(1, "mem ok\n");
     b34:	c7 44 24 04 d7 45 00 	movl   $0x45d7,0x4(%esp)
     b3b:	00 
     b3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b43:	e8 81 32 00 00       	call   3dc9 <printf>
    exit();
     b48:	e8 ef 30 00 00       	call   3c3c <exit>
  } else {
    wait();
     b4d:	e8 f2 30 00 00       	call   3c44 <wait>
  }
}
     b52:	c9                   	leave  
     b53:	c3                   	ret    

00000b54 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     b54:	55                   	push   %ebp
     b55:	89 e5                	mov    %esp,%ebp
     b57:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     b5a:	c7 44 24 04 df 45 00 	movl   $0x45df,0x4(%esp)
     b61:	00 
     b62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b69:	e8 5b 32 00 00       	call   3dc9 <printf>

  unlink("sharedfd");
     b6e:	c7 04 24 ee 45 00 00 	movl   $0x45ee,(%esp)
     b75:	e8 12 31 00 00       	call   3c8c <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     b7a:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     b81:	00 
     b82:	c7 04 24 ee 45 00 00 	movl   $0x45ee,(%esp)
     b89:	e8 ee 30 00 00       	call   3c7c <open>
     b8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     b91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b95:	79 19                	jns    bb0 <sharedfd+0x5c>
    printf(1, "fstests: cannot open sharedfd for writing");
     b97:	c7 44 24 04 f8 45 00 	movl   $0x45f8,0x4(%esp)
     b9e:	00 
     b9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ba6:	e8 1e 32 00 00       	call   3dc9 <printf>
     bab:	e9 a0 01 00 00       	jmp    d50 <sharedfd+0x1fc>
    return;
  }
  pid = fork();
     bb0:	e8 7f 30 00 00       	call   3c34 <fork>
     bb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     bb8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     bbc:	75 07                	jne    bc5 <sharedfd+0x71>
     bbe:	b8 63 00 00 00       	mov    $0x63,%eax
     bc3:	eb 05                	jmp    bca <sharedfd+0x76>
     bc5:	b8 70 00 00 00       	mov    $0x70,%eax
     bca:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     bd1:	00 
     bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
     bd6:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     bd9:	89 04 24             	mov    %eax,(%esp)
     bdc:	e8 b4 2e 00 00       	call   3a95 <memset>
  for(i = 0; i < 1000; i++){
     be1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     be8:	eb 39                	jmp    c23 <sharedfd+0xcf>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     bea:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     bf1:	00 
     bf2:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
     bf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bfc:	89 04 24             	mov    %eax,(%esp)
     bff:	e8 58 30 00 00       	call   3c5c <write>
     c04:	83 f8 0a             	cmp    $0xa,%eax
     c07:	74 16                	je     c1f <sharedfd+0xcb>
      printf(1, "fstests: write sharedfd failed\n");
     c09:	c7 44 24 04 24 46 00 	movl   $0x4624,0x4(%esp)
     c10:	00 
     c11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c18:	e8 ac 31 00 00       	call   3dc9 <printf>
      break;
     c1d:	eb 0d                	jmp    c2c <sharedfd+0xd8>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     c1f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c23:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     c2a:	7e be                	jle    bea <sharedfd+0x96>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     c2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     c30:	75 05                	jne    c37 <sharedfd+0xe3>
    exit();
     c32:	e8 05 30 00 00       	call   3c3c <exit>
  else
    wait();
     c37:	e8 08 30 00 00       	call   3c44 <wait>
  close(fd);
     c3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c3f:	89 04 24             	mov    %eax,(%esp)
     c42:	e8 1d 30 00 00       	call   3c64 <close>
  fd = open("sharedfd", 0);
     c47:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c4e:	00 
     c4f:	c7 04 24 ee 45 00 00 	movl   $0x45ee,(%esp)
     c56:	e8 21 30 00 00       	call   3c7c <open>
     c5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     c5e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     c62:	79 19                	jns    c7d <sharedfd+0x129>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     c64:	c7 44 24 04 44 46 00 	movl   $0x4644,0x4(%esp)
     c6b:	00 
     c6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c73:	e8 51 31 00 00       	call   3dc9 <printf>
     c78:	e9 d3 00 00 00       	jmp    d50 <sharedfd+0x1fc>
    return;
  }
  nc = np = 0;
     c7d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     c8a:	eb 3b                	jmp    cc7 <sharedfd+0x173>
    for(i = 0; i < sizeof(buf); i++){
     c8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c93:	eb 2a                	jmp    cbf <sharedfd+0x16b>
      if(buf[i] == 'c')
     c95:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c9b:	01 d0                	add    %edx,%eax
     c9d:	0f b6 00             	movzbl (%eax),%eax
     ca0:	3c 63                	cmp    $0x63,%al
     ca2:	75 04                	jne    ca8 <sharedfd+0x154>
        nc++;
     ca4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     ca8:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cae:	01 d0                	add    %edx,%eax
     cb0:	0f b6 00             	movzbl (%eax),%eax
     cb3:	3c 70                	cmp    $0x70,%al
     cb5:	75 04                	jne    cbb <sharedfd+0x167>
        np++;
     cb7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     cbb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cc2:	83 f8 09             	cmp    $0x9,%eax
     cc5:	76 ce                	jbe    c95 <sharedfd+0x141>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     cc7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     cce:	00 
     ccf:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
     cd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cd9:	89 04 24             	mov    %eax,(%esp)
     cdc:	e8 73 2f 00 00       	call   3c54 <read>
     ce1:	89 45 e0             	mov    %eax,-0x20(%ebp)
     ce4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     ce8:	7f a2                	jg     c8c <sharedfd+0x138>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     cea:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ced:	89 04 24             	mov    %eax,(%esp)
     cf0:	e8 6f 2f 00 00       	call   3c64 <close>
  unlink("sharedfd");
     cf5:	c7 04 24 ee 45 00 00 	movl   $0x45ee,(%esp)
     cfc:	e8 8b 2f 00 00       	call   3c8c <unlink>
  if(nc == 10000 && np == 10000){
     d01:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     d08:	75 1f                	jne    d29 <sharedfd+0x1d5>
     d0a:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
     d11:	75 16                	jne    d29 <sharedfd+0x1d5>
    printf(1, "sharedfd ok\n");
     d13:	c7 44 24 04 6f 46 00 	movl   $0x466f,0x4(%esp)
     d1a:	00 
     d1b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d22:	e8 a2 30 00 00       	call   3dc9 <printf>
     d27:	eb 27                	jmp    d50 <sharedfd+0x1fc>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
     d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d33:	89 44 24 08          	mov    %eax,0x8(%esp)
     d37:	c7 44 24 04 7c 46 00 	movl   $0x467c,0x4(%esp)
     d3e:	00 
     d3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d46:	e8 7e 30 00 00       	call   3dc9 <printf>
    exit();
     d4b:	e8 ec 2e 00 00       	call   3c3c <exit>
  }
}
     d50:	c9                   	leave  
     d51:	c3                   	ret    

00000d52 <twofiles>:

// two processes write two different files at the same
// time, to test block allocation.
void
twofiles(void)
{
     d52:	55                   	push   %ebp
     d53:	89 e5                	mov    %esp,%ebp
     d55:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, j, n, total;
  char *fname;

  printf(1, "twofiles test\n");
     d58:	c7 44 24 04 91 46 00 	movl   $0x4691,0x4(%esp)
     d5f:	00 
     d60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d67:	e8 5d 30 00 00       	call   3dc9 <printf>

  unlink("f1");
     d6c:	c7 04 24 a0 46 00 00 	movl   $0x46a0,(%esp)
     d73:	e8 14 2f 00 00       	call   3c8c <unlink>
  unlink("f2");
     d78:	c7 04 24 a3 46 00 00 	movl   $0x46a3,(%esp)
     d7f:	e8 08 2f 00 00       	call   3c8c <unlink>

  pid = fork();
     d84:	e8 ab 2e 00 00       	call   3c34 <fork>
     d89:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(pid < 0){
     d8c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d90:	79 19                	jns    dab <twofiles+0x59>
    printf(1, "fork failed\n");
     d92:	c7 44 24 04 89 45 00 	movl   $0x4589,0x4(%esp)
     d99:	00 
     d9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     da1:	e8 23 30 00 00       	call   3dc9 <printf>
    exit();
     da6:	e8 91 2e 00 00       	call   3c3c <exit>
  }

  fname = pid ? "f1" : "f2";
     dab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     daf:	74 07                	je     db8 <twofiles+0x66>
     db1:	b8 a0 46 00 00       	mov    $0x46a0,%eax
     db6:	eb 05                	jmp    dbd <twofiles+0x6b>
     db8:	b8 a3 46 00 00       	mov    $0x46a3,%eax
     dbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  fd = open(fname, O_CREATE | O_RDWR);
     dc0:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     dc7:	00 
     dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     dcb:	89 04 24             	mov    %eax,(%esp)
     dce:	e8 a9 2e 00 00       	call   3c7c <open>
     dd3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(fd < 0){
     dd6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     dda:	79 19                	jns    df5 <twofiles+0xa3>
    printf(1, "create failed\n");
     ddc:	c7 44 24 04 a6 46 00 	movl   $0x46a6,0x4(%esp)
     de3:	00 
     de4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     deb:	e8 d9 2f 00 00       	call   3dc9 <printf>
    exit();
     df0:	e8 47 2e 00 00       	call   3c3c <exit>
  }

  memset(buf, pid?'p':'c', 512);
     df5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     df9:	74 07                	je     e02 <twofiles+0xb0>
     dfb:	b8 70 00 00 00       	mov    $0x70,%eax
     e00:	eb 05                	jmp    e07 <twofiles+0xb5>
     e02:	b8 63 00 00 00       	mov    $0x63,%eax
     e07:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     e0e:	00 
     e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
     e13:	c7 04 24 e0 86 00 00 	movl   $0x86e0,(%esp)
     e1a:	e8 76 2c 00 00       	call   3a95 <memset>
  for(i = 0; i < 12; i++){
     e1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e26:	eb 4b                	jmp    e73 <twofiles+0x121>
    if((n = write(fd, buf, 500)) != 500){
     e28:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
     e2f:	00 
     e30:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
     e37:	00 
     e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
     e3b:	89 04 24             	mov    %eax,(%esp)
     e3e:	e8 19 2e 00 00       	call   3c5c <write>
     e43:	89 45 dc             	mov    %eax,-0x24(%ebp)
     e46:	81 7d dc f4 01 00 00 	cmpl   $0x1f4,-0x24(%ebp)
     e4d:	74 20                	je     e6f <twofiles+0x11d>
      printf(1, "write failed %d\n", n);
     e4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
     e52:	89 44 24 08          	mov    %eax,0x8(%esp)
     e56:	c7 44 24 04 b5 46 00 	movl   $0x46b5,0x4(%esp)
     e5d:	00 
     e5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e65:	e8 5f 2f 00 00       	call   3dc9 <printf>
      exit();
     e6a:	e8 cd 2d 00 00       	call   3c3c <exit>
    printf(1, "create failed\n");
    exit();
  }

  memset(buf, pid?'p':'c', 512);
  for(i = 0; i < 12; i++){
     e6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     e73:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
     e77:	7e af                	jle    e28 <twofiles+0xd6>
    if((n = write(fd, buf, 500)) != 500){
      printf(1, "write failed %d\n", n);
      exit();
    }
  }
  close(fd);
     e79:	8b 45 e0             	mov    -0x20(%ebp),%eax
     e7c:	89 04 24             	mov    %eax,(%esp)
     e7f:	e8 e0 2d 00 00       	call   3c64 <close>
  if(pid)
     e84:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e88:	74 11                	je     e9b <twofiles+0x149>
    wait();
     e8a:	e8 b5 2d 00 00       	call   3c44 <wait>
  else
    exit();

  for(i = 0; i < 2; i++){
     e8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e96:	e9 e7 00 00 00       	jmp    f82 <twofiles+0x230>
  }
  close(fd);
  if(pid)
    wait();
  else
    exit();
     e9b:	e8 9c 2d 00 00       	call   3c3c <exit>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
     ea0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ea4:	74 07                	je     ead <twofiles+0x15b>
     ea6:	b8 a0 46 00 00       	mov    $0x46a0,%eax
     eab:	eb 05                	jmp    eb2 <twofiles+0x160>
     ead:	b8 a3 46 00 00       	mov    $0x46a3,%eax
     eb2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     eb9:	00 
     eba:	89 04 24             	mov    %eax,(%esp)
     ebd:	e8 ba 2d 00 00       	call   3c7c <open>
     ec2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    total = 0;
     ec5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
     ecc:	eb 58                	jmp    f26 <twofiles+0x1d4>
      for(j = 0; j < n; j++){
     ece:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     ed5:	eb 41                	jmp    f18 <twofiles+0x1c6>
        if(buf[j] != (i?'p':'c')){
     ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eda:	05 e0 86 00 00       	add    $0x86e0,%eax
     edf:	0f b6 00             	movzbl (%eax),%eax
     ee2:	0f be d0             	movsbl %al,%edx
     ee5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ee9:	74 07                	je     ef2 <twofiles+0x1a0>
     eeb:	b8 70 00 00 00       	mov    $0x70,%eax
     ef0:	eb 05                	jmp    ef7 <twofiles+0x1a5>
     ef2:	b8 63 00 00 00       	mov    $0x63,%eax
     ef7:	39 c2                	cmp    %eax,%edx
     ef9:	74 19                	je     f14 <twofiles+0x1c2>
          printf(1, "wrong char\n");
     efb:	c7 44 24 04 c6 46 00 	movl   $0x46c6,0x4(%esp)
     f02:	00 
     f03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f0a:	e8 ba 2e 00 00       	call   3dc9 <printf>
          exit();
     f0f:	e8 28 2d 00 00       	call   3c3c <exit>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
     f14:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f1b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     f1e:	7c b7                	jl     ed7 <twofiles+0x185>
        if(buf[j] != (i?'p':'c')){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
     f20:	8b 45 dc             	mov    -0x24(%ebp),%eax
     f23:	01 45 ec             	add    %eax,-0x14(%ebp)
    exit();

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
     f26:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     f2d:	00 
     f2e:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
     f35:	00 
     f36:	8b 45 e0             	mov    -0x20(%ebp),%eax
     f39:	89 04 24             	mov    %eax,(%esp)
     f3c:	e8 13 2d 00 00       	call   3c54 <read>
     f41:	89 45 dc             	mov    %eax,-0x24(%ebp)
     f44:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
     f48:	7f 84                	jg     ece <twofiles+0x17c>
          exit();
        }
      }
      total += n;
    }
    close(fd);
     f4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
     f4d:	89 04 24             	mov    %eax,(%esp)
     f50:	e8 0f 2d 00 00       	call   3c64 <close>
    if(total != 12*500){
     f55:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
     f5c:	74 20                	je     f7e <twofiles+0x22c>
      printf(1, "wrong length %d\n", total);
     f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f61:	89 44 24 08          	mov    %eax,0x8(%esp)
     f65:	c7 44 24 04 d2 46 00 	movl   $0x46d2,0x4(%esp)
     f6c:	00 
     f6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f74:	e8 50 2e 00 00       	call   3dc9 <printf>
      exit();
     f79:	e8 be 2c 00 00       	call   3c3c <exit>
  if(pid)
    wait();
  else
    exit();

  for(i = 0; i < 2; i++){
     f7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f82:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
     f86:	0f 8e 14 ff ff ff    	jle    ea0 <twofiles+0x14e>
      printf(1, "wrong length %d\n", total);
      exit();
    }
  }

  unlink("f1");
     f8c:	c7 04 24 a0 46 00 00 	movl   $0x46a0,(%esp)
     f93:	e8 f4 2c 00 00       	call   3c8c <unlink>
  unlink("f2");
     f98:	c7 04 24 a3 46 00 00 	movl   $0x46a3,(%esp)
     f9f:	e8 e8 2c 00 00       	call   3c8c <unlink>

  printf(1, "twofiles ok\n");
     fa4:	c7 44 24 04 e3 46 00 	movl   $0x46e3,0x4(%esp)
     fab:	00 
     fac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fb3:	e8 11 2e 00 00       	call   3dc9 <printf>
}
     fb8:	c9                   	leave  
     fb9:	c3                   	ret    

00000fba <createdelete>:

// two processes create and delete different files in same directory
void
createdelete(void)
{
     fba:	55                   	push   %ebp
     fbb:	89 e5                	mov    %esp,%ebp
     fbd:	83 ec 48             	sub    $0x48,%esp
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
     fc0:	c7 44 24 04 f0 46 00 	movl   $0x46f0,0x4(%esp)
     fc7:	00 
     fc8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fcf:	e8 f5 2d 00 00       	call   3dc9 <printf>
  pid = fork();
     fd4:	e8 5b 2c 00 00       	call   3c34 <fork>
     fd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid < 0){
     fdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fe0:	79 19                	jns    ffb <createdelete+0x41>
    printf(1, "fork failed\n");
     fe2:	c7 44 24 04 89 45 00 	movl   $0x4589,0x4(%esp)
     fe9:	00 
     fea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ff1:	e8 d3 2d 00 00       	call   3dc9 <printf>
    exit();
     ff6:	e8 41 2c 00 00       	call   3c3c <exit>
  }

  name[0] = pid ? 'p' : 'c';
     ffb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fff:	74 07                	je     1008 <createdelete+0x4e>
    1001:	b8 70 00 00 00       	mov    $0x70,%eax
    1006:	eb 05                	jmp    100d <createdelete+0x53>
    1008:	b8 63 00 00 00       	mov    $0x63,%eax
    100d:	88 45 cc             	mov    %al,-0x34(%ebp)
  name[2] = '\0';
    1010:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
  for(i = 0; i < N; i++){
    1014:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    101b:	e9 97 00 00 00       	jmp    10b7 <createdelete+0xfd>
    name[1] = '0' + i;
    1020:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1023:	83 c0 30             	add    $0x30,%eax
    1026:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, O_CREATE | O_RDWR);
    1029:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1030:	00 
    1031:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1034:	89 04 24             	mov    %eax,(%esp)
    1037:	e8 40 2c 00 00       	call   3c7c <open>
    103c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    103f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1043:	79 19                	jns    105e <createdelete+0xa4>
      printf(1, "create failed\n");
    1045:	c7 44 24 04 a6 46 00 	movl   $0x46a6,0x4(%esp)
    104c:	00 
    104d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1054:	e8 70 2d 00 00       	call   3dc9 <printf>
      exit();
    1059:	e8 de 2b 00 00       	call   3c3c <exit>
    }
    close(fd);
    105e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1061:	89 04 24             	mov    %eax,(%esp)
    1064:	e8 fb 2b 00 00       	call   3c64 <close>
    if(i > 0 && (i % 2 ) == 0){
    1069:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    106d:	7e 44                	jle    10b3 <createdelete+0xf9>
    106f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1072:	83 e0 01             	and    $0x1,%eax
    1075:	85 c0                	test   %eax,%eax
    1077:	75 3a                	jne    10b3 <createdelete+0xf9>
      name[1] = '0' + (i / 2);
    1079:	8b 45 f4             	mov    -0xc(%ebp),%eax
    107c:	89 c2                	mov    %eax,%edx
    107e:	c1 ea 1f             	shr    $0x1f,%edx
    1081:	01 d0                	add    %edx,%eax
    1083:	d1 f8                	sar    %eax
    1085:	83 c0 30             	add    $0x30,%eax
    1088:	88 45 cd             	mov    %al,-0x33(%ebp)
      if(unlink(name) < 0){
    108b:	8d 45 cc             	lea    -0x34(%ebp),%eax
    108e:	89 04 24             	mov    %eax,(%esp)
    1091:	e8 f6 2b 00 00       	call   3c8c <unlink>
    1096:	85 c0                	test   %eax,%eax
    1098:	79 19                	jns    10b3 <createdelete+0xf9>
        printf(1, "unlink failed\n");
    109a:	c7 44 24 04 03 47 00 	movl   $0x4703,0x4(%esp)
    10a1:	00 
    10a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10a9:	e8 1b 2d 00 00       	call   3dc9 <printf>
        exit();
    10ae:	e8 89 2b 00 00       	call   3c3c <exit>
    exit();
  }

  name[0] = pid ? 'p' : 'c';
  name[2] = '\0';
  for(i = 0; i < N; i++){
    10b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    10b7:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    10bb:	0f 8e 5f ff ff ff    	jle    1020 <createdelete+0x66>
        exit();
      }
    }
  }

  if(pid==0)
    10c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10c5:	75 05                	jne    10cc <createdelete+0x112>
    exit();
    10c7:	e8 70 2b 00 00       	call   3c3c <exit>
  else
    wait();
    10cc:	e8 73 2b 00 00       	call   3c44 <wait>

  for(i = 0; i < N; i++){
    10d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10d8:	e9 34 01 00 00       	jmp    1211 <createdelete+0x257>
    name[0] = 'p';
    10dd:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    10e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10e4:	83 c0 30             	add    $0x30,%eax
    10e7:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    10ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10f1:	00 
    10f2:	8d 45 cc             	lea    -0x34(%ebp),%eax
    10f5:	89 04 24             	mov    %eax,(%esp)
    10f8:	e8 7f 2b 00 00       	call   3c7c <open>
    10fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    1100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1104:	74 06                	je     110c <createdelete+0x152>
    1106:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    110a:	7e 26                	jle    1132 <createdelete+0x178>
    110c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1110:	79 20                	jns    1132 <createdelete+0x178>
      printf(1, "oops createdelete %s didn't exist\n", name);
    1112:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1115:	89 44 24 08          	mov    %eax,0x8(%esp)
    1119:	c7 44 24 04 14 47 00 	movl   $0x4714,0x4(%esp)
    1120:	00 
    1121:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1128:	e8 9c 2c 00 00       	call   3dc9 <printf>
      exit();
    112d:	e8 0a 2b 00 00       	call   3c3c <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    1132:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1136:	7e 2c                	jle    1164 <createdelete+0x1aa>
    1138:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    113c:	7f 26                	jg     1164 <createdelete+0x1aa>
    113e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1142:	78 20                	js     1164 <createdelete+0x1aa>
      printf(1, "oops createdelete %s did exist\n", name);
    1144:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1147:	89 44 24 08          	mov    %eax,0x8(%esp)
    114b:	c7 44 24 04 38 47 00 	movl   $0x4738,0x4(%esp)
    1152:	00 
    1153:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    115a:	e8 6a 2c 00 00       	call   3dc9 <printf>
      exit();
    115f:	e8 d8 2a 00 00       	call   3c3c <exit>
    }
    if(fd >= 0)
    1164:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1168:	78 0b                	js     1175 <createdelete+0x1bb>
      close(fd);
    116a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    116d:	89 04 24             	mov    %eax,(%esp)
    1170:	e8 ef 2a 00 00       	call   3c64 <close>

    name[0] = 'c';
    1175:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    name[1] = '0' + i;
    1179:	8b 45 f4             	mov    -0xc(%ebp),%eax
    117c:	83 c0 30             	add    $0x30,%eax
    117f:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    1182:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1189:	00 
    118a:	8d 45 cc             	lea    -0x34(%ebp),%eax
    118d:	89 04 24             	mov    %eax,(%esp)
    1190:	e8 e7 2a 00 00       	call   3c7c <open>
    1195:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    1198:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    119c:	74 06                	je     11a4 <createdelete+0x1ea>
    119e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    11a2:	7e 26                	jle    11ca <createdelete+0x210>
    11a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    11a8:	79 20                	jns    11ca <createdelete+0x210>
      printf(1, "oops createdelete %s didn't exist\n", name);
    11aa:	8d 45 cc             	lea    -0x34(%ebp),%eax
    11ad:	89 44 24 08          	mov    %eax,0x8(%esp)
    11b1:	c7 44 24 04 14 47 00 	movl   $0x4714,0x4(%esp)
    11b8:	00 
    11b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11c0:	e8 04 2c 00 00       	call   3dc9 <printf>
      exit();
    11c5:	e8 72 2a 00 00       	call   3c3c <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    11ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11ce:	7e 2c                	jle    11fc <createdelete+0x242>
    11d0:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    11d4:	7f 26                	jg     11fc <createdelete+0x242>
    11d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    11da:	78 20                	js     11fc <createdelete+0x242>
      printf(1, "oops createdelete %s did exist\n", name);
    11dc:	8d 45 cc             	lea    -0x34(%ebp),%eax
    11df:	89 44 24 08          	mov    %eax,0x8(%esp)
    11e3:	c7 44 24 04 38 47 00 	movl   $0x4738,0x4(%esp)
    11ea:	00 
    11eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11f2:	e8 d2 2b 00 00       	call   3dc9 <printf>
      exit();
    11f7:	e8 40 2a 00 00       	call   3c3c <exit>
    }
    if(fd >= 0)
    11fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1200:	78 0b                	js     120d <createdelete+0x253>
      close(fd);
    1202:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1205:	89 04 24             	mov    %eax,(%esp)
    1208:	e8 57 2a 00 00       	call   3c64 <close>
  if(pid==0)
    exit();
  else
    wait();

  for(i = 0; i < N; i++){
    120d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1211:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1215:	0f 8e c2 fe ff ff    	jle    10dd <createdelete+0x123>
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    121b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1222:	eb 2b                	jmp    124f <createdelete+0x295>
    name[0] = 'p';
    1224:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    1228:	8b 45 f4             	mov    -0xc(%ebp),%eax
    122b:	83 c0 30             	add    $0x30,%eax
    122e:	88 45 cd             	mov    %al,-0x33(%ebp)
    unlink(name);
    1231:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1234:	89 04 24             	mov    %eax,(%esp)
    1237:	e8 50 2a 00 00       	call   3c8c <unlink>
    name[0] = 'c';
    123c:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    unlink(name);
    1240:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1243:	89 04 24             	mov    %eax,(%esp)
    1246:	e8 41 2a 00 00       	call   3c8c <unlink>
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    124b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    124f:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1253:	7e cf                	jle    1224 <createdelete+0x26a>
    unlink(name);
    name[0] = 'c';
    unlink(name);
  }

  printf(1, "createdelete ok\n");
    1255:	c7 44 24 04 58 47 00 	movl   $0x4758,0x4(%esp)
    125c:	00 
    125d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1264:	e8 60 2b 00 00       	call   3dc9 <printf>
}
    1269:	c9                   	leave  
    126a:	c3                   	ret    

0000126b <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    126b:	55                   	push   %ebp
    126c:	89 e5                	mov    %esp,%ebp
    126e:	83 ec 28             	sub    $0x28,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1271:	c7 44 24 04 69 47 00 	movl   $0x4769,0x4(%esp)
    1278:	00 
    1279:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1280:	e8 44 2b 00 00       	call   3dc9 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1285:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    128c:	00 
    128d:	c7 04 24 7a 47 00 00 	movl   $0x477a,(%esp)
    1294:	e8 e3 29 00 00       	call   3c7c <open>
    1299:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    129c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12a0:	79 19                	jns    12bb <unlinkread+0x50>
    printf(1, "create unlinkread failed\n");
    12a2:	c7 44 24 04 85 47 00 	movl   $0x4785,0x4(%esp)
    12a9:	00 
    12aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12b1:	e8 13 2b 00 00       	call   3dc9 <printf>
    exit();
    12b6:	e8 81 29 00 00       	call   3c3c <exit>
  }
  write(fd, "hello", 5);
    12bb:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    12c2:	00 
    12c3:	c7 44 24 04 9f 47 00 	movl   $0x479f,0x4(%esp)
    12ca:	00 
    12cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ce:	89 04 24             	mov    %eax,(%esp)
    12d1:	e8 86 29 00 00       	call   3c5c <write>
  close(fd);
    12d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d9:	89 04 24             	mov    %eax,(%esp)
    12dc:	e8 83 29 00 00       	call   3c64 <close>

  fd = open("unlinkread", O_RDWR);
    12e1:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    12e8:	00 
    12e9:	c7 04 24 7a 47 00 00 	movl   $0x477a,(%esp)
    12f0:	e8 87 29 00 00       	call   3c7c <open>
    12f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    12f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12fc:	79 19                	jns    1317 <unlinkread+0xac>
    printf(1, "open unlinkread failed\n");
    12fe:	c7 44 24 04 a5 47 00 	movl   $0x47a5,0x4(%esp)
    1305:	00 
    1306:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    130d:	e8 b7 2a 00 00       	call   3dc9 <printf>
    exit();
    1312:	e8 25 29 00 00       	call   3c3c <exit>
  }
  if(unlink("unlinkread") != 0){
    1317:	c7 04 24 7a 47 00 00 	movl   $0x477a,(%esp)
    131e:	e8 69 29 00 00       	call   3c8c <unlink>
    1323:	85 c0                	test   %eax,%eax
    1325:	74 19                	je     1340 <unlinkread+0xd5>
    printf(1, "unlink unlinkread failed\n");
    1327:	c7 44 24 04 bd 47 00 	movl   $0x47bd,0x4(%esp)
    132e:	00 
    132f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1336:	e8 8e 2a 00 00       	call   3dc9 <printf>
    exit();
    133b:	e8 fc 28 00 00       	call   3c3c <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1340:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1347:	00 
    1348:	c7 04 24 7a 47 00 00 	movl   $0x477a,(%esp)
    134f:	e8 28 29 00 00       	call   3c7c <open>
    1354:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    1357:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    135e:	00 
    135f:	c7 44 24 04 d7 47 00 	movl   $0x47d7,0x4(%esp)
    1366:	00 
    1367:	8b 45 f0             	mov    -0x10(%ebp),%eax
    136a:	89 04 24             	mov    %eax,(%esp)
    136d:	e8 ea 28 00 00       	call   3c5c <write>
  close(fd1);
    1372:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1375:	89 04 24             	mov    %eax,(%esp)
    1378:	e8 e7 28 00 00       	call   3c64 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    137d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1384:	00 
    1385:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
    138c:	00 
    138d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1390:	89 04 24             	mov    %eax,(%esp)
    1393:	e8 bc 28 00 00       	call   3c54 <read>
    1398:	83 f8 05             	cmp    $0x5,%eax
    139b:	74 19                	je     13b6 <unlinkread+0x14b>
    printf(1, "unlinkread read failed");
    139d:	c7 44 24 04 db 47 00 	movl   $0x47db,0x4(%esp)
    13a4:	00 
    13a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13ac:	e8 18 2a 00 00       	call   3dc9 <printf>
    exit();
    13b1:	e8 86 28 00 00       	call   3c3c <exit>
  }
  if(buf[0] != 'h'){
    13b6:	0f b6 05 e0 86 00 00 	movzbl 0x86e0,%eax
    13bd:	3c 68                	cmp    $0x68,%al
    13bf:	74 19                	je     13da <unlinkread+0x16f>
    printf(1, "unlinkread wrong data\n");
    13c1:	c7 44 24 04 f2 47 00 	movl   $0x47f2,0x4(%esp)
    13c8:	00 
    13c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13d0:	e8 f4 29 00 00       	call   3dc9 <printf>
    exit();
    13d5:	e8 62 28 00 00       	call   3c3c <exit>
  }
  if(write(fd, buf, 10) != 10){
    13da:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    13e1:	00 
    13e2:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
    13e9:	00 
    13ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ed:	89 04 24             	mov    %eax,(%esp)
    13f0:	e8 67 28 00 00       	call   3c5c <write>
    13f5:	83 f8 0a             	cmp    $0xa,%eax
    13f8:	74 19                	je     1413 <unlinkread+0x1a8>
    printf(1, "unlinkread write failed\n");
    13fa:	c7 44 24 04 09 48 00 	movl   $0x4809,0x4(%esp)
    1401:	00 
    1402:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1409:	e8 bb 29 00 00       	call   3dc9 <printf>
    exit();
    140e:	e8 29 28 00 00       	call   3c3c <exit>
  }
  close(fd);
    1413:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1416:	89 04 24             	mov    %eax,(%esp)
    1419:	e8 46 28 00 00       	call   3c64 <close>
  unlink("unlinkread");
    141e:	c7 04 24 7a 47 00 00 	movl   $0x477a,(%esp)
    1425:	e8 62 28 00 00       	call   3c8c <unlink>
  printf(1, "unlinkread ok\n");
    142a:	c7 44 24 04 22 48 00 	movl   $0x4822,0x4(%esp)
    1431:	00 
    1432:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1439:	e8 8b 29 00 00       	call   3dc9 <printf>
}
    143e:	c9                   	leave  
    143f:	c3                   	ret    

00001440 <linktest>:

void
linktest(void)
{
    1440:	55                   	push   %ebp
    1441:	89 e5                	mov    %esp,%ebp
    1443:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "linktest\n");
    1446:	c7 44 24 04 31 48 00 	movl   $0x4831,0x4(%esp)
    144d:	00 
    144e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1455:	e8 6f 29 00 00       	call   3dc9 <printf>

  unlink("lf1");
    145a:	c7 04 24 3b 48 00 00 	movl   $0x483b,(%esp)
    1461:	e8 26 28 00 00       	call   3c8c <unlink>
  unlink("lf2");
    1466:	c7 04 24 3f 48 00 00 	movl   $0x483f,(%esp)
    146d:	e8 1a 28 00 00       	call   3c8c <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    1472:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1479:	00 
    147a:	c7 04 24 3b 48 00 00 	movl   $0x483b,(%esp)
    1481:	e8 f6 27 00 00       	call   3c7c <open>
    1486:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    148d:	79 19                	jns    14a8 <linktest+0x68>
    printf(1, "create lf1 failed\n");
    148f:	c7 44 24 04 43 48 00 	movl   $0x4843,0x4(%esp)
    1496:	00 
    1497:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    149e:	e8 26 29 00 00       	call   3dc9 <printf>
    exit();
    14a3:	e8 94 27 00 00       	call   3c3c <exit>
  }
  if(write(fd, "hello", 5) != 5){
    14a8:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    14af:	00 
    14b0:	c7 44 24 04 9f 47 00 	movl   $0x479f,0x4(%esp)
    14b7:	00 
    14b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14bb:	89 04 24             	mov    %eax,(%esp)
    14be:	e8 99 27 00 00       	call   3c5c <write>
    14c3:	83 f8 05             	cmp    $0x5,%eax
    14c6:	74 19                	je     14e1 <linktest+0xa1>
    printf(1, "write lf1 failed\n");
    14c8:	c7 44 24 04 56 48 00 	movl   $0x4856,0x4(%esp)
    14cf:	00 
    14d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14d7:	e8 ed 28 00 00       	call   3dc9 <printf>
    exit();
    14dc:	e8 5b 27 00 00       	call   3c3c <exit>
  }
  close(fd);
    14e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e4:	89 04 24             	mov    %eax,(%esp)
    14e7:	e8 78 27 00 00       	call   3c64 <close>

  if(link("lf1", "lf2") < 0){
    14ec:	c7 44 24 04 3f 48 00 	movl   $0x483f,0x4(%esp)
    14f3:	00 
    14f4:	c7 04 24 3b 48 00 00 	movl   $0x483b,(%esp)
    14fb:	e8 9c 27 00 00       	call   3c9c <link>
    1500:	85 c0                	test   %eax,%eax
    1502:	79 19                	jns    151d <linktest+0xdd>
    printf(1, "link lf1 lf2 failed\n");
    1504:	c7 44 24 04 68 48 00 	movl   $0x4868,0x4(%esp)
    150b:	00 
    150c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1513:	e8 b1 28 00 00       	call   3dc9 <printf>
    exit();
    1518:	e8 1f 27 00 00       	call   3c3c <exit>
  }
  unlink("lf1");
    151d:	c7 04 24 3b 48 00 00 	movl   $0x483b,(%esp)
    1524:	e8 63 27 00 00       	call   3c8c <unlink>

  if(open("lf1", 0) >= 0){
    1529:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1530:	00 
    1531:	c7 04 24 3b 48 00 00 	movl   $0x483b,(%esp)
    1538:	e8 3f 27 00 00       	call   3c7c <open>
    153d:	85 c0                	test   %eax,%eax
    153f:	78 19                	js     155a <linktest+0x11a>
    printf(1, "unlinked lf1 but it is still there!\n");
    1541:	c7 44 24 04 80 48 00 	movl   $0x4880,0x4(%esp)
    1548:	00 
    1549:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1550:	e8 74 28 00 00       	call   3dc9 <printf>
    exit();
    1555:	e8 e2 26 00 00       	call   3c3c <exit>
  }

  fd = open("lf2", 0);
    155a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1561:	00 
    1562:	c7 04 24 3f 48 00 00 	movl   $0x483f,(%esp)
    1569:	e8 0e 27 00 00       	call   3c7c <open>
    156e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1575:	79 19                	jns    1590 <linktest+0x150>
    printf(1, "open lf2 failed\n");
    1577:	c7 44 24 04 a5 48 00 	movl   $0x48a5,0x4(%esp)
    157e:	00 
    157f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1586:	e8 3e 28 00 00       	call   3dc9 <printf>
    exit();
    158b:	e8 ac 26 00 00       	call   3c3c <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1590:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1597:	00 
    1598:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
    159f:	00 
    15a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a3:	89 04 24             	mov    %eax,(%esp)
    15a6:	e8 a9 26 00 00       	call   3c54 <read>
    15ab:	83 f8 05             	cmp    $0x5,%eax
    15ae:	74 19                	je     15c9 <linktest+0x189>
    printf(1, "read lf2 failed\n");
    15b0:	c7 44 24 04 b6 48 00 	movl   $0x48b6,0x4(%esp)
    15b7:	00 
    15b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15bf:	e8 05 28 00 00       	call   3dc9 <printf>
    exit();
    15c4:	e8 73 26 00 00       	call   3c3c <exit>
  }
  close(fd);
    15c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15cc:	89 04 24             	mov    %eax,(%esp)
    15cf:	e8 90 26 00 00       	call   3c64 <close>

  if(link("lf2", "lf2") >= 0){
    15d4:	c7 44 24 04 3f 48 00 	movl   $0x483f,0x4(%esp)
    15db:	00 
    15dc:	c7 04 24 3f 48 00 00 	movl   $0x483f,(%esp)
    15e3:	e8 b4 26 00 00       	call   3c9c <link>
    15e8:	85 c0                	test   %eax,%eax
    15ea:	78 19                	js     1605 <linktest+0x1c5>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    15ec:	c7 44 24 04 c7 48 00 	movl   $0x48c7,0x4(%esp)
    15f3:	00 
    15f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15fb:	e8 c9 27 00 00       	call   3dc9 <printf>
    exit();
    1600:	e8 37 26 00 00       	call   3c3c <exit>
  }

  unlink("lf2");
    1605:	c7 04 24 3f 48 00 00 	movl   $0x483f,(%esp)
    160c:	e8 7b 26 00 00       	call   3c8c <unlink>
  if(link("lf2", "lf1") >= 0){
    1611:	c7 44 24 04 3b 48 00 	movl   $0x483b,0x4(%esp)
    1618:	00 
    1619:	c7 04 24 3f 48 00 00 	movl   $0x483f,(%esp)
    1620:	e8 77 26 00 00       	call   3c9c <link>
    1625:	85 c0                	test   %eax,%eax
    1627:	78 19                	js     1642 <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    1629:	c7 44 24 04 e8 48 00 	movl   $0x48e8,0x4(%esp)
    1630:	00 
    1631:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1638:	e8 8c 27 00 00       	call   3dc9 <printf>
    exit();
    163d:	e8 fa 25 00 00       	call   3c3c <exit>
  }

  if(link(".", "lf1") >= 0){
    1642:	c7 44 24 04 3b 48 00 	movl   $0x483b,0x4(%esp)
    1649:	00 
    164a:	c7 04 24 0b 49 00 00 	movl   $0x490b,(%esp)
    1651:	e8 46 26 00 00       	call   3c9c <link>
    1656:	85 c0                	test   %eax,%eax
    1658:	78 19                	js     1673 <linktest+0x233>
    printf(1, "link . lf1 succeeded! oops\n");
    165a:	c7 44 24 04 0d 49 00 	movl   $0x490d,0x4(%esp)
    1661:	00 
    1662:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1669:	e8 5b 27 00 00       	call   3dc9 <printf>
    exit();
    166e:	e8 c9 25 00 00       	call   3c3c <exit>
  }

  printf(1, "linktest ok\n");
    1673:	c7 44 24 04 29 49 00 	movl   $0x4929,0x4(%esp)
    167a:	00 
    167b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1682:	e8 42 27 00 00       	call   3dc9 <printf>
}
    1687:	c9                   	leave  
    1688:	c3                   	ret    

00001689 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1689:	55                   	push   %ebp
    168a:	89 e5                	mov    %esp,%ebp
    168c:	83 ec 68             	sub    $0x68,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    168f:	c7 44 24 04 36 49 00 	movl   $0x4936,0x4(%esp)
    1696:	00 
    1697:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    169e:	e8 26 27 00 00       	call   3dc9 <printf>
  file[0] = 'C';
    16a3:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    16a7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    16ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    16b2:	e9 f7 00 00 00       	jmp    17ae <concreate+0x125>
    file[1] = '0' + i;
    16b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16ba:	83 c0 30             	add    $0x30,%eax
    16bd:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    16c0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16c3:	89 04 24             	mov    %eax,(%esp)
    16c6:	e8 c1 25 00 00       	call   3c8c <unlink>
    pid = fork();
    16cb:	e8 64 25 00 00       	call   3c34 <fork>
    16d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    16d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16d7:	74 3a                	je     1713 <concreate+0x8a>
    16d9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16dc:	ba 56 55 55 55       	mov    $0x55555556,%edx
    16e1:	89 c8                	mov    %ecx,%eax
    16e3:	f7 ea                	imul   %edx
    16e5:	89 c8                	mov    %ecx,%eax
    16e7:	c1 f8 1f             	sar    $0x1f,%eax
    16ea:	29 c2                	sub    %eax,%edx
    16ec:	89 d0                	mov    %edx,%eax
    16ee:	01 c0                	add    %eax,%eax
    16f0:	01 d0                	add    %edx,%eax
    16f2:	89 ca                	mov    %ecx,%edx
    16f4:	29 c2                	sub    %eax,%edx
    16f6:	83 fa 01             	cmp    $0x1,%edx
    16f9:	75 18                	jne    1713 <concreate+0x8a>
      link("C0", file);
    16fb:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16fe:	89 44 24 04          	mov    %eax,0x4(%esp)
    1702:	c7 04 24 46 49 00 00 	movl   $0x4946,(%esp)
    1709:	e8 8e 25 00 00       	call   3c9c <link>
    170e:	e9 87 00 00 00       	jmp    179a <concreate+0x111>
    } else if(pid == 0 && (i % 5) == 1){
    1713:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1717:	75 3a                	jne    1753 <concreate+0xca>
    1719:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    171c:	ba 67 66 66 66       	mov    $0x66666667,%edx
    1721:	89 c8                	mov    %ecx,%eax
    1723:	f7 ea                	imul   %edx
    1725:	d1 fa                	sar    %edx
    1727:	89 c8                	mov    %ecx,%eax
    1729:	c1 f8 1f             	sar    $0x1f,%eax
    172c:	29 c2                	sub    %eax,%edx
    172e:	89 d0                	mov    %edx,%eax
    1730:	c1 e0 02             	shl    $0x2,%eax
    1733:	01 d0                	add    %edx,%eax
    1735:	89 ca                	mov    %ecx,%edx
    1737:	29 c2                	sub    %eax,%edx
    1739:	83 fa 01             	cmp    $0x1,%edx
    173c:	75 15                	jne    1753 <concreate+0xca>
      link("C0", file);
    173e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1741:	89 44 24 04          	mov    %eax,0x4(%esp)
    1745:	c7 04 24 46 49 00 00 	movl   $0x4946,(%esp)
    174c:	e8 4b 25 00 00       	call   3c9c <link>
    1751:	eb 47                	jmp    179a <concreate+0x111>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1753:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    175a:	00 
    175b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    175e:	89 04 24             	mov    %eax,(%esp)
    1761:	e8 16 25 00 00       	call   3c7c <open>
    1766:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    1769:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    176d:	79 20                	jns    178f <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    176f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1772:	89 44 24 08          	mov    %eax,0x8(%esp)
    1776:	c7 44 24 04 49 49 00 	movl   $0x4949,0x4(%esp)
    177d:	00 
    177e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1785:	e8 3f 26 00 00       	call   3dc9 <printf>
        exit();
    178a:	e8 ad 24 00 00       	call   3c3c <exit>
      }
      close(fd);
    178f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1792:	89 04 24             	mov    %eax,(%esp)
    1795:	e8 ca 24 00 00       	call   3c64 <close>
    }
    if(pid == 0)
    179a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    179e:	75 05                	jne    17a5 <concreate+0x11c>
      exit();
    17a0:	e8 97 24 00 00       	call   3c3c <exit>
    else
      wait();
    17a5:	e8 9a 24 00 00       	call   3c44 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    17aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    17ae:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    17b2:	0f 8e ff fe ff ff    	jle    16b7 <concreate+0x2e>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    17b8:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    17bf:	00 
    17c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17c7:	00 
    17c8:	8d 45 bd             	lea    -0x43(%ebp),%eax
    17cb:	89 04 24             	mov    %eax,(%esp)
    17ce:	e8 c2 22 00 00       	call   3a95 <memset>
  fd = open(".", 0);
    17d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17da:	00 
    17db:	c7 04 24 0b 49 00 00 	movl   $0x490b,(%esp)
    17e2:	e8 95 24 00 00       	call   3c7c <open>
    17e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    17ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    17f1:	e9 a7 00 00 00       	jmp    189d <concreate+0x214>
    if(de.inum == 0)
    17f6:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    17fa:	66 85 c0             	test   %ax,%ax
    17fd:	0f 84 99 00 00 00    	je     189c <concreate+0x213>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1803:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1807:	3c 43                	cmp    $0x43,%al
    1809:	0f 85 8e 00 00 00    	jne    189d <concreate+0x214>
    180f:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1813:	84 c0                	test   %al,%al
    1815:	0f 85 82 00 00 00    	jne    189d <concreate+0x214>
      i = de.name[1] - '0';
    181b:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    181f:	0f be c0             	movsbl %al,%eax
    1822:	83 e8 30             	sub    $0x30,%eax
    1825:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    182c:	78 08                	js     1836 <concreate+0x1ad>
    182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1831:	83 f8 27             	cmp    $0x27,%eax
    1834:	76 23                	jbe    1859 <concreate+0x1d0>
        printf(1, "concreate weird file %s\n", de.name);
    1836:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1839:	83 c0 02             	add    $0x2,%eax
    183c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1840:	c7 44 24 04 65 49 00 	movl   $0x4965,0x4(%esp)
    1847:	00 
    1848:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    184f:	e8 75 25 00 00       	call   3dc9 <printf>
        exit();
    1854:	e8 e3 23 00 00       	call   3c3c <exit>
      }
      if(fa[i]){
    1859:	8d 55 bd             	lea    -0x43(%ebp),%edx
    185c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185f:	01 d0                	add    %edx,%eax
    1861:	0f b6 00             	movzbl (%eax),%eax
    1864:	84 c0                	test   %al,%al
    1866:	74 23                	je     188b <concreate+0x202>
        printf(1, "concreate duplicate file %s\n", de.name);
    1868:	8d 45 ac             	lea    -0x54(%ebp),%eax
    186b:	83 c0 02             	add    $0x2,%eax
    186e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1872:	c7 44 24 04 7e 49 00 	movl   $0x497e,0x4(%esp)
    1879:	00 
    187a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1881:	e8 43 25 00 00       	call   3dc9 <printf>
        exit();
    1886:	e8 b1 23 00 00       	call   3c3c <exit>
      }
      fa[i] = 1;
    188b:	8d 55 bd             	lea    -0x43(%ebp),%edx
    188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1891:	01 d0                	add    %edx,%eax
    1893:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1896:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    189a:	eb 01                	jmp    189d <concreate+0x214>
  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    if(de.inum == 0)
      continue;
    189c:	90                   	nop
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    189d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    18a4:	00 
    18a5:	8d 45 ac             	lea    -0x54(%ebp),%eax
    18a8:	89 44 24 04          	mov    %eax,0x4(%esp)
    18ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18af:	89 04 24             	mov    %eax,(%esp)
    18b2:	e8 9d 23 00 00       	call   3c54 <read>
    18b7:	85 c0                	test   %eax,%eax
    18b9:	0f 8f 37 ff ff ff    	jg     17f6 <concreate+0x16d>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    18bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18c2:	89 04 24             	mov    %eax,(%esp)
    18c5:	e8 9a 23 00 00       	call   3c64 <close>

  if(n != 40){
    18ca:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    18ce:	74 19                	je     18e9 <concreate+0x260>
    printf(1, "concreate not enough files in directory listing\n");
    18d0:	c7 44 24 04 9c 49 00 	movl   $0x499c,0x4(%esp)
    18d7:	00 
    18d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18df:	e8 e5 24 00 00       	call   3dc9 <printf>
    exit();
    18e4:	e8 53 23 00 00       	call   3c3c <exit>
  }

  for(i = 0; i < 40; i++){
    18e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    18f0:	e9 2d 01 00 00       	jmp    1a22 <concreate+0x399>
    file[1] = '0' + i;
    18f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f8:	83 c0 30             	add    $0x30,%eax
    18fb:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    18fe:	e8 31 23 00 00       	call   3c34 <fork>
    1903:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1906:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    190a:	79 19                	jns    1925 <concreate+0x29c>
      printf(1, "fork failed\n");
    190c:	c7 44 24 04 89 45 00 	movl   $0x4589,0x4(%esp)
    1913:	00 
    1914:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    191b:	e8 a9 24 00 00       	call   3dc9 <printf>
      exit();
    1920:	e8 17 23 00 00       	call   3c3c <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1925:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1928:	ba 56 55 55 55       	mov    $0x55555556,%edx
    192d:	89 c8                	mov    %ecx,%eax
    192f:	f7 ea                	imul   %edx
    1931:	89 c8                	mov    %ecx,%eax
    1933:	c1 f8 1f             	sar    $0x1f,%eax
    1936:	29 c2                	sub    %eax,%edx
    1938:	89 d0                	mov    %edx,%eax
    193a:	01 c0                	add    %eax,%eax
    193c:	01 d0                	add    %edx,%eax
    193e:	89 ca                	mov    %ecx,%edx
    1940:	29 c2                	sub    %eax,%edx
    1942:	85 d2                	test   %edx,%edx
    1944:	75 06                	jne    194c <concreate+0x2c3>
    1946:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    194a:	74 28                	je     1974 <concreate+0x2eb>
       ((i % 3) == 1 && pid != 0)){
    194c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    194f:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1954:	89 c8                	mov    %ecx,%eax
    1956:	f7 ea                	imul   %edx
    1958:	89 c8                	mov    %ecx,%eax
    195a:	c1 f8 1f             	sar    $0x1f,%eax
    195d:	29 c2                	sub    %eax,%edx
    195f:	89 d0                	mov    %edx,%eax
    1961:	01 c0                	add    %eax,%eax
    1963:	01 d0                	add    %edx,%eax
    1965:	89 ca                	mov    %ecx,%edx
    1967:	29 c2                	sub    %eax,%edx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1969:	83 fa 01             	cmp    $0x1,%edx
    196c:	75 74                	jne    19e2 <concreate+0x359>
       ((i % 3) == 1 && pid != 0)){
    196e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1972:	74 6e                	je     19e2 <concreate+0x359>
      close(open(file, 0));
    1974:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    197b:	00 
    197c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    197f:	89 04 24             	mov    %eax,(%esp)
    1982:	e8 f5 22 00 00       	call   3c7c <open>
    1987:	89 04 24             	mov    %eax,(%esp)
    198a:	e8 d5 22 00 00       	call   3c64 <close>
      close(open(file, 0));
    198f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1996:	00 
    1997:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    199a:	89 04 24             	mov    %eax,(%esp)
    199d:	e8 da 22 00 00       	call   3c7c <open>
    19a2:	89 04 24             	mov    %eax,(%esp)
    19a5:	e8 ba 22 00 00       	call   3c64 <close>
      close(open(file, 0));
    19aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    19b1:	00 
    19b2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19b5:	89 04 24             	mov    %eax,(%esp)
    19b8:	e8 bf 22 00 00       	call   3c7c <open>
    19bd:	89 04 24             	mov    %eax,(%esp)
    19c0:	e8 9f 22 00 00       	call   3c64 <close>
      close(open(file, 0));
    19c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    19cc:	00 
    19cd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19d0:	89 04 24             	mov    %eax,(%esp)
    19d3:	e8 a4 22 00 00       	call   3c7c <open>
    19d8:	89 04 24             	mov    %eax,(%esp)
    19db:	e8 84 22 00 00       	call   3c64 <close>
    19e0:	eb 2c                	jmp    1a0e <concreate+0x385>
    } else {
      unlink(file);
    19e2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19e5:	89 04 24             	mov    %eax,(%esp)
    19e8:	e8 9f 22 00 00       	call   3c8c <unlink>
      unlink(file);
    19ed:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19f0:	89 04 24             	mov    %eax,(%esp)
    19f3:	e8 94 22 00 00       	call   3c8c <unlink>
      unlink(file);
    19f8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19fb:	89 04 24             	mov    %eax,(%esp)
    19fe:	e8 89 22 00 00       	call   3c8c <unlink>
      unlink(file);
    1a03:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a06:	89 04 24             	mov    %eax,(%esp)
    1a09:	e8 7e 22 00 00       	call   3c8c <unlink>
    }
    if(pid == 0)
    1a0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a12:	75 05                	jne    1a19 <concreate+0x390>
      exit();
    1a14:	e8 23 22 00 00       	call   3c3c <exit>
    else
      wait();
    1a19:	e8 26 22 00 00       	call   3c44 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1a1e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a22:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a26:	0f 8e c9 fe ff ff    	jle    18f5 <concreate+0x26c>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1a2c:	c7 44 24 04 cd 49 00 	movl   $0x49cd,0x4(%esp)
    1a33:	00 
    1a34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a3b:	e8 89 23 00 00       	call   3dc9 <printf>
}
    1a40:	c9                   	leave  
    1a41:	c3                   	ret    

00001a42 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1a42:	55                   	push   %ebp
    1a43:	89 e5                	mov    %esp,%ebp
    1a45:	83 ec 28             	sub    $0x28,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1a48:	c7 44 24 04 db 49 00 	movl   $0x49db,0x4(%esp)
    1a4f:	00 
    1a50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a57:	e8 6d 23 00 00       	call   3dc9 <printf>

  unlink("x");
    1a5c:	c7 04 24 42 45 00 00 	movl   $0x4542,(%esp)
    1a63:	e8 24 22 00 00       	call   3c8c <unlink>
  pid = fork();
    1a68:	e8 c7 21 00 00       	call   3c34 <fork>
    1a6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1a70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a74:	79 19                	jns    1a8f <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1a76:	c7 44 24 04 89 45 00 	movl   $0x4589,0x4(%esp)
    1a7d:	00 
    1a7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a85:	e8 3f 23 00 00       	call   3dc9 <printf>
    exit();
    1a8a:	e8 ad 21 00 00       	call   3c3c <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1a8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a93:	74 07                	je     1a9c <linkunlink+0x5a>
    1a95:	b8 01 00 00 00       	mov    $0x1,%eax
    1a9a:	eb 05                	jmp    1aa1 <linkunlink+0x5f>
    1a9c:	b8 61 00 00 00       	mov    $0x61,%eax
    1aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1aa4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1aab:	e9 8e 00 00 00       	jmp    1b3e <linkunlink+0xfc>
    x = x * 1103515245 + 12345;
    1ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ab3:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1ab9:	05 39 30 00 00       	add    $0x3039,%eax
    1abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1ac1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1ac4:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1ac9:	89 c8                	mov    %ecx,%eax
    1acb:	f7 e2                	mul    %edx
    1acd:	d1 ea                	shr    %edx
    1acf:	89 d0                	mov    %edx,%eax
    1ad1:	01 c0                	add    %eax,%eax
    1ad3:	01 d0                	add    %edx,%eax
    1ad5:	89 ca                	mov    %ecx,%edx
    1ad7:	29 c2                	sub    %eax,%edx
    1ad9:	85 d2                	test   %edx,%edx
    1adb:	75 1e                	jne    1afb <linkunlink+0xb9>
      close(open("x", O_RDWR | O_CREATE));
    1add:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1ae4:	00 
    1ae5:	c7 04 24 42 45 00 00 	movl   $0x4542,(%esp)
    1aec:	e8 8b 21 00 00       	call   3c7c <open>
    1af1:	89 04 24             	mov    %eax,(%esp)
    1af4:	e8 6b 21 00 00       	call   3c64 <close>
    1af9:	eb 3f                	jmp    1b3a <linkunlink+0xf8>
    } else if((x % 3) == 1){
    1afb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1afe:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1b03:	89 c8                	mov    %ecx,%eax
    1b05:	f7 e2                	mul    %edx
    1b07:	d1 ea                	shr    %edx
    1b09:	89 d0                	mov    %edx,%eax
    1b0b:	01 c0                	add    %eax,%eax
    1b0d:	01 d0                	add    %edx,%eax
    1b0f:	89 ca                	mov    %ecx,%edx
    1b11:	29 c2                	sub    %eax,%edx
    1b13:	83 fa 01             	cmp    $0x1,%edx
    1b16:	75 16                	jne    1b2e <linkunlink+0xec>
      link("cat", "x");
    1b18:	c7 44 24 04 42 45 00 	movl   $0x4542,0x4(%esp)
    1b1f:	00 
    1b20:	c7 04 24 ec 49 00 00 	movl   $0x49ec,(%esp)
    1b27:	e8 70 21 00 00       	call   3c9c <link>
    1b2c:	eb 0c                	jmp    1b3a <linkunlink+0xf8>
    } else {
      unlink("x");
    1b2e:	c7 04 24 42 45 00 00 	movl   $0x4542,(%esp)
    1b35:	e8 52 21 00 00       	call   3c8c <unlink>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1b3a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1b3e:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1b42:	0f 8e 68 ff ff ff    	jle    1ab0 <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1b48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b4c:	74 1b                	je     1b69 <linkunlink+0x127>
    wait();
    1b4e:	e8 f1 20 00 00       	call   3c44 <wait>
  else 
    exit();

  printf(1, "linkunlink ok\n");
    1b53:	c7 44 24 04 f0 49 00 	movl   $0x49f0,0x4(%esp)
    1b5a:	00 
    1b5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b62:	e8 62 22 00 00       	call   3dc9 <printf>
    1b67:	eb 05                	jmp    1b6e <linkunlink+0x12c>
  }

  if(pid)
    wait();
  else 
    exit();
    1b69:	e8 ce 20 00 00       	call   3c3c <exit>

  printf(1, "linkunlink ok\n");
}
    1b6e:	c9                   	leave  
    1b6f:	c3                   	ret    

00001b70 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1b70:	55                   	push   %ebp
    1b71:	89 e5                	mov    %esp,%ebp
    1b73:	83 ec 38             	sub    $0x38,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1b76:	c7 44 24 04 ff 49 00 	movl   $0x49ff,0x4(%esp)
    1b7d:	00 
    1b7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b85:	e8 3f 22 00 00       	call   3dc9 <printf>
  unlink("bd");
    1b8a:	c7 04 24 0c 4a 00 00 	movl   $0x4a0c,(%esp)
    1b91:	e8 f6 20 00 00       	call   3c8c <unlink>

  fd = open("bd", O_CREATE);
    1b96:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1b9d:	00 
    1b9e:	c7 04 24 0c 4a 00 00 	movl   $0x4a0c,(%esp)
    1ba5:	e8 d2 20 00 00       	call   3c7c <open>
    1baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1bad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1bb1:	79 19                	jns    1bcc <bigdir+0x5c>
    printf(1, "bigdir create failed\n");
    1bb3:	c7 44 24 04 0f 4a 00 	movl   $0x4a0f,0x4(%esp)
    1bba:	00 
    1bbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bc2:	e8 02 22 00 00       	call   3dc9 <printf>
    exit();
    1bc7:	e8 70 20 00 00       	call   3c3c <exit>
  }
  close(fd);
    1bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1bcf:	89 04 24             	mov    %eax,(%esp)
    1bd2:	e8 8d 20 00 00       	call   3c64 <close>

  for(i = 0; i < 500; i++){
    1bd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1bde:	eb 68                	jmp    1c48 <bigdir+0xd8>
    name[0] = 'x';
    1be0:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1be7:	8d 50 3f             	lea    0x3f(%eax),%edx
    1bea:	85 c0                	test   %eax,%eax
    1bec:	0f 48 c2             	cmovs  %edx,%eax
    1bef:	c1 f8 06             	sar    $0x6,%eax
    1bf2:	83 c0 30             	add    $0x30,%eax
    1bf5:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bfb:	89 c2                	mov    %eax,%edx
    1bfd:	c1 fa 1f             	sar    $0x1f,%edx
    1c00:	c1 ea 1a             	shr    $0x1a,%edx
    1c03:	01 d0                	add    %edx,%eax
    1c05:	83 e0 3f             	and    $0x3f,%eax
    1c08:	29 d0                	sub    %edx,%eax
    1c0a:	83 c0 30             	add    $0x30,%eax
    1c0d:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1c10:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1c14:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1c17:	89 44 24 04          	mov    %eax,0x4(%esp)
    1c1b:	c7 04 24 0c 4a 00 00 	movl   $0x4a0c,(%esp)
    1c22:	e8 75 20 00 00       	call   3c9c <link>
    1c27:	85 c0                	test   %eax,%eax
    1c29:	74 19                	je     1c44 <bigdir+0xd4>
      printf(1, "bigdir link failed\n");
    1c2b:	c7 44 24 04 25 4a 00 	movl   $0x4a25,0x4(%esp)
    1c32:	00 
    1c33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c3a:	e8 8a 21 00 00       	call   3dc9 <printf>
      exit();
    1c3f:	e8 f8 1f 00 00       	call   3c3c <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1c44:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1c48:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1c4f:	7e 8f                	jle    1be0 <bigdir+0x70>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1c51:	c7 04 24 0c 4a 00 00 	movl   $0x4a0c,(%esp)
    1c58:	e8 2f 20 00 00       	call   3c8c <unlink>
  for(i = 0; i < 500; i++){
    1c5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1c64:	eb 60                	jmp    1cc6 <bigdir+0x156>
    name[0] = 'x';
    1c66:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c6d:	8d 50 3f             	lea    0x3f(%eax),%edx
    1c70:	85 c0                	test   %eax,%eax
    1c72:	0f 48 c2             	cmovs  %edx,%eax
    1c75:	c1 f8 06             	sar    $0x6,%eax
    1c78:	83 c0 30             	add    $0x30,%eax
    1c7b:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c81:	89 c2                	mov    %eax,%edx
    1c83:	c1 fa 1f             	sar    $0x1f,%edx
    1c86:	c1 ea 1a             	shr    $0x1a,%edx
    1c89:	01 d0                	add    %edx,%eax
    1c8b:	83 e0 3f             	and    $0x3f,%eax
    1c8e:	29 d0                	sub    %edx,%eax
    1c90:	83 c0 30             	add    $0x30,%eax
    1c93:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1c96:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1c9a:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1c9d:	89 04 24             	mov    %eax,(%esp)
    1ca0:	e8 e7 1f 00 00       	call   3c8c <unlink>
    1ca5:	85 c0                	test   %eax,%eax
    1ca7:	74 19                	je     1cc2 <bigdir+0x152>
      printf(1, "bigdir unlink failed");
    1ca9:	c7 44 24 04 39 4a 00 	movl   $0x4a39,0x4(%esp)
    1cb0:	00 
    1cb1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cb8:	e8 0c 21 00 00       	call   3dc9 <printf>
      exit();
    1cbd:	e8 7a 1f 00 00       	call   3c3c <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1cc2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1cc6:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1ccd:	7e 97                	jle    1c66 <bigdir+0xf6>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1ccf:	c7 44 24 04 4e 4a 00 	movl   $0x4a4e,0x4(%esp)
    1cd6:	00 
    1cd7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cde:	e8 e6 20 00 00       	call   3dc9 <printf>
}
    1ce3:	c9                   	leave  
    1ce4:	c3                   	ret    

00001ce5 <subdir>:

void
subdir(void)
{
    1ce5:	55                   	push   %ebp
    1ce6:	89 e5                	mov    %esp,%ebp
    1ce8:	83 ec 28             	sub    $0x28,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1ceb:	c7 44 24 04 59 4a 00 	movl   $0x4a59,0x4(%esp)
    1cf2:	00 
    1cf3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cfa:	e8 ca 20 00 00       	call   3dc9 <printf>

  unlink("ff");
    1cff:	c7 04 24 66 4a 00 00 	movl   $0x4a66,(%esp)
    1d06:	e8 81 1f 00 00       	call   3c8c <unlink>
  if(mkdir("dd") != 0){
    1d0b:	c7 04 24 69 4a 00 00 	movl   $0x4a69,(%esp)
    1d12:	e8 8d 1f 00 00       	call   3ca4 <mkdir>
    1d17:	85 c0                	test   %eax,%eax
    1d19:	74 19                	je     1d34 <subdir+0x4f>
    printf(1, "subdir mkdir dd failed\n");
    1d1b:	c7 44 24 04 6c 4a 00 	movl   $0x4a6c,0x4(%esp)
    1d22:	00 
    1d23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d2a:	e8 9a 20 00 00       	call   3dc9 <printf>
    exit();
    1d2f:	e8 08 1f 00 00       	call   3c3c <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1d34:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d3b:	00 
    1d3c:	c7 04 24 84 4a 00 00 	movl   $0x4a84,(%esp)
    1d43:	e8 34 1f 00 00       	call   3c7c <open>
    1d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1d4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1d4f:	79 19                	jns    1d6a <subdir+0x85>
    printf(1, "create dd/ff failed\n");
    1d51:	c7 44 24 04 8a 4a 00 	movl   $0x4a8a,0x4(%esp)
    1d58:	00 
    1d59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d60:	e8 64 20 00 00       	call   3dc9 <printf>
    exit();
    1d65:	e8 d2 1e 00 00       	call   3c3c <exit>
  }
  write(fd, "ff", 2);
    1d6a:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1d71:	00 
    1d72:	c7 44 24 04 66 4a 00 	movl   $0x4a66,0x4(%esp)
    1d79:	00 
    1d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d7d:	89 04 24             	mov    %eax,(%esp)
    1d80:	e8 d7 1e 00 00       	call   3c5c <write>
  close(fd);
    1d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d88:	89 04 24             	mov    %eax,(%esp)
    1d8b:	e8 d4 1e 00 00       	call   3c64 <close>
  
  if(unlink("dd") >= 0){
    1d90:	c7 04 24 69 4a 00 00 	movl   $0x4a69,(%esp)
    1d97:	e8 f0 1e 00 00       	call   3c8c <unlink>
    1d9c:	85 c0                	test   %eax,%eax
    1d9e:	78 19                	js     1db9 <subdir+0xd4>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1da0:	c7 44 24 04 a0 4a 00 	movl   $0x4aa0,0x4(%esp)
    1da7:	00 
    1da8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1daf:	e8 15 20 00 00       	call   3dc9 <printf>
    exit();
    1db4:	e8 83 1e 00 00       	call   3c3c <exit>
  }

  if(mkdir("/dd/dd") != 0){
    1db9:	c7 04 24 c6 4a 00 00 	movl   $0x4ac6,(%esp)
    1dc0:	e8 df 1e 00 00       	call   3ca4 <mkdir>
    1dc5:	85 c0                	test   %eax,%eax
    1dc7:	74 19                	je     1de2 <subdir+0xfd>
    printf(1, "subdir mkdir dd/dd failed\n");
    1dc9:	c7 44 24 04 cd 4a 00 	movl   $0x4acd,0x4(%esp)
    1dd0:	00 
    1dd1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1dd8:	e8 ec 1f 00 00       	call   3dc9 <printf>
    exit();
    1ddd:	e8 5a 1e 00 00       	call   3c3c <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1de2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1de9:	00 
    1dea:	c7 04 24 e8 4a 00 00 	movl   $0x4ae8,(%esp)
    1df1:	e8 86 1e 00 00       	call   3c7c <open>
    1df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1df9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1dfd:	79 19                	jns    1e18 <subdir+0x133>
    printf(1, "create dd/dd/ff failed\n");
    1dff:	c7 44 24 04 f1 4a 00 	movl   $0x4af1,0x4(%esp)
    1e06:	00 
    1e07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e0e:	e8 b6 1f 00 00       	call   3dc9 <printf>
    exit();
    1e13:	e8 24 1e 00 00       	call   3c3c <exit>
  }
  write(fd, "FF", 2);
    1e18:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1e1f:	00 
    1e20:	c7 44 24 04 09 4b 00 	movl   $0x4b09,0x4(%esp)
    1e27:	00 
    1e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e2b:	89 04 24             	mov    %eax,(%esp)
    1e2e:	e8 29 1e 00 00       	call   3c5c <write>
  close(fd);
    1e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e36:	89 04 24             	mov    %eax,(%esp)
    1e39:	e8 26 1e 00 00       	call   3c64 <close>

  fd = open("dd/dd/../ff", 0);
    1e3e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1e45:	00 
    1e46:	c7 04 24 0c 4b 00 00 	movl   $0x4b0c,(%esp)
    1e4d:	e8 2a 1e 00 00       	call   3c7c <open>
    1e52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1e55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1e59:	79 19                	jns    1e74 <subdir+0x18f>
    printf(1, "open dd/dd/../ff failed\n");
    1e5b:	c7 44 24 04 18 4b 00 	movl   $0x4b18,0x4(%esp)
    1e62:	00 
    1e63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e6a:	e8 5a 1f 00 00       	call   3dc9 <printf>
    exit();
    1e6f:	e8 c8 1d 00 00       	call   3c3c <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    1e74:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1e7b:	00 
    1e7c:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
    1e83:	00 
    1e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e87:	89 04 24             	mov    %eax,(%esp)
    1e8a:	e8 c5 1d 00 00       	call   3c54 <read>
    1e8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    1e92:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    1e96:	75 0b                	jne    1ea3 <subdir+0x1be>
    1e98:	0f b6 05 e0 86 00 00 	movzbl 0x86e0,%eax
    1e9f:	3c 66                	cmp    $0x66,%al
    1ea1:	74 19                	je     1ebc <subdir+0x1d7>
    printf(1, "dd/dd/../ff wrong content\n");
    1ea3:	c7 44 24 04 31 4b 00 	movl   $0x4b31,0x4(%esp)
    1eaa:	00 
    1eab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1eb2:	e8 12 1f 00 00       	call   3dc9 <printf>
    exit();
    1eb7:	e8 80 1d 00 00       	call   3c3c <exit>
  }
  close(fd);
    1ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ebf:	89 04 24             	mov    %eax,(%esp)
    1ec2:	e8 9d 1d 00 00       	call   3c64 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1ec7:	c7 44 24 04 4c 4b 00 	movl   $0x4b4c,0x4(%esp)
    1ece:	00 
    1ecf:	c7 04 24 e8 4a 00 00 	movl   $0x4ae8,(%esp)
    1ed6:	e8 c1 1d 00 00       	call   3c9c <link>
    1edb:	85 c0                	test   %eax,%eax
    1edd:	74 19                	je     1ef8 <subdir+0x213>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    1edf:	c7 44 24 04 58 4b 00 	movl   $0x4b58,0x4(%esp)
    1ee6:	00 
    1ee7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1eee:	e8 d6 1e 00 00       	call   3dc9 <printf>
    exit();
    1ef3:	e8 44 1d 00 00       	call   3c3c <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    1ef8:	c7 04 24 e8 4a 00 00 	movl   $0x4ae8,(%esp)
    1eff:	e8 88 1d 00 00       	call   3c8c <unlink>
    1f04:	85 c0                	test   %eax,%eax
    1f06:	74 19                	je     1f21 <subdir+0x23c>
    printf(1, "unlink dd/dd/ff failed\n");
    1f08:	c7 44 24 04 79 4b 00 	movl   $0x4b79,0x4(%esp)
    1f0f:	00 
    1f10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f17:	e8 ad 1e 00 00       	call   3dc9 <printf>
    exit();
    1f1c:	e8 1b 1d 00 00       	call   3c3c <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1f21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1f28:	00 
    1f29:	c7 04 24 e8 4a 00 00 	movl   $0x4ae8,(%esp)
    1f30:	e8 47 1d 00 00       	call   3c7c <open>
    1f35:	85 c0                	test   %eax,%eax
    1f37:	78 19                	js     1f52 <subdir+0x26d>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    1f39:	c7 44 24 04 94 4b 00 	movl   $0x4b94,0x4(%esp)
    1f40:	00 
    1f41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f48:	e8 7c 1e 00 00       	call   3dc9 <printf>
    exit();
    1f4d:	e8 ea 1c 00 00       	call   3c3c <exit>
  }

  if(chdir("dd") != 0){
    1f52:	c7 04 24 69 4a 00 00 	movl   $0x4a69,(%esp)
    1f59:	e8 4e 1d 00 00       	call   3cac <chdir>
    1f5e:	85 c0                	test   %eax,%eax
    1f60:	74 19                	je     1f7b <subdir+0x296>
    printf(1, "chdir dd failed\n");
    1f62:	c7 44 24 04 b8 4b 00 	movl   $0x4bb8,0x4(%esp)
    1f69:	00 
    1f6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f71:	e8 53 1e 00 00       	call   3dc9 <printf>
    exit();
    1f76:	e8 c1 1c 00 00       	call   3c3c <exit>
  }
  if(chdir("dd/../../dd") != 0){
    1f7b:	c7 04 24 c9 4b 00 00 	movl   $0x4bc9,(%esp)
    1f82:	e8 25 1d 00 00       	call   3cac <chdir>
    1f87:	85 c0                	test   %eax,%eax
    1f89:	74 19                	je     1fa4 <subdir+0x2bf>
    printf(1, "chdir dd/../../dd failed\n");
    1f8b:	c7 44 24 04 d5 4b 00 	movl   $0x4bd5,0x4(%esp)
    1f92:	00 
    1f93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f9a:	e8 2a 1e 00 00       	call   3dc9 <printf>
    exit();
    1f9f:	e8 98 1c 00 00       	call   3c3c <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    1fa4:	c7 04 24 ef 4b 00 00 	movl   $0x4bef,(%esp)
    1fab:	e8 fc 1c 00 00       	call   3cac <chdir>
    1fb0:	85 c0                	test   %eax,%eax
    1fb2:	74 19                	je     1fcd <subdir+0x2e8>
    printf(1, "chdir dd/../../dd failed\n");
    1fb4:	c7 44 24 04 d5 4b 00 	movl   $0x4bd5,0x4(%esp)
    1fbb:	00 
    1fbc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fc3:	e8 01 1e 00 00       	call   3dc9 <printf>
    exit();
    1fc8:	e8 6f 1c 00 00       	call   3c3c <exit>
  }
  if(chdir("./..") != 0){
    1fcd:	c7 04 24 fe 4b 00 00 	movl   $0x4bfe,(%esp)
    1fd4:	e8 d3 1c 00 00       	call   3cac <chdir>
    1fd9:	85 c0                	test   %eax,%eax
    1fdb:	74 19                	je     1ff6 <subdir+0x311>
    printf(1, "chdir ./.. failed\n");
    1fdd:	c7 44 24 04 03 4c 00 	movl   $0x4c03,0x4(%esp)
    1fe4:	00 
    1fe5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fec:	e8 d8 1d 00 00       	call   3dc9 <printf>
    exit();
    1ff1:	e8 46 1c 00 00       	call   3c3c <exit>
  }

  fd = open("dd/dd/ffff", 0);
    1ff6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1ffd:	00 
    1ffe:	c7 04 24 4c 4b 00 00 	movl   $0x4b4c,(%esp)
    2005:	e8 72 1c 00 00       	call   3c7c <open>
    200a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    200d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2011:	79 19                	jns    202c <subdir+0x347>
    printf(1, "open dd/dd/ffff failed\n");
    2013:	c7 44 24 04 16 4c 00 	movl   $0x4c16,0x4(%esp)
    201a:	00 
    201b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2022:	e8 a2 1d 00 00       	call   3dc9 <printf>
    exit();
    2027:	e8 10 1c 00 00       	call   3c3c <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    202c:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2033:	00 
    2034:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
    203b:	00 
    203c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    203f:	89 04 24             	mov    %eax,(%esp)
    2042:	e8 0d 1c 00 00       	call   3c54 <read>
    2047:	83 f8 02             	cmp    $0x2,%eax
    204a:	74 19                	je     2065 <subdir+0x380>
    printf(1, "read dd/dd/ffff wrong len\n");
    204c:	c7 44 24 04 2e 4c 00 	movl   $0x4c2e,0x4(%esp)
    2053:	00 
    2054:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    205b:	e8 69 1d 00 00       	call   3dc9 <printf>
    exit();
    2060:	e8 d7 1b 00 00       	call   3c3c <exit>
  }
  close(fd);
    2065:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2068:	89 04 24             	mov    %eax,(%esp)
    206b:	e8 f4 1b 00 00       	call   3c64 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2070:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2077:	00 
    2078:	c7 04 24 e8 4a 00 00 	movl   $0x4ae8,(%esp)
    207f:	e8 f8 1b 00 00       	call   3c7c <open>
    2084:	85 c0                	test   %eax,%eax
    2086:	78 19                	js     20a1 <subdir+0x3bc>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2088:	c7 44 24 04 4c 4c 00 	movl   $0x4c4c,0x4(%esp)
    208f:	00 
    2090:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2097:	e8 2d 1d 00 00       	call   3dc9 <printf>
    exit();
    209c:	e8 9b 1b 00 00       	call   3c3c <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    20a1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    20a8:	00 
    20a9:	c7 04 24 71 4c 00 00 	movl   $0x4c71,(%esp)
    20b0:	e8 c7 1b 00 00       	call   3c7c <open>
    20b5:	85 c0                	test   %eax,%eax
    20b7:	78 19                	js     20d2 <subdir+0x3ed>
    printf(1, "create dd/ff/ff succeeded!\n");
    20b9:	c7 44 24 04 7a 4c 00 	movl   $0x4c7a,0x4(%esp)
    20c0:	00 
    20c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20c8:	e8 fc 1c 00 00       	call   3dc9 <printf>
    exit();
    20cd:	e8 6a 1b 00 00       	call   3c3c <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    20d2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    20d9:	00 
    20da:	c7 04 24 96 4c 00 00 	movl   $0x4c96,(%esp)
    20e1:	e8 96 1b 00 00       	call   3c7c <open>
    20e6:	85 c0                	test   %eax,%eax
    20e8:	78 19                	js     2103 <subdir+0x41e>
    printf(1, "create dd/xx/ff succeeded!\n");
    20ea:	c7 44 24 04 9f 4c 00 	movl   $0x4c9f,0x4(%esp)
    20f1:	00 
    20f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20f9:	e8 cb 1c 00 00       	call   3dc9 <printf>
    exit();
    20fe:	e8 39 1b 00 00       	call   3c3c <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    2103:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    210a:	00 
    210b:	c7 04 24 69 4a 00 00 	movl   $0x4a69,(%esp)
    2112:	e8 65 1b 00 00       	call   3c7c <open>
    2117:	85 c0                	test   %eax,%eax
    2119:	78 19                	js     2134 <subdir+0x44f>
    printf(1, "create dd succeeded!\n");
    211b:	c7 44 24 04 bb 4c 00 	movl   $0x4cbb,0x4(%esp)
    2122:	00 
    2123:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    212a:	e8 9a 1c 00 00       	call   3dc9 <printf>
    exit();
    212f:	e8 08 1b 00 00       	call   3c3c <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    2134:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    213b:	00 
    213c:	c7 04 24 69 4a 00 00 	movl   $0x4a69,(%esp)
    2143:	e8 34 1b 00 00       	call   3c7c <open>
    2148:	85 c0                	test   %eax,%eax
    214a:	78 19                	js     2165 <subdir+0x480>
    printf(1, "open dd rdwr succeeded!\n");
    214c:	c7 44 24 04 d1 4c 00 	movl   $0x4cd1,0x4(%esp)
    2153:	00 
    2154:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    215b:	e8 69 1c 00 00       	call   3dc9 <printf>
    exit();
    2160:	e8 d7 1a 00 00       	call   3c3c <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    2165:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    216c:	00 
    216d:	c7 04 24 69 4a 00 00 	movl   $0x4a69,(%esp)
    2174:	e8 03 1b 00 00       	call   3c7c <open>
    2179:	85 c0                	test   %eax,%eax
    217b:	78 19                	js     2196 <subdir+0x4b1>
    printf(1, "open dd wronly succeeded!\n");
    217d:	c7 44 24 04 ea 4c 00 	movl   $0x4cea,0x4(%esp)
    2184:	00 
    2185:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    218c:	e8 38 1c 00 00       	call   3dc9 <printf>
    exit();
    2191:	e8 a6 1a 00 00       	call   3c3c <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2196:	c7 44 24 04 05 4d 00 	movl   $0x4d05,0x4(%esp)
    219d:	00 
    219e:	c7 04 24 71 4c 00 00 	movl   $0x4c71,(%esp)
    21a5:	e8 f2 1a 00 00       	call   3c9c <link>
    21aa:	85 c0                	test   %eax,%eax
    21ac:	75 19                	jne    21c7 <subdir+0x4e2>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    21ae:	c7 44 24 04 10 4d 00 	movl   $0x4d10,0x4(%esp)
    21b5:	00 
    21b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21bd:	e8 07 1c 00 00       	call   3dc9 <printf>
    exit();
    21c2:	e8 75 1a 00 00       	call   3c3c <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    21c7:	c7 44 24 04 05 4d 00 	movl   $0x4d05,0x4(%esp)
    21ce:	00 
    21cf:	c7 04 24 96 4c 00 00 	movl   $0x4c96,(%esp)
    21d6:	e8 c1 1a 00 00       	call   3c9c <link>
    21db:	85 c0                	test   %eax,%eax
    21dd:	75 19                	jne    21f8 <subdir+0x513>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    21df:	c7 44 24 04 34 4d 00 	movl   $0x4d34,0x4(%esp)
    21e6:	00 
    21e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21ee:	e8 d6 1b 00 00       	call   3dc9 <printf>
    exit();
    21f3:	e8 44 1a 00 00       	call   3c3c <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    21f8:	c7 44 24 04 4c 4b 00 	movl   $0x4b4c,0x4(%esp)
    21ff:	00 
    2200:	c7 04 24 84 4a 00 00 	movl   $0x4a84,(%esp)
    2207:	e8 90 1a 00 00       	call   3c9c <link>
    220c:	85 c0                	test   %eax,%eax
    220e:	75 19                	jne    2229 <subdir+0x544>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2210:	c7 44 24 04 58 4d 00 	movl   $0x4d58,0x4(%esp)
    2217:	00 
    2218:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    221f:	e8 a5 1b 00 00       	call   3dc9 <printf>
    exit();
    2224:	e8 13 1a 00 00       	call   3c3c <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    2229:	c7 04 24 71 4c 00 00 	movl   $0x4c71,(%esp)
    2230:	e8 6f 1a 00 00       	call   3ca4 <mkdir>
    2235:	85 c0                	test   %eax,%eax
    2237:	75 19                	jne    2252 <subdir+0x56d>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    2239:	c7 44 24 04 7a 4d 00 	movl   $0x4d7a,0x4(%esp)
    2240:	00 
    2241:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2248:	e8 7c 1b 00 00       	call   3dc9 <printf>
    exit();
    224d:	e8 ea 19 00 00       	call   3c3c <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    2252:	c7 04 24 96 4c 00 00 	movl   $0x4c96,(%esp)
    2259:	e8 46 1a 00 00       	call   3ca4 <mkdir>
    225e:	85 c0                	test   %eax,%eax
    2260:	75 19                	jne    227b <subdir+0x596>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2262:	c7 44 24 04 95 4d 00 	movl   $0x4d95,0x4(%esp)
    2269:	00 
    226a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2271:	e8 53 1b 00 00       	call   3dc9 <printf>
    exit();
    2276:	e8 c1 19 00 00       	call   3c3c <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    227b:	c7 04 24 4c 4b 00 00 	movl   $0x4b4c,(%esp)
    2282:	e8 1d 1a 00 00       	call   3ca4 <mkdir>
    2287:	85 c0                	test   %eax,%eax
    2289:	75 19                	jne    22a4 <subdir+0x5bf>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    228b:	c7 44 24 04 b0 4d 00 	movl   $0x4db0,0x4(%esp)
    2292:	00 
    2293:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    229a:	e8 2a 1b 00 00       	call   3dc9 <printf>
    exit();
    229f:	e8 98 19 00 00       	call   3c3c <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    22a4:	c7 04 24 96 4c 00 00 	movl   $0x4c96,(%esp)
    22ab:	e8 dc 19 00 00       	call   3c8c <unlink>
    22b0:	85 c0                	test   %eax,%eax
    22b2:	75 19                	jne    22cd <subdir+0x5e8>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    22b4:	c7 44 24 04 cd 4d 00 	movl   $0x4dcd,0x4(%esp)
    22bb:	00 
    22bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22c3:	e8 01 1b 00 00       	call   3dc9 <printf>
    exit();
    22c8:	e8 6f 19 00 00       	call   3c3c <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    22cd:	c7 04 24 71 4c 00 00 	movl   $0x4c71,(%esp)
    22d4:	e8 b3 19 00 00       	call   3c8c <unlink>
    22d9:	85 c0                	test   %eax,%eax
    22db:	75 19                	jne    22f6 <subdir+0x611>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    22dd:	c7 44 24 04 e9 4d 00 	movl   $0x4de9,0x4(%esp)
    22e4:	00 
    22e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22ec:	e8 d8 1a 00 00       	call   3dc9 <printf>
    exit();
    22f1:	e8 46 19 00 00       	call   3c3c <exit>
  }
  if(chdir("dd/ff") == 0){
    22f6:	c7 04 24 84 4a 00 00 	movl   $0x4a84,(%esp)
    22fd:	e8 aa 19 00 00       	call   3cac <chdir>
    2302:	85 c0                	test   %eax,%eax
    2304:	75 19                	jne    231f <subdir+0x63a>
    printf(1, "chdir dd/ff succeeded!\n");
    2306:	c7 44 24 04 05 4e 00 	movl   $0x4e05,0x4(%esp)
    230d:	00 
    230e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2315:	e8 af 1a 00 00       	call   3dc9 <printf>
    exit();
    231a:	e8 1d 19 00 00       	call   3c3c <exit>
  }
  if(chdir("dd/xx") == 0){
    231f:	c7 04 24 1d 4e 00 00 	movl   $0x4e1d,(%esp)
    2326:	e8 81 19 00 00       	call   3cac <chdir>
    232b:	85 c0                	test   %eax,%eax
    232d:	75 19                	jne    2348 <subdir+0x663>
    printf(1, "chdir dd/xx succeeded!\n");
    232f:	c7 44 24 04 23 4e 00 	movl   $0x4e23,0x4(%esp)
    2336:	00 
    2337:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    233e:	e8 86 1a 00 00       	call   3dc9 <printf>
    exit();
    2343:	e8 f4 18 00 00       	call   3c3c <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    2348:	c7 04 24 4c 4b 00 00 	movl   $0x4b4c,(%esp)
    234f:	e8 38 19 00 00       	call   3c8c <unlink>
    2354:	85 c0                	test   %eax,%eax
    2356:	74 19                	je     2371 <subdir+0x68c>
    printf(1, "unlink dd/dd/ff failed\n");
    2358:	c7 44 24 04 79 4b 00 	movl   $0x4b79,0x4(%esp)
    235f:	00 
    2360:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2367:	e8 5d 1a 00 00       	call   3dc9 <printf>
    exit();
    236c:	e8 cb 18 00 00       	call   3c3c <exit>
  }
  if(unlink("dd/ff") != 0){
    2371:	c7 04 24 84 4a 00 00 	movl   $0x4a84,(%esp)
    2378:	e8 0f 19 00 00       	call   3c8c <unlink>
    237d:	85 c0                	test   %eax,%eax
    237f:	74 19                	je     239a <subdir+0x6b5>
    printf(1, "unlink dd/ff failed\n");
    2381:	c7 44 24 04 3b 4e 00 	movl   $0x4e3b,0x4(%esp)
    2388:	00 
    2389:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2390:	e8 34 1a 00 00       	call   3dc9 <printf>
    exit();
    2395:	e8 a2 18 00 00       	call   3c3c <exit>
  }
  if(unlink("dd") == 0){
    239a:	c7 04 24 69 4a 00 00 	movl   $0x4a69,(%esp)
    23a1:	e8 e6 18 00 00       	call   3c8c <unlink>
    23a6:	85 c0                	test   %eax,%eax
    23a8:	75 19                	jne    23c3 <subdir+0x6de>
    printf(1, "unlink non-empty dd succeeded!\n");
    23aa:	c7 44 24 04 50 4e 00 	movl   $0x4e50,0x4(%esp)
    23b1:	00 
    23b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23b9:	e8 0b 1a 00 00       	call   3dc9 <printf>
    exit();
    23be:	e8 79 18 00 00       	call   3c3c <exit>
  }
  if(unlink("dd/dd") < 0){
    23c3:	c7 04 24 70 4e 00 00 	movl   $0x4e70,(%esp)
    23ca:	e8 bd 18 00 00       	call   3c8c <unlink>
    23cf:	85 c0                	test   %eax,%eax
    23d1:	79 19                	jns    23ec <subdir+0x707>
    printf(1, "unlink dd/dd failed\n");
    23d3:	c7 44 24 04 76 4e 00 	movl   $0x4e76,0x4(%esp)
    23da:	00 
    23db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23e2:	e8 e2 19 00 00       	call   3dc9 <printf>
    exit();
    23e7:	e8 50 18 00 00       	call   3c3c <exit>
  }
  if(unlink("dd") < 0){
    23ec:	c7 04 24 69 4a 00 00 	movl   $0x4a69,(%esp)
    23f3:	e8 94 18 00 00       	call   3c8c <unlink>
    23f8:	85 c0                	test   %eax,%eax
    23fa:	79 19                	jns    2415 <subdir+0x730>
    printf(1, "unlink dd failed\n");
    23fc:	c7 44 24 04 8b 4e 00 	movl   $0x4e8b,0x4(%esp)
    2403:	00 
    2404:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    240b:	e8 b9 19 00 00       	call   3dc9 <printf>
    exit();
    2410:	e8 27 18 00 00       	call   3c3c <exit>
  }

  printf(1, "subdir ok\n");
    2415:	c7 44 24 04 9d 4e 00 	movl   $0x4e9d,0x4(%esp)
    241c:	00 
    241d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2424:	e8 a0 19 00 00       	call   3dc9 <printf>
}
    2429:	c9                   	leave  
    242a:	c3                   	ret    

0000242b <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    242b:	55                   	push   %ebp
    242c:	89 e5                	mov    %esp,%ebp
    242e:	83 ec 28             	sub    $0x28,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    2431:	c7 44 24 04 a8 4e 00 	movl   $0x4ea8,0x4(%esp)
    2438:	00 
    2439:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2440:	e8 84 19 00 00       	call   3dc9 <printf>

  unlink("bigwrite");
    2445:	c7 04 24 b7 4e 00 00 	movl   $0x4eb7,(%esp)
    244c:	e8 3b 18 00 00       	call   3c8c <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    2451:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    2458:	e9 b3 00 00 00       	jmp    2510 <bigwrite+0xe5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    245d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2464:	00 
    2465:	c7 04 24 b7 4e 00 00 	movl   $0x4eb7,(%esp)
    246c:	e8 0b 18 00 00       	call   3c7c <open>
    2471:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    2474:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2478:	79 19                	jns    2493 <bigwrite+0x68>
      printf(1, "cannot create bigwrite\n");
    247a:	c7 44 24 04 c0 4e 00 	movl   $0x4ec0,0x4(%esp)
    2481:	00 
    2482:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2489:	e8 3b 19 00 00       	call   3dc9 <printf>
      exit();
    248e:	e8 a9 17 00 00       	call   3c3c <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    2493:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    249a:	eb 50                	jmp    24ec <bigwrite+0xc1>
      int cc = write(fd, buf, sz);
    249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    249f:	89 44 24 08          	mov    %eax,0x8(%esp)
    24a3:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
    24aa:	00 
    24ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
    24ae:	89 04 24             	mov    %eax,(%esp)
    24b1:	e8 a6 17 00 00       	call   3c5c <write>
    24b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    24b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    24bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    24bf:	74 27                	je     24e8 <bigwrite+0xbd>
        printf(1, "write(%d) ret %d\n", sz, cc);
    24c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    24c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
    24c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24cb:	89 44 24 08          	mov    %eax,0x8(%esp)
    24cf:	c7 44 24 04 d8 4e 00 	movl   $0x4ed8,0x4(%esp)
    24d6:	00 
    24d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24de:	e8 e6 18 00 00       	call   3dc9 <printf>
        exit();
    24e3:	e8 54 17 00 00       	call   3c3c <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    24e8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    24ec:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    24f0:	7e aa                	jle    249c <bigwrite+0x71>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    24f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    24f5:	89 04 24             	mov    %eax,(%esp)
    24f8:	e8 67 17 00 00       	call   3c64 <close>
    unlink("bigwrite");
    24fd:	c7 04 24 b7 4e 00 00 	movl   $0x4eb7,(%esp)
    2504:	e8 83 17 00 00       	call   3c8c <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    2509:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    2510:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    2517:	0f 8e 40 ff ff ff    	jle    245d <bigwrite+0x32>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    251d:	c7 44 24 04 ea 4e 00 	movl   $0x4eea,0x4(%esp)
    2524:	00 
    2525:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    252c:	e8 98 18 00 00       	call   3dc9 <printf>
}
    2531:	c9                   	leave  
    2532:	c3                   	ret    

00002533 <bigfile>:

void
bigfile(void)
{
    2533:	55                   	push   %ebp
    2534:	89 e5                	mov    %esp,%ebp
    2536:	83 ec 28             	sub    $0x28,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    2539:	c7 44 24 04 f7 4e 00 	movl   $0x4ef7,0x4(%esp)
    2540:	00 
    2541:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2548:	e8 7c 18 00 00       	call   3dc9 <printf>

  unlink("bigfile");
    254d:	c7 04 24 05 4f 00 00 	movl   $0x4f05,(%esp)
    2554:	e8 33 17 00 00       	call   3c8c <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2559:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2560:	00 
    2561:	c7 04 24 05 4f 00 00 	movl   $0x4f05,(%esp)
    2568:	e8 0f 17 00 00       	call   3c7c <open>
    256d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    2570:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2574:	79 19                	jns    258f <bigfile+0x5c>
    printf(1, "cannot create bigfile");
    2576:	c7 44 24 04 0d 4f 00 	movl   $0x4f0d,0x4(%esp)
    257d:	00 
    257e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2585:	e8 3f 18 00 00       	call   3dc9 <printf>
    exit();
    258a:	e8 ad 16 00 00       	call   3c3c <exit>
  }
  for(i = 0; i < 20; i++){
    258f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2596:	eb 5a                	jmp    25f2 <bigfile+0xbf>
    memset(buf, i, 600);
    2598:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    259f:	00 
    25a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    25a3:	89 44 24 04          	mov    %eax,0x4(%esp)
    25a7:	c7 04 24 e0 86 00 00 	movl   $0x86e0,(%esp)
    25ae:	e8 e2 14 00 00       	call   3a95 <memset>
    if(write(fd, buf, 600) != 600){
    25b3:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    25ba:	00 
    25bb:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
    25c2:	00 
    25c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    25c6:	89 04 24             	mov    %eax,(%esp)
    25c9:	e8 8e 16 00 00       	call   3c5c <write>
    25ce:	3d 58 02 00 00       	cmp    $0x258,%eax
    25d3:	74 19                	je     25ee <bigfile+0xbb>
      printf(1, "write bigfile failed\n");
    25d5:	c7 44 24 04 23 4f 00 	movl   $0x4f23,0x4(%esp)
    25dc:	00 
    25dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25e4:	e8 e0 17 00 00       	call   3dc9 <printf>
      exit();
    25e9:	e8 4e 16 00 00       	call   3c3c <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    25ee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    25f2:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    25f6:	7e a0                	jle    2598 <bigfile+0x65>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    25f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    25fb:	89 04 24             	mov    %eax,(%esp)
    25fe:	e8 61 16 00 00       	call   3c64 <close>

  fd = open("bigfile", 0);
    2603:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    260a:	00 
    260b:	c7 04 24 05 4f 00 00 	movl   $0x4f05,(%esp)
    2612:	e8 65 16 00 00       	call   3c7c <open>
    2617:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    261a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    261e:	79 19                	jns    2639 <bigfile+0x106>
    printf(1, "cannot open bigfile\n");
    2620:	c7 44 24 04 39 4f 00 	movl   $0x4f39,0x4(%esp)
    2627:	00 
    2628:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    262f:	e8 95 17 00 00       	call   3dc9 <printf>
    exit();
    2634:	e8 03 16 00 00       	call   3c3c <exit>
  }
  total = 0;
    2639:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    2640:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    2647:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    264e:	00 
    264f:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
    2656:	00 
    2657:	8b 45 ec             	mov    -0x14(%ebp),%eax
    265a:	89 04 24             	mov    %eax,(%esp)
    265d:	e8 f2 15 00 00       	call   3c54 <read>
    2662:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    2665:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2669:	79 19                	jns    2684 <bigfile+0x151>
      printf(1, "read bigfile failed\n");
    266b:	c7 44 24 04 4e 4f 00 	movl   $0x4f4e,0x4(%esp)
    2672:	00 
    2673:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    267a:	e8 4a 17 00 00       	call   3dc9 <printf>
      exit();
    267f:	e8 b8 15 00 00       	call   3c3c <exit>
    }
    if(cc == 0)
    2684:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2688:	74 7e                	je     2708 <bigfile+0x1d5>
      break;
    if(cc != 300){
    268a:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    2691:	74 19                	je     26ac <bigfile+0x179>
      printf(1, "short read bigfile\n");
    2693:	c7 44 24 04 63 4f 00 	movl   $0x4f63,0x4(%esp)
    269a:	00 
    269b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26a2:	e8 22 17 00 00       	call   3dc9 <printf>
      exit();
    26a7:	e8 90 15 00 00       	call   3c3c <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    26ac:	0f b6 05 e0 86 00 00 	movzbl 0x86e0,%eax
    26b3:	0f be d0             	movsbl %al,%edx
    26b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26b9:	89 c1                	mov    %eax,%ecx
    26bb:	c1 e9 1f             	shr    $0x1f,%ecx
    26be:	01 c8                	add    %ecx,%eax
    26c0:	d1 f8                	sar    %eax
    26c2:	39 c2                	cmp    %eax,%edx
    26c4:	75 1a                	jne    26e0 <bigfile+0x1ad>
    26c6:	0f b6 05 0b 88 00 00 	movzbl 0x880b,%eax
    26cd:	0f be d0             	movsbl %al,%edx
    26d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26d3:	89 c1                	mov    %eax,%ecx
    26d5:	c1 e9 1f             	shr    $0x1f,%ecx
    26d8:	01 c8                	add    %ecx,%eax
    26da:	d1 f8                	sar    %eax
    26dc:	39 c2                	cmp    %eax,%edx
    26de:	74 19                	je     26f9 <bigfile+0x1c6>
      printf(1, "read bigfile wrong data\n");
    26e0:	c7 44 24 04 77 4f 00 	movl   $0x4f77,0x4(%esp)
    26e7:	00 
    26e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26ef:	e8 d5 16 00 00       	call   3dc9 <printf>
      exit();
    26f4:	e8 43 15 00 00       	call   3c3c <exit>
    }
    total += cc;
    26f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    26fc:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    26ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    2703:	e9 3f ff ff ff       	jmp    2647 <bigfile+0x114>
    if(cc < 0){
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    2708:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    2709:	8b 45 ec             	mov    -0x14(%ebp),%eax
    270c:	89 04 24             	mov    %eax,(%esp)
    270f:	e8 50 15 00 00       	call   3c64 <close>
  if(total != 20*600){
    2714:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    271b:	74 19                	je     2736 <bigfile+0x203>
    printf(1, "read bigfile wrong total\n");
    271d:	c7 44 24 04 90 4f 00 	movl   $0x4f90,0x4(%esp)
    2724:	00 
    2725:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    272c:	e8 98 16 00 00       	call   3dc9 <printf>
    exit();
    2731:	e8 06 15 00 00       	call   3c3c <exit>
  }
  unlink("bigfile");
    2736:	c7 04 24 05 4f 00 00 	movl   $0x4f05,(%esp)
    273d:	e8 4a 15 00 00       	call   3c8c <unlink>

  printf(1, "bigfile test ok\n");
    2742:	c7 44 24 04 aa 4f 00 	movl   $0x4faa,0x4(%esp)
    2749:	00 
    274a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2751:	e8 73 16 00 00       	call   3dc9 <printf>
}
    2756:	c9                   	leave  
    2757:	c3                   	ret    

00002758 <fourteen>:

void
fourteen(void)
{
    2758:	55                   	push   %ebp
    2759:	89 e5                	mov    %esp,%ebp
    275b:	83 ec 28             	sub    $0x28,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    275e:	c7 44 24 04 bb 4f 00 	movl   $0x4fbb,0x4(%esp)
    2765:	00 
    2766:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    276d:	e8 57 16 00 00       	call   3dc9 <printf>

  if(mkdir("12345678901234") != 0){
    2772:	c7 04 24 ca 4f 00 00 	movl   $0x4fca,(%esp)
    2779:	e8 26 15 00 00       	call   3ca4 <mkdir>
    277e:	85 c0                	test   %eax,%eax
    2780:	74 19                	je     279b <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2782:	c7 44 24 04 d9 4f 00 	movl   $0x4fd9,0x4(%esp)
    2789:	00 
    278a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2791:	e8 33 16 00 00       	call   3dc9 <printf>
    exit();
    2796:	e8 a1 14 00 00       	call   3c3c <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    279b:	c7 04 24 f8 4f 00 00 	movl   $0x4ff8,(%esp)
    27a2:	e8 fd 14 00 00       	call   3ca4 <mkdir>
    27a7:	85 c0                	test   %eax,%eax
    27a9:	74 19                	je     27c4 <fourteen+0x6c>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    27ab:	c7 44 24 04 18 50 00 	movl   $0x5018,0x4(%esp)
    27b2:	00 
    27b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27ba:	e8 0a 16 00 00       	call   3dc9 <printf>
    exit();
    27bf:	e8 78 14 00 00       	call   3c3c <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    27c4:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    27cb:	00 
    27cc:	c7 04 24 48 50 00 00 	movl   $0x5048,(%esp)
    27d3:	e8 a4 14 00 00       	call   3c7c <open>
    27d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    27db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    27df:	79 19                	jns    27fa <fourteen+0xa2>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    27e1:	c7 44 24 04 78 50 00 	movl   $0x5078,0x4(%esp)
    27e8:	00 
    27e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27f0:	e8 d4 15 00 00       	call   3dc9 <printf>
    exit();
    27f5:	e8 42 14 00 00       	call   3c3c <exit>
  }
  close(fd);
    27fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    27fd:	89 04 24             	mov    %eax,(%esp)
    2800:	e8 5f 14 00 00       	call   3c64 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2805:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    280c:	00 
    280d:	c7 04 24 b8 50 00 00 	movl   $0x50b8,(%esp)
    2814:	e8 63 14 00 00       	call   3c7c <open>
    2819:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    281c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2820:	79 19                	jns    283b <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2822:	c7 44 24 04 e8 50 00 	movl   $0x50e8,0x4(%esp)
    2829:	00 
    282a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2831:	e8 93 15 00 00       	call   3dc9 <printf>
    exit();
    2836:	e8 01 14 00 00       	call   3c3c <exit>
  }
  close(fd);
    283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    283e:	89 04 24             	mov    %eax,(%esp)
    2841:	e8 1e 14 00 00       	call   3c64 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2846:	c7 04 24 22 51 00 00 	movl   $0x5122,(%esp)
    284d:	e8 52 14 00 00       	call   3ca4 <mkdir>
    2852:	85 c0                	test   %eax,%eax
    2854:	75 19                	jne    286f <fourteen+0x117>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2856:	c7 44 24 04 40 51 00 	movl   $0x5140,0x4(%esp)
    285d:	00 
    285e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2865:	e8 5f 15 00 00       	call   3dc9 <printf>
    exit();
    286a:	e8 cd 13 00 00       	call   3c3c <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    286f:	c7 04 24 70 51 00 00 	movl   $0x5170,(%esp)
    2876:	e8 29 14 00 00       	call   3ca4 <mkdir>
    287b:	85 c0                	test   %eax,%eax
    287d:	75 19                	jne    2898 <fourteen+0x140>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    287f:	c7 44 24 04 90 51 00 	movl   $0x5190,0x4(%esp)
    2886:	00 
    2887:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    288e:	e8 36 15 00 00       	call   3dc9 <printf>
    exit();
    2893:	e8 a4 13 00 00       	call   3c3c <exit>
  }

  printf(1, "fourteen ok\n");
    2898:	c7 44 24 04 c1 51 00 	movl   $0x51c1,0x4(%esp)
    289f:	00 
    28a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28a7:	e8 1d 15 00 00       	call   3dc9 <printf>
}
    28ac:	c9                   	leave  
    28ad:	c3                   	ret    

000028ae <rmdot>:

void
rmdot(void)
{
    28ae:	55                   	push   %ebp
    28af:	89 e5                	mov    %esp,%ebp
    28b1:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    28b4:	c7 44 24 04 ce 51 00 	movl   $0x51ce,0x4(%esp)
    28bb:	00 
    28bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28c3:	e8 01 15 00 00       	call   3dc9 <printf>
  if(mkdir("dots") != 0){
    28c8:	c7 04 24 da 51 00 00 	movl   $0x51da,(%esp)
    28cf:	e8 d0 13 00 00       	call   3ca4 <mkdir>
    28d4:	85 c0                	test   %eax,%eax
    28d6:	74 19                	je     28f1 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    28d8:	c7 44 24 04 df 51 00 	movl   $0x51df,0x4(%esp)
    28df:	00 
    28e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28e7:	e8 dd 14 00 00       	call   3dc9 <printf>
    exit();
    28ec:	e8 4b 13 00 00       	call   3c3c <exit>
  }
  if(chdir("dots") != 0){
    28f1:	c7 04 24 da 51 00 00 	movl   $0x51da,(%esp)
    28f8:	e8 af 13 00 00       	call   3cac <chdir>
    28fd:	85 c0                	test   %eax,%eax
    28ff:	74 19                	je     291a <rmdot+0x6c>
    printf(1, "chdir dots failed\n");
    2901:	c7 44 24 04 f2 51 00 	movl   $0x51f2,0x4(%esp)
    2908:	00 
    2909:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2910:	e8 b4 14 00 00       	call   3dc9 <printf>
    exit();
    2915:	e8 22 13 00 00       	call   3c3c <exit>
  }
  if(unlink(".") == 0){
    291a:	c7 04 24 0b 49 00 00 	movl   $0x490b,(%esp)
    2921:	e8 66 13 00 00       	call   3c8c <unlink>
    2926:	85 c0                	test   %eax,%eax
    2928:	75 19                	jne    2943 <rmdot+0x95>
    printf(1, "rm . worked!\n");
    292a:	c7 44 24 04 05 52 00 	movl   $0x5205,0x4(%esp)
    2931:	00 
    2932:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2939:	e8 8b 14 00 00       	call   3dc9 <printf>
    exit();
    293e:	e8 f9 12 00 00       	call   3c3c <exit>
  }
  if(unlink("..") == 0){
    2943:	c7 04 24 98 44 00 00 	movl   $0x4498,(%esp)
    294a:	e8 3d 13 00 00       	call   3c8c <unlink>
    294f:	85 c0                	test   %eax,%eax
    2951:	75 19                	jne    296c <rmdot+0xbe>
    printf(1, "rm .. worked!\n");
    2953:	c7 44 24 04 13 52 00 	movl   $0x5213,0x4(%esp)
    295a:	00 
    295b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2962:	e8 62 14 00 00       	call   3dc9 <printf>
    exit();
    2967:	e8 d0 12 00 00       	call   3c3c <exit>
  }
  if(chdir("/") != 0){
    296c:	c7 04 24 22 52 00 00 	movl   $0x5222,(%esp)
    2973:	e8 34 13 00 00       	call   3cac <chdir>
    2978:	85 c0                	test   %eax,%eax
    297a:	74 19                	je     2995 <rmdot+0xe7>
    printf(1, "chdir / failed\n");
    297c:	c7 44 24 04 24 52 00 	movl   $0x5224,0x4(%esp)
    2983:	00 
    2984:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    298b:	e8 39 14 00 00       	call   3dc9 <printf>
    exit();
    2990:	e8 a7 12 00 00       	call   3c3c <exit>
  }
  if(unlink("dots/.") == 0){
    2995:	c7 04 24 34 52 00 00 	movl   $0x5234,(%esp)
    299c:	e8 eb 12 00 00       	call   3c8c <unlink>
    29a1:	85 c0                	test   %eax,%eax
    29a3:	75 19                	jne    29be <rmdot+0x110>
    printf(1, "unlink dots/. worked!\n");
    29a5:	c7 44 24 04 3b 52 00 	movl   $0x523b,0x4(%esp)
    29ac:	00 
    29ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29b4:	e8 10 14 00 00       	call   3dc9 <printf>
    exit();
    29b9:	e8 7e 12 00 00       	call   3c3c <exit>
  }
  if(unlink("dots/..") == 0){
    29be:	c7 04 24 52 52 00 00 	movl   $0x5252,(%esp)
    29c5:	e8 c2 12 00 00       	call   3c8c <unlink>
    29ca:	85 c0                	test   %eax,%eax
    29cc:	75 19                	jne    29e7 <rmdot+0x139>
    printf(1, "unlink dots/.. worked!\n");
    29ce:	c7 44 24 04 5a 52 00 	movl   $0x525a,0x4(%esp)
    29d5:	00 
    29d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29dd:	e8 e7 13 00 00       	call   3dc9 <printf>
    exit();
    29e2:	e8 55 12 00 00       	call   3c3c <exit>
  }
  if(unlink("dots") != 0){
    29e7:	c7 04 24 da 51 00 00 	movl   $0x51da,(%esp)
    29ee:	e8 99 12 00 00       	call   3c8c <unlink>
    29f3:	85 c0                	test   %eax,%eax
    29f5:	74 19                	je     2a10 <rmdot+0x162>
    printf(1, "unlink dots failed!\n");
    29f7:	c7 44 24 04 72 52 00 	movl   $0x5272,0x4(%esp)
    29fe:	00 
    29ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a06:	e8 be 13 00 00       	call   3dc9 <printf>
    exit();
    2a0b:	e8 2c 12 00 00       	call   3c3c <exit>
  }
  printf(1, "rmdot ok\n");
    2a10:	c7 44 24 04 87 52 00 	movl   $0x5287,0x4(%esp)
    2a17:	00 
    2a18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a1f:	e8 a5 13 00 00       	call   3dc9 <printf>
}
    2a24:	c9                   	leave  
    2a25:	c3                   	ret    

00002a26 <dirfile>:

void
dirfile(void)
{
    2a26:	55                   	push   %ebp
    2a27:	89 e5                	mov    %esp,%ebp
    2a29:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "dir vs file\n");
    2a2c:	c7 44 24 04 91 52 00 	movl   $0x5291,0x4(%esp)
    2a33:	00 
    2a34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a3b:	e8 89 13 00 00       	call   3dc9 <printf>

  fd = open("dirfile", O_CREATE);
    2a40:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2a47:	00 
    2a48:	c7 04 24 9e 52 00 00 	movl   $0x529e,(%esp)
    2a4f:	e8 28 12 00 00       	call   3c7c <open>
    2a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a5b:	79 19                	jns    2a76 <dirfile+0x50>
    printf(1, "create dirfile failed\n");
    2a5d:	c7 44 24 04 a6 52 00 	movl   $0x52a6,0x4(%esp)
    2a64:	00 
    2a65:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a6c:	e8 58 13 00 00       	call   3dc9 <printf>
    exit();
    2a71:	e8 c6 11 00 00       	call   3c3c <exit>
  }
  close(fd);
    2a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a79:	89 04 24             	mov    %eax,(%esp)
    2a7c:	e8 e3 11 00 00       	call   3c64 <close>
  if(chdir("dirfile") == 0){
    2a81:	c7 04 24 9e 52 00 00 	movl   $0x529e,(%esp)
    2a88:	e8 1f 12 00 00       	call   3cac <chdir>
    2a8d:	85 c0                	test   %eax,%eax
    2a8f:	75 19                	jne    2aaa <dirfile+0x84>
    printf(1, "chdir dirfile succeeded!\n");
    2a91:	c7 44 24 04 bd 52 00 	movl   $0x52bd,0x4(%esp)
    2a98:	00 
    2a99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2aa0:	e8 24 13 00 00       	call   3dc9 <printf>
    exit();
    2aa5:	e8 92 11 00 00       	call   3c3c <exit>
  }
  fd = open("dirfile/xx", 0);
    2aaa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2ab1:	00 
    2ab2:	c7 04 24 d7 52 00 00 	movl   $0x52d7,(%esp)
    2ab9:	e8 be 11 00 00       	call   3c7c <open>
    2abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2ac1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2ac5:	78 19                	js     2ae0 <dirfile+0xba>
    printf(1, "create dirfile/xx succeeded!\n");
    2ac7:	c7 44 24 04 e2 52 00 	movl   $0x52e2,0x4(%esp)
    2ace:	00 
    2acf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ad6:	e8 ee 12 00 00       	call   3dc9 <printf>
    exit();
    2adb:	e8 5c 11 00 00       	call   3c3c <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2ae0:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2ae7:	00 
    2ae8:	c7 04 24 d7 52 00 00 	movl   $0x52d7,(%esp)
    2aef:	e8 88 11 00 00       	call   3c7c <open>
    2af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2afb:	78 19                	js     2b16 <dirfile+0xf0>
    printf(1, "create dirfile/xx succeeded!\n");
    2afd:	c7 44 24 04 e2 52 00 	movl   $0x52e2,0x4(%esp)
    2b04:	00 
    2b05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b0c:	e8 b8 12 00 00       	call   3dc9 <printf>
    exit();
    2b11:	e8 26 11 00 00       	call   3c3c <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2b16:	c7 04 24 d7 52 00 00 	movl   $0x52d7,(%esp)
    2b1d:	e8 82 11 00 00       	call   3ca4 <mkdir>
    2b22:	85 c0                	test   %eax,%eax
    2b24:	75 19                	jne    2b3f <dirfile+0x119>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2b26:	c7 44 24 04 00 53 00 	movl   $0x5300,0x4(%esp)
    2b2d:	00 
    2b2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b35:	e8 8f 12 00 00       	call   3dc9 <printf>
    exit();
    2b3a:	e8 fd 10 00 00       	call   3c3c <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2b3f:	c7 04 24 d7 52 00 00 	movl   $0x52d7,(%esp)
    2b46:	e8 41 11 00 00       	call   3c8c <unlink>
    2b4b:	85 c0                	test   %eax,%eax
    2b4d:	75 19                	jne    2b68 <dirfile+0x142>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2b4f:	c7 44 24 04 1d 53 00 	movl   $0x531d,0x4(%esp)
    2b56:	00 
    2b57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b5e:	e8 66 12 00 00       	call   3dc9 <printf>
    exit();
    2b63:	e8 d4 10 00 00       	call   3c3c <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2b68:	c7 44 24 04 d7 52 00 	movl   $0x52d7,0x4(%esp)
    2b6f:	00 
    2b70:	c7 04 24 3b 53 00 00 	movl   $0x533b,(%esp)
    2b77:	e8 20 11 00 00       	call   3c9c <link>
    2b7c:	85 c0                	test   %eax,%eax
    2b7e:	75 19                	jne    2b99 <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2b80:	c7 44 24 04 44 53 00 	movl   $0x5344,0x4(%esp)
    2b87:	00 
    2b88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b8f:	e8 35 12 00 00       	call   3dc9 <printf>
    exit();
    2b94:	e8 a3 10 00 00       	call   3c3c <exit>
  }
  if(unlink("dirfile") != 0){
    2b99:	c7 04 24 9e 52 00 00 	movl   $0x529e,(%esp)
    2ba0:	e8 e7 10 00 00       	call   3c8c <unlink>
    2ba5:	85 c0                	test   %eax,%eax
    2ba7:	74 19                	je     2bc2 <dirfile+0x19c>
    printf(1, "unlink dirfile failed!\n");
    2ba9:	c7 44 24 04 63 53 00 	movl   $0x5363,0x4(%esp)
    2bb0:	00 
    2bb1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bb8:	e8 0c 12 00 00       	call   3dc9 <printf>
    exit();
    2bbd:	e8 7a 10 00 00       	call   3c3c <exit>
  }

  fd = open(".", O_RDWR);
    2bc2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2bc9:	00 
    2bca:	c7 04 24 0b 49 00 00 	movl   $0x490b,(%esp)
    2bd1:	e8 a6 10 00 00       	call   3c7c <open>
    2bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2bd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2bdd:	78 19                	js     2bf8 <dirfile+0x1d2>
    printf(1, "open . for writing succeeded!\n");
    2bdf:	c7 44 24 04 7c 53 00 	movl   $0x537c,0x4(%esp)
    2be6:	00 
    2be7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bee:	e8 d6 11 00 00       	call   3dc9 <printf>
    exit();
    2bf3:	e8 44 10 00 00       	call   3c3c <exit>
  }
  fd = open(".", 0);
    2bf8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2bff:	00 
    2c00:	c7 04 24 0b 49 00 00 	movl   $0x490b,(%esp)
    2c07:	e8 70 10 00 00       	call   3c7c <open>
    2c0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2c0f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2c16:	00 
    2c17:	c7 44 24 04 42 45 00 	movl   $0x4542,0x4(%esp)
    2c1e:	00 
    2c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2c22:	89 04 24             	mov    %eax,(%esp)
    2c25:	e8 32 10 00 00       	call   3c5c <write>
    2c2a:	85 c0                	test   %eax,%eax
    2c2c:	7e 19                	jle    2c47 <dirfile+0x221>
    printf(1, "write . succeeded!\n");
    2c2e:	c7 44 24 04 9b 53 00 	movl   $0x539b,0x4(%esp)
    2c35:	00 
    2c36:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c3d:	e8 87 11 00 00       	call   3dc9 <printf>
    exit();
    2c42:	e8 f5 0f 00 00       	call   3c3c <exit>
  }
  close(fd);
    2c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2c4a:	89 04 24             	mov    %eax,(%esp)
    2c4d:	e8 12 10 00 00       	call   3c64 <close>

  printf(1, "dir vs file OK\n");
    2c52:	c7 44 24 04 af 53 00 	movl   $0x53af,0x4(%esp)
    2c59:	00 
    2c5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c61:	e8 63 11 00 00       	call   3dc9 <printf>
}
    2c66:	c9                   	leave  
    2c67:	c3                   	ret    

00002c68 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2c68:	55                   	push   %ebp
    2c69:	89 e5                	mov    %esp,%ebp
    2c6b:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2c6e:	c7 44 24 04 bf 53 00 	movl   $0x53bf,0x4(%esp)
    2c75:	00 
    2c76:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c7d:	e8 47 11 00 00       	call   3dc9 <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2c82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2c89:	e9 d2 00 00 00       	jmp    2d60 <iref+0xf8>
    if(mkdir("irefd") != 0){
    2c8e:	c7 04 24 d0 53 00 00 	movl   $0x53d0,(%esp)
    2c95:	e8 0a 10 00 00       	call   3ca4 <mkdir>
    2c9a:	85 c0                	test   %eax,%eax
    2c9c:	74 19                	je     2cb7 <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2c9e:	c7 44 24 04 d6 53 00 	movl   $0x53d6,0x4(%esp)
    2ca5:	00 
    2ca6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cad:	e8 17 11 00 00       	call   3dc9 <printf>
      exit();
    2cb2:	e8 85 0f 00 00       	call   3c3c <exit>
    }
    if(chdir("irefd") != 0){
    2cb7:	c7 04 24 d0 53 00 00 	movl   $0x53d0,(%esp)
    2cbe:	e8 e9 0f 00 00       	call   3cac <chdir>
    2cc3:	85 c0                	test   %eax,%eax
    2cc5:	74 19                	je     2ce0 <iref+0x78>
      printf(1, "chdir irefd failed\n");
    2cc7:	c7 44 24 04 ea 53 00 	movl   $0x53ea,0x4(%esp)
    2cce:	00 
    2ccf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cd6:	e8 ee 10 00 00       	call   3dc9 <printf>
      exit();
    2cdb:	e8 5c 0f 00 00       	call   3c3c <exit>
    }

    mkdir("");
    2ce0:	c7 04 24 fe 53 00 00 	movl   $0x53fe,(%esp)
    2ce7:	e8 b8 0f 00 00       	call   3ca4 <mkdir>
    link("README", "");
    2cec:	c7 44 24 04 fe 53 00 	movl   $0x53fe,0x4(%esp)
    2cf3:	00 
    2cf4:	c7 04 24 3b 53 00 00 	movl   $0x533b,(%esp)
    2cfb:	e8 9c 0f 00 00       	call   3c9c <link>
    fd = open("", O_CREATE);
    2d00:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d07:	00 
    2d08:	c7 04 24 fe 53 00 00 	movl   $0x53fe,(%esp)
    2d0f:	e8 68 0f 00 00       	call   3c7c <open>
    2d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2d17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2d1b:	78 0b                	js     2d28 <iref+0xc0>
      close(fd);
    2d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2d20:	89 04 24             	mov    %eax,(%esp)
    2d23:	e8 3c 0f 00 00       	call   3c64 <close>
    fd = open("xx", O_CREATE);
    2d28:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d2f:	00 
    2d30:	c7 04 24 ff 53 00 00 	movl   $0x53ff,(%esp)
    2d37:	e8 40 0f 00 00       	call   3c7c <open>
    2d3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2d3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2d43:	78 0b                	js     2d50 <iref+0xe8>
      close(fd);
    2d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2d48:	89 04 24             	mov    %eax,(%esp)
    2d4b:	e8 14 0f 00 00       	call   3c64 <close>
    unlink("xx");
    2d50:	c7 04 24 ff 53 00 00 	movl   $0x53ff,(%esp)
    2d57:	e8 30 0f 00 00       	call   3c8c <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2d5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2d60:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    2d64:	0f 8e 24 ff ff ff    	jle    2c8e <iref+0x26>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    2d6a:	c7 04 24 22 52 00 00 	movl   $0x5222,(%esp)
    2d71:	e8 36 0f 00 00       	call   3cac <chdir>
  printf(1, "empty file name OK\n");
    2d76:	c7 44 24 04 02 54 00 	movl   $0x5402,0x4(%esp)
    2d7d:	00 
    2d7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d85:	e8 3f 10 00 00       	call   3dc9 <printf>
}
    2d8a:	c9                   	leave  
    2d8b:	c3                   	ret    

00002d8c <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2d8c:	55                   	push   %ebp
    2d8d:	89 e5                	mov    %esp,%ebp
    2d8f:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    2d92:	c7 44 24 04 16 54 00 	movl   $0x5416,0x4(%esp)
    2d99:	00 
    2d9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2da1:	e8 23 10 00 00       	call   3dc9 <printf>

  for(n=0; n<1000; n++){
    2da6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2dad:	eb 1d                	jmp    2dcc <forktest+0x40>
    pid = fork();
    2daf:	e8 80 0e 00 00       	call   3c34 <fork>
    2db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    2db7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2dbb:	78 1a                	js     2dd7 <forktest+0x4b>
      break;
    if(pid == 0)
    2dbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2dc1:	75 05                	jne    2dc8 <forktest+0x3c>
      exit();
    2dc3:	e8 74 0e 00 00       	call   3c3c <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    2dc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2dcc:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    2dd3:	7e da                	jle    2daf <forktest+0x23>
    2dd5:	eb 01                	jmp    2dd8 <forktest+0x4c>
    pid = fork();
    if(pid < 0)
      break;
    2dd7:	90                   	nop
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    2dd8:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    2ddf:	75 3f                	jne    2e20 <forktest+0x94>
    printf(1, "fork claimed to work 1000 times!\n");
    2de1:	c7 44 24 04 24 54 00 	movl   $0x5424,0x4(%esp)
    2de8:	00 
    2de9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2df0:	e8 d4 0f 00 00       	call   3dc9 <printf>
    exit();
    2df5:	e8 42 0e 00 00       	call   3c3c <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
    2dfa:	e8 45 0e 00 00       	call   3c44 <wait>
    2dff:	85 c0                	test   %eax,%eax
    2e01:	79 19                	jns    2e1c <forktest+0x90>
      printf(1, "wait stopped early\n");
    2e03:	c7 44 24 04 46 54 00 	movl   $0x5446,0x4(%esp)
    2e0a:	00 
    2e0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e12:	e8 b2 0f 00 00       	call   3dc9 <printf>
      exit();
    2e17:	e8 20 0e 00 00       	call   3c3c <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    2e1c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    2e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e24:	7f d4                	jg     2dfa <forktest+0x6e>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    2e26:	e8 19 0e 00 00       	call   3c44 <wait>
    2e2b:	83 f8 ff             	cmp    $0xffffffff,%eax
    2e2e:	74 19                	je     2e49 <forktest+0xbd>
    printf(1, "wait got too many\n");
    2e30:	c7 44 24 04 5a 54 00 	movl   $0x545a,0x4(%esp)
    2e37:	00 
    2e38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e3f:	e8 85 0f 00 00       	call   3dc9 <printf>
    exit();
    2e44:	e8 f3 0d 00 00       	call   3c3c <exit>
  }
  
  printf(1, "fork test OK\n");
    2e49:	c7 44 24 04 6d 54 00 	movl   $0x546d,0x4(%esp)
    2e50:	00 
    2e51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e58:	e8 6c 0f 00 00       	call   3dc9 <printf>
}
    2e5d:	c9                   	leave  
    2e5e:	c3                   	ret    

00002e5f <sbrktest>:

void
sbrktest(void)
{
    2e5f:	55                   	push   %ebp
    2e60:	89 e5                	mov    %esp,%ebp
    2e62:	53                   	push   %ebx
    2e63:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    2e69:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    2e6e:	c7 44 24 04 7b 54 00 	movl   $0x547b,0x4(%esp)
    2e75:	00 
    2e76:	89 04 24             	mov    %eax,(%esp)
    2e79:	e8 4b 0f 00 00       	call   3dc9 <printf>
  oldbrk = sbrk(0);
    2e7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e85:	e8 3a 0e 00 00       	call   3cc4 <sbrk>
    2e8a:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    2e8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e94:	e8 2b 0e 00 00       	call   3cc4 <sbrk>
    2e99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    2e9c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2ea3:	eb 59                	jmp    2efe <sbrktest+0x9f>
    b = sbrk(1);
    2ea5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2eac:	e8 13 0e 00 00       	call   3cc4 <sbrk>
    2eb1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    2eb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2eb7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2eba:	74 2f                	je     2eeb <sbrktest+0x8c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2ebc:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    2ec1:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2ec4:	89 54 24 10          	mov    %edx,0x10(%esp)
    2ec8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2ecb:	89 54 24 0c          	mov    %edx,0xc(%esp)
    2ecf:	8b 55 f0             	mov    -0x10(%ebp),%edx
    2ed2:	89 54 24 08          	mov    %edx,0x8(%esp)
    2ed6:	c7 44 24 04 86 54 00 	movl   $0x5486,0x4(%esp)
    2edd:	00 
    2ede:	89 04 24             	mov    %eax,(%esp)
    2ee1:	e8 e3 0e 00 00       	call   3dc9 <printf>
      exit();
    2ee6:	e8 51 0d 00 00       	call   3c3c <exit>
    }
    *b = 1;
    2eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2eee:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    2ef1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2ef4:	83 c0 01             	add    $0x1,%eax
    2ef7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    2efa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2efe:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    2f05:	7e 9e                	jle    2ea5 <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    2f07:	e8 28 0d 00 00       	call   3c34 <fork>
    2f0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    2f0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    2f13:	79 1a                	jns    2f2f <sbrktest+0xd0>
    printf(stdout, "sbrk test fork failed\n");
    2f15:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    2f1a:	c7 44 24 04 a1 54 00 	movl   $0x54a1,0x4(%esp)
    2f21:	00 
    2f22:	89 04 24             	mov    %eax,(%esp)
    2f25:	e8 9f 0e 00 00       	call   3dc9 <printf>
    exit();
    2f2a:	e8 0d 0d 00 00       	call   3c3c <exit>
  }
  c = sbrk(1);
    2f2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f36:	e8 89 0d 00 00       	call   3cc4 <sbrk>
    2f3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    2f3e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f45:	e8 7a 0d 00 00       	call   3cc4 <sbrk>
    2f4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    2f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f50:	83 c0 01             	add    $0x1,%eax
    2f53:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    2f56:	74 1a                	je     2f72 <sbrktest+0x113>
    printf(stdout, "sbrk test failed post-fork\n");
    2f58:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    2f5d:	c7 44 24 04 b8 54 00 	movl   $0x54b8,0x4(%esp)
    2f64:	00 
    2f65:	89 04 24             	mov    %eax,(%esp)
    2f68:	e8 5c 0e 00 00       	call   3dc9 <printf>
    exit();
    2f6d:	e8 ca 0c 00 00       	call   3c3c <exit>
  }
  if(pid == 0)
    2f72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    2f76:	75 05                	jne    2f7d <sbrktest+0x11e>
    exit();
    2f78:	e8 bf 0c 00 00       	call   3c3c <exit>
  wait();
    2f7d:	e8 c2 0c 00 00       	call   3c44 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    2f82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f89:	e8 36 0d 00 00       	call   3cc4 <sbrk>
    2f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    2f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f94:	ba 00 00 40 06       	mov    $0x6400000,%edx
    2f99:	89 d1                	mov    %edx,%ecx
    2f9b:	29 c1                	sub    %eax,%ecx
    2f9d:	89 c8                	mov    %ecx,%eax
    2f9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    2fa2:	8b 45 dc             	mov    -0x24(%ebp),%eax
    2fa5:	89 04 24             	mov    %eax,(%esp)
    2fa8:	e8 17 0d 00 00       	call   3cc4 <sbrk>
    2fad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    2fb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
    2fb3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2fb6:	74 1a                	je     2fd2 <sbrktest+0x173>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    2fb8:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    2fbd:	c7 44 24 04 d4 54 00 	movl   $0x54d4,0x4(%esp)
    2fc4:	00 
    2fc5:	89 04 24             	mov    %eax,(%esp)
    2fc8:	e8 fc 0d 00 00       	call   3dc9 <printf>
    exit();
    2fcd:	e8 6a 0c 00 00       	call   3c3c <exit>
  }
  lastaddr = (char*) (BIG-1);
    2fd2:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    2fd9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    2fdc:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    2fdf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fe6:	e8 d9 0c 00 00       	call   3cc4 <sbrk>
    2feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    2fee:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    2ff5:	e8 ca 0c 00 00       	call   3cc4 <sbrk>
    2ffa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    2ffd:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3001:	75 1a                	jne    301d <sbrktest+0x1be>
    printf(stdout, "sbrk could not deallocate\n");
    3003:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    3008:	c7 44 24 04 12 55 00 	movl   $0x5512,0x4(%esp)
    300f:	00 
    3010:	89 04 24             	mov    %eax,(%esp)
    3013:	e8 b1 0d 00 00       	call   3dc9 <printf>
    exit();
    3018:	e8 1f 0c 00 00       	call   3c3c <exit>
  }
  c = sbrk(0);
    301d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3024:	e8 9b 0c 00 00       	call   3cc4 <sbrk>
    3029:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    302f:	2d 00 10 00 00       	sub    $0x1000,%eax
    3034:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    3037:	74 28                	je     3061 <sbrktest+0x202>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3039:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    303e:	8b 55 e0             	mov    -0x20(%ebp),%edx
    3041:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3045:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3048:	89 54 24 08          	mov    %edx,0x8(%esp)
    304c:	c7 44 24 04 30 55 00 	movl   $0x5530,0x4(%esp)
    3053:	00 
    3054:	89 04 24             	mov    %eax,(%esp)
    3057:	e8 6d 0d 00 00       	call   3dc9 <printf>
    exit();
    305c:	e8 db 0b 00 00       	call   3c3c <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    3061:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3068:	e8 57 0c 00 00       	call   3cc4 <sbrk>
    306d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    3070:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    3077:	e8 48 0c 00 00       	call   3cc4 <sbrk>
    307c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    307f:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3082:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3085:	75 19                	jne    30a0 <sbrktest+0x241>
    3087:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    308e:	e8 31 0c 00 00       	call   3cc4 <sbrk>
    3093:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3096:	81 c2 00 10 00 00    	add    $0x1000,%edx
    309c:	39 d0                	cmp    %edx,%eax
    309e:	74 28                	je     30c8 <sbrktest+0x269>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    30a0:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    30a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
    30a8:	89 54 24 0c          	mov    %edx,0xc(%esp)
    30ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
    30af:	89 54 24 08          	mov    %edx,0x8(%esp)
    30b3:	c7 44 24 04 68 55 00 	movl   $0x5568,0x4(%esp)
    30ba:	00 
    30bb:	89 04 24             	mov    %eax,(%esp)
    30be:	e8 06 0d 00 00       	call   3dc9 <printf>
    exit();
    30c3:	e8 74 0b 00 00       	call   3c3c <exit>
  }
  if(*lastaddr == 99){
    30c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    30cb:	0f b6 00             	movzbl (%eax),%eax
    30ce:	3c 63                	cmp    $0x63,%al
    30d0:	75 1a                	jne    30ec <sbrktest+0x28d>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    30d2:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    30d7:	c7 44 24 04 90 55 00 	movl   $0x5590,0x4(%esp)
    30de:	00 
    30df:	89 04 24             	mov    %eax,(%esp)
    30e2:	e8 e2 0c 00 00       	call   3dc9 <printf>
    exit();
    30e7:	e8 50 0b 00 00       	call   3c3c <exit>
  }

  a = sbrk(0);
    30ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    30f3:	e8 cc 0b 00 00       	call   3cc4 <sbrk>
    30f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    30fb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    30fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3105:	e8 ba 0b 00 00       	call   3cc4 <sbrk>
    310a:	89 da                	mov    %ebx,%edx
    310c:	29 c2                	sub    %eax,%edx
    310e:	89 d0                	mov    %edx,%eax
    3110:	89 04 24             	mov    %eax,(%esp)
    3113:	e8 ac 0b 00 00       	call   3cc4 <sbrk>
    3118:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    311b:	8b 45 e0             	mov    -0x20(%ebp),%eax
    311e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3121:	74 28                	je     314b <sbrktest+0x2ec>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    3123:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    3128:	8b 55 e0             	mov    -0x20(%ebp),%edx
    312b:	89 54 24 0c          	mov    %edx,0xc(%esp)
    312f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3132:	89 54 24 08          	mov    %edx,0x8(%esp)
    3136:	c7 44 24 04 c0 55 00 	movl   $0x55c0,0x4(%esp)
    313d:	00 
    313e:	89 04 24             	mov    %eax,(%esp)
    3141:	e8 83 0c 00 00       	call   3dc9 <printf>
    exit();
    3146:	e8 f1 0a 00 00       	call   3c3c <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    314b:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    3152:	eb 7b                	jmp    31cf <sbrktest+0x370>
    ppid = getpid();
    3154:	e8 63 0b 00 00       	call   3cbc <getpid>
    3159:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    315c:	e8 d3 0a 00 00       	call   3c34 <fork>
    3161:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    3164:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3168:	79 1a                	jns    3184 <sbrktest+0x325>
      printf(stdout, "fork failed\n");
    316a:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    316f:	c7 44 24 04 89 45 00 	movl   $0x4589,0x4(%esp)
    3176:	00 
    3177:	89 04 24             	mov    %eax,(%esp)
    317a:	e8 4a 0c 00 00       	call   3dc9 <printf>
      exit();
    317f:	e8 b8 0a 00 00       	call   3c3c <exit>
    }
    if(pid == 0){
    3184:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3188:	75 39                	jne    31c3 <sbrktest+0x364>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    318a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    318d:	0f b6 00             	movzbl (%eax),%eax
    3190:	0f be d0             	movsbl %al,%edx
    3193:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    3198:	89 54 24 0c          	mov    %edx,0xc(%esp)
    319c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    319f:	89 54 24 08          	mov    %edx,0x8(%esp)
    31a3:	c7 44 24 04 e1 55 00 	movl   $0x55e1,0x4(%esp)
    31aa:	00 
    31ab:	89 04 24             	mov    %eax,(%esp)
    31ae:	e8 16 0c 00 00       	call   3dc9 <printf>
      kill(ppid);
    31b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
    31b6:	89 04 24             	mov    %eax,(%esp)
    31b9:	e8 ae 0a 00 00       	call   3c6c <kill>
      exit();
    31be:	e8 79 0a 00 00       	call   3c3c <exit>
    }
    wait();
    31c3:	e8 7c 0a 00 00       	call   3c44 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    31c8:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    31cf:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    31d6:	0f 86 78 ff ff ff    	jbe    3154 <sbrktest+0x2f5>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    31dc:	8d 45 c8             	lea    -0x38(%ebp),%eax
    31df:	89 04 24             	mov    %eax,(%esp)
    31e2:	e8 65 0a 00 00       	call   3c4c <pipe>
    31e7:	85 c0                	test   %eax,%eax
    31e9:	74 19                	je     3204 <sbrktest+0x3a5>
    printf(1, "pipe() failed\n");
    31eb:	c7 44 24 04 dd 44 00 	movl   $0x44dd,0x4(%esp)
    31f2:	00 
    31f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31fa:	e8 ca 0b 00 00       	call   3dc9 <printf>
    exit();
    31ff:	e8 38 0a 00 00       	call   3c3c <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3204:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    320b:	e9 89 00 00 00       	jmp    3299 <sbrktest+0x43a>
    if((pids[i] = fork()) == 0){
    3210:	e8 1f 0a 00 00       	call   3c34 <fork>
    3215:	8b 55 f0             	mov    -0x10(%ebp),%edx
    3218:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    321c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    321f:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3223:	85 c0                	test   %eax,%eax
    3225:	75 48                	jne    326f <sbrktest+0x410>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    3227:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    322e:	e8 91 0a 00 00       	call   3cc4 <sbrk>
    3233:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3238:	89 d1                	mov    %edx,%ecx
    323a:	29 c1                	sub    %eax,%ecx
    323c:	89 c8                	mov    %ecx,%eax
    323e:	89 04 24             	mov    %eax,(%esp)
    3241:	e8 7e 0a 00 00       	call   3cc4 <sbrk>
      write(fds[1], "x", 1);
    3246:	8b 45 cc             	mov    -0x34(%ebp),%eax
    3249:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3250:	00 
    3251:	c7 44 24 04 42 45 00 	movl   $0x4542,0x4(%esp)
    3258:	00 
    3259:	89 04 24             	mov    %eax,(%esp)
    325c:	e8 fb 09 00 00       	call   3c5c <write>
      // sit around until killed
      for(;;) sleep(1000);
    3261:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    3268:	e8 5f 0a 00 00       	call   3ccc <sleep>
    326d:	eb f2                	jmp    3261 <sbrktest+0x402>
    }
    if(pids[i] != -1)
    326f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3272:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3276:	83 f8 ff             	cmp    $0xffffffff,%eax
    3279:	74 1a                	je     3295 <sbrktest+0x436>
      read(fds[0], &scratch, 1);
    327b:	8b 45 c8             	mov    -0x38(%ebp),%eax
    327e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3285:	00 
    3286:	8d 55 9f             	lea    -0x61(%ebp),%edx
    3289:	89 54 24 04          	mov    %edx,0x4(%esp)
    328d:	89 04 24             	mov    %eax,(%esp)
    3290:	e8 bf 09 00 00       	call   3c54 <read>
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3295:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3299:	8b 45 f0             	mov    -0x10(%ebp),%eax
    329c:	83 f8 09             	cmp    $0x9,%eax
    329f:	0f 86 6b ff ff ff    	jbe    3210 <sbrktest+0x3b1>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    32a5:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    32ac:	e8 13 0a 00 00       	call   3cc4 <sbrk>
    32b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    32b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    32bb:	eb 27                	jmp    32e4 <sbrktest+0x485>
    if(pids[i] == -1)
    32bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    32c0:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    32c4:	83 f8 ff             	cmp    $0xffffffff,%eax
    32c7:	74 16                	je     32df <sbrktest+0x480>
      continue;
    kill(pids[i]);
    32c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    32cc:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    32d0:	89 04 24             	mov    %eax,(%esp)
    32d3:	e8 94 09 00 00       	call   3c6c <kill>
    wait();
    32d8:	e8 67 09 00 00       	call   3c44 <wait>
    32dd:	eb 01                	jmp    32e0 <sbrktest+0x481>
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
      continue;
    32df:	90                   	nop
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    32e0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    32e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    32e7:	83 f8 09             	cmp    $0x9,%eax
    32ea:	76 d1                	jbe    32bd <sbrktest+0x45e>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    32ec:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    32f0:	75 1a                	jne    330c <sbrktest+0x4ad>
    printf(stdout, "failed sbrk leaked memory\n");
    32f2:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    32f7:	c7 44 24 04 fa 55 00 	movl   $0x55fa,0x4(%esp)
    32fe:	00 
    32ff:	89 04 24             	mov    %eax,(%esp)
    3302:	e8 c2 0a 00 00       	call   3dc9 <printf>
    exit();
    3307:	e8 30 09 00 00       	call   3c3c <exit>
  }

  if(sbrk(0) > oldbrk)
    330c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3313:	e8 ac 09 00 00       	call   3cc4 <sbrk>
    3318:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    331b:	76 1d                	jbe    333a <sbrktest+0x4db>
    sbrk(-(sbrk(0) - oldbrk));
    331d:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    3320:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3327:	e8 98 09 00 00       	call   3cc4 <sbrk>
    332c:	89 da                	mov    %ebx,%edx
    332e:	29 c2                	sub    %eax,%edx
    3330:	89 d0                	mov    %edx,%eax
    3332:	89 04 24             	mov    %eax,(%esp)
    3335:	e8 8a 09 00 00       	call   3cc4 <sbrk>

  printf(stdout, "sbrk test OK\n");
    333a:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    333f:	c7 44 24 04 15 56 00 	movl   $0x5615,0x4(%esp)
    3346:	00 
    3347:	89 04 24             	mov    %eax,(%esp)
    334a:	e8 7a 0a 00 00       	call   3dc9 <printf>
}
    334f:	81 c4 84 00 00 00    	add    $0x84,%esp
    3355:	5b                   	pop    %ebx
    3356:	5d                   	pop    %ebp
    3357:	c3                   	ret    

00003358 <validateint>:

void
validateint(int *p)
{
    3358:	55                   	push   %ebp
    3359:	89 e5                	mov    %esp,%ebp
    335b:	56                   	push   %esi
    335c:	53                   	push   %ebx
    335d:	83 ec 14             	sub    $0x14,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    3360:	c7 45 e4 0d 00 00 00 	movl   $0xd,-0x1c(%ebp)
    3367:	8b 55 08             	mov    0x8(%ebp),%edx
    336a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    336d:	89 d1                	mov    %edx,%ecx
    336f:	89 e3                	mov    %esp,%ebx
    3371:	89 cc                	mov    %ecx,%esp
    3373:	cd 40                	int    $0x40
    3375:	89 dc                	mov    %ebx,%esp
    3377:	89 c6                	mov    %eax,%esi
    3379:	89 75 f4             	mov    %esi,-0xc(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    337c:	83 c4 14             	add    $0x14,%esp
    337f:	5b                   	pop    %ebx
    3380:	5e                   	pop    %esi
    3381:	5d                   	pop    %ebp
    3382:	c3                   	ret    

00003383 <validatetest>:

void
validatetest(void)
{
    3383:	55                   	push   %ebp
    3384:	89 e5                	mov    %esp,%ebp
    3386:	83 ec 28             	sub    $0x28,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3389:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    338e:	c7 44 24 04 23 56 00 	movl   $0x5623,0x4(%esp)
    3395:	00 
    3396:	89 04 24             	mov    %eax,(%esp)
    3399:	e8 2b 0a 00 00       	call   3dc9 <printf>
  hi = 1100*1024;
    339e:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    33a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    33ac:	eb 7f                	jmp    342d <validatetest+0xaa>
    if((pid = fork()) == 0){
    33ae:	e8 81 08 00 00       	call   3c34 <fork>
    33b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    33b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    33ba:	75 10                	jne    33cc <validatetest+0x49>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    33bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    33bf:	89 04 24             	mov    %eax,(%esp)
    33c2:	e8 91 ff ff ff       	call   3358 <validateint>
      exit();
    33c7:	e8 70 08 00 00       	call   3c3c <exit>
    }
    sleep(0);
    33cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33d3:	e8 f4 08 00 00       	call   3ccc <sleep>
    sleep(0);
    33d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33df:	e8 e8 08 00 00       	call   3ccc <sleep>
    kill(pid);
    33e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    33e7:	89 04 24             	mov    %eax,(%esp)
    33ea:	e8 7d 08 00 00       	call   3c6c <kill>
    wait();
    33ef:	e8 50 08 00 00       	call   3c44 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    33f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    33f7:	89 44 24 04          	mov    %eax,0x4(%esp)
    33fb:	c7 04 24 32 56 00 00 	movl   $0x5632,(%esp)
    3402:	e8 95 08 00 00       	call   3c9c <link>
    3407:	83 f8 ff             	cmp    $0xffffffff,%eax
    340a:	74 1a                	je     3426 <validatetest+0xa3>
      printf(stdout, "link should not succeed\n");
    340c:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    3411:	c7 44 24 04 3d 56 00 	movl   $0x563d,0x4(%esp)
    3418:	00 
    3419:	89 04 24             	mov    %eax,(%esp)
    341c:	e8 a8 09 00 00       	call   3dc9 <printf>
      exit();
    3421:	e8 16 08 00 00       	call   3c3c <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    3426:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    342d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3430:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3433:	0f 83 75 ff ff ff    	jae    33ae <validatetest+0x2b>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    3439:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    343e:	c7 44 24 04 56 56 00 	movl   $0x5656,0x4(%esp)
    3445:	00 
    3446:	89 04 24             	mov    %eax,(%esp)
    3449:	e8 7b 09 00 00       	call   3dc9 <printf>
}
    344e:	c9                   	leave  
    344f:	c3                   	ret    

00003450 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    3450:	55                   	push   %ebp
    3451:	89 e5                	mov    %esp,%ebp
    3453:	83 ec 28             	sub    $0x28,%esp
  int i;

  printf(stdout, "bss test\n");
    3456:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    345b:	c7 44 24 04 63 56 00 	movl   $0x5663,0x4(%esp)
    3462:	00 
    3463:	89 04 24             	mov    %eax,(%esp)
    3466:	e8 5e 09 00 00       	call   3dc9 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    346b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3472:	eb 2d                	jmp    34a1 <bsstest+0x51>
    if(uninit[i] != '\0'){
    3474:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3477:	05 c0 5f 00 00       	add    $0x5fc0,%eax
    347c:	0f b6 00             	movzbl (%eax),%eax
    347f:	84 c0                	test   %al,%al
    3481:	74 1a                	je     349d <bsstest+0x4d>
      printf(stdout, "bss test failed\n");
    3483:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    3488:	c7 44 24 04 6d 56 00 	movl   $0x566d,0x4(%esp)
    348f:	00 
    3490:	89 04 24             	mov    %eax,(%esp)
    3493:	e8 31 09 00 00       	call   3dc9 <printf>
      exit();
    3498:	e8 9f 07 00 00       	call   3c3c <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    349d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    34a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34a4:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    34a9:	76 c9                	jbe    3474 <bsstest+0x24>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    34ab:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    34b0:	c7 44 24 04 7e 56 00 	movl   $0x567e,0x4(%esp)
    34b7:	00 
    34b8:	89 04 24             	mov    %eax,(%esp)
    34bb:	e8 09 09 00 00       	call   3dc9 <printf>
}
    34c0:	c9                   	leave  
    34c1:	c3                   	ret    

000034c2 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    34c2:	55                   	push   %ebp
    34c3:	89 e5                	mov    %esp,%ebp
    34c5:	83 ec 28             	sub    $0x28,%esp
  int pid, fd;

  unlink("bigarg-ok");
    34c8:	c7 04 24 8b 56 00 00 	movl   $0x568b,(%esp)
    34cf:	e8 b8 07 00 00       	call   3c8c <unlink>
  pid = fork();
    34d4:	e8 5b 07 00 00       	call   3c34 <fork>
    34d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    34dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    34e0:	0f 85 90 00 00 00    	jne    3576 <bigargtest+0xb4>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    34e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    34ed:	eb 12                	jmp    3501 <bigargtest+0x3f>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    34ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34f2:	c7 04 85 20 5f 00 00 	movl   $0x5698,0x5f20(,%eax,4)
    34f9:	98 56 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    34fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3501:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    3505:	7e e8                	jle    34ef <bigargtest+0x2d>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    3507:	c7 05 9c 5f 00 00 00 	movl   $0x0,0x5f9c
    350e:	00 00 00 
    printf(stdout, "bigarg test\n");
    3511:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    3516:	c7 44 24 04 75 57 00 	movl   $0x5775,0x4(%esp)
    351d:	00 
    351e:	89 04 24             	mov    %eax,(%esp)
    3521:	e8 a3 08 00 00       	call   3dc9 <printf>
    exec("echo", args);
    3526:	c7 44 24 04 20 5f 00 	movl   $0x5f20,0x4(%esp)
    352d:	00 
    352e:	c7 04 24 9c 41 00 00 	movl   $0x419c,(%esp)
    3535:	e8 3a 07 00 00       	call   3c74 <exec>
    printf(stdout, "bigarg test ok\n");
    353a:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    353f:	c7 44 24 04 82 57 00 	movl   $0x5782,0x4(%esp)
    3546:	00 
    3547:	89 04 24             	mov    %eax,(%esp)
    354a:	e8 7a 08 00 00       	call   3dc9 <printf>
    fd = open("bigarg-ok", O_CREATE);
    354f:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3556:	00 
    3557:	c7 04 24 8b 56 00 00 	movl   $0x568b,(%esp)
    355e:	e8 19 07 00 00       	call   3c7c <open>
    3563:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    3566:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3569:	89 04 24             	mov    %eax,(%esp)
    356c:	e8 f3 06 00 00       	call   3c64 <close>
    exit();
    3571:	e8 c6 06 00 00       	call   3c3c <exit>
  } else if(pid < 0){
    3576:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    357a:	79 1a                	jns    3596 <bigargtest+0xd4>
    printf(stdout, "bigargtest: fork failed\n");
    357c:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    3581:	c7 44 24 04 92 57 00 	movl   $0x5792,0x4(%esp)
    3588:	00 
    3589:	89 04 24             	mov    %eax,(%esp)
    358c:	e8 38 08 00 00       	call   3dc9 <printf>
    exit();
    3591:	e8 a6 06 00 00       	call   3c3c <exit>
  }
  wait();
    3596:	e8 a9 06 00 00       	call   3c44 <wait>
  fd = open("bigarg-ok", 0);
    359b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    35a2:	00 
    35a3:	c7 04 24 8b 56 00 00 	movl   $0x568b,(%esp)
    35aa:	e8 cd 06 00 00       	call   3c7c <open>
    35af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    35b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    35b6:	79 1a                	jns    35d2 <bigargtest+0x110>
    printf(stdout, "bigarg test failed!\n");
    35b8:	a1 f0 5e 00 00       	mov    0x5ef0,%eax
    35bd:	c7 44 24 04 ab 57 00 	movl   $0x57ab,0x4(%esp)
    35c4:	00 
    35c5:	89 04 24             	mov    %eax,(%esp)
    35c8:	e8 fc 07 00 00       	call   3dc9 <printf>
    exit();
    35cd:	e8 6a 06 00 00       	call   3c3c <exit>
  }
  close(fd);
    35d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    35d5:	89 04 24             	mov    %eax,(%esp)
    35d8:	e8 87 06 00 00       	call   3c64 <close>
  unlink("bigarg-ok");
    35dd:	c7 04 24 8b 56 00 00 	movl   $0x568b,(%esp)
    35e4:	e8 a3 06 00 00       	call   3c8c <unlink>
}
    35e9:	c9                   	leave  
    35ea:	c3                   	ret    

000035eb <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    35eb:	55                   	push   %ebp
    35ec:	89 e5                	mov    %esp,%ebp
    35ee:	53                   	push   %ebx
    35ef:	83 ec 74             	sub    $0x74,%esp
  int nfiles;
  int fsblocks = 0;
    35f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    35f9:	c7 44 24 04 c0 57 00 	movl   $0x57c0,0x4(%esp)
    3600:	00 
    3601:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3608:	e8 bc 07 00 00       	call   3dc9 <printf>

  for(nfiles = 0; ; nfiles++){
    360d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    3614:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3618:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    361b:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3620:	89 c8                	mov    %ecx,%eax
    3622:	f7 ea                	imul   %edx
    3624:	c1 fa 06             	sar    $0x6,%edx
    3627:	89 c8                	mov    %ecx,%eax
    3629:	c1 f8 1f             	sar    $0x1f,%eax
    362c:	89 d1                	mov    %edx,%ecx
    362e:	29 c1                	sub    %eax,%ecx
    3630:	89 c8                	mov    %ecx,%eax
    3632:	83 c0 30             	add    $0x30,%eax
    3635:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3638:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    363b:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3640:	89 d8                	mov    %ebx,%eax
    3642:	f7 ea                	imul   %edx
    3644:	c1 fa 06             	sar    $0x6,%edx
    3647:	89 d8                	mov    %ebx,%eax
    3649:	c1 f8 1f             	sar    $0x1f,%eax
    364c:	89 d1                	mov    %edx,%ecx
    364e:	29 c1                	sub    %eax,%ecx
    3650:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3656:	89 d9                	mov    %ebx,%ecx
    3658:	29 c1                	sub    %eax,%ecx
    365a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    365f:	89 c8                	mov    %ecx,%eax
    3661:	f7 ea                	imul   %edx
    3663:	c1 fa 05             	sar    $0x5,%edx
    3666:	89 c8                	mov    %ecx,%eax
    3668:	c1 f8 1f             	sar    $0x1f,%eax
    366b:	89 d1                	mov    %edx,%ecx
    366d:	29 c1                	sub    %eax,%ecx
    366f:	89 c8                	mov    %ecx,%eax
    3671:	83 c0 30             	add    $0x30,%eax
    3674:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3677:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    367a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    367f:	89 d8                	mov    %ebx,%eax
    3681:	f7 ea                	imul   %edx
    3683:	c1 fa 05             	sar    $0x5,%edx
    3686:	89 d8                	mov    %ebx,%eax
    3688:	c1 f8 1f             	sar    $0x1f,%eax
    368b:	89 d1                	mov    %edx,%ecx
    368d:	29 c1                	sub    %eax,%ecx
    368f:	6b c1 64             	imul   $0x64,%ecx,%eax
    3692:	89 d9                	mov    %ebx,%ecx
    3694:	29 c1                	sub    %eax,%ecx
    3696:	ba 67 66 66 66       	mov    $0x66666667,%edx
    369b:	89 c8                	mov    %ecx,%eax
    369d:	f7 ea                	imul   %edx
    369f:	c1 fa 02             	sar    $0x2,%edx
    36a2:	89 c8                	mov    %ecx,%eax
    36a4:	c1 f8 1f             	sar    $0x1f,%eax
    36a7:	89 d1                	mov    %edx,%ecx
    36a9:	29 c1                	sub    %eax,%ecx
    36ab:	89 c8                	mov    %ecx,%eax
    36ad:	83 c0 30             	add    $0x30,%eax
    36b0:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    36b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    36b6:	ba 67 66 66 66       	mov    $0x66666667,%edx
    36bb:	89 c8                	mov    %ecx,%eax
    36bd:	f7 ea                	imul   %edx
    36bf:	c1 fa 02             	sar    $0x2,%edx
    36c2:	89 c8                	mov    %ecx,%eax
    36c4:	c1 f8 1f             	sar    $0x1f,%eax
    36c7:	29 c2                	sub    %eax,%edx
    36c9:	89 d0                	mov    %edx,%eax
    36cb:	c1 e0 02             	shl    $0x2,%eax
    36ce:	01 d0                	add    %edx,%eax
    36d0:	01 c0                	add    %eax,%eax
    36d2:	89 ca                	mov    %ecx,%edx
    36d4:	29 c2                	sub    %eax,%edx
    36d6:	89 d0                	mov    %edx,%eax
    36d8:	83 c0 30             	add    $0x30,%eax
    36db:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    36de:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    36e2:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    36e5:	89 44 24 08          	mov    %eax,0x8(%esp)
    36e9:	c7 44 24 04 cd 57 00 	movl   $0x57cd,0x4(%esp)
    36f0:	00 
    36f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    36f8:	e8 cc 06 00 00       	call   3dc9 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    36fd:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    3704:	00 
    3705:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3708:	89 04 24             	mov    %eax,(%esp)
    370b:	e8 6c 05 00 00       	call   3c7c <open>
    3710:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    3713:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3717:	79 20                	jns    3739 <fsfull+0x14e>
      printf(1, "open %s failed\n", name);
    3719:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    371c:	89 44 24 08          	mov    %eax,0x8(%esp)
    3720:	c7 44 24 04 d9 57 00 	movl   $0x57d9,0x4(%esp)
    3727:	00 
    3728:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    372f:	e8 95 06 00 00       	call   3dc9 <printf>
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3734:	e9 51 01 00 00       	jmp    388a <fsfull+0x29f>
    int fd = open(name, O_CREATE|O_RDWR);
    if(fd < 0){
      printf(1, "open %s failed\n", name);
      break;
    }
    int total = 0;
    3739:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    3740:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    3747:	00 
    3748:	c7 44 24 04 e0 86 00 	movl   $0x86e0,0x4(%esp)
    374f:	00 
    3750:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3753:	89 04 24             	mov    %eax,(%esp)
    3756:	e8 01 05 00 00       	call   3c5c <write>
    375b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    375e:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    3765:	7e 0c                	jle    3773 <fsfull+0x188>
        break;
      total += cc;
    3767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    376a:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    376d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    3771:	eb cd                	jmp    3740 <fsfull+0x155>
    }
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
    3773:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    3774:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3777:	89 44 24 08          	mov    %eax,0x8(%esp)
    377b:	c7 44 24 04 e9 57 00 	movl   $0x57e9,0x4(%esp)
    3782:	00 
    3783:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    378a:	e8 3a 06 00 00       	call   3dc9 <printf>
    close(fd);
    378f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3792:	89 04 24             	mov    %eax,(%esp)
    3795:	e8 ca 04 00 00       	call   3c64 <close>
    if(total == 0)
    379a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    379e:	0f 84 e6 00 00 00    	je     388a <fsfull+0x29f>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    37a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    37a8:	e9 67 fe ff ff       	jmp    3614 <fsfull+0x29>

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    37ad:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    37b1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    37b4:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    37b9:	89 c8                	mov    %ecx,%eax
    37bb:	f7 ea                	imul   %edx
    37bd:	c1 fa 06             	sar    $0x6,%edx
    37c0:	89 c8                	mov    %ecx,%eax
    37c2:	c1 f8 1f             	sar    $0x1f,%eax
    37c5:	89 d1                	mov    %edx,%ecx
    37c7:	29 c1                	sub    %eax,%ecx
    37c9:	89 c8                	mov    %ecx,%eax
    37cb:	83 c0 30             	add    $0x30,%eax
    37ce:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    37d1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    37d4:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    37d9:	89 d8                	mov    %ebx,%eax
    37db:	f7 ea                	imul   %edx
    37dd:	c1 fa 06             	sar    $0x6,%edx
    37e0:	89 d8                	mov    %ebx,%eax
    37e2:	c1 f8 1f             	sar    $0x1f,%eax
    37e5:	89 d1                	mov    %edx,%ecx
    37e7:	29 c1                	sub    %eax,%ecx
    37e9:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    37ef:	89 d9                	mov    %ebx,%ecx
    37f1:	29 c1                	sub    %eax,%ecx
    37f3:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    37f8:	89 c8                	mov    %ecx,%eax
    37fa:	f7 ea                	imul   %edx
    37fc:	c1 fa 05             	sar    $0x5,%edx
    37ff:	89 c8                	mov    %ecx,%eax
    3801:	c1 f8 1f             	sar    $0x1f,%eax
    3804:	89 d1                	mov    %edx,%ecx
    3806:	29 c1                	sub    %eax,%ecx
    3808:	89 c8                	mov    %ecx,%eax
    380a:	83 c0 30             	add    $0x30,%eax
    380d:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3810:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3813:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3818:	89 d8                	mov    %ebx,%eax
    381a:	f7 ea                	imul   %edx
    381c:	c1 fa 05             	sar    $0x5,%edx
    381f:	89 d8                	mov    %ebx,%eax
    3821:	c1 f8 1f             	sar    $0x1f,%eax
    3824:	89 d1                	mov    %edx,%ecx
    3826:	29 c1                	sub    %eax,%ecx
    3828:	6b c1 64             	imul   $0x64,%ecx,%eax
    382b:	89 d9                	mov    %ebx,%ecx
    382d:	29 c1                	sub    %eax,%ecx
    382f:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3834:	89 c8                	mov    %ecx,%eax
    3836:	f7 ea                	imul   %edx
    3838:	c1 fa 02             	sar    $0x2,%edx
    383b:	89 c8                	mov    %ecx,%eax
    383d:	c1 f8 1f             	sar    $0x1f,%eax
    3840:	89 d1                	mov    %edx,%ecx
    3842:	29 c1                	sub    %eax,%ecx
    3844:	89 c8                	mov    %ecx,%eax
    3846:	83 c0 30             	add    $0x30,%eax
    3849:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    384c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    384f:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3854:	89 c8                	mov    %ecx,%eax
    3856:	f7 ea                	imul   %edx
    3858:	c1 fa 02             	sar    $0x2,%edx
    385b:	89 c8                	mov    %ecx,%eax
    385d:	c1 f8 1f             	sar    $0x1f,%eax
    3860:	29 c2                	sub    %eax,%edx
    3862:	89 d0                	mov    %edx,%eax
    3864:	c1 e0 02             	shl    $0x2,%eax
    3867:	01 d0                	add    %edx,%eax
    3869:	01 c0                	add    %eax,%eax
    386b:	89 ca                	mov    %ecx,%edx
    386d:	29 c2                	sub    %eax,%edx
    386f:	89 d0                	mov    %edx,%eax
    3871:	83 c0 30             	add    $0x30,%eax
    3874:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3877:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    387b:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    387e:	89 04 24             	mov    %eax,(%esp)
    3881:	e8 06 04 00 00       	call   3c8c <unlink>
    nfiles--;
    3886:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    388a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    388e:	0f 89 19 ff ff ff    	jns    37ad <fsfull+0x1c2>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    3894:	c7 44 24 04 f9 57 00 	movl   $0x57f9,0x4(%esp)
    389b:	00 
    389c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38a3:	e8 21 05 00 00       	call   3dc9 <printf>
}
    38a8:	83 c4 74             	add    $0x74,%esp
    38ab:	5b                   	pop    %ebx
    38ac:	5d                   	pop    %ebp
    38ad:	c3                   	ret    

000038ae <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    38ae:	55                   	push   %ebp
    38af:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    38b1:	a1 f4 5e 00 00       	mov    0x5ef4,%eax
    38b6:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    38bc:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    38c1:	a3 f4 5e 00 00       	mov    %eax,0x5ef4
  return randstate;
    38c6:	a1 f4 5e 00 00       	mov    0x5ef4,%eax
}
    38cb:	5d                   	pop    %ebp
    38cc:	c3                   	ret    

000038cd <main>:

int
main(int argc, char *argv[])
{
    38cd:	55                   	push   %ebp
    38ce:	89 e5                	mov    %esp,%ebp
    38d0:	83 e4 f0             	and    $0xfffffff0,%esp
    38d3:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    38d6:	c7 44 24 04 0f 58 00 	movl   $0x580f,0x4(%esp)
    38dd:	00 
    38de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38e5:	e8 df 04 00 00       	call   3dc9 <printf>

  if(open("usertests.ran", 0) >= 0){
    38ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    38f1:	00 
    38f2:	c7 04 24 23 58 00 00 	movl   $0x5823,(%esp)
    38f9:	e8 7e 03 00 00       	call   3c7c <open>
    38fe:	85 c0                	test   %eax,%eax
    3900:	78 19                	js     391b <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3902:	c7 44 24 04 34 58 00 	movl   $0x5834,0x4(%esp)
    3909:	00 
    390a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3911:	e8 b3 04 00 00       	call   3dc9 <printf>
    exit();
    3916:	e8 21 03 00 00       	call   3c3c <exit>
  }
  close(open("usertests.ran", O_CREATE));
    391b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3922:	00 
    3923:	c7 04 24 23 58 00 00 	movl   $0x5823,(%esp)
    392a:	e8 4d 03 00 00       	call   3c7c <open>
    392f:	89 04 24             	mov    %eax,(%esp)
    3932:	e8 2d 03 00 00       	call   3c64 <close>

  bigargtest();
    3937:	e8 86 fb ff ff       	call   34c2 <bigargtest>
  bigwrite();
    393c:	e8 ea ea ff ff       	call   242b <bigwrite>
  bigargtest();
    3941:	e8 7c fb ff ff       	call   34c2 <bigargtest>
  bsstest();
    3946:	e8 05 fb ff ff       	call   3450 <bsstest>
  sbrktest();
    394b:	e8 0f f5 ff ff       	call   2e5f <sbrktest>
  validatetest();
    3950:	e8 2e fa ff ff       	call   3383 <validatetest>

  opentest();
    3955:	e8 a6 c6 ff ff       	call   0 <opentest>
  writetest();
    395a:	e8 4c c7 ff ff       	call   ab <writetest>
  writetest1();
    395f:	e8 5c c9 ff ff       	call   2c0 <writetest1>
  createtest();
    3964:	e8 60 cb ff ff       	call   4c9 <createtest>

  mem();
    3969:	e8 01 d1 ff ff       	call   a6f <mem>
  pipe1();
    396e:	e8 37 cd ff ff       	call   6aa <pipe1>
  preempt();
    3973:	e8 20 cf ff ff       	call   898 <preempt>
  exitwait();
    3978:	e8 74 d0 ff ff       	call   9f1 <exitwait>

  rmdot();
    397d:	e8 2c ef ff ff       	call   28ae <rmdot>
  fourteen();
    3982:	e8 d1 ed ff ff       	call   2758 <fourteen>
  bigfile();
    3987:	e8 a7 eb ff ff       	call   2533 <bigfile>
  subdir();
    398c:	e8 54 e3 ff ff       	call   1ce5 <subdir>
  concreate();
    3991:	e8 f3 dc ff ff       	call   1689 <concreate>
  linkunlink();
    3996:	e8 a7 e0 ff ff       	call   1a42 <linkunlink>
  linktest();
    399b:	e8 a0 da ff ff       	call   1440 <linktest>
  unlinkread();
    39a0:	e8 c6 d8 ff ff       	call   126b <unlinkread>
  createdelete();
    39a5:	e8 10 d6 ff ff       	call   fba <createdelete>
  twofiles();
    39aa:	e8 a3 d3 ff ff       	call   d52 <twofiles>
  sharedfd();
    39af:	e8 a0 d1 ff ff       	call   b54 <sharedfd>
  dirfile();
    39b4:	e8 6d f0 ff ff       	call   2a26 <dirfile>
  iref();
    39b9:	e8 aa f2 ff ff       	call   2c68 <iref>
  forktest();
    39be:	e8 c9 f3 ff ff       	call   2d8c <forktest>
  bigdir(); // slow
    39c3:	e8 a8 e1 ff ff       	call   1b70 <bigdir>

  exectest();
    39c8:	e8 8e cc ff ff       	call   65b <exectest>

  exit();
    39cd:	e8 6a 02 00 00       	call   3c3c <exit>
    39d2:	66 90                	xchg   %ax,%ax

000039d4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    39d4:	55                   	push   %ebp
    39d5:	89 e5                	mov    %esp,%ebp
    39d7:	57                   	push   %edi
    39d8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    39d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
    39dc:	8b 55 10             	mov    0x10(%ebp),%edx
    39df:	8b 45 0c             	mov    0xc(%ebp),%eax
    39e2:	89 cb                	mov    %ecx,%ebx
    39e4:	89 df                	mov    %ebx,%edi
    39e6:	89 d1                	mov    %edx,%ecx
    39e8:	fc                   	cld    
    39e9:	f3 aa                	rep stos %al,%es:(%edi)
    39eb:	89 ca                	mov    %ecx,%edx
    39ed:	89 fb                	mov    %edi,%ebx
    39ef:	89 5d 08             	mov    %ebx,0x8(%ebp)
    39f2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    39f5:	5b                   	pop    %ebx
    39f6:	5f                   	pop    %edi
    39f7:	5d                   	pop    %ebp
    39f8:	c3                   	ret    

000039f9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    39f9:	55                   	push   %ebp
    39fa:	89 e5                	mov    %esp,%ebp
    39fc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    39ff:	8b 45 08             	mov    0x8(%ebp),%eax
    3a02:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3a05:	90                   	nop
    3a06:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a09:	0f b6 10             	movzbl (%eax),%edx
    3a0c:	8b 45 08             	mov    0x8(%ebp),%eax
    3a0f:	88 10                	mov    %dl,(%eax)
    3a11:	8b 45 08             	mov    0x8(%ebp),%eax
    3a14:	0f b6 00             	movzbl (%eax),%eax
    3a17:	84 c0                	test   %al,%al
    3a19:	0f 95 c0             	setne  %al
    3a1c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3a20:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    3a24:	84 c0                	test   %al,%al
    3a26:	75 de                	jne    3a06 <strcpy+0xd>
    ;
  return os;
    3a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3a2b:	c9                   	leave  
    3a2c:	c3                   	ret    

00003a2d <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3a2d:	55                   	push   %ebp
    3a2e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3a30:	eb 08                	jmp    3a3a <strcmp+0xd>
    p++, q++;
    3a32:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3a36:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3a3a:	8b 45 08             	mov    0x8(%ebp),%eax
    3a3d:	0f b6 00             	movzbl (%eax),%eax
    3a40:	84 c0                	test   %al,%al
    3a42:	74 10                	je     3a54 <strcmp+0x27>
    3a44:	8b 45 08             	mov    0x8(%ebp),%eax
    3a47:	0f b6 10             	movzbl (%eax),%edx
    3a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a4d:	0f b6 00             	movzbl (%eax),%eax
    3a50:	38 c2                	cmp    %al,%dl
    3a52:	74 de                	je     3a32 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3a54:	8b 45 08             	mov    0x8(%ebp),%eax
    3a57:	0f b6 00             	movzbl (%eax),%eax
    3a5a:	0f b6 d0             	movzbl %al,%edx
    3a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a60:	0f b6 00             	movzbl (%eax),%eax
    3a63:	0f b6 c0             	movzbl %al,%eax
    3a66:	89 d1                	mov    %edx,%ecx
    3a68:	29 c1                	sub    %eax,%ecx
    3a6a:	89 c8                	mov    %ecx,%eax
}
    3a6c:	5d                   	pop    %ebp
    3a6d:	c3                   	ret    

00003a6e <strlen>:

uint
strlen(char *s)
{
    3a6e:	55                   	push   %ebp
    3a6f:	89 e5                	mov    %esp,%ebp
    3a71:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3a74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3a7b:	eb 04                	jmp    3a81 <strlen+0x13>
    3a7d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3a81:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3a84:	8b 45 08             	mov    0x8(%ebp),%eax
    3a87:	01 d0                	add    %edx,%eax
    3a89:	0f b6 00             	movzbl (%eax),%eax
    3a8c:	84 c0                	test   %al,%al
    3a8e:	75 ed                	jne    3a7d <strlen+0xf>
    ;
  return n;
    3a90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3a93:	c9                   	leave  
    3a94:	c3                   	ret    

00003a95 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3a95:	55                   	push   %ebp
    3a96:	89 e5                	mov    %esp,%ebp
    3a98:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    3a9b:	8b 45 10             	mov    0x10(%ebp),%eax
    3a9e:	89 44 24 08          	mov    %eax,0x8(%esp)
    3aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
    3aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
    3aa9:	8b 45 08             	mov    0x8(%ebp),%eax
    3aac:	89 04 24             	mov    %eax,(%esp)
    3aaf:	e8 20 ff ff ff       	call   39d4 <stosb>
  return dst;
    3ab4:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3ab7:	c9                   	leave  
    3ab8:	c3                   	ret    

00003ab9 <strchr>:

char*
strchr(const char *s, char c)
{
    3ab9:	55                   	push   %ebp
    3aba:	89 e5                	mov    %esp,%ebp
    3abc:	83 ec 04             	sub    $0x4,%esp
    3abf:	8b 45 0c             	mov    0xc(%ebp),%eax
    3ac2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3ac5:	eb 14                	jmp    3adb <strchr+0x22>
    if(*s == c)
    3ac7:	8b 45 08             	mov    0x8(%ebp),%eax
    3aca:	0f b6 00             	movzbl (%eax),%eax
    3acd:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3ad0:	75 05                	jne    3ad7 <strchr+0x1e>
      return (char*)s;
    3ad2:	8b 45 08             	mov    0x8(%ebp),%eax
    3ad5:	eb 13                	jmp    3aea <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3ad7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3adb:	8b 45 08             	mov    0x8(%ebp),%eax
    3ade:	0f b6 00             	movzbl (%eax),%eax
    3ae1:	84 c0                	test   %al,%al
    3ae3:	75 e2                	jne    3ac7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3ae5:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3aea:	c9                   	leave  
    3aeb:	c3                   	ret    

00003aec <gets>:

char*
gets(char *buf, int max)
{
    3aec:	55                   	push   %ebp
    3aed:	89 e5                	mov    %esp,%ebp
    3aef:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3af2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3af9:	eb 46                	jmp    3b41 <gets+0x55>
    cc = read(0, &c, 1);
    3afb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3b02:	00 
    3b03:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3b06:	89 44 24 04          	mov    %eax,0x4(%esp)
    3b0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3b11:	e8 3e 01 00 00       	call   3c54 <read>
    3b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3b19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3b1d:	7e 2f                	jle    3b4e <gets+0x62>
      break;
    buf[i++] = c;
    3b1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3b22:	8b 45 08             	mov    0x8(%ebp),%eax
    3b25:	01 c2                	add    %eax,%edx
    3b27:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3b2b:	88 02                	mov    %al,(%edx)
    3b2d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
    3b31:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3b35:	3c 0a                	cmp    $0xa,%al
    3b37:	74 16                	je     3b4f <gets+0x63>
    3b39:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3b3d:	3c 0d                	cmp    $0xd,%al
    3b3f:	74 0e                	je     3b4f <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b44:	83 c0 01             	add    $0x1,%eax
    3b47:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3b4a:	7c af                	jl     3afb <gets+0xf>
    3b4c:	eb 01                	jmp    3b4f <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    3b4e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3b52:	8b 45 08             	mov    0x8(%ebp),%eax
    3b55:	01 d0                	add    %edx,%eax
    3b57:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3b5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3b5d:	c9                   	leave  
    3b5e:	c3                   	ret    

00003b5f <stat>:

int
stat(char *n, struct stat *st)
{
    3b5f:	55                   	push   %ebp
    3b60:	89 e5                	mov    %esp,%ebp
    3b62:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3b65:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3b6c:	00 
    3b6d:	8b 45 08             	mov    0x8(%ebp),%eax
    3b70:	89 04 24             	mov    %eax,(%esp)
    3b73:	e8 04 01 00 00       	call   3c7c <open>
    3b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3b7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b7f:	79 07                	jns    3b88 <stat+0x29>
    return -1;
    3b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3b86:	eb 23                	jmp    3bab <stat+0x4c>
  r = fstat(fd, st);
    3b88:	8b 45 0c             	mov    0xc(%ebp),%eax
    3b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
    3b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b92:	89 04 24             	mov    %eax,(%esp)
    3b95:	e8 fa 00 00 00       	call   3c94 <fstat>
    3b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ba0:	89 04 24             	mov    %eax,(%esp)
    3ba3:	e8 bc 00 00 00       	call   3c64 <close>
  return r;
    3ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3bab:	c9                   	leave  
    3bac:	c3                   	ret    

00003bad <atoi>:

int
atoi(const char *s)
{
    3bad:	55                   	push   %ebp
    3bae:	89 e5                	mov    %esp,%ebp
    3bb0:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3bb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3bba:	eb 23                	jmp    3bdf <atoi+0x32>
    n = n*10 + *s++ - '0';
    3bbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3bbf:	89 d0                	mov    %edx,%eax
    3bc1:	c1 e0 02             	shl    $0x2,%eax
    3bc4:	01 d0                	add    %edx,%eax
    3bc6:	01 c0                	add    %eax,%eax
    3bc8:	89 c2                	mov    %eax,%edx
    3bca:	8b 45 08             	mov    0x8(%ebp),%eax
    3bcd:	0f b6 00             	movzbl (%eax),%eax
    3bd0:	0f be c0             	movsbl %al,%eax
    3bd3:	01 d0                	add    %edx,%eax
    3bd5:	83 e8 30             	sub    $0x30,%eax
    3bd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3bdb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3bdf:	8b 45 08             	mov    0x8(%ebp),%eax
    3be2:	0f b6 00             	movzbl (%eax),%eax
    3be5:	3c 2f                	cmp    $0x2f,%al
    3be7:	7e 0a                	jle    3bf3 <atoi+0x46>
    3be9:	8b 45 08             	mov    0x8(%ebp),%eax
    3bec:	0f b6 00             	movzbl (%eax),%eax
    3bef:	3c 39                	cmp    $0x39,%al
    3bf1:	7e c9                	jle    3bbc <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3bf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3bf6:	c9                   	leave  
    3bf7:	c3                   	ret    

00003bf8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3bf8:	55                   	push   %ebp
    3bf9:	89 e5                	mov    %esp,%ebp
    3bfb:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3bfe:	8b 45 08             	mov    0x8(%ebp),%eax
    3c01:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3c04:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c07:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3c0a:	eb 13                	jmp    3c1f <memmove+0x27>
    *dst++ = *src++;
    3c0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3c0f:	0f b6 10             	movzbl (%eax),%edx
    3c12:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3c15:	88 10                	mov    %dl,(%eax)
    3c17:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3c1b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3c1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    3c23:	0f 9f c0             	setg   %al
    3c26:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    3c2a:	84 c0                	test   %al,%al
    3c2c:	75 de                	jne    3c0c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3c2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3c31:	c9                   	leave  
    3c32:	c3                   	ret    
    3c33:	90                   	nop

00003c34 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3c34:	b8 01 00 00 00       	mov    $0x1,%eax
    3c39:	cd 40                	int    $0x40
    3c3b:	c3                   	ret    

00003c3c <exit>:
SYSCALL(exit)
    3c3c:	b8 02 00 00 00       	mov    $0x2,%eax
    3c41:	cd 40                	int    $0x40
    3c43:	c3                   	ret    

00003c44 <wait>:
SYSCALL(wait)
    3c44:	b8 03 00 00 00       	mov    $0x3,%eax
    3c49:	cd 40                	int    $0x40
    3c4b:	c3                   	ret    

00003c4c <pipe>:
SYSCALL(pipe)
    3c4c:	b8 04 00 00 00       	mov    $0x4,%eax
    3c51:	cd 40                	int    $0x40
    3c53:	c3                   	ret    

00003c54 <read>:
SYSCALL(read)
    3c54:	b8 05 00 00 00       	mov    $0x5,%eax
    3c59:	cd 40                	int    $0x40
    3c5b:	c3                   	ret    

00003c5c <write>:
SYSCALL(write)
    3c5c:	b8 10 00 00 00       	mov    $0x10,%eax
    3c61:	cd 40                	int    $0x40
    3c63:	c3                   	ret    

00003c64 <close>:
SYSCALL(close)
    3c64:	b8 15 00 00 00       	mov    $0x15,%eax
    3c69:	cd 40                	int    $0x40
    3c6b:	c3                   	ret    

00003c6c <kill>:
SYSCALL(kill)
    3c6c:	b8 06 00 00 00       	mov    $0x6,%eax
    3c71:	cd 40                	int    $0x40
    3c73:	c3                   	ret    

00003c74 <exec>:
SYSCALL(exec)
    3c74:	b8 07 00 00 00       	mov    $0x7,%eax
    3c79:	cd 40                	int    $0x40
    3c7b:	c3                   	ret    

00003c7c <open>:
SYSCALL(open)
    3c7c:	b8 0f 00 00 00       	mov    $0xf,%eax
    3c81:	cd 40                	int    $0x40
    3c83:	c3                   	ret    

00003c84 <mknod>:
SYSCALL(mknod)
    3c84:	b8 11 00 00 00       	mov    $0x11,%eax
    3c89:	cd 40                	int    $0x40
    3c8b:	c3                   	ret    

00003c8c <unlink>:
SYSCALL(unlink)
    3c8c:	b8 12 00 00 00       	mov    $0x12,%eax
    3c91:	cd 40                	int    $0x40
    3c93:	c3                   	ret    

00003c94 <fstat>:
SYSCALL(fstat)
    3c94:	b8 08 00 00 00       	mov    $0x8,%eax
    3c99:	cd 40                	int    $0x40
    3c9b:	c3                   	ret    

00003c9c <link>:
SYSCALL(link)
    3c9c:	b8 13 00 00 00       	mov    $0x13,%eax
    3ca1:	cd 40                	int    $0x40
    3ca3:	c3                   	ret    

00003ca4 <mkdir>:
SYSCALL(mkdir)
    3ca4:	b8 14 00 00 00       	mov    $0x14,%eax
    3ca9:	cd 40                	int    $0x40
    3cab:	c3                   	ret    

00003cac <chdir>:
SYSCALL(chdir)
    3cac:	b8 09 00 00 00       	mov    $0x9,%eax
    3cb1:	cd 40                	int    $0x40
    3cb3:	c3                   	ret    

00003cb4 <dup>:
SYSCALL(dup)
    3cb4:	b8 0a 00 00 00       	mov    $0xa,%eax
    3cb9:	cd 40                	int    $0x40
    3cbb:	c3                   	ret    

00003cbc <getpid>:
SYSCALL(getpid)
    3cbc:	b8 0b 00 00 00       	mov    $0xb,%eax
    3cc1:	cd 40                	int    $0x40
    3cc3:	c3                   	ret    

00003cc4 <sbrk>:
SYSCALL(sbrk)
    3cc4:	b8 0c 00 00 00       	mov    $0xc,%eax
    3cc9:	cd 40                	int    $0x40
    3ccb:	c3                   	ret    

00003ccc <sleep>:
SYSCALL(sleep)
    3ccc:	b8 0d 00 00 00       	mov    $0xd,%eax
    3cd1:	cd 40                	int    $0x40
    3cd3:	c3                   	ret    

00003cd4 <uptime>:
SYSCALL(uptime)
    3cd4:	b8 0e 00 00 00       	mov    $0xe,%eax
    3cd9:	cd 40                	int    $0x40
    3cdb:	c3                   	ret    

00003cdc <halt>:
SYSCALL(halt)
    3cdc:	b8 16 00 00 00       	mov    $0x16,%eax
    3ce1:	cd 40                	int    $0x40
    3ce3:	c3                   	ret    

00003ce4 <alarm>:
    3ce4:	b8 17 00 00 00       	mov    $0x17,%eax
    3ce9:	cd 40                	int    $0x40
    3ceb:	c3                   	ret    

00003cec <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3cec:	55                   	push   %ebp
    3ced:	89 e5                	mov    %esp,%ebp
    3cef:	83 ec 28             	sub    $0x28,%esp
    3cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cf5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3cf8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3cff:	00 
    3d00:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3d03:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d07:	8b 45 08             	mov    0x8(%ebp),%eax
    3d0a:	89 04 24             	mov    %eax,(%esp)
    3d0d:	e8 4a ff ff ff       	call   3c5c <write>
}
    3d12:	c9                   	leave  
    3d13:	c3                   	ret    

00003d14 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3d14:	55                   	push   %ebp
    3d15:	89 e5                	mov    %esp,%ebp
    3d17:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3d1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3d21:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3d25:	74 17                	je     3d3e <printint+0x2a>
    3d27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3d2b:	79 11                	jns    3d3e <printint+0x2a>
    neg = 1;
    3d2d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3d34:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d37:	f7 d8                	neg    %eax
    3d39:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3d3c:	eb 06                	jmp    3d44 <printint+0x30>
  } else {
    x = xx;
    3d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d41:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3d44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3d4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3d4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3d51:	ba 00 00 00 00       	mov    $0x0,%edx
    3d56:	f7 f1                	div    %ecx
    3d58:	89 d0                	mov    %edx,%eax
    3d5a:	0f b6 80 f8 5e 00 00 	movzbl 0x5ef8(%eax),%eax
    3d61:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    3d64:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3d67:	01 ca                	add    %ecx,%edx
    3d69:	88 02                	mov    %al,(%edx)
    3d6b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
    3d6f:	8b 55 10             	mov    0x10(%ebp),%edx
    3d72:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    3d75:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3d78:	ba 00 00 00 00       	mov    $0x0,%edx
    3d7d:	f7 75 d4             	divl   -0x2c(%ebp)
    3d80:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3d83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3d87:	75 c2                	jne    3d4b <printint+0x37>
  if(neg)
    3d89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3d8d:	74 2e                	je     3dbd <printint+0xa9>
    buf[i++] = '-';
    3d8f:	8d 55 dc             	lea    -0x24(%ebp),%edx
    3d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d95:	01 d0                	add    %edx,%eax
    3d97:	c6 00 2d             	movb   $0x2d,(%eax)
    3d9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
    3d9e:	eb 1d                	jmp    3dbd <printint+0xa9>
    putc(fd, buf[i]);
    3da0:	8d 55 dc             	lea    -0x24(%ebp),%edx
    3da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3da6:	01 d0                	add    %edx,%eax
    3da8:	0f b6 00             	movzbl (%eax),%eax
    3dab:	0f be c0             	movsbl %al,%eax
    3dae:	89 44 24 04          	mov    %eax,0x4(%esp)
    3db2:	8b 45 08             	mov    0x8(%ebp),%eax
    3db5:	89 04 24             	mov    %eax,(%esp)
    3db8:	e8 2f ff ff ff       	call   3cec <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    3dbd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    3dc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3dc5:	79 d9                	jns    3da0 <printint+0x8c>
    putc(fd, buf[i]);
}
    3dc7:	c9                   	leave  
    3dc8:	c3                   	ret    

00003dc9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    3dc9:	55                   	push   %ebp
    3dca:	89 e5                	mov    %esp,%ebp
    3dcc:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    3dcf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    3dd6:	8d 45 0c             	lea    0xc(%ebp),%eax
    3dd9:	83 c0 04             	add    $0x4,%eax
    3ddc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    3ddf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3de6:	e9 7d 01 00 00       	jmp    3f68 <printf+0x19f>
    c = fmt[i] & 0xff;
    3deb:	8b 55 0c             	mov    0xc(%ebp),%edx
    3dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3df1:	01 d0                	add    %edx,%eax
    3df3:	0f b6 00             	movzbl (%eax),%eax
    3df6:	0f be c0             	movsbl %al,%eax
    3df9:	25 ff 00 00 00       	and    $0xff,%eax
    3dfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    3e01:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3e05:	75 2c                	jne    3e33 <printf+0x6a>
      if(c == '%'){
    3e07:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    3e0b:	75 0c                	jne    3e19 <printf+0x50>
        state = '%';
    3e0d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    3e14:	e9 4b 01 00 00       	jmp    3f64 <printf+0x19b>
      } else {
        putc(fd, c);
    3e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3e1c:	0f be c0             	movsbl %al,%eax
    3e1f:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e23:	8b 45 08             	mov    0x8(%ebp),%eax
    3e26:	89 04 24             	mov    %eax,(%esp)
    3e29:	e8 be fe ff ff       	call   3cec <putc>
    3e2e:	e9 31 01 00 00       	jmp    3f64 <printf+0x19b>
      }
    } else if(state == '%'){
    3e33:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    3e37:	0f 85 27 01 00 00    	jne    3f64 <printf+0x19b>
      if(c == 'd'){
    3e3d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    3e41:	75 2d                	jne    3e70 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    3e43:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3e46:	8b 00                	mov    (%eax),%eax
    3e48:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    3e4f:	00 
    3e50:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    3e57:	00 
    3e58:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e5c:	8b 45 08             	mov    0x8(%ebp),%eax
    3e5f:	89 04 24             	mov    %eax,(%esp)
    3e62:	e8 ad fe ff ff       	call   3d14 <printint>
        ap++;
    3e67:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3e6b:	e9 ed 00 00 00       	jmp    3f5d <printf+0x194>
      } else if(c == 'x' || c == 'p'){
    3e70:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    3e74:	74 06                	je     3e7c <printf+0xb3>
    3e76:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    3e7a:	75 2d                	jne    3ea9 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    3e7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3e7f:	8b 00                	mov    (%eax),%eax
    3e81:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    3e88:	00 
    3e89:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    3e90:	00 
    3e91:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e95:	8b 45 08             	mov    0x8(%ebp),%eax
    3e98:	89 04 24             	mov    %eax,(%esp)
    3e9b:	e8 74 fe ff ff       	call   3d14 <printint>
        ap++;
    3ea0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3ea4:	e9 b4 00 00 00       	jmp    3f5d <printf+0x194>
      } else if(c == 's'){
    3ea9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    3ead:	75 46                	jne    3ef5 <printf+0x12c>
        s = (char*)*ap;
    3eaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3eb2:	8b 00                	mov    (%eax),%eax
    3eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    3eb7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    3ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3ebf:	75 27                	jne    3ee8 <printf+0x11f>
          s = "(null)";
    3ec1:	c7 45 f4 5e 58 00 00 	movl   $0x585e,-0xc(%ebp)
        while(*s != 0){
    3ec8:	eb 1e                	jmp    3ee8 <printf+0x11f>
          putc(fd, *s);
    3eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ecd:	0f b6 00             	movzbl (%eax),%eax
    3ed0:	0f be c0             	movsbl %al,%eax
    3ed3:	89 44 24 04          	mov    %eax,0x4(%esp)
    3ed7:	8b 45 08             	mov    0x8(%ebp),%eax
    3eda:	89 04 24             	mov    %eax,(%esp)
    3edd:	e8 0a fe ff ff       	call   3cec <putc>
          s++;
    3ee2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3ee6:	eb 01                	jmp    3ee9 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    3ee8:	90                   	nop
    3ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3eec:	0f b6 00             	movzbl (%eax),%eax
    3eef:	84 c0                	test   %al,%al
    3ef1:	75 d7                	jne    3eca <printf+0x101>
    3ef3:	eb 68                	jmp    3f5d <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3ef5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    3ef9:	75 1d                	jne    3f18 <printf+0x14f>
        putc(fd, *ap);
    3efb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3efe:	8b 00                	mov    (%eax),%eax
    3f00:	0f be c0             	movsbl %al,%eax
    3f03:	89 44 24 04          	mov    %eax,0x4(%esp)
    3f07:	8b 45 08             	mov    0x8(%ebp),%eax
    3f0a:	89 04 24             	mov    %eax,(%esp)
    3f0d:	e8 da fd ff ff       	call   3cec <putc>
        ap++;
    3f12:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3f16:	eb 45                	jmp    3f5d <printf+0x194>
      } else if(c == '%'){
    3f18:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    3f1c:	75 17                	jne    3f35 <printf+0x16c>
        putc(fd, c);
    3f1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3f21:	0f be c0             	movsbl %al,%eax
    3f24:	89 44 24 04          	mov    %eax,0x4(%esp)
    3f28:	8b 45 08             	mov    0x8(%ebp),%eax
    3f2b:	89 04 24             	mov    %eax,(%esp)
    3f2e:	e8 b9 fd ff ff       	call   3cec <putc>
    3f33:	eb 28                	jmp    3f5d <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    3f35:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    3f3c:	00 
    3f3d:	8b 45 08             	mov    0x8(%ebp),%eax
    3f40:	89 04 24             	mov    %eax,(%esp)
    3f43:	e8 a4 fd ff ff       	call   3cec <putc>
        putc(fd, c);
    3f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3f4b:	0f be c0             	movsbl %al,%eax
    3f4e:	89 44 24 04          	mov    %eax,0x4(%esp)
    3f52:	8b 45 08             	mov    0x8(%ebp),%eax
    3f55:	89 04 24             	mov    %eax,(%esp)
    3f58:	e8 8f fd ff ff       	call   3cec <putc>
      }
      state = 0;
    3f5d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3f64:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3f68:	8b 55 0c             	mov    0xc(%ebp),%edx
    3f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3f6e:	01 d0                	add    %edx,%eax
    3f70:	0f b6 00             	movzbl (%eax),%eax
    3f73:	84 c0                	test   %al,%al
    3f75:	0f 85 70 fe ff ff    	jne    3deb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    3f7b:	c9                   	leave  
    3f7c:	c3                   	ret    
    3f7d:	66 90                	xchg   %ax,%ax
    3f7f:	90                   	nop

00003f80 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3f80:	55                   	push   %ebp
    3f81:	89 e5                	mov    %esp,%ebp
    3f83:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3f86:	8b 45 08             	mov    0x8(%ebp),%eax
    3f89:	83 e8 08             	sub    $0x8,%eax
    3f8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3f8f:	a1 a8 5f 00 00       	mov    0x5fa8,%eax
    3f94:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3f97:	eb 24                	jmp    3fbd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3f99:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f9c:	8b 00                	mov    (%eax),%eax
    3f9e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3fa1:	77 12                	ja     3fb5 <free+0x35>
    3fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fa6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3fa9:	77 24                	ja     3fcf <free+0x4f>
    3fab:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fae:	8b 00                	mov    (%eax),%eax
    3fb0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    3fb3:	77 1a                	ja     3fcf <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3fb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fb8:	8b 00                	mov    (%eax),%eax
    3fba:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3fbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fc0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3fc3:	76 d4                	jbe    3f99 <free+0x19>
    3fc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fc8:	8b 00                	mov    (%eax),%eax
    3fca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    3fcd:	76 ca                	jbe    3f99 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    3fcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fd2:	8b 40 04             	mov    0x4(%eax),%eax
    3fd5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    3fdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fdf:	01 c2                	add    %eax,%edx
    3fe1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fe4:	8b 00                	mov    (%eax),%eax
    3fe6:	39 c2                	cmp    %eax,%edx
    3fe8:	75 24                	jne    400e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    3fea:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fed:	8b 50 04             	mov    0x4(%eax),%edx
    3ff0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3ff3:	8b 00                	mov    (%eax),%eax
    3ff5:	8b 40 04             	mov    0x4(%eax),%eax
    3ff8:	01 c2                	add    %eax,%edx
    3ffa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3ffd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    4000:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4003:	8b 00                	mov    (%eax),%eax
    4005:	8b 10                	mov    (%eax),%edx
    4007:	8b 45 f8             	mov    -0x8(%ebp),%eax
    400a:	89 10                	mov    %edx,(%eax)
    400c:	eb 0a                	jmp    4018 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    400e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4011:	8b 10                	mov    (%eax),%edx
    4013:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4016:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    4018:	8b 45 fc             	mov    -0x4(%ebp),%eax
    401b:	8b 40 04             	mov    0x4(%eax),%eax
    401e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4025:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4028:	01 d0                	add    %edx,%eax
    402a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    402d:	75 20                	jne    404f <free+0xcf>
    p->s.size += bp->s.size;
    402f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4032:	8b 50 04             	mov    0x4(%eax),%edx
    4035:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4038:	8b 40 04             	mov    0x4(%eax),%eax
    403b:	01 c2                	add    %eax,%edx
    403d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4040:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    4043:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4046:	8b 10                	mov    (%eax),%edx
    4048:	8b 45 fc             	mov    -0x4(%ebp),%eax
    404b:	89 10                	mov    %edx,(%eax)
    404d:	eb 08                	jmp    4057 <free+0xd7>
  } else
    p->s.ptr = bp;
    404f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4052:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4055:	89 10                	mov    %edx,(%eax)
  freep = p;
    4057:	8b 45 fc             	mov    -0x4(%ebp),%eax
    405a:	a3 a8 5f 00 00       	mov    %eax,0x5fa8
}
    405f:	c9                   	leave  
    4060:	c3                   	ret    

00004061 <morecore>:

static Header*
morecore(uint nu)
{
    4061:	55                   	push   %ebp
    4062:	89 e5                	mov    %esp,%ebp
    4064:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    4067:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    406e:	77 07                	ja     4077 <morecore+0x16>
    nu = 4096;
    4070:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    4077:	8b 45 08             	mov    0x8(%ebp),%eax
    407a:	c1 e0 03             	shl    $0x3,%eax
    407d:	89 04 24             	mov    %eax,(%esp)
    4080:	e8 3f fc ff ff       	call   3cc4 <sbrk>
    4085:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    4088:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    408c:	75 07                	jne    4095 <morecore+0x34>
    return 0;
    408e:	b8 00 00 00 00       	mov    $0x0,%eax
    4093:	eb 22                	jmp    40b7 <morecore+0x56>
  hp = (Header*)p;
    4095:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4098:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    409b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    409e:	8b 55 08             	mov    0x8(%ebp),%edx
    40a1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    40a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    40a7:	83 c0 08             	add    $0x8,%eax
    40aa:	89 04 24             	mov    %eax,(%esp)
    40ad:	e8 ce fe ff ff       	call   3f80 <free>
  return freep;
    40b2:	a1 a8 5f 00 00       	mov    0x5fa8,%eax
}
    40b7:	c9                   	leave  
    40b8:	c3                   	ret    

000040b9 <malloc>:

void*
malloc(uint nbytes)
{
    40b9:	55                   	push   %ebp
    40ba:	89 e5                	mov    %esp,%ebp
    40bc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    40bf:	8b 45 08             	mov    0x8(%ebp),%eax
    40c2:	83 c0 07             	add    $0x7,%eax
    40c5:	c1 e8 03             	shr    $0x3,%eax
    40c8:	83 c0 01             	add    $0x1,%eax
    40cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    40ce:	a1 a8 5f 00 00       	mov    0x5fa8,%eax
    40d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    40d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    40da:	75 23                	jne    40ff <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    40dc:	c7 45 f0 a0 5f 00 00 	movl   $0x5fa0,-0x10(%ebp)
    40e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    40e6:	a3 a8 5f 00 00       	mov    %eax,0x5fa8
    40eb:	a1 a8 5f 00 00       	mov    0x5fa8,%eax
    40f0:	a3 a0 5f 00 00       	mov    %eax,0x5fa0
    base.s.size = 0;
    40f5:	c7 05 a4 5f 00 00 00 	movl   $0x0,0x5fa4
    40fc:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    40ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4102:	8b 00                	mov    (%eax),%eax
    4104:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4107:	8b 45 f4             	mov    -0xc(%ebp),%eax
    410a:	8b 40 04             	mov    0x4(%eax),%eax
    410d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    4110:	72 4d                	jb     415f <malloc+0xa6>
      if(p->s.size == nunits)
    4112:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4115:	8b 40 04             	mov    0x4(%eax),%eax
    4118:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    411b:	75 0c                	jne    4129 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    411d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4120:	8b 10                	mov    (%eax),%edx
    4122:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4125:	89 10                	mov    %edx,(%eax)
    4127:	eb 26                	jmp    414f <malloc+0x96>
      else {
        p->s.size -= nunits;
    4129:	8b 45 f4             	mov    -0xc(%ebp),%eax
    412c:	8b 40 04             	mov    0x4(%eax),%eax
    412f:	89 c2                	mov    %eax,%edx
    4131:	2b 55 ec             	sub    -0x14(%ebp),%edx
    4134:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4137:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    413a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    413d:	8b 40 04             	mov    0x4(%eax),%eax
    4140:	c1 e0 03             	shl    $0x3,%eax
    4143:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    4146:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4149:	8b 55 ec             	mov    -0x14(%ebp),%edx
    414c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    414f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4152:	a3 a8 5f 00 00       	mov    %eax,0x5fa8
      return (void*)(p + 1);
    4157:	8b 45 f4             	mov    -0xc(%ebp),%eax
    415a:	83 c0 08             	add    $0x8,%eax
    415d:	eb 38                	jmp    4197 <malloc+0xde>
    }
    if(p == freep)
    415f:	a1 a8 5f 00 00       	mov    0x5fa8,%eax
    4164:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    4167:	75 1b                	jne    4184 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    4169:	8b 45 ec             	mov    -0x14(%ebp),%eax
    416c:	89 04 24             	mov    %eax,(%esp)
    416f:	e8 ed fe ff ff       	call   4061 <morecore>
    4174:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4177:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    417b:	75 07                	jne    4184 <malloc+0xcb>
        return 0;
    417d:	b8 00 00 00 00       	mov    $0x0,%eax
    4182:	eb 13                	jmp    4197 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4184:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4187:	89 45 f0             	mov    %eax,-0x10(%ebp)
    418a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    418d:	8b 00                	mov    (%eax),%eax
    418f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    4192:	e9 70 ff ff ff       	jmp    4107 <malloc+0x4e>
}
    4197:	c9                   	leave  
    4198:	c3                   	ret    
