/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   main.c                                             :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <zhaozicen951230@gmail.com>          +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/03 15:37:21 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/07 12:14:45 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

//child_process()//open the infile as input + cmd1 -> end[1] as output
//end[1] pipe end[0] 
//parent_process()//end[0] as input + cmd2 -> outfile as output

void	child_process(int *fd, char **argv, char **envp)
{
	int	infile;

	close(fd[0]);
	infile = open(argv[1], O_RDONLY);
	if (infile == -1)
	{
		ft_printf("error\n");
		return ;
	}
	dup2(infile, 0);
	dup2(fd[1], 1);
	run(argv,envp);
	close(fd[1]);
	
}

void	parent_process(int *fd, char **argv, char **envp)
{
	int	outfile;

	close(fd[1]);
	outfile = open(argv[4], O_RDONLY | O_CREAT);
	if (outfile == -1)
	{
		ft_printf("error\n");
		return ;
	}
	dup2(fd[0], 0);
	dup2(outfile, 1);
	run(argv,envp);
	execve("/bin/cat", str, envp);
	close(fd[0]);
}

int	main(int argc, char **argv, char **envp)
{
	pid_t	id;
	int		fd[2];

	if (argc != 5 || pipe(fd) == -1)
	{
		ft_printf("error\n");
		return (1);
	}
	id = fork();
	if (id == -1)
		return (1);
	if (id == 0)
		child_process(fd, argv, envp);
	waitpid(id, NULL, 0);
	parent_process(fd, argv, envp);
	return (0);
}
