unit DocumentCardFormViewModel;

interface

uses

  DocumentMainInformationFormViewModelUnit,
  DocumentFilesFormViewModelUnit,
  DocumentChargesFormViewModelUnit,
  DocumentRelationsFormViewModelUnit,
  DocumentFilesViewFormViewModel,
  DocumentApprovingsFormViewModel,
  DocumentChargeSheetsFormViewModel,
  LoodsmanDocumentUploadingInfoFormViewModel,
  Disposable,
  SysUtils,
  Classes;

type

  TDocumentCardFormViewModel = class

    protected

      FDocumentRemoveToolEnabled: Boolean;

      FDocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel;
      FDocumentFilesFormViewModel: TDocumentFilesFormViewModel;

      FDocumentChargesFormViewModel: TDocumentChargesFormViewModel;
      FFreeDocumentChargesFormViewModel: IDisposable;
      
      FDocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel;
      FFreeDocumentChargeSheetsFormViewModel: IDisposable;

      FDocumentRelationsFormViewModel: TDocumentRelationsFormViewModel;
      FDocumentFilesViewFormViewModel: TDocumentFilesViewFormViewModel;
      FDocumentApprovingsFormViewModel: TDocumentApprovingsFormViewModel;

      FLoodsmanDocumentUploadingInfoFormViewModel: TLoodsmanDocumentUploadingInfoFormViewModel;

      procedure SetDocumentMainInformationFormViewModel(
        DocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel
      );

      procedure SetDocumentFilesFormViewModel(
        DocumentFilesFormViewModel: TDocumentFilesFormViewModel
      );

      procedure SetDocumentChargesFormViewModel(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      );

      procedure SetDocumentChargeSheetsFormViewModel(
        const Value: TDocumentChargeSheetsFormViewModel
      );

      procedure SetDocumentRelationsFormViewModel(
        DocumentRelationsFormViewModel: TDocumentRelationsFormViewModel
      );

      procedure SetDocumentApprovingsFormViewModel(
        Value: TDocumentApprovingsFormViewModel
      );

      function GetDocumentId: Variant;
      procedure SetDocumentId(const Value: Variant);

      function GetBaseDocumentId: Variant;
      procedure SetBaseDocumentId(const Value: Variant);
      
      function GetDocumentKindId: Variant;
      procedure SetDocumentKindId(const Value: Variant);

      function GetCurrentDocumentWorkCycleStageName: String;
      function GetCurrentDocumentWorkCycleStageNumber: Integer;
      procedure SetCurrentDocumentWorkCycleStageName(const Value: String);
      procedure SetCurrentDocumentWorkCycleStageNumber(const Value: Integer);

      function GetNumber: String;
      procedure SetNumber(const Value: String);

      procedure SetLoodsmanDocumentUploadingInfoFormViewModel(
        const Value: TLoodsmanDocumentUploadingInfoFormViewModel);
        
    public

      destructor Destroy; override;
      constructor Create;

    public

      property DocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel
      read FDocumentMainInformationFormViewModel
      write FDocumentMainInformationFormViewModel;

      property DocumentFilesFormViewModel: TDocumentFilesFormViewModel
      read FDocumentFilesFormViewModel write FDocumentFilesFormViewModel;

      property DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      read FDocumentChargesFormViewModel write SetDocumentChargesFormViewModel;

      property DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel
      read FDocumentChargeSheetsFormViewModel write SetDocumentChargeSheetsFormViewModel;

      property DocumentRelationsFormViewModel: TDocumentRelationsFormViewModel
      read FDocumentRelationsFormViewModel write FDocumentRelationsFormViewModel;

      property DocumentFilesViewFormViewModel: TDocumentFilesViewFormViewModel
      read FDocumentFilesViewFormViewModel write FDocumentFilesViewFormViewModel;

      property DocumentApprovingsFormViewModel: TDocumentApprovingsFormViewModel
      read FDocumentApprovingsFormViewModel write SetDocumentApprovingsFormViewModel;

      property LoodsmanDocumentUploadingInfoFormViewModel: TLoodsmanDocumentUploadingInfoFormViewModel
      read FLoodsmanDocumentUploadingInfoFormViewModel write SetLoodsmanDocumentUploadingInfoFormViewModel;
      
    public
      
      property DocumentId: Variant
      read GetDocumentId write SetDocumentId;

      property BaseDocumentId: Variant
      read GetBaseDocumentId write SetBaseDocumentId;
      
      property DocumentKindId: Variant
      read GetDocumentKindId write SetDocumentKindId;

      property CurrentDocumentWorkCycleStageNumber: Integer
      read GetCurrentDocumentWorkCycleStageNumber
      write SetCurrentDocumentWorkCycleStageNumber;

      property CurrentDocumentWorkCycleStageName: String
      read GetCurrentDocumentWorkCycleStageName
      write SetCurrentDocumentWorkCycleStageName;

      property Number: String
      read GetNumber
      write SetNumber;

    public

      property DocumentRemoveToolEnabled: Boolean
      read FDocumentRemoveToolEnabled write FDocumentRemoveToolEnabled;

  end;

  TDocumentCardFormViewModelClass = class of TDocumentCardFormViewModel;
  
