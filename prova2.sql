use paulista;
GO
CREATE TRIGGER t_block_times ON Times
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    ROLLBACK TRANSACTION
    RAISERROR('N�o � permitido inserir, alterar ou exclir na tabela Times', 16, 1)
END
GO
CREATE TRIGGER t_block_grupos ON Grupos
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    ROLLBACK TRANSACTION
    RAISERROR('N�o � permitido inserir, alterar ou excluir na tabela Grupos', 16, 1)
END
GO
CREATE TRIGGER t_block_jogos ON Jogos
AFTER INSERT, DELETE
AS
BEGIN
    ROLLBACK TRANSACTION
    RAISERROR('N�o � permitido inserir ou excluir na tabela Jogos', 16, 1)
END
GO
CREATE VIEW v_new_id
AS
SELECT NEWID() AS new_id
GO
CREATE FUNCTION fn_random_in_range(@min INT, @max INT) RETURNS INT
AS
BEGIN
	RETURN (SELECT ABS(CHECKSUM((SELECT new_id FROM v_new_id)) % (@max - @min + 1)) + @min)
END
GO
DECLARE @jogos TABLE (
	CodigoJogo INT NOT NULL,
	CodigoTimeA INT NOT NULL,
	CodigoTimeB INT NOT NULL,
	GolsTimeA INT DEFAULT 0,
	GolsTimeB INT DEFAULT 0,
	DataDoJogo Date NULL 
)
INSERT INTO @jogos SELECT * FROM Jogos;
GO
CREATE FUNCTION fn_total_jogos(@codigo INT) RETURNS INT
AS
BEGIN
	RETURN (
		SELECT COUNT(CodigoJogo) AS total FROM Jogos
		WHERE CodigoTimeA = @codigo OR CodigoTimeB = @codigo
	)
END
GO
CREATE FUNCTION fn_vitorias(@codigo INT) RETURNS INT
AS
BEGIN
	RETURN (
		SELECT COUNT(CodigoJogo) FROM Jogos
		WHERE 
		(CodigoTimeA = @codigo AND GolsTimeA > GolsTimeB)
		OR
		(CodigoTimeB = @codigo AND GolsTimeB > GolsTimeA)
	)
END
GO
CREATE FUNCTION fn_empates(@codigo INT) RETURNS INT
AS
BEGIN
	RETURN (
		SELECT COUNT(CodigoJogo) FROM Jogos
		WHERE 
		(CodigoTimeA = @codigo AND GolsTimeA = GolsTimeB)
		OR
		(CodigoTimeB = @codigo AND GolsTimeB = GolsTimeA)
	)
END
GO
CREATE FUNCTION fn_derrotas(@codigo INT) RETURNS INT
AS
BEGIN
	RETURN (
		SELECT COUNT(CodigoJogo) FROM Jogos
		WHERE 
		(CodigoTimeA = @codigo AND GolsTimeA < GolsTimeB)
		OR
		(CodigoTimeB = @codigo AND GolsTimeB < GolsTimeA)
	)
END
GO
CREATE FUNCTION fn_gols_p(@codigo INT) RETURNS INT
AS
BEGIN
	RETURN (
		(SELECT SUM(GolsTimeA) AS gols FROM Jogos WHERE CodigoTimeA = @codigo)
		+
		(SELECT SUM(GolsTimeB) AS gols FROM Jogos WHERE CodigoTimeB = @codigo)
	)
END
GO
CREATE FUNCTION fn_gols_s(@codigo INT) RETURNS INT
AS
BEGIN
	RETURN (
		(SELECT SUM(GolsTimeB) AS gols FROM Jogos WHERE CodigoTimeA = @codigo)
		+
		(SELECT SUM(GolsTimeA) AS gols FROM Jogos WHERE CodigoTimeB = @codigo)
	)
END
GO
CREATE FUNCTION fn_pontos(@codigo INT) RETURNS INT
AS
BEGIN
	RETURN((dbo.fn_vitorias(@codigo) * 3) + dbo.fn_empates(@codigo))
END
GO

