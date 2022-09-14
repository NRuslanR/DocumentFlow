unit DocumentInfoDTO;

interface

uses

  DepartmentInfoDTO,
  SysUtils,
  Classes;

type

  TDocumentRelationInfoDTO = class

    public

      RelatedDocumentId: Variant;
      RelatedDocumentKindId: Variant;
      RelatedDocumentKindName: String;
      RelatedDocumentNumber: String;
      RelatedDocumentName: String;
      RelatedDocumentCreationDate: TDateTime;

  end;

  TDocumentRelationsInfoDTO = class;

  TDocumentRelationsInfoDTOEnumerator = class (TListEnumerator)

    private

      function GetCurrentDocumentRelationInfoDTO: TDocumentRelationInfoDTO;

    public

      constructor Create(DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO);

      property Current: TDocumentRelationInfoDTO
      read GetCurrentDocumentRelationInfoDTO;

  end;

  TDocumentRelationsInfoDTO = class (TList)

    private

      function GetDocumentRelationInfoDTOByIndex(
        Index: Integer
      ): TDocumentRelationInfoDTO;

      procedure SetDocumentRelationInfoDTOByIndex(
        Index: Integer;
        DocumentRelationInfoDTO: TDocumentRelationInfoDTO
      );

    public

      function GetEnumerator: TDocumentRelationsInfoDTOEnumerator;

      function Add(DocumentRelationInfoDTO: TDocumentRelationInfoDTO): Integer;

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

      property Items[Index: Integer]: TDocumentRelationInfoDTO
      read GetDocumentRelationInfoDTOByIndex
      write SetDocumentRelationInfoDTOByIndex; default;

  end;

  TDocumentFileInfoDTO = class

    public

      Id: Variant;
      FileName: String;
      FilePath: String;

  end;

  TDocumentFilesInfoDTO = class;

  TDocumentFilesInfoDTOEnumerator = class (TListEnumerator)

    strict private

      function GetCurrentDocumentFileInfoDTO: TDocumentFileInfoDTO;

    public

      constructor Create(DocumentFilesInfoDTO: TDocumentFilesInfoDTO);

      property Current: TDocumentFileInfoDTO
      read GetCurrentDocumentFileInfoDTO;

  end;

  TDocumentFilesInfoDTO = class (TList)

    strict private

      function GetDocumentFileInfoDTOByIndex(
        Index: Integer
      ): TDocumentFileInfoDTO;

      procedure SetDocumentFileInfoDTOByIndex(
        Index: Integer;
        DocumentFileInfoDTO: TDocumentFileInfoDTO
      );

    strict protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function GetEnumerator: TDocumentFilesInfoDTOEnumerator;

      function Add(DocumentFileInfoDTO: TDocumentFileInfoDTO): Integer;
      procedure Remove(const Index: Integer);

      property Items[Index: Integer]: TDocumentFileInfoDTO
      read GetDocumentFileInfoDTOByIndex
      write SetDocumentFileInfoDTOByIndex; default;

  end;

  TDocumentSignerInfoDTO = class

    public

      Id: Variant;
      Name: String;
      DepartmentInfoDTO: TDepartmentInfoDTO;

      destructor Destroy; override;

  end;
  
  TDocumentSigningInfoDTO = class

    public

      Id: Variant;
      SignerInfoDTO: TDocumentSignerInfoDTO;
      ActuallySignedEmployeeInfoDTO: TDocumentSignerInfoDTO;
      SigningDate: Variant;

      destructor Destroy; override;
      
  end;

  TDocumentSigningsInfoDTO = class;

  TDocumentSigningsInfoDTOEnumerator = class (TListEnumerator)

    private

      function GetCurrentDocumentSigningInfoDTO:
        TDocumentSigningInfoDTO;

    public

      constructor Create(DocumentSigningsInfoDTO: TDocumentSigningsInfoDTO);

      property Current: TDocumentSigningInfoDTO
      read GetCurrentDocumentSigningInfoDTO;
      
  end;
  
  TDocumentSigningsInfoDTO = class (TList)

    private

      function GetDocumentSigningInfoDTOByIndex(
        Index: Integer
      ): TDocumentSigningInfoDTO;

      procedure SetDocumentSigningInfoDTOByIndex(
        Index: Integer;
        DocumentSigningInfoDTO: TDocumentSigningInfoDTO
      );

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function Add(DocumentSigningInfoDTO: TDocumentSigningInfoDTO): Integer;

      function GetEnumerator: TDocumentSigningsInfoDTOEnumerator;

      property Items[Index: Integer]: TDocumentSigningInfoDTO
      read GetDocumentSigningInfoDTOByIndex
      write SetDocumentSigningInfoDTOByIndex; default;
    
  end;

  TDocumentChargeInfoDTO = class

    public

      Id: Variant;

      ChargeText: String;
      PerformerResponse: String;
      
      TimeFrameStartLine: Variant;
      TimeFrameDeadline: Variant;
      PerformingDate: Variant;

      PerformerName: String;
      PerformerSpeciality: String;

      PerformerDepartmentInfoDTO: TDepartmentInfoDTO;

      destructor Destroy; override;

  end;

  TDocumentChargesInfoDTO = class;

  TDocumentChargesInfoDTOEnumerator = class (TListEnumerator)

    strict private

      function GetCurrentDocumentChargeInfoDTO: TDocumentChargeInfoDTO;

    public

      constructor Create(DocumentChargesInfoDTO: TDocumentChargesInfoDTO);

      property Current: TDocumentChargeInfoDTO
      read GetCurrentDocumentChargeInfoDTO;

  end;

  TDocumentChargesInfoDTO = class (TList)

    strict private

      function GetDocumentChargeInfoDTOByIndex(
        Index: Integer
      ): TDocumentChargeInfoDTO;

      procedure SetDocumentChargeInfoDTOByIndex(
        Index: Integer;
        DocumentChargeInfoDTO: TDocumentChargeInfoDTO
      );

    strict protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function Add(DocumentChargeInfoDTO: TDocumentChargeInfoDTO): Integer;
      procedure Remove(const Index: Integer);

      function GetEnumerator: TDocumentChargesInfoDTOEnumerator;

      property Items[Index: Integer]: TDocumentChargeInfoDTO
      read GetDocumentChargeInfoDTOByIndex
      write SetDocumentChargeInfoDTOByIndex; default;

  end;

  TDocumentResponsibleInfoDTO = class

    public

      Id: Variant;
      Name: String;
      TelephoneNumber: String;

      DepartmentInfoDTO: TDepartmentInfoDTO;

      destructor Destroy; override;

  end;

  TDocumentAuthorInfoDTO = class

    Id: Variant;
    Name: String;
    DepartmentInfoDTO: TDepartmentInfoDTO;

    destructor Destroy; override;
    
  end;

  TDocumentDTO = class

    public

      Id: Variant;
      Number: String;
      Name: String;
      Content: String;
      CreationDate: String;
      Note: String;
      Kind: String;
      AuthorDTO: TDocumentAuthorInfoDTO;

      ChargesInfoDTO: TDocumentChargesInfoDTO;
      ResponsibleInfoDTO: TDocumentResponsibleInfoDTO;

      CurrentWorkCycleStageNumber: Integer;
      CurrentWorkCycleStageName: String;

      destructor Destroy; override;

  end;

  TDocumentInfoDTO = class

    public

      DocumentDTO: TDocumentDTO;
      DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO;
      DocumentFilesInfoDTO: TDocumentFilesInfoDTO;

      destructor Destroy; override;

  end;

