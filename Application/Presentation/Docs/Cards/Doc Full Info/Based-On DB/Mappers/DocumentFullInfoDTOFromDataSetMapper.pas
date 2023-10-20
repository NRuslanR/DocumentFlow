unit DocumentFullInfoDTOFromDataSetMapper;

interface
                    
uses

  DB,
  DepartmentInfoDTO,
  DocumentResponsibleInfoDTO,
  DocumentFullInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  EmployeeInfoDTO,
  DocumentChargeSheetsInfoDTO,
  DocumentFullInfoDataSetHolder,
  DocumentDTOFromDataSetMapper,
  DocumentRelationsInfoDTOFromDataSetMapper,
  DocumentFilesInfoDTOFromDataSetMapper,
  DocumentApprovingsInfoDTOFromDataSetMapper,
  DocumentApprovingCycleResultsInfoDTOFromDataSetMapper,
  DocumentChargesInfoDTOFromDataSetMapper,
  DocumentChargeSheetsInfoDTOFromDataSetMapper,
  Disposable,
  SysUtils,
  Classes;

type

  TDocumentFullInfoDTOFromDataSetMapper = class

    private

      function CreateDocumentApprovingCycleResultInfoDTOInstance: TDocumentApprovingCycleResultInfoDTO;
      function CreateDocumentApprovingCycleResultsInfoDTOInstance: TDocumentApprovingCycleResultsInfoDTO;
      function CreateDocumentApprovingInfoDTOInstance: TDocumentApprovingInfoDTO;
      function CreateDocumentApprovingsInfoDTOInstance: TDocumentApprovingsInfoDTO;
      function CreateDocumentChargeInfoDTOInstance: TDocumentChargeInfoDTO;
      function CreateDocumentChargeSheetInfoDTOInstance: TDocumentChargeSheetInfoDTO;
      function CreateDocumentChargesInfoDTOInstance: TDocumentChargesInfoDTO;
      function CreateDocumentDTOInstance: TDocumentDTO;
      function CreateDocumentFilesInfoDTOInstance: TDocumentFilesInfoDTO;
      function CreateDocumentRelationsInfoDTOInstance: TDocumentRelationsInfoDTO;
      function CreateDocumentSigningInfoDTOInstance: TDocumentSigningInfoDTO;
      function CreateDocumentSigningsInfoDTOInstance: TDocumentSigningsInfoDTO;

    protected

      FDocumentDTOFromDataSetMapper: TDocumentDTOFromDataSetMapper;
      FFreeDocumentDTOFromDataSetMapper: IDisposable;

      FDocumentApprovingsInfoDTOFromDataSetMapper: TDocumentApprovingsInfoDTOFromDataSetMapper;
      FFreeDocumentApprovingsInfoDTOFromDataSetMapper: IDisposable;

      FDocumentApprovingCycleResultsInfoDTOFromDataSetMapper: TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper;
      FFreeDocumentApprovingCycleResultsInfoDTOFromDataSetMapper: IDisposable;

      FDocumentChargesInfoDTOFromDataSetMapper: TDocumentChargesInfoDTOFromDataSetMapper;
      FFreeDocumentChargesInfoDTOFromDataSetMapper: IDisposable;

      FDocumentChargeSheetsInfoDTOFromDataSetMapper: TDocumentChargeSheetsInfoDTOFromDataSetMapper;
      FFreeDocumentChargeSheetsInfoDTOFromDataSetMapper: IDisposable;

      FDocumentRelationsInfoDTOFromDataSetMapper: TDocumentRelationsInfoDTOFromDataSetMapper;
      FFreeDocumentRelationsInfoDTOFromDataSetMapper: IDisposable;

      FDocumentFilesInfoDTOFromDataSetMapper: TDocumentFilesInfoDTOFromDataSetMapper;
      FFreeDocumentFilesInfoDTOFromDataSetMapper: IDisposable;

      function CreateDocumentFullInfoDTOInstance: TDocumentFullInfoDTO; virtual;
      
    public

      constructor Create(
        DocumentDTOFromDataSetMapper: TDocumentDTOFromDataSetMapper;
        DocumentApprovingsInfoDTOFromDataSetMapper: TDocumentApprovingsInfoDTOFromDataSetMapper;
        DocumentApprovingCycleResultsInfoDTOFromDataSetMapper: TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper;
        DocumentChargesInfoDTOFromDataSetMapper: TDocumentChargesInfoDTOFromDataSetMapper;
        DocumentChargeSheetsInfoDTOFromDataSetMapper: TDocumentChargeSheetsInfoDTOFromDataSetMapper;
        DocumentRelationsInfoDTOFromDataSetMapper: TDocumentRelationsInfoDTOFromDataSetMapper;
        DocumentFilesInfoDTOFromDataSetMapper: TDocumentFilesInfoDTOFromDataSetMapper
      );

      function MapDocumentFullInfoDTOFrom(
        DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
      ): TDocumentFullInfoDTO; virtual;

      function MapDocumentDTOFrom(
        DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
      ): TDocumentDTO; virtual;

      function MapDocumentApprovingsInfoDTOFrom(
        DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
      ): TDocumentApprovingsInfoDTO; virtual;
      
      function MapDocumentChargeSheetsInfoDTOFrom(
        DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
      ): TDocumentChargeSheetsInfoDTO; virtual;

      function MapDocumentApprovingCycleResultsInfoDTOFrom(
        DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
      ): TDocumentApprovingCycleResultsInfoDTO; virtual;

      function MapDocumentSigningsInfoDTOFrom(
        DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
      ): TDocumentSigningsInfoDTO; virtual;

      function MapDocumentChargesInfoDTOFrom(
        DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
      ): TDocumentChargesInfoDTO; virtual;

      function MapDocumentFilesInfoDTOFrom(
        DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
      ): TDocumentFilesInfoDTO; virtual;

      function MapDocumentRelationsInfoDTOFrom(
        DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
      ): TDocumentRelationsInfoDTO; virtual;

  end;

