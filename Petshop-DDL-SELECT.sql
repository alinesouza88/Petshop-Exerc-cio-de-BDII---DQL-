SELECT
    E.nome AS 'Nome Empregado',
    E.cpf AS 'CPF Empregado',
    DATE_FORMAT(E.dataAdm, '%Y-%m-%d') AS 'Data Admissão',
    CONCAT('R$ ', FORMAT(E.salario, 2)) AS 'Salário',
    D.nome AS 'Departamento',
    GROUP_CONCAT(T.numero SEPARATOR ', ') AS 'Número De Telefone'
FROM
    Empregado E
INNER JOIN
    Departamento D ON E.Departamento_idDepartamento = D.idDepartamento
LEFT JOIN
    Telefone T ON E.cpf = T.Empregado_cpf
WHERE
    E.dataAdm BETWEEN '2019-01-01' AND '2022-03-31'
GROUP BY
    E.cpf, E.nome, E.dataAdm, E.salario, D.nome
ORDER BY
    E.dataAdm DESC;
    
    
SELECT
    e.nome AS 'Nome Empregado',
    e.cpf AS 'CPF Empregado',
    DATE_FORMAT(e.dataadm, '%d-%m-%Y') AS 'Data Admissão',
    CONCAT('R$ ', FORMAT(e.salario, 2)) AS 'Salário',
    d.nome AS 'Departamento',
    IFNULL(GROUP_CONCAT(t.numero SEPARATOR ', '), '--') AS 'Telefones'
FROM
    empregado e
INNER JOIN
    departamento d ON e.departamento_iddepartamento = d.iddepartamento
LEFT JOIN
    telefone t ON e.cpf = t.empregado_cpf
WHERE
    e.salario < (SELECT AVG(salario) FROM empregado)
GROUP BY
    e.cpf, e.nome, e.dataadm, e.salario, d.nome
ORDER BY
    e.nome;
    
    
SELECT
    d.nome AS 'Departamento',
    COUNT(e.cpf) AS 'Quantidade De Empregados',
    CONCAT('R$ ', FORMAT(AVG(e.salario), 2)) AS 'Média Salarial',
    CONCAT('R$ ', FORMAT(AVG(e.comissao), 2)) AS 'Média Da Comissão'
FROM
    departamento d
INNER JOIN
    empregado e ON d.iddepartamento = e.departamento_iddepartamento
GROUP BY
    d.nome
ORDER BY
    d.nome;
    
    
SELECT
    e.nome AS 'Nome Empregado',
    e.cpf AS 'CPF Empregado',
    e.sexo AS 'Sexo',
    CONCAT('R$ ', FORMAT(e.salario, 2)) AS 'Salário',
    COUNT(v.idvenda) AS 'Quantidade Vendas',
    CONCAT('R$ ', FORMAT(IFNULL(SUM(v.valor), 0), 2)) AS 'Total Valor Vendido',
    CONCAT('R$ ', FORMAT(IFNULL(SUM(v.comissao), 0), 2)) AS 'Total Comissão Das Vendas'
FROM
    empregado e
LEFT JOIN
    venda v ON e.cpf = v.empregado_cpf
GROUP BY
    e.cpf, e.nome, e.sexo, e.salario
ORDER BY
    'Quantidade Vendas' DESC;
    
    
SELECT
    e.nome AS 'Nome Empregado',
    e.cpf AS 'CPF Empregado',
    e.sexo AS 'Sexo',
    CONCAT('R$ ', FORMAT(e.salario, 2)) AS 'Salário',
    COUNT(t.venda_idvenda) AS 'Quantidade Vendas Com Serviço',
    CONCAT('R$ ', FORMAT(IFNULL(SUM(t.valor_servico), 0), 2)) AS 'Total Valor Vendido Com Serviço',
    CONCAT('R$ ', FORMAT(IFNULL(SUM(t.comissao_venda), 0), 2)) AS 'Total Comissão Das Vendas Com Serviço'
FROM
    empregado e
LEFT JOIN
    (
        SELECT
            its.empregado_cpf,
            its.venda_idvenda,
            SUM(its.valor) AS valor_servico,
            v.comissao AS comissao_venda
        FROM
            itensservico its
        INNER JOIN
            venda v ON its.venda_idvenda = v.idvenda
        GROUP BY
            its.empregado_cpf, its.venda_idvenda, v.comissao
    ) t ON e.cpf = t.empregado_cpf
GROUP BY
    e.cpf, e.nome, e.sexo, e.salario
