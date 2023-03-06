/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   main.c                                             :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <zhaozicen951230@gmail.com>          +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/03 15:37:21 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/06 20:20:55 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

int	main(int argc, char **argv, char **envp)
{
	pid_t	id;
	if (argc != 5)
		//print error and return or free something
	id = fork();
	if (id == -1)
		return (1);
	if (id == 0)
		child();//child play
	//wait child dead
	//parent play
	return (0);
}
child()//open the infile as input + cmd1 -> end[1] as output
//end[1] pipe end[0] 
parent()//end[0] as input + cmd2 -> outfile as output