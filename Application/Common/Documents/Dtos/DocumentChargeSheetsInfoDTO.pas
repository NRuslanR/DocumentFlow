unit DocumentChargeSheetsInfoDTO;

interface

uses

  EmployeeInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  DepartmentInfoDTO,
  SysUtils,
  Classes;

type

  TDocumentChargeSheetAccessRightsDTO = class

    public

      ViewingAllowed: Variant;
      ChargeSectionAccessible: Variant;
      ResponseSectionAccessible: Variant;
      RemovingAllowed: Variant;
      PerformingAllowed: Variant;

      constructor Create;
      
  end;

  TDocumentChargeSheetInfoDTO = class

    private

      FIsChargeTextChanged: Boolean;
      FIsPerformerResponseChanged: Boolean;

      FChargeText: String;
      FPerformerResponse: String;
      
      procedure SetChargeText(const Value: String);
      procedure SetPerformerResponse(const Value: String);

    public

      Id: Variant;
      
      KindId: Variant;
      KindName: String;
      ServiceKindName: String;
      
      TopLevelChargeSheetId: Variant;
      DocumentId: Variant;
      DocumentKindId: Variant;

      TimeFrameStart: Variant;
      TimeFrameDeadline: Variant;

      IssuingDateTime: Variant;
      PerformingDateTime: Variant;

      IsForAcquaitance: Boolean;

      ViewingDateByPerformer: Variant;

      AccessRights: TDocumentChargeSheetAccessRightsDTO;
      
      PerformerInfoDTO: TDocumentFlowEmployeeInfoDTO;
      ActuallyPerformedEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO;
      SenderEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO;

      constructor Create;
      destructor Destroy; override;

    published

      property ChargeText: String read FChargeText write SetChargeText;
      property PerformerResponse: String read FPerformerResponse write SetPerformerResponse;

      property IsChargeTextChanged: Boolean read FIsChargeTextChanged;
      property IsPerformerResponseChanged: Boolean read FIsPerformerResponseChanged;

  end;

  TDocumentChargeSheetInfoDTOClass = class of TDocumentChargeSheetInfoDTO;
  
  TDocumentAcquaitanceSheetInfoDTO = class (TDocumentChargeSheetInfoDTO)
  
  end;

  TDocumentPerformingSheetInfoDTO = class (TDocumentChargeSheetInfoDTO)

  end;
  
  TDocumentChargeSheetsInfoDTO = class;
  
  TDocumentChargeSheetsInfoDTOEnumerator = class (TListEnumerator)

    private

      function GetCurrentDocumentChargeSheetInfoDTO:
        TDocumentChargeSheetInfoDTO;

    public

      constructor Create(
        DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO
      );

      property Current: TDocumentChargeSheetInfoDTO
      read GetCurrentDocumentChargeSheetInfoDTO;
      
  end;

  TDocumentChargeSheetsInfoDTO = class (TList)

    private

      function GetDocumentChargeSheetInfoDTOByIndex(
        Index: Integer
      ): TDocumentChargeSheetInfoDTO;

      procedure SetDocumentChargeSheetInfoDTOByIndex(
        Index: Integer;
        DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO
      );

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function Add(
        DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO
      ): Integer;

      function FindById(const DocumentChargeSheetId: Variant): TDocumentChargeSheetInfoDTO;
      
      function GetEnumerator: TDocumentChargeSheetsInfoDTOEnumerator;

      property Items[Index: Integer]: TDocumentChargeSheetInfoDTO
      read GetDocumentChargeSheetInfoDTOByIndex
      write SetDocumentChargeSheetInfoDTOByIndex; default;
  
  end;

implementation

uses

  Variants;
  
{ TDocumentChargeSheetsInfoDTOEnumerator }

constructor TDocumentChargeSheetsInfoDTOEnumerator.Create(
  DocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO);
begin

  inherited Create(DocumentChargeSheetsInfoDTO);
  
end;

function TDocumentChargeSheetsInfoDTOEnumerator
  .GetCurrentDocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
begin

  Result := TDocumentChargeSheetInfoDTO(GetCurrent);
  
end;

{ TDocumentChargeSheetsInfoDTO }

function TDocumentChargeSheetsInfoDTO.Add(
  DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO
): Integer;
begin

  Result := inherited Add(DocumentChargeSheetInfoDTO);

end;

function TDocumentChargeSheetsInfoDTO.FindById(
  const DocumentChargeSheetId: Variant): TDocumentChargeSheetInfoDTO;
begin

  for Result in Self do
    if Result.Id = DocumentChargeSheetId then
      Exit;

  Result := nil;

end;

function TDocumentChargeSheetsInfoDTO.GetDocumentChargeSheetInfoDTOByIndex(
  Index: Integer): TDocumentChargeSheetInfoDTO;
begin

  Result := TDocumentChargeSheetInfoDTO(Get(Index));
  
end;

function TDocumentChargeSheetsInfoDTO.GetEnumerator: TDocumentChargeSheetsInfoDTOEnumerator;
begin

  Result := TDocumentChargeSheetsInfoDTOEnumerator.Create(Self);
  
end;

procedure TDocumentChargeSheetsInfoDTO.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDocumentChargeSheetInfoDTO(Ptr).Destroy;

end;

procedure TDocumentChargeSheetsInfoDTO.SetDocumentChargeSheetInfoDTOByIndex(
  Index: Integer; DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO);
begin

  Put(Index, DocumentChargeSheetInfoDTO);
  
end;

{ TDocumentChargeSheetInfoDTO }

constructor TDocumentChargeSheetInfoDTO.Create;
begin

  inherited;

  Id := Null;
  KindId := Null;
  DocumentKindId := Null;
  TopLevelChargeSheetId := Null;
  DocumentId := Null;
  TimeFrameStart := Null;
  TimeFrameDeadline := Null;
  IssuingDateTime := Null;
  PerformingDateTime := Null;
  ViewingDateByPerformer := Null;

  AccessRights := TDocumentChargeSheetAccessRightsDTO.Create;
  
end;

destructor TDocumentChargeSheetInfoDTO.Destroy;
begin

  FreeAndNil(AccessRights);
  FreeAndNil(PerformerInfoDTO);
  FreeAndNil(ActuallyPerformedEmployeeInfoDTO);
  FreeAndNil(SenderEmployeeInfoDTO);
  
  inherited;

end;

procedure TDocumentChargeSheetInfoDTO.SetChargeText(const Value: String);
begin

  FIsChargeTextChanged := FChargeText <> Value;
  
  FChargeText := Value;

end;

procedure TDocumentChargeSheetInfoDTO.SetPerformerResponse(const Value: String);
begin

  FIsPerformerResponseChanged := FPerformerResponse <> Value;
  
  FPerformerResponse := Value;
  
end;

{ TDocumentChargeSheetAccessRightsDTO }

constructor TDocumentChargeSheetAccessRightsDTO.Create;
begin

  inherited;

  ViewingAllowed := Null;
  ChargeSectionAccessible := Null;
  ResponseSectionAccessible := Null;
  RemovingAllowed := Null;
  PerformingAllowed := Null;
  
end;

end.
