--trigger para sempre que um automovel for 
--alugado ele não estar mais disponivel 

CREATE TRIGGER trg_indisponibilizar_veiculo
AFTER INSERT ON aluguel
FOR EACH ROW
UPDATE veiculo
SET disponivel = FALSE
WHERE id_veiculo = NEW.id_veiculo;


--select 
SELECT id_veiculo, modelo, disponivel
FROM veiculo
WHERE id_veiculo = 1;


--insert do automovel em aluguel 
INSERT INTO aluguel
(
    id_locador,
    id_locatario,
    id_veiculo,
    data_reserva,
    data_retirada,
    data_prevista_devolucao,
    status,
    valor_total
)
VALUES
(
    6,
    1,
    1,
    CURDATE(),
    CURDATE(),
    DATE_ADD(CURDATE(), INTERVAL 3 DAY),
    'Reservado',
    360.00
);

--verificação

SELECT id_veiculo, modelo, disponivel
FROM veiculo
WHERE id_veiculo = 1;
