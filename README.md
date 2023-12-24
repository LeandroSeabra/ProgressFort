# Barra de Progresso para Fortran

O `ProgressFort` é um módulo Fortran projetado para facilitar a criação e o gerenciamento de barras de progresso em aplicações de console. Ele oferece uma forma eficaz de visualizar o progresso de tarefas de longa duração.

## Características

- **Monitoramento do Tempo:** Utiliza funções de tempo de CPU e de sistema para acompanhar o progresso das tarefas.
- **Visualização Colorida:** Emprega códigos de cores ANSI para uma exibição clara e atrativa da barra de progresso.
- **Controle Detalhado:** Permite ajustes finos, como a definição da largura da barra de progresso.

## Utilização

Para usar o `ProgressFort`, inclua-o no seu projeto Fortran e chame suas sub-rotinas conforme necessário para iniciar o temporizador, monitorar o progresso e finalizar o temporizador.

### Exemplo Básico

```fortran
program teste
    use ProgressFort

    call start_timer(n) 
    do i = 1, n
        ! seu código aqui
        call monitor_progress(i)
    end do
    call end_timer()

end program teste

## Sub-rotinas

- **start_timer:** Inicia o temporizador para a operação.
- **monitor_progress:** Atualiza a barra de progresso com base no progresso atual da tarefa.
- **end_timer:** Encerra o temporizador e exibe o tempo total decorrido.

## Atualizações Futuras

- **Suporte a Diferentes Tipos de Progresso:** Planejamos adicionar suporte a outras formas de progresso, como progressões exponenciais (2n, 3n, etc.), tornando o módulo mais versátil para diferentes tipos de aplicações.
- **Personalização Avançada:** Implementação de opções para personalizar ainda mais a aparência da barra de progresso, incluindo cores e formatos personalizados.
- **Otimização de Desempenho:** Melhorias no desempenho do módulo, garantindo que ele seja leve e não impacte negativamente o desempenho das aplicações.
- **Integração com Outras Bibliotecas:** Explorar a integração com outras bibliotecas Fortran para expandir as funcionalidades e usos do módulo.

## Licença

Este projeto está sob a Licença Apache 2.0. Consulte o arquivo `LICENSE` para mais detalhes.
