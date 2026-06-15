--view para ver as avaliações dos veiculos

CREATE VIEW vw_avaliacao_veiculos AS
SELECT
    v.id_veiculo,
    v.modelo,
    v.placa,
    ROUND(AVG(a.nota),2) AS media_avaliacao,
    COUNT(a.id_avaliacao) AS total_avaliacoes
FROM veiculo v
LEFT JOIN avaliacao a
    ON v.id_veiculo = a.id_veiculo
GROUP BY
    v.id_veiculo,
    v.modelo,
    v.placa;
