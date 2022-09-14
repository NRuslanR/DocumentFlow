{
  refactor:
  преобразовать в PrefixedNumberComparator
}
unit ServiceNoteNumberColumnCellComparator;

interface

uses

  DocumentNumberColumnCellComparator,
  SysUtils,
  Classes,
  StrUtils,
  RegExpr;

type

  TServiceNoteNumberColumnCellComparator =
    class (TDocumentNumberColumnCellComparator)

      protected

        function CompareDocumentNumbers(
          const FirstDocumentNumber: String;
          const SecondDocumentNumber: String
        ): Integer; override;

    end;

implementation

uses

  AuxiliaryStringFunctions;

{ TServiceNoteNumberColumnCellComparator }

function TServiceNoteNumberColumnCellComparator.CompareDocumentNumbers(
  const FirstDocumentNumber, SecondDocumentNumber: String
): Integer;
var FirstServiceNoteNumberPartDelimiterPos: Integer;
    SecondServiceNoteNumberPartDelimiterPos: Integer;

    FirstRegExpr, SecondRegExpr: TRegExpr;

    DepartmentCodeCompareResult: Integer;
    AssignableDocumentNumberPartCompareResult: Integer;

    FirstDepartmentCodeFirstNotMatchPos,
    SecondDepartmentCodeFirstNotMatchPos: Integer;
begin

  FirstRegExpr := nil;
  SecondRegExpr := nil;
  
  try

    FirstServiceNoteNumberPartDelimiterPos :=
      Pos('/', FirstDocumentNumber);

    SecondServiceNoteNumberPartDelimiterPos :=
      Pos('/', SecondDocumentNumber);

    if (FirstServiceNoteNumberPartDelimiterPos = 0) or
       (SecondServiceNoteNumberPartDelimiterPos = 0)

    then begin

      if (FirstDocumentNumber = '') or (SecondDocumentNumber = '') then begin

        if (FirstDocumentNumber = '') and (SecondDocumentNumber = '') then
          Result := 0

        else if FirstDocumentNumber = '' then
          Result := -1

        else Result := 1;
        
        Exit;

      end;

      raise Exception.CreateFmt(
              'Не удалось распознать формат номеров ' +
              'служебных записок для сравнения. ' + sLineBreak +
              'Сравниваемые номера: "%s", "%s"',
              [FirstDocumentNumber, SecondDocumentNumber]
            );

    end;

    FirstRegExpr := TRegExpr.Create;
    SecondRegExpr := TRegExpr.Create;

    FirstRegExpr.Expression := '\d+';
    SecondRegExpr.Expression := '\d+';

    if FirstRegExpr.Exec(FirstDocumentNumber) and
       SecondRegExpr.Exec(SecondDocumentNumber)

    then begin

      repeat

        DepartmentCodeCompareResult :=
          StrToInt(FirstRegExpr.Match[0]) - StrToInt(SecondRegExpr.Match[0]);

        if DepartmentCodeCompareResult <> 0 then begin

          Result := DepartmentCodeCompareResult;
          Exit;
          
        end;

        FirstDepartmentCodeFirstNotMatchPos :=
          FirstRegExpr.MatchPos[0] + FirstRegExpr.MatchLen[0];

        SecondDepartmentCodeFirstNotMatchPos :=
          SecondRegExpr.MatchPos[0] + SecondRegExpr.MatchLen[0];

      until not (FirstRegExpr.ExecNext and SecondRegExpr.ExecNext);

      DepartmentCodeCompareResult :=
        CompareStr(
          LeftStr(FirstDocumentNumber, FirstDepartmentCodeFirstNotMatchPos),
          LeftStr(SecondDocumentNumber, SecondDepartmentCodeFirstNotMatchPos)
        );

      Result := DepartmentCodeCompareResult;

    end

    else DepartmentCodeCompareResult := CompareStr(FirstDocumentNumber, FirstDocumentNumber);

  finally

    FreeAndNil(FirstRegExpr);
    FreeAndNil(SecondRegExpr);
    
  end;

end;

end.
