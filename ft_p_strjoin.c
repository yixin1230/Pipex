/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   ft_p_strjoin.c                                     :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2022/10/17 14:27:29 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/20 16:50:37 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

char	*ft_p_strjoin(char const *s1, char const *s2)
{
	int		i;
	int		len;
	char	*s3;

	i = 0;
	len = 0;
	s3 = malloc((ft_strlen(s1)+ft_strlen(s2) + 1) * sizeof(char));
	if (!s3)
		exit(1);
	while (s1[i])
	{
		s3[len] = s1[i];
		i++;
		len++;
	}
	i = 0;
	while (s2[i])
	{
		s3[len] = s2[i];
		i++;
		len++;
	}
	s3[len] = '\0';
	return (s3);
}