ORDER BY
    'Quantidade Vendas Com Serviço' DESC;
    
    
SELECT
    p.nome AS 'Nome Do Pet',
    DATE_FORMAT(v.data, '%d-%m-%Y') AS 'Data Do Serviço',
    s.nome AS 'Nome Do Serviço',
    its.quantidade AS 'Quantidade',
    CONCAT('R$ ', FORMAT(its.valor, 2)) AS 'Valor',
    e.nome AS 'Empregado Que Realizou O Serviço'
FROM
    pet p
INNER JOIN
    itensservico its ON p.idpet = its.pet_idpet
INNER JOIN
    servico s ON its.servico_idservico = s.idservico
INNER JOIN
    empregado e ON its.empregado_cpf = e.cpf
INNER JOIN
    venda v ON its.venda_idvenda = v.idvenda
ORDER BY
    v.data DESC;
    
    
SELECT
    DATE_FORMAT(v.data, '%d-%m-%Y') AS 'Data Da Venda',
    CONCAT('R$ ', FORMAT(v.valor, 2)) AS 'Valor',
    CONCAT('R$ ', FORMAT(v.desconto, 2)) AS 'Desconto',
    CONCAT('R$ ', FORMAT(v.valor - IFNULL(v.desconto, 0), 2)) AS 'Valor Final',
    e.nome AS 'Empregado Que Realizou A Venda'
FROM
    venda v
INNER JOIN
    empregado e ON v.empregado_cpf = e.cpf
ORDER BY
    v.data DESC;
    
    
SELECT
    s.nome AS 'Nome Do Serviço',
    COUNT(*) AS 'Quantidade Vendas',
    CONCAT('R$ ', FORMAT(IFNULL(SUM(its.valor), 0), 2)) AS 'Total Valor Vendido'
FROM
    servico s
INNER JOIN
    itensservico its ON s.idservico = its.servico_idservico
GROUP BY
    s.nome
ORDER BY
    'Quantidade Vendas' DESC
LIMIT 10;


SELECT
    fpv.tipo AS 'Tipo Forma Pagamento',
    COUNT(DISTINCT fpv.venda_idvenda) AS 'Quantidade Vendas',
    CONCAT('R$ ', FORMAT(SUM(fpv.valorpago), 2)) AS 'Total Valor Vendido'
FROM
    formapgvenda fpv
GROUP BY
    fpv.tipo
ORDER BY
    'Quantidade Vendas' DESC;
    

SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SELECT
    DATE_FORMAT(DATE(v.data), '%d-%m-%Y') AS 'Data Venda',
    COUNT(v.idvenda) AS 'Quantidade De Vendas',
    CONCAT('R$ ', FORMAT(SUM(v.valor), 2)) AS 'Valor Total Venda'
FROM
    venda v
GROUP BY
    DATE_FORMAT(DATE(v.data), '%d-%m-%Y')
ORDER BY
    DATE(v.data) DESC
LIMIT 0, 1000;

SELECT
    p.nome AS 'Nome Produto',
    CONCAT('R$ ', FORMAT(p.valorvenda, 2)) AS 'Valor Produto',
    p.marca AS 'Marca',
    f.nome AS 'Nome Fornecedor',
    f.email AS 'Email Fornecedor',
    IFNULL(GROUP_CONCAT(t.numero SEPARATOR ', '), '--') AS 'Telefone Fornecedor'
FROM
    produtos p
INNER JOIN
    itenscompra ic ON p.idproduto = ic.produtos_idproduto
INNER JOIN
    compras c ON ic.compras_idcompra = c.idcompra
INNER JOIN
    fornecedor f ON c.fornecedor_cpf_cnpj = f.cpf_cnpj
LEFT JOIN
    telefone t ON f.cpf_cnpj = t.fornecedor_cpf_cnpj
GROUP BY
    p.nome, p.valorvenda, p.marca, f.nome, f.email, f.cpf_cnpj
ORDER BY
    p.nome;
    
    
SELECT
    p.nome AS 'Nome Produto',
    COUNT(*) AS 'Quantidade (Total) Vendas',
    CONCAT('R$ ', FORMAT(IFNULL(SUM(ivp.valor), 0), 2)) AS 'Valor Total Recebido Pela Venda Do Produto'
FROM
    produtos p
INNER JOIN
    itensvendaprod ivp ON p.idproduto = ivp.produto_idproduto
GROUP BY
    p.nome
ORDER BY
    'Quantidade (Total) Vendas' DESC;