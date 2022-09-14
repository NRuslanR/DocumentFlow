unit PersonnelOrderRecordViewModel;

interface

uses

  DocumentRecordViewModel,
  SysUtils;

type

  TPersonnelOrderRecordViewModel = class (TDocumentRecordViewModel)

    public

      SubKindId: Variant;
      SubKindName: String;

    public

      constructor Create; override;
    
  end;
  
implementation

uses

  Variants;

{ TPersonnelOrderRecordViewModel }

constructor TPersonnelOrderRecordViewModel.Create;
begin

  inherited Create;

  SubKindId := Null;

end;

end.