implementation

{ TDocumentRelationsInfoDTOEnumerator }

constructor TDocumentRelationsInfoDTOEnumerator.Create(
  DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO);
begin

  inherited Create(DocumentRelationsInfoDTO);

end;

function TDocumentRelationsInfoDTOEnumerator.GetCurrentDocumentRelationInfoDTO: TDocumentRelationInfoDTO;
begin

  Result := TDocumentRelationInfoDTO(GetCurrent);
  
end;

{ TDocumentRelationsInfoDTO }

function TDocumentRelationsInfoDTO.Add(
  DocumentRelationInfoDTO: TDocumentRelationInfoDTO): Integer;
begin

  Result := inherited Add(DocumentRelationInfoDTO);
  
end;

function TDocumentRelationsInfoDTO.GetDocumentRelationInfoDTOByIndex(
  Index: Integer): TDocumentRelationInfoDTO;
begin

  Result := TDocumentRelationInfoDTO(Get(Index));
  
end;

function TDocumentRelationsInfoDTO.GetEnumerator: TDocumentRelationsInfoDTOEnumerator;
begin

  Result := TDocumentRelationsInfoDTOEnumerator.Create(Self);
  
end;

procedure TDocumentRelationsInfoDTO.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDocumentRelationInfoDTO(Ptr).Destroy;

