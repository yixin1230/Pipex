/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   b_utils.c                                          :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/09 12:30:34 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/12 18:10:52 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

char	*get_next_line(int fd);

char	*get_next_line(int fd)
{
	int		i;
	int		j;
	char	buff;
	char	*str;

	i = 8;
	j = 0;
	str = malloc(7000);
	while (i)
	{
		i = read(fd, &buff, 1);
		if (i < 0)
			return (NULL);
		if (buff == '\n')
			break ;
		if (i > 0)
			str[j] = buff;
		j++;
	}
	str[j] = '\0';
	return (ft_strdup(str));
}
