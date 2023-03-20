/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   pipex.h                                            :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <zhaozicen951230@gmail.com>          +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/03 15:34:15 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/20 18:50:09 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#ifndef PIPEX_H
# define PIPEX_H

# include <unistd.h>
# include <fcntl.h>
# include <stdio.h>
# include <string.h>
# include <errno.h>
# include <sys/wait.h>
# include "ft_printf/ft_printf.h"

void	run(char *argv, char **envp);
char	*find_path(char *cmd, char **envp);
void	print_error(char *str, int i);
void	child_process(int *fd, char **argv, char **envp);
void	parent_process(int *fd, char **argv, char **envp);
void	redirect_close_run(int in, int out, char *argv, char **envp);
int		check_envp(char **envp);
void	leaks(void);

char	*get_next_line(int fd);
void	here_doc(char *limiter);
void	b_child_process(char *argv, char **envp);
void	free_2dstr(char **str);
void	here_doc_child(int *fd, char *str, char *limiter);
int		set_infile_outfile(char **argv, int argc, int *infile, int *outfile);
char	**ft_p_split(char const *s, char c);
char	*ft_p_strjoin(char const *s1, char const *s2);

#endif