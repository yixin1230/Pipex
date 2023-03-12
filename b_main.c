/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   b_main.c                                           :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/09 09:11:57 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/12 18:07:43 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

//loop thoufgh child process
//child process : create a fork and pipe, put the output inside a pipe and then close with 
//the run function. The main process will change his stdin for the pipe file descriptor.
void	here_doc(char *limiter);

void	here_doc(char *limiter)
{
	char	*str;
	char	*tmp;
	int		fd[2];
	pid_t	id;

	if (pipe(fd) == -1)
		print_error("0", 0);
	id = fork();
	if (id < 0)
		print_error("0", 0);
	if (id == 0)
	{
		close(fd[0]);
		str = get_next_line(0);
		ft_printf("%s",str);
		while (str)
		{
			if (ft_strncmp(str, limiter, ft_strlen(limiter)) == 0)
			{
				free(str);
				close(fd[1]);
				return ;
			}
			ft_printf("%s",str);
			write(fd[1], str, ft_strlen(str));
			tmp = str;
			str = get_next_line(0);
			free(tmp);
		}
	}
	else
	{
		close(fd[1]);
		wait(NULL);
	}
}

int	main(int argc, char **argv, char **envp)
{
	int	infile;
	int	outfile;
	int	i;
	char	**tmp;

	tmp = envp;
	if (argc < 5)
	{
		ft_putstr_fd("Error: Bad arguments\n", 2);
		exit(1);
	}
	if (ft_strncmp(argv[1], "here_doc", 8) == 0)
	{
		i = 3;
		outfile = open(argv[argc - 1], O_WRONLY | O_CREAT | O_APPEND, 0777);
		here_doc(argv[2]);
	}
	else
	{
		i = 2;
		infile = open(argv[1], O_RDONLY, 0777);
		outfile = open(argv[argc - 1], O_WRONLY | O_CREAT | O_TRUNC, 0777);
	}
	while (i < argc - 2)
	{
		b_child_process(argv[i], envp);
		i++;
	}
	dup2(outfile, 1);
	run(argv[argc - 2],envp);
	close(outfile);
}