CREATE FUNCTION fn_tabela_grupos(@grupo VARCHAR(1)) RETURNS @table TABLE(
	nome_time VARCHAR(255),
	num_jogos_disputados INT,
	vitorias INT,
	empates INT,
	derrotas INT, 
	gols_marcados INT,
	gols_sofridos INT,
	saldo_gols INT,
	pontos INT
)
AS
BEGIN
	INSERT INTO @table
		SELECT
			NomeTime AS nome_time,
			dbo.fn_total_jogos(Grupos.CodigoTime) AS num_jogos_disputados,
			dbo.fn_vitorias(Grupos.CodigoTime) AS vitorias,
			dbo.fn_empates(Grupos.CodigoTime) AS empates,
			dbo.fn_derrotas(Grupos.CodigoTime) AS derrotas,
			dbo.fn_gols_p(Grupos.CodigoTime) AS gols_marcados,
			dbo.fn_gols_s(Grupos.CodigoTime) AS gols_sofridos,
			(dbo.fn_gols_p(Grupos.CodigoTime) - dbo.fn_gols_s(Grupos.CodigoTime)) AS saldo_gols,
			dbo.fn_pontos(Grupos.CodigoTime) AS pontos
		FROM Grupos
		LEFT JOIN Times
		ON Grupos.CodigoTime = Times.CodigoTime where Grupos.Grupo = @grupo ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_gols DESC;
	RETURN ;
END
GO

CREATE FUNCTION fn_tabela_geral() RETURNS @table TABLE(
	nome_time VARCHAR(255),
	num_jogos_disputados INT,
	vitorias INT,
	empates INT,
	derrotas INT, 
	gols_marcados INT,
	gols_sofridos INT,
	saldo_gols INT,
	pontos INT
)
AS
BEGIN
	INSERT INTO @table
		SELECT
			NomeTime AS nome_time,
			dbo.fn_total_jogos(Grupos.CodigoTime) AS num_jogos_disputados,
			dbo.fn_vitorias(Grupos.CodigoTime) AS vitorias,
			dbo.fn_empates(Grupos.CodigoTime) AS empates,
			dbo.fn_derrotas(Grupos.CodigoTime) AS derrotas,
			dbo.fn_gols_p(Grupos.CodigoTime) AS gols_marcados,
			dbo.fn_gols_s(Grupos.CodigoTime) AS gols_sofridos,
			(dbo.fn_gols_p(Grupos.CodigoTime) - dbo.fn_gols_s(Grupos.CodigoTime)) AS saldo_gols,
			dbo.fn_pontos(Grupos.CodigoTime) AS pontos
		FROM Grupos
		LEFT JOIN Times
		ON Grupos.CodigoTime = Times.CodigoTime ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_gols DESC;
	RETURN ;
END
GO
CREATE FUNCTION fn_quartas() RETURNS @table TABLE(nome_time VARCHAR(200), nome_grupo VARCHAR(1))
AS
BEGIN
	INSERT INTO @table SELECT TOP 2 Resultados.nome_time as nome_time, 'A' 
		FROM dbo.fn_tabela_grupos('A') as Resultados
		INNER JOIN Times ON Resultados.nome_time = Times.NomeTime
		INNER JOIN Grupos ON Times.CodigoTime = Grupos.CodigoTime
		WHERE Grupo = 'A'
		ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_gols DESC
	INSERT INTO @table SELECT TOP 2 Resultados.nome_time as nome_time, 'B' 
		FROM dbo.fn_tabela_grupos('B') as Resultados
		INNER JOIN Times ON Resultados.nome_time = Times.NomeTime
		INNER JOIN Grupos ON Times.CodigoTime = Grupos.CodigoTime
		WHERE Grupo = 'B'
		ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_gols DESC
	INSERT INTO @table SELECT TOP 2 Resultados.nome_time as nome_time, 'C' 
		FROM dbo.fn_tabela_grupos('C') as Resultados
		INNER JOIN Times ON Resultados.nome_time = Times.NomeTime
		INNER JOIN Grupos ON Times.CodigoTime = Grupos.CodigoTime
		WHERE Grupo = 'C'
		ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_gols DESC
	INSERT INTO @table SELECT TOP 2 Resultados.nome_time as nome_time, 'D' 
		FROM dbo.fn_tabela_grupos('D') as Resultados
		INNER JOIN Times ON Resultados.nome_time = Times.NomeTime
		INNER JOIN Grupos ON Times.CodigoTime = Grupos.CodigoTime
		WHERE Grupo = 'D'
		ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_gols DESC
	RETURN;
END
GO