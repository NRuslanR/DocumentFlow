unit LoodsmanDocumentUploadingInfo;

interface

uses

  LoodsmanDocumentUploadingStatus,
  DocumentFullInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  IGetSelfUnit,
  SysUtils,
  Classes;

type

  ILoodsmanDocumentUploadingAccessRights = interface (IGetSelf)

  end;

  TLoodsmanDocumentUploadingAccessRights = class (TInterfacedObject, ILoodsmanDocumentUploadingAccessRights)

    public

      UploadingAllowed: Boolean;
      CancellationAllowed: Boolean;

    public

      function GetSelf: TObject;
      
  end;

  ILoodsmanDocumentUploadingStatusInfo = interface (IGetSelf)

  end;

  TLoodsmanDocumentUploadingStatusInfo =
    class (TInterfacedObject, ILoodsmanDocumentUploadingStatusInfo)

      private

        FStatusInitiatorDTO: TDocumentFlowEmployeeInfoDTO;

        procedure SetStatusInitiatorDTO(const Value: TDocumentFlowEmployeeInfoDTO);
        
      public

        Status: TLoodsmanDocumentUploadingStatus;
        StatusDateTime: TDateTime;
        ErrorMessage: String;

        destructor Destroy; override;
        
        constructor Create; overload;
        constructor Create(
          const Status: TLoodsmanDocumentUploadingStatus;
          const StatusDateTime: TDateTime;
          const StatusInitiatorDTO: TDocumentFlowEmployeeInfoDTO;
          const ErrorMessage: String = ''
        ); overload;

        function GetSelf: TObject;

        property StatusInitiatorDTO: TDocumentFlowEmployeeInfoDTO
        read FStatusInitiatorDTO write SetStatusInitiatorDTO;
        
    end;

  ILoodsmanDocumentUploadingInfo = interface (IGetSelf)

  end;

  TLoodsmanDocumentUploadingInfo = class (TInterfacedObject, ILoodsmanDocumentUploadingInfo)

    private

      FAccessRights: TLoodsmanDocumentUploadingAccessRights;
      FDocumentFullInfoDTO: TDocumentFullInfoDTO;
      FStatusInfo: TLoodsmanDocumentUploadingStatusInfo;
      
      procedure SetAccessRights(
        const Value: TLoodsmanDocumentUploadingAccessRights
      );
      
      procedure SetDocumentFullInfoDTO(const Value: TDocumentFullInfoDTO);
      procedure SetStatusInfo(const Value: TLoodsmanDocumentUploadingStatusInfo);

    public

      destructor Destroy; override;
      constructor Create;
      constructor CreateAsEmpty;

      function IsEmpty: Boolean;
      
      property AccessRights: TLoodsmanDocumentUploadingAccessRights
      read FAccessRights write SetAccessRights;

      property DocumentFullInfoDTO: TDocumentFullInfoDTO
      read FDocumentFullInfoDTO write SetDocumentFullInfoDTO;

      property StatusInfo: TLoodsmanDocumentUploadingStatusInfo
      read FStatusInfo write SetStatusInfo;

      function GetSelf: TObject;
          
  end;
  
implementation

{ TLoodsmanDocumentUploadingInfo }

constructor TLoodsmanDocumentUploadingInfo.CreateAsEmpty;
begin

  Create;
  
end;

constructor TLoodsmanDocumentUploadingInfo.Create;
begin

  inherited;

  Self.AccessRights := TLoodsmanDocumentUploadingAccessRights.Create;
  Self.DocumentFullInfoDTO := TDocumentFullInfoDTO.Create;
  Self.FStatusInfo := TLoodsmanDocumentUploadingStatusInfo.Create;
  
end;

destructor TLoodsmanDocumentUploadingInfo.Destroy;
begin

  FreeAndNil(FAccessRights);
  FreeAndNil(FDocumentFullInfoDTO);
  FreeAndNil(FStatusInfo);
  
  inherited;

end;

function TLoodsmanDocumentUploadingInfo.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TLoodsmanDocumentUploadingInfo.IsEmpty: Boolean;
begin

  Result := FStatusInfo.Status = usUnknown;
  
end;

procedure TLoodsmanDocumentUploadingInfo.SetAccessRights(
  const Value: TLoodsmanDocumentUploadingAccessRights);
begin

  if FAccessRights = Value then Exit;

  FreeAndNil(FAccessRights);
  
  FAccessRights := Value;

end;

procedure TLoodsmanDocumentUploadingInfo.SetDocumentFullInfoDTO(
  const Value: TDocumentFullInfoDTO);
begin

  if FDocumentFullInfoDTO = Value then Exit;

  FreeAndNil(FDocumentFullInfoDTO);

  FDocumentFullInfoDTO := Value;

end;

procedure TLoodsmanDocumentUploadingInfo.SetStatusInfo(
  const Value: TLoodsmanDocumentUploadingStatusInfo);
begin

  if FStatusInfo = Value then Exit;

  FreeAndNil(FStatusInfo);
  
  FStatusInfo := Value;

end;

{ TLoodsmanDocumentUploadingAccessRights }

function TLoodsmanDocumentUploadingAccessRights.GetSelf: TObject;
begin

  Result := Self;
  
end;

{ TLoodsmanDocumentUploadingStatusInfo }

constructor TLoodsmanDocumentUploadingStatusInfo.Create;
begin

  Create(usUnknown, 0, nil);
  
end;

constructor TLoodsmanDocumentUploadingStatusInfo.Create(
  const Status: TLoodsmanDocumentUploadingStatus;
  const StatusDateTime: TDateTime;
  const StatusInitiatorDTO: TDocumentFlowEmployeeInfoDTO;
  const ErrorMessage: String
);
begin

  inherited Create;

  Self.Status := Status;
  Self.StatusDateTime := StatusDateTime;
  Self.StatusInitiatorDTO := StatusInitiatorDTO;
  Self.ErrorMessage := ErrorMessage;
  
end;

destructor TLoodsmanDocumentUploadingStatusInfo.Destroy;
begin

  FreeAndNil(FStatusInitiatorDTO);

  inherited;

end;

function TLoodsmanDocumentUploadingStatusInfo.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TLoodsmanDocumentUploadingStatusInfo.SetStatusInitiatorDTO(
  const Value: TDocumentFlowEmployeeInfoDTO);
begin

  if FStatusInitiatorDTO = Value then Exit;

  FreeAndNil(FStatusInitiatorDTO);
  
  FStatusInitiatorDTO := Value;

end;

end.
