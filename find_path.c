/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   find_path.c                                        :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/07 10:28:16 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/21 16:23:22 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	print_error(char *str, int i)
{
	if (i == 3)
	{
		ft_putstr_fd("Error: bad arguments\n", 2);
		exit(1);
	}
	if (i == 0)
		ft_putstr_fd(strerror(errno), 2);
	else if (i == 2)
		ft_putstr_fd("Command not found", 2);
	ft_putstr_fd(": ", 2);
	ft_putstr_fd(str, 2);
	ft_putstr_fd("\n", 2);
	exit(1);
}

int	check_envp(char **envp)
{
	int		i;

	i = 0;
	while (envp[i])
	{
		if (ft_strnstr(envp[i], "PATH", 4) != NULL)
			break ;
		i++;
	}
	if (!envp[i])
		return (-1);
	return (i);
}

char	*find_path(char *cmd, char **envp)
{
	int		i;
	char	*path;
	char	*path_undone;
	char	**envp_paths;

	i = check_envp(envp);
	if (i < 0)
		return (NULL);
	envp_paths = ft_p_split(envp[i] + 5, ':');
	i = -1;
	while (envp_paths[++i])
	{
		path_undone = ft_p_strjoin(envp_paths[i], "/");
		path = ft_p_strjoin(path_undone, cmd);
		free(path_undone);
		if (access(path, F_OK) == 0)
		{
			free_2dstr(envp_paths);
			return (path);
		}
		free(path);
	}
	free_2dstr(envp_paths);
	return (NULL);
}

void	run(char *argv, char **envp)
{
	char	**cmd;
	char	*path;
	int		i;

	i = 0;
	cmd = ft_p_split(argv, ' ');
	if (!*cmd)
		print_error(argv, 2);
	if (access(argv, F_OK) == 0)
		path = argv;
	else if (access(cmd[0], F_OK) == 0)
		path = cmd[0];
	else
		path = find_path(cmd[0], envp);
	if (!path)
	{
		if (ft_strchr(cmd[0], '/') != NULL)
			print_error(cmd[0], 1);
		else
			print_error(cmd[0], 2);
		free_2dstr(cmd);
		exit(1);
	}
	if (execve(path, cmd, envp) == -1)
		print_error(argv, 0);
	exit (0);
}

void	free_2dstr(char **str)
{
	int	i;

	i = 0;
	while (str[i])
	{
		free(str[i]);
		i++;
	}
	free(str);
}