implementation

uses

  Variants,
  VariantListUnit;

{ TDocumentFullInfoDTOFromDataSetMapper }

function TDocumentFullInfoDTOFromDataSetMapper.MapDocumentFullInfoDTOFrom(
  DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
): TDocumentFullInfoDTO;
begin

  if DocumentFullInfoDataSetHolder.IsEmpty then begin

    Result := nil;
    Exit;

  end;
                                            
  Result := CreateDocumentFullInfoDTOInstance;

  try

    Result.DocumentDTO := MapDocumentDTOFrom(DocumentFullInfoDataSetHolder);
    Result.DocumentRelationsInfoDTO := MapDocumentRelationsInfoDTOFrom(DocumentFullInfoDataSetHolder);
    Result.DocumentFilesInfoDTO := MapDocumentFilesInfoDTOFrom(DocumentFullInfoDataSetHolder);
    Result.DocumentChargeSheetsInfoDTO := MapDocumentChargeSheetsInfoDTOFrom(DocumentFullInfoDataSetHolder);
    Result.DocumentApprovingCycleResultsInfoDTO := MapDocumentApprovingCycleResultsInfoDTOFrom(DocumentFullInfoDataSetHolder);
  
  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;

end;

function TDocumentFullInfoDTOFromDataSetMapper.
  MapDocumentApprovingCycleResultsInfoDTOFrom(
    DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
  ): TDocumentApprovingCycleResultsInfoDTO;
begin

  Result :=
    FDocumentApprovingCycleResultsInfoDTOFromDataSetMapper
      .MapDocumentApprovingCycleResultsInfoDTOFrom(
        DocumentFullInfoDataSetHolder.ApprovingsInfoHolder
      );

end;

function TDocumentFullInfoDTOFromDataSetMapper.MapDocumentApprovingsInfoDTOFrom(
  DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder): TDocumentApprovingsInfoDTO;
begin

  Result :=
    FDocumentApprovingsInfoDTOFromDataSetMapper
      .MapDocumentApprovingsInfoDTOFrom(
        DocumentFullInfoDataSetHolder.ApprovingsInfoHolder
      );
  
end;

function TDocumentFullInfoDTOFromDataSetMapper.
  MapDocumentChargeSheetsInfoDTOFrom(
    DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
  ): TDocumentChargeSheetsInfoDTO;
begin

  Result :=
    FDocumentChargeSheetsInfoDTOFromDataSetMapper
      .MapDocumentChargeSheetsInfoDTOFrom(
        DocumentFullInfoDataSetHolder.ChargeSheetsInfoHolder
      );

end;

function TDocumentFullInfoDTOFromDataSetMapper.MapDocumentChargesInfoDTOFrom(
  DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
): TDocumentChargesInfoDTO;
begin

  Result :=
    FDocumentChargesInfoDTOFromDataSetMapper
      .MapDocumentChargesInfoDTOFrom(
        DocumentFullInfoDataSetHolder.ChargesInfoHolder
      );

end;

function TDocumentFullInfoDTOFromDataSetMapper.MapDocumentDTOFrom(
  DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
): TDocumentDTO;
begin

  Result :=
    FDocumentDTOFromDataSetMapper.MapDocumentDTOFrom(
      DocumentFullInfoDataSetHolder.DocumentInfoHolder
    );

  Result.ChargesInfoDTO :=
    MapDocumentChargesInfoDTOFrom(DocumentFullInfoDataSetHolder);

  Result.ApprovingsInfoDTO :=
    MapDocumentApprovingsInfoDTOFrom(DocumentFullInfoDataSetHolder);

end;

function TDocumentFullInfoDTOFromDataSetMapper.MapDocumentFilesInfoDTOFrom(
  DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
): TDocumentFilesInfoDTO;
begin

  Result :=
    FDocumentFilesInfoDTOFromDataSetMapper
      .MapDocumentFilesInfoDTOFrom(
        DocumentFullInfoDataSetHolder.FilesInfoHolder
      );

end;

function TDocumentFullInfoDTOFromDataSetMapper.MapDocumentRelationsInfoDTOFrom(
  DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
): TDocumentRelationsInfoDTO;
begin

  Result :=
    FDocumentRelationsInfoDTOFromDataSetMapper
      .MapDocumentRelationsInfoDTOFrom(
        DocumentFullInfoDataSetHolder.RelationsInfoHolder
      );

end;

function TDocumentFullInfoDTOFromDataSetMapper.MapDocumentSigningsInfoDTOFrom(
  DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder): TDocumentSigningsInfoDTO;
begin

end;

constructor TDocumentFullInfoDTOFromDataSetMapper.Create(
  DocumentDTOFromDataSetMapper: TDocumentDTOFromDataSetMapper;
  DocumentApprovingsInfoDTOFromDataSetMapper: TDocumentApprovingsInfoDTOFromDataSetMapper;
  DocumentApprovingCycleResultsInfoDTOFromDataSetMapper: TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper;
  DocumentChargesInfoDTOFromDataSetMapper: TDocumentChargesInfoDTOFromDataSetMapper;
  DocumentChargeSheetsInfoDTOFromDataSetMapper: TDocumentChargeSheetsInfoDTOFromDataSetMapper;
  DocumentRelationsInfoDTOFromDataSetMapper: TDocumentRelationsInfoDTOFromDataSetMapper;
  DocumentFilesInfoDTOFromDataSetMapper: TDocumentFilesInfoDTOFromDataSetMapper);
