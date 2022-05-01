CREATE DATABASE paulista
GO
USE paulista
GO
CREATE TABLE Times (
    CodigoTime INT NOT NULL IDENTITY,
    NomeTime VARCHAR(255) NOT NULL,
    Cidade VARCHAR(255) NOT NULL,
    Estadio VARCHAR(255) NOT NULL,
    PRIMARY KEY(CodigoTime)
)
GO
CREATE TABLE Grupos (
    Grupo VARCHAR(1) NOT NULL,
    CodigoTime INT NOT NULL,
    FOREIGN KEY(CodigoTime) REFERENCES Times(CodigoTime)
)
GO
CREATE TABLE Jogos (
    CodigoJogo INT NOT NULL IDENTITY,
    CodigoTimeA INT NOT NULL,
    CodigoTimeB INT NOT NULL,
    GolsTimeA INT DEFAULT 0,
    GolsTimeB INT DEFAULT 0,
    DiaDoJogo Date,
	FOREIGN KEY(CodigoTimeA) REFERENCES Times(CodigoTime),
	FOREIGN KEY(CodigoTimeB) REFERENCES Times(CodigoTime),
	PRIMARY KEY(CodigoJogo)
)
GO
INSERT INTO Times(NomeTime, Cidade, Estadio) VALUES
('Botafogo-SP', 'Ribeirão Preto', 'Santa Cruz'),
('Corinthians', 'São Paulo', 'Neo Química Areno'),
('Ferroviária', 'Araraquara', 'Fonte Luminosa'),
('Guarani', 'Campinas', 'Brinco de Ouro'), 
('Inter de Limeira', 'Limeira', 'Limeirão'),
('Ituano', 'Itu', 'Novelli Júnior'),
('Mirassol', 'Mirassol', 'José Maria de Campos Maia'), 
('Novorizontino', 'Novo Horizonte', 'Jorge Ismael de Biasi'),
('Palmeiras', 'São Paulo', 'Allianz Parque'),
('Ponte Preta', 'Campinas', 'Moisés Lucarelli'),
('Red Bull Bragantino', 'Bragança Paulista', 'Nabi Abi Chedd'),
('Santo André', 'Santo André', 'Bruno José Daniel'),
('Santos', 'Santos', 'Vila Belmiro'),
('São Bento', 'Sorocaba', 'Walter Ribeiro'),
('São Caetano', 'São Caetano do Sul', 'Anacletto Campanella'),
('São Paulo', 'São Paulo', 'Morumbi')

GO
DROP VIEW v_aleatorio;
GO
DROP FUNCTION aleatorio;
GO
DROP PROCEDURE gerar_grupos;
GO
CREATE VIEW v_aleatorio
AS
SELECT CAST(CAST(NEWID() AS BINARY(3)) AS INT) AS novo_id
GO
CREATE FUNCTION aletorio() RETURNS INT
AS
BEGIN
    RETURN (SELECT TOP 1 novo_id FROM v_aleatorio)
END
GO
CREATE PROCEDURE gerar_grupos
AS
BEGIN
	TRUNCATE TABLE GRUPOS;
	DECLARE @tabela TABLE (
		CodigoGrupo INT NOT NULL IDENTITY,
		Grupo CHAR(1) NOT NULL DEFAULT 'A',
		CodigoTime INT NOT NULL,
		NomeTime VARCHAR(255) NOT NULL
	)
    DECLARE @grupo INT
    SET @grupo = 1
    DECLARE @times TABLE (
        Codigo INT NOT NULL IDENTITY,
        CodigoTime INT NOT NULL,
        NomeTime VARCHAR(255) NOT NULL
    )

    INSERT INTO @times (CodigoTime, NomeTime)
    SELECT CodigoTime, NomeTime FROM Times
    ORDER BY dbo.aletorio()

    INSERT INTO @tabela(CodigoTime, NomeTime)
    SELECT CodigoTime, NomeTime
    FROM @times
    WHERE NomeTime IN ('São Paulo', 'Corinthians', 'Palmeiras', 'Santos')
    ORDER BY dbo.aletorio()

    INSERT INTO @tabela(CodigoTime, NomeTime)
    SELECT CodigoTime, NomeTime
    FROM @times
    WHERE NomeTime NOT IN ('São Paulo', 'Corinthians', 'Palmeiras', 'Santos')
    ORDER BY dbo.aletorio()

    WHILE (@grupo <= 4)
    BEGIN
        UPDATE @tabela SET Grupo = 'A'
        WHERE CodigoGrupo = @grupo * 4 - 3
        UPDATE @tabela SET Grupo = 'B'
        WHERE CodigoGrupo = @grupo * 4 - 2
        UPDATE @tabela SET Grupo = 'C'
        WHERE CodigoGrupo = @grupo * 4 - 1
        UPDATE @tabela SET Grupo = 'D'
        WHERE CodigoGrupo = @grupo * 4
        SET @grupo = @grupo + 1;
    END
	INSERT INTO Grupos(Grupo, CodigoTime) SELECT Grupo, CodigoTime FROM @tabela
    RETURN