implementation

uses

  AuxDebugFunctionsUnit;

constructor TDocumentCardFormViewModel.Create;
begin

  inherited;

end;

destructor TDocumentCardFormViewModel.Destroy;
begin

  FreeAndNil(FDocumentMainInformationFormViewModel);
  FreeAndNil(FDocumentFilesFormViewModel);
  FreeAndNil(FDocumentRelationsFormViewModel);
  FreeAndNil(FDocumentFilesViewFormViewModel);
  FreeAndNil(FDocumentApprovingsFormViewModel);

  inherited;

end;

function TDocumentCardFormViewModel.GetBaseDocumentId: Variant;
begin

  Result :=
    FDocumentMainInformationFormViewModel.BaseDocumentId;
    
end;

function TDocumentCardFormViewModel.GetCurrentDocumentWorkCycleStageName: String;
begin

  Result :=
    FDocumentMainInformationFormViewModel.CurrentWorkCycleStageName;

end;

function TDocumentCardFormViewModel.GetCurrentDocumentWorkCycleStageNumber: Integer;
begin

  Result :=
    FDocumentMainInformationFormViewModel.CurrentWorkCycleStageNumber;
    
end;

function TDocumentCardFormViewModel.GetNumber: String;
begin

  Result :=
    FDocumentMainInformationFormViewModel.Number;
    
end;

function TDocumentCardFormViewModel.GetDocumentId: Variant;
begin

  Result :=
    FDocumentMainInformationFormViewModel.DocumentId;

end;

function TDocumentCardFormViewModel.GetDocumentKindId: Variant;
begin

  Result := FDocumentMainInformationFormViewModel.KindId;
  
end;

procedure TDocumentCardFormViewModel.SetBaseDocumentId(const Value: Variant);
begin

  FDocumentMainInformationFormViewModel.BaseDocumentId := Value;
  
end;

procedure TDocumentCardFormViewModel.SetCurrentDocumentWorkCycleStageName(
  const Value: String);
begin

  FDocumentMainInformationFormViewModel.CurrentWorkCycleStageName := Value;
  
end;

procedure TDocumentCardFormViewModel.SetCurrentDocumentWorkCycleStageNumber(
  const Value: Integer);
begin

  FDocumentMainInformationFormViewModel.CurrentWorkCycleStageNumber := Value;
  
end;

procedure TDocumentCardFormViewModel.SetDocumentApprovingsFormViewModel(
  Value: TDocumentApprovingsFormViewModel);
begin

  FreeAndNil(FDocumentApprovingsFormViewModel);

  FDocumentApprovingsFormViewModel := Value;
  
end;

procedure TDocumentCardFormViewModel.SetNumber(const Value: String);
begin

  FDocumentMainInformationFormViewModel.Number := Value;
  
end;

procedure TDocumentCardFormViewModel.SetDocumentFilesFormViewModel(
  DocumentFilesFormViewModel: TDocumentFilesFormViewModel);
begin

  FreeAndNil(FDocumentFilesFormViewModel);

  FDocumentFilesFormViewModel := DocumentFilesFormViewModel;
  
end;

procedure TDocumentCardFormViewModel.SetDocumentId(const Value: Variant);
begin

  FDocumentMainInformationFormViewModel.DocumentId := Value;
  
end;

procedure TDocumentCardFormViewModel.SetDocumentKindId(const Value: Variant);
begin

  FDocumentMainInformationFormViewModel.KindId := Value;
  
end;

procedure TDocumentCardFormViewModel.SetDocumentMainInformationFormViewModel(
  DocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel);
begin

  FreeAndNil(FDocumentMainInformationFormViewModel);

  FDocumentMainInformationFormViewModel := DocumentMainInformationFormViewModel;

end;

procedure TDocumentCardFormViewModel.SetDocumentChargesFormViewModel(
  DocumentChargesFormViewModel: TDocumentChargesFormViewModel);
begin

  FDocumentChargesFormViewModel := DocumentChargesFormViewModel;
  FFreeDocumentChargesFormViewModel := DocumentChargesFormViewModel;
  
end;

procedure TDocumentCardFormViewModel.SetDocumentChargeSheetsFormViewModel(
  const Value: TDocumentChargeSheetsFormViewModel);
begin

  FDocumentChargeSheetsFormViewModel := Value;
  FFreeDocumentChargeSheetsFormViewModel := Value;

end;

procedure TDocumentCardFormViewModel.SetDocumentRelationsFormViewModel(
  DocumentRelationsFormViewModel: TDocumentRelationsFormViewModel);
begin

  FreeAndNil(FDocumentRelationsFormViewModel);

  FDocumentRelationsFormViewModel := DocumentRelationsFormViewModel;
  
end;

procedure TDocumentCardFormViewModel.SetLoodsmanDocumentUploadingInfoFormViewModel(
  const Value: TLoodsmanDocumentUploadingInfoFormViewModel);
begin

  FreeAndNil(FLoodsmanDocumentUploadingInfoFormViewModel);
  
  FLoodsmanDocumentUploadingInfoFormViewModel := Value;

end;

end.
