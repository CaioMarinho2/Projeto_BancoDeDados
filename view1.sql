--view para ver dados especificos do aluguel 

CREATE VIEW vw_relatorio_alugueis AS
SELECT
    a.id_aluguel,
    ul.nome AS locador,
    ut.nome AS locatario,
    v.modelo,
    v.placa,
    a.data_retirada,
    a.data_prevista_devolucao,
    a.status,
    a.valor_total
FROM aluguel a
JOIN usuario ul
    ON a.id_locador = ul.id_usuario
JOIN usuario ut
    ON a.id_locatario = ut.id_usuario
JOIN veiculo v
    ON a.id_veiculo = v.id_veiculo;

