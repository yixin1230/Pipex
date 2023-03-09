# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: yizhang <zhaozicen951230@gmail.com>          +#+                      #
#                                                    +#+                       #
#    Created: 2023/03/03 15:44:45 by yizhang       #+#    #+#                  #
#    Updated: 2023/03/09 18:04:06 by yizhang       ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

NAME = pipex
B_NAME = pipex_b
CC = gcc
FLAG = -Wall -Werror -Wextra
FT_PRINTF = ft_printf/libftprintf.a
SRC = find_path.c main.c 
OBJ = ${SRC:.c=.o}
B_SRC = find_path.c b_utils.c b_main.c
B_OBJ = ${B_SRC.c=.o}

all: ${NAME}

bonus: ${B_NAME}

${NAME}: ${FT_PRINTF} ${OBJ}
		@${CC} ${FLAG} ${FT_PRINTF} ${OBJ} -o ${NAME}

${B_NAME}: ${FT_PRINTF} ${B_OBJ}
		@${CC} ${FLAG} ${FT_PRINTF} ${B_OBJ} -o ${B_NAME}

${OBJ}: ${SRC}
		@${CC} ${FLAG} -c ${SRC}

${B_OBJ}: ${B_SRC}
		@${CC} ${FLAG} -c ${B_SRC}

${FT_PRINTF}:
	@make -C ft_printf

clean:
	@rm -rf ${OBJ}
	@rm -rf ${B_OBJ}
	@make clean -C ft_printf

fclean:clean
	@rm -rf ${NAME}
	@rm -rf ${B_NAME}
	@make fclean -C ft_printf

re:fclean all

.PHONY: all clean fclean re bonus
