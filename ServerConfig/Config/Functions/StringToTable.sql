CREATE FUNCTION [Config].[StringToTable]
                 (@list      nvarchar(MAX),
                  @delimiter nchar(1) = N',')
      RETURNS @tbl TABLE (listpos int IDENTITY(1, 1) NOT NULL,
                          str     varchar(4000)      NOT NULL,
                          nstr    nvarchar(2000)     NOT NULL) AS

BEGIN
   DECLARE @endpos   int,
           @startpos int,
           @textpos  int,
           @chunklen smallint,
           @tmpstr   nvarchar(4000),
           @leftover nvarchar(4000),
           @tmpval   nvarchar(4000)

   SET @textpos = 1
   SET @leftover = ''
   WHILE @textpos <= datalength(@list) / 2
   BEGIN
      SET @chunklen = 4000 - datalength(@leftover) / 2
      SET @tmpstr = @leftover + substring(@list, @textpos, @chunklen)
      SET @textpos = @textpos + @chunklen

      SET @startpos = 0
      SET @endpos = charindex(@delimiter, @tmpstr)

      WHILE @endpos > 0
      BEGIN
         SET @tmpval = ltrim(rtrim(substring(@tmpstr, @startpos + 1,
                                             @endpos - @startpos - 1)))
         INSERT @tbl (str, nstr) VALUES(@tmpval, @tmpval)
         SET @startpos = @endpos
         SET @endpos = charindex(@delimiter,
                                 @tmpstr, @startpos + 1)
      END

      SET @leftover = right(@tmpstr, datalength(@tmpstr) / 2 - @startpos)
   END

   INSERT @tbl(str, nstr)
      VALUES (ltrim(rtrim(@leftover)), ltrim(rtrim(@leftover)))
   RETURN
END
