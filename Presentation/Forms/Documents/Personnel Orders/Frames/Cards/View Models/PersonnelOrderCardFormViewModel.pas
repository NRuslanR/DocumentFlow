unit PersonnelOrderCardFormViewModel;

interface

uses

  DocumentCardFormViewModel,
  PersonnelOrderMainInformationFormViewModel,
  SysUtils;

type

  TPersonnelOrderCardFormViewModel = class (TDocumentCardFormViewModel)

    private

      function GetPersonnelOrderMainInformationFormViewModel: TPersonnelOrderMainInformationFormViewModel;
      function GetSubKindId: Variant;
      function GetSubKindName: String;

      procedure SetPersonnelOrderMainInformationFormViewModel(
        const Value: TPersonnelOrderMainInformationFormViewModel
      );
      
      procedure SetSubKindId(const Value: Variant);
      procedure SetSubKindName(const Value: String);

    public

      property SubKindId: Variant
      read GetSubKindId write SetSubKindId;

      property SubKindName: String
      read GetSubKindName write SetSubKindName;

      property DocumentMainInformationFormViewModel:
        TPersonnelOrderMainInformationFormViewModel
      read GetPersonnelOrderMainInformationFormViewModel
      write SetPersonnelOrderMainInformationFormViewModel;

  end;

implementation



{ TPersonnelOrderCardFormViewModel }

function TPersonnelOrderCardFormViewModel.
  GetPersonnelOrderMainInformationFormViewModel: TPersonnelOrderMainInformationFormViewModel;
begin

  Result :=
    TPersonnelOrderMainInformationFormViewModel(
      inherited DocumentMainInformationFormViewModel
    );

end;

function TPersonnelOrderCardFormViewModel.GetSubKindId: Variant;
begin

  Result := DocumentMainInformationFormViewModel.SubKindId;
  
end;

function TPersonnelOrderCardFormViewModel.GetSubKindName: String;
begin

  Result := DocumentMainInformationFormViewModel.SubKindName;
  
end;

procedure TPersonnelOrderCardFormViewModel.SetPersonnelOrderMainInformationFormViewModel(
  const Value: TPersonnelOrderMainInformationFormViewModel);
begin

  inherited DocumentMainInformationFormViewModel := Value;
  
end;

procedure TPersonnelOrderCardFormViewModel.SetSubKindId(const Value: Variant);
begin

  DocumentMainInformationFormViewModel.SubKindId := Value;
  
end;

procedure TPersonnelOrderCardFormViewModel.SetSubKindName(const Value: String);
begin

  DocumentMainInformationFormViewModel.SubKindName := Value;

end;

end.
