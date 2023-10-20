unit PersonnelOrderMainInformationFormViewModel;

interface

uses

  DocumentMainInformationFormViewModelUnit,
  SysUtils,
  Classes;

type

  TPersonnelOrderMainInformationFormViewModel =
    class (TDocumentMainInformationFormViewModel)

      public

        SubKindId: Variant;
        SubKindName: String;

      public

        constructor Create; override;
        
        procedure CopyFrom(Other: TDocumentMainInformationFormViewModel); override;
      
    end;

implementation

uses

  Variants;
  
{ TPersonnelOrderMainInformationFormViewModel }

procedure TPersonnelOrderMainInformationFormViewModel.CopyFrom(
  Other: TDocumentMainInformationFormViewModel
);
var
    OtherPersonnelOrderMainInformationFormViewModel:
      TPersonnelOrderMainInformationFormViewModel;
begin

  OtherPersonnelOrderMainInformationFormViewModel :=
    Other as TPersonnelOrderMainInformationFormViewModel;
    
  inherited CopyFrom(OtherPersonnelOrderMainInformationFormViewModel);

  with OtherPersonnelOrderMainInformationFormViewModel do begin

    Self.SubKindId := SubKindId;
    Self.SubKindName := SubKindName;

  end;

end;

constructor TPersonnelOrderMainInformationFormViewModel.Create;
begin

  inherited Create;

  SubKindId := Null;
  
end;

end.