END
GO
DROP PROCEDURE pr_g;
GO
CREATE PROCEDURE pr_g
AS
BEGIN
	TRUNCATE TABLE Jogos;
	 DECLARE @tabela TABLE (
		CodigoJogo INT NOT NULL IDENTITY,
		Partida VARCHAR(10),
		CodigoTimeA INT NOT NULL,
		CodigoTimeB INT NOT NULL,
		DiaDoJogo Date,
		Debug VARCHAR(200)
	)
	DECLARE @codigoTime INT
	DECLARE @grupoTime CHAR(1)
	DECLARE cursor1 CURSOR FOR
	SELECT CodigoTime, Grupo FROM Grupos ORDER BY CodigoTime

	OPEN cursor1
	FETCH NEXT FROM cursor1 INTO @codigoTime, @grupoTime
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @tabela (CodigoTimeA, CodigoTimeB, Partida, DiaDoJogo)
		SELECT DISTINCT
			@codigoTime AS CodigoTimeA,
			CodigoTime AS CodigoTimeB,
			CONCAT(
				CONCAT(
					CASE
						WHEN @codigoTime < CodigoTime THEN @codigoTime
						ELSE CodigoTime
					END
					,
					'-'
				),
				CASE
					WHEN @codigoTime > CodigoTime THEN @codigoTime
					ELSE CodigoTime
				END
			) AS Partida,
			NULL
		FROM Grupos
		WHERE Grupo != @grupoTime
		AND
		CONCAT(
				CONCAT(
					CASE
						WHEN @codigoTime < CodigoTime THEN @codigoTime
						ELSE CodigoTime
					END
					,
					'-'
				),
				CASE
					WHEN @codigoTime > CodigoTime THEN @codigoTime
					ELSE CodigoTime
				END
		) NOT IN (SELECT Partida FROM @tabela)

		FETCH NEXT FROM cursor1 INTO @codigoTime, @grupoTime
		
	END
	DECLARE @i INT = 1;
	DECLARE @data DATE = '27-02-2022';
	DECLARE @cj INT = 0;
	DECLARE @timeA INT;
	DECLARE @timeB INT;
	DECLARE @have INT = 0;
	DECLARE @full INT =0;
	DECLARE @r DATE;
	DECLARE @debug VARCHAR(200);		
		WHILE @i <= 24 BEGIN
			SET @cj = 1;
			SET @full = 0;
			
				WHILE @cj <= 96 AND @full < 4 BEGIN
					SET @have = 0;
					
					SELECT @timeA = CodigoTimeA, @timeB = CodigoTimeB, @r = DiaDoJogo FROM @tabela WHERE CodigoJogo = @cj;
					UPDATE @tabela SET Debug = @r WHERE CodigoJogo = @cj;
					IF @i % 2 != 0 BEGIN
						SELECT @have = COUNT(*) FROM @tabela WHERE  DiaDoJogo = @data AND (CodigoTimeA IN (@timeA, @timeB) OR CodigoTimeB IN(@timeA, @timeB));
					END
					ELSE
					BEGIN
						SELECT @have = COUNT(CodigoJogo) FROM @tabela WHERE (DiaDoJogo  = @data OR DiaDoJogo = DATEADD(DAY,-4,@data)) AND (CodigoTimeA IN (@timeA, @timeB) OR CodigoTimeB IN(@timeA, @timeB));
					END

					IF @have = 0 AND @r IS NULL BEGIN
						UPDATE @tabela SET DiaDoJogo=@data WHERE  CodigoJogo=@cj
						SET @full = @full + 1;
					END
					
					SET @cj = @cj + 1;
				END
			
			IF @i % 2 != 0 BEGIN
				SET @data = DATEADD(DAY, 3, @data);
			END
			ELSE
			BEGIN
				SET @data = DATEADD(DAY, 4, @data);
			END
			SET @i = @i+1;
		END
		UPDATE @tabela SET DiaDoJogo='2022-05-15' WHERE CodigoJogo = 93;
		UPDATE @tabela SET DiaDoJogo='2022-05-11' WHERE CodigoJogo = 94;
		UPDATE @tabela SET DiaDoJogo='2022-05-18' WHERE CodigoJogo = 95;
		UPDATE @tabela SET DiaDoJogo='2022-05-18' WHERE CodigoJogo = 96;
		INSERT INTO Jogos(CodigoTimeA, CodigoTimeB, DiaDoJogo, GolsTimeA, GolsTimeB) SELECT  CodigoTimeA, CodigoTimeB, DiaDoJogo, NULL, NULL FROM @tabela;
		DEALLOCATE cursor1;
	RETURN  
END
GO