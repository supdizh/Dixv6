	.text

/* Switch from current_thread to next_thread. Make next_thread
 * the current_thread, and set next_thread to 0.
 * Use eax as a temporary register, which should be caller saved.
 */
	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	pushal			/*8register,32byte,0x20 address on to current_thread stack*/
	movl	current_thread,%eax
	movl	%esp,(%eax)	/*save esp into sp*/
	movl	next_thread, %eax
	movl	%eax,current_thread
	movl	$0,next_thread
	movl	current_thread,%eax
	movl	(%eax),%esp
	popal
	ret				/* pop return address from stack */