end;

procedure TDocumentRelationsInfoDTO.SetDocumentRelationInfoDTOByIndex(
  Index: Integer; DocumentRelationInfoDTO: TDocumentRelationInfoDTO);
begin

  Put(Index, DocumentRelationInfoDTO);
  
end;

{ TDocumentFilesInfoDTOEnumerator }

constructor TDocumentFilesInfoDTOEnumerator.Create(
  DocumentFilesInfoDTO: TDocumentFilesInfoDTO);
begin

  inherited Create(DocumentFilesInfoDTO);
  
end;

function TDocumentFilesInfoDTOEnumerator.GetCurrentDocumentFileInfoDTO: TDocumentFileInfoDTO;
begin

  Result := TDocumentFileInfoDTO(GetCurrent);
  
end;

{ TDocumentFilesInfoDTO }

function TDocumentFilesInfoDTO.Add(
  DocumentFileInfoDTO: TDocumentFileInfoDTO): Integer;
begin

  Result := inherited Add(DocumentFileInfoDTO);

end;

function TDocumentFilesInfoDTO.GetDocumentFileInfoDTOByIndex(
  Index: Integer): TDocumentFileInfoDTO;
begin

  Result := TDocumentFileInfoDTO(Get(Index));

end;

function TDocumentFilesInfoDTO.GetEnumerator: TDocumentFilesInfoDTOEnumerator;
begin

  Result := TDocumentFilesInfoDTOEnumerator.Create(Self);
  
end;

