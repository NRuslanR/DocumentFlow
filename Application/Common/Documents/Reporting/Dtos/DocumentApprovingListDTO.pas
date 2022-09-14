unit DocumentApprovingListDTO;

interface

uses

  DocumentFlowEmployeeInfoDTO,
  SysUtils,
  Classes;

type

  TDocumentApprovingPerformingResultDTO =
    (DocumentApproved, DocumentNotApproved, DocumentApprovingNotPerformed);

  TDocumentApprovingListRecordDTO = class

    public

      ApproverDTO: TDocumentFlowEmployeeInfoDTO;
      ApprovingPerformingResultDTO: TDocumentApprovingPerformingResultDTO;
    
  end;

  TDocumentApprovingListRecordDTOs = class;
  
  TDocumentApprovingListRecordDTOsEnumerator = class (TListEnumerator)

    protected

      function GetCurrentDocumentApprovingListRecordDTO: TDocumentApprovingListRecordDTO;

    public

      constructor Create(DocumentApprovingListRecordDTOs: TDocumentApprovingListRecordDTOs);

      property Current: TDocumentApprovingListRecordDTO
      read GetCurrentDocumentApprovingListRecordDTO;

  end;

  TDocumentApprovingListRecordDTOs = class (TList)

    protected

      function GetDocumentApprovingListRecordDTOByIndex(
        Index: Integer
      ): TDocumentApprovingListRecordDTO;

      procedure SetDocumentApprovingListRecordDTOByIndex(
        Index: Integer;
        DocumentApprovingListRecordDTO: TDocumentApprovingListRecordDTO
      );

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      procedure Add(DocumentApprovingListRecordDTO: TDocumentApprovingListRecordDTO);

      function GetEnumerator: TDocumentApprovingListRecordDTOsEnumerator;
      
      property Items[Index: Integer]: TDocumentApprovingListRecordDTO
      read GetDocumentApprovingListRecordDTOByIndex
      write SetDocumentApprovingListRecordDTOByIndex; default;
      
  end;

  TDocumentApprovingListKindDto = (alkApproving, alkViseing);
  
  TDocumentApprovingListDTO = class

    public

      Title: String;
      Kind: TDocumentApprovingListKindDto;
      Records: TDocumentApprovingListRecordDTOs;

      destructor Destroy; override;
      constructor Create;

      procedure AddRecordDTO(RecordDTO: TDocumentApprovingListRecordDTO);
    
  end;

  TDocumentApprovingListDTOs = class;

  TDocumentApprovingListDTOsEnumerator = class (TListEnumerator)

    protected

      function GetCurrentDocumentApprovingListDTO: TDocumentApprovingListDTO;

    public

      constructor Create(DocumentApprovingListDTOs: TDocumentApprovingListDTOs);

      property Current: TDocumentApprovingListDTO
      read GetCurrentDocumentApprovingListDTO;
      
  end;

  TDocumentApprovingListDTOs = class (TList)

    private

      function GetDocumentApprovingListDTOByIndex(
        Index: Integer
      ): TDocumentApprovingListDTO;

      procedure SetDocumentApprovingListDTOByIndex(
        Index: Integer;
        const Value: TDocumentApprovingListDTO
      );

    public

      procedure Add(DocumentApprovingListDTO: TDocumentApprovingListDTO);

      function GetEnumerator: TDocumentApprovingListDTOsEnumerator;
      
      property Items[Index: Integer]: TDocumentApprovingListDTO
      read GetDocumentApprovingListDTOByIndex
      write SetDocumentApprovingListDTOByIndex; default;

  end;

implementation

{ TDocumentApprovingListRecordDTOsEnumerator }

constructor TDocumentApprovingListRecordDTOsEnumerator.Create(
  DocumentApprovingListRecordDTOs: TDocumentApprovingListRecordDTOs);
begin

  inherited Create(DocumentApprovingListRecordDTOs);
  
end;

function TDocumentApprovingListRecordDTOsEnumerator.GetCurrentDocumentApprovingListRecordDTO: TDocumentApprovingListRecordDTO;
begin

  Result := TDocumentApprovingListRecordDTO(GetCurrent);
  
end;

{ TDocumentApprovingListRecordDTOs }

procedure TDocumentApprovingListRecordDTOs.Add(
  DocumentApprovingListRecordDTO: TDocumentApprovingListRecordDTO);
begin

  inherited Add(DocumentApprovingListRecordDTO);
  
end;

function TDocumentApprovingListRecordDTOs.
  GetDocumentApprovingListRecordDTOByIndex(
    Index: Integer
  ): TDocumentApprovingListRecordDTO;
begin

  Result := TDocumentApprovingListRecordDTO(Get(Index));
  
end;

function TDocumentApprovingListRecordDTOs.GetEnumerator: TDocumentApprovingListRecordDTOsEnumerator;
begin

  Result := TDocumentApprovingListRecordDTOsEnumerator.Create(Self);

end;

procedure TDocumentApprovingListRecordDTOs.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if Action = lnDeleted then
    TDocumentApprovingListRecordDTO(Ptr).Destroy;

end;

procedure TDocumentApprovingListRecordDTOs.
  SetDocumentApprovingListRecordDTOByIndex(
    Index: Integer;
    DocumentApprovingListRecordDTO: TDocumentApprovingListRecordDTO
  );
begin

  Put(Index, DocumentApprovingListRecordDTO);
  
end;

{ TDocumentApprovingListDTO }

procedure TDocumentApprovingListDTO.AddRecordDTO(
  RecordDTO: TDocumentApprovingListRecordDTO);
begin

  Records.Add(RecordDTO);

end;

constructor TDocumentApprovingListDTO.Create;
begin

  inherited;

  Records := TDocumentApprovingListRecordDTOs.Create;
  
end;

destructor TDocumentApprovingListDTO.Destroy;
begin

  FreeAndNil(Records);
  inherited;

end;

{ TDocumentApprovingListDTOs }

procedure TDocumentApprovingListDTOs.Add(
  DocumentApprovingListDTO: TDocumentApprovingListDTO);
begin

  inherited Add(DocumentApprovingListDTO);

end;

function TDocumentApprovingListDTOs.GetDocumentApprovingListDTOByIndex(
  Index: Integer): TDocumentApprovingListDTO;
begin

  Result := TDocumentApprovingListDTO(Get(Index));

end;

function TDocumentApprovingListDTOs.GetEnumerator: TDocumentApprovingListDTOsEnumerator;
begin

  Result := TDocumentApprovingListDTOsEnumerator.Create(Self);

end;

procedure TDocumentApprovingListDTOs.SetDocumentApprovingListDTOByIndex(
  Index: Integer; const Value: TDocumentApprovingListDTO);
begin

  Put(Index, Value);
  
end;

{ TDocumentApprovingListDTOsEnumerator }

constructor TDocumentApprovingListDTOsEnumerator.Create(
  DocumentApprovingListDTOs: TDocumentApprovingListDTOs);
begin

  inherited Create(DocumentApprovingListDTOs);

end;

function TDocumentApprovingListDTOsEnumerator.GetCurrentDocumentApprovingListDTO: TDocumentApprovingListDTO;
begin

  Result := TDocumentApprovingListDTO(GetCurrent);
  
end;

end.
