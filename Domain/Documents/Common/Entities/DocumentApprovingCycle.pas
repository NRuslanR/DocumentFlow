unit DocumentApprovingCycle;

interface

uses

  DomainException,
  DomainObjectUnit,
  SysUtils,
  Classes;

type

  TDocumentApprovingCycleException = class (TDomainException)

  end;
  
  TDocumentApprovingCycle = class (TDomainObject)

    private
    
    protected

      FNumber: Integer;
      FBeginDate: TDateTime;

      procedure SetBeginDate(const Value: TDateTime);
      procedure SetNumber(const Value: Integer);

    public

      constructor Create(
        const Identity: Variant;
        const Number: Integer;
        const BeginDate: TDateTime
      );

    published

      property Number: Integer
      read FNumber write SetNumber;

      property BeginDate: TDateTime
      read FBeginDate write SetBeginDate;

  end;

implementation

uses

  Variants,DateUtils;

{ TDocumentApprovingCycle }

constructor TDocumentApprovingCycle.Create(
  const Identity: Variant;
  const Number: Integer;
  const BeginDate: TDateTime
);
begin

  inherited Create(Identity);

  Self.Number := Number;
  Self.BeginDate := BeginDate;
  
end;

procedure TDocumentApprovingCycle.SetBeginDate(const Value: TDateTime);
var Years, Months, Days, Hours, Minutes, Seconds, Milliseconds: Word;
begin

  DecodeDateTime(
    Value, Years, Months, Days, Hours, Minutes, Seconds, Milliseconds
  );

  if not
     IsValidDateTime(
        Years, Months, Days, Hours, Minutes, Seconds, Milliseconds
     )
  then
    raise TDocumentApprovingCycleException.Create(
      'Некорректная дата начала цикла согласования'
    );

  FBeginDate := Value;
  
end;

procedure TDocumentApprovingCycle.SetNumber(const Value: Integer);
begin

  if Value < 0 then
    raise TDocumentApprovingCycleException.Create(
      'Некорректный номер цикла согласования'
    );

  FNumber := Value;
  
end;

end.