begin

  inherited Create;

  FDocumentDTOFromDataSetMapper := DocumentDTOFromDataSetMapper;
  FFreeDocumentDTOFromDataSetMapper := FDocumentDTOFromDataSetMapper;

  FDocumentApprovingsInfoDTOFromDataSetMapper := DocumentApprovingsInfoDTOFromDataSetMapper;
  FFreeDocumentApprovingsInfoDTOFromDataSetMapper := FDocumentApprovingsInfoDTOFromDataSetMapper;

  FDocumentApprovingCycleResultsInfoDTOFromDataSetMapper := DocumentApprovingCycleResultsInfoDTOFromDataSetMapper;
  FFreeDocumentApprovingCycleResultsInfoDTOFromDataSetMapper := FDocumentApprovingCycleResultsInfoDTOFromDataSetMapper;

  FDocumentChargesInfoDTOFromDataSetMapper := DocumentChargesInfoDTOFromDataSetMapper;
  FFreeDocumentChargesInfoDTOFromDataSetMapper := FDocumentChargesInfoDTOFromDataSetMapper;

  FDocumentChargeSheetsInfoDTOFromDataSetMapper := DocumentChargeSheetsInfoDTOFromDataSetMapper;
  FFreeDocumentChargeSheetsInfoDTOFromDataSetMapper := FDocumentChargeSheetsInfoDTOFromDataSetMapper;

  FDocumentRelationsInfoDTOFromDataSetMapper := DocumentRelationsInfoDTOFromDataSetMapper;
  FFreeDocumentRelationsInfoDTOFromDataSetMapper := FDocumentRelationsInfoDTOFromDataSetMapper;

  FDocumentFilesInfoDTOFromDataSetMapper := DocumentFilesInfoDTOFromDataSetMapper;
  FFreeDocumentFilesInfoDTOFromDataSetMapper := FDocumentFilesInfoDTOFromDataSetMapper;
  
end;

function TDocumentFullInfoDTOFromDataSetMapper.CreateDocumentApprovingCycleResultInfoDTOInstance: TDocumentApprovingCycleResultInfoDTO;
begin

  Result := TDocumentApprovingCycleResultInfoDTO.Create;

end;

function TDocumentFullInfoDTOFromDataSetMapper.CreateDocumentApprovingCycleResultsInfoDTOInstance: TDocumentApprovingCycleResultsInfoDTO;
begin

  Result := TDocumentApprovingCycleResultsInfoDTO.Create;
  
end;

function TDocumentFullInfoDTOFromDataSetMapper.CreateDocumentApprovingInfoDTOInstance: TDocumentApprovingInfoDTO;
begin

  Result := TDocumentApprovingInfoDTO.Create;
  
end;

function TDocumentFullInfoDTOFromDataSetMapper.CreateDocumentApprovingsInfoDTOInstance: TDocumentApprovingsInfoDTO;
begin

  Result := TDocumentApprovingsInfoDTO.Create;
  
end;

function TDocumentFullInfoDTOFromDataSetMapper.CreateDocumentChargeInfoDTOInstance: TDocumentChargeInfoDTO;
begin

  Result := TDocumentChargeInfoDTO.Create;

end;

function TDocumentFullInfoDTOFromDataSetMapper.CreateDocumentChargeSheetInfoDTOInstance: TDocumentChargeSheetInfoDTO;
begin

  Result := TDocumentChargeSheetInfoDTO.Create;

end;

function TDocumentFullInfoDTOFromDataSetMapper.CreateDocumentChargesInfoDTOInstance: TDocumentChargesInfoDTO;
begin

  Result := TDocumentChargesInfoDTO.Create;

end;

function TDocumentFullInfoDTOFromDataSetMapper.CreateDocumentDTOInstance: TDocumentDTO;
begin

  Result := TDocumentDTO.Create;
  
end;

function TDocumentFullInfoDTOFromDataSetMapper.CreateDocumentFilesInfoDTOInstance: TDocumentFilesInfoDTO;
begin

  Result := TDocumentFilesInfoDTO.Create;
  
end;

function TDocumentFullInfoDTOFromDataSetMapper.CreateDocumentFullInfoDTOInstance: TDocumentFullInfoDTO;
begin

  Result := TDocumentFullInfoDTO.Create;
  
end;

function TDocumentFullInfoDTOFromDataSetMapper.CreateDocumentRelationsInfoDTOInstance: TDocumentRelationsInfoDTO;
begin

  Result := TDocumentRelationsInfoDTO.Create;
  
end;

function TDocumentFullInfoDTOFromDataSetMapper.CreateDocumentSigningInfoDTOInstance: TDocumentSigningInfoDTO;
begin

  Result := TDocumentSigningInfoDTO.Create;
  
end;

function TDocumentFullInfoDTOFromDataSetMapper.CreateDocumentSigningsInfoDTOInstance: TDocumentSigningsInfoDTO;
begin

  Result := TDocumentSigningsInfoDTO.Create;
  
end;

end.