procedure TDocumentFilesInfoDTO.Notify(Ptr: Pointer; Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDocumentFileInfoDTO(Ptr).Destroy;

end;

procedure TDocumentFilesInfoDTO.Remove(const Index: Integer);
begin

  Delete(Index);
  
end;

procedure TDocumentFilesInfoDTO.SetDocumentFileInfoDTOByIndex(Index: Integer;
  DocumentFileInfoDTO: TDocumentFileInfoDTO);
begin

  Put(Index, DocumentFileInfoDTO);
  
end;

{ TDocumentChargesInfoDTOEnumerator }

constructor TDocumentChargesInfoDTOEnumerator.Create(
  DocumentChargesInfoDTO: TDocumentChargesInfoDTO);
begin

  inherited Create(DocumentChargesInfoDTO);
  
end;

function TDocumentChargesInfoDTOEnumerator.GetCurrentDocumentChargeInfoDTO: TDocumentChargeInfoDTO;
begin

  Result := TDocumentChargeInfoDTO(GetCurrent);
  
end;

{ TDocumentChargesInfoDTO }

function TDocumentChargesInfoDTO.Add(
  DocumentChargeInfoDTO: TDocumentChargeInfoDTO): Integer;
begin

  Result := inherited Add(DocumentChargeInfoDTO);
  
end;

function TDocumentChargesInfoDTO.GetDocumentChargeInfoDTOByIndex(
  Index: Integer): TDocumentChargeInfoDTO;
begin

  Result := TDocumentChargeInfoDTO(Get(Index));
  
end;

function TDocumentChargesInfoDTO.GetEnumerator: TDocumentChargesInfoDTOEnumerator;
begin

  Result := TDocumentChargesInfoDTOEnumerator.Create(Self);
  
end;

procedure TDocumentChargesInfoDTO.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if lnDeleted = Action then
    if Assigned(Ptr) then
      TDocumentChargeInfoDTO(Ptr).Destroy;

end;

procedure TDocumentChargesInfoDTO.Remove(const Index: Integer);
begin

  Delete(Index);
  
end;

procedure TDocumentChargesInfoDTO.SetDocumentChargeInfoDTOByIndex(
  Index: Integer; DocumentChargeInfoDTO: TDocumentChargeInfoDTO);
begin

  Put(Index, DocumentChargeInfoDTO);

end;

{ TDocumentResponsibleInfoDTO }

destructor TDocumentResponsibleInfoDTO.Destroy;
begin

  FreeAndNil(DepartmentInfoDTO);

  inherited;

end;

{ TDocumentDTO }

destructor TDocumentDTO.Destroy;
begin

  FreeAndNil(AuthorDTO);
  FreeAndNil(ResponsibleInfoDTO);

  inherited;

end;

{ TDocumentInfoDTO }

destructor TDocumentInfoDTO.Destroy;
begin

  FreeAndNil(DocumentDTO);
  FreeAndNil(DocumentRelationsInfoDTO);
  FreeAndNil(DocumentFilesInfoDTO);
  
  inherited;

end;

{ TDocumentSigningsInfoDTOEnumerator }

constructor TDocumentSigningsInfoDTOEnumerator.Create(
  DocumentSigningsInfoDTO: TDocumentSigningsInfoDTO);
begin

  inherited Create(DocumentSigningsInfoDTO);
  
end;

function TDocumentSigningsInfoDTOEnumerator.GetCurrentDocumentSigningInfoDTO: TDocumentSigningInfoDTO;
begin

  Result := TDocumentSigningInfoDTO(GetCurrent);
  
end;

{ TDocumentSigningsInfoDTO }

function TDocumentSigningsInfoDTO.Add(
  DocumentSigningInfoDTO: TDocumentSigningInfoDTO
): Integer;
begin

  Result := inherited Add(DocumentSigningInfoDTO);

end;

function TDocumentSigningsInfoDTO.GetDocumentSigningInfoDTOByIndex(
  Index: Integer): TDocumentSigningInfoDTO;
begin

  Result := TDocumentSigningInfoDTO(Get(Index));
  
end;

function TDocumentSigningsInfoDTO.GetEnumerator: TDocumentSigningsInfoDTOEnumerator;
begin

  Result := TDocumentSigningsInfoDTOEnumerator.Create(Self);
  
end;

procedure TDocumentSigningsInfoDTO.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDocumentSigningInfoDTO(Ptr).Destroy;

end;

procedure TDocumentSigningsInfoDTO.SetDocumentSigningInfoDTOByIndex(
  Index: Integer; DocumentSigningInfoDTO: TDocumentSigningInfoDTO);
begin

  Put(Index, DocumentSigningInfoDTO);

end;

{ TDocumentSignerInfoDTO }

destructor TDocumentSignerInfoDTO.Destroy;
begin

  FreeAndNil(DepartmentInfoDTO);
  inherited;

end;

{ TDocumentSigningInfoDTO }

destructor TDocumentSigningInfoDTO.Destroy;
begin

  FreeAndNil(SignerInfoDTO);
  FreeAndNil(ActuallySignedEmployeeInfoDTO);
  inherited;

end;

{ TDocumentChargeInfoDTO }

destructor TDocumentChargeInfoDTO.Destroy;
begin

  FreeAndNil(PerformerDepartmentInfoDTO);
  inherited;

end;

end.
