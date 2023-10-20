{
  refactor(DocumentChargeSheetsChangesInfoDTOMapper, 1):
  в соответствии с изменённым функционалом поручений
  изменить данный маппер. Сделать отдельный маппер
  на каждый тип поручения
}

unit DocumentChargeSheetsChangesInfoDTOMapper;

interface

uses

  DocumentChargeSheetsInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  DepartmentInfoDTO,
  DocumentChargeSheetsChangesInfoDTO,
  DocumentChargeSetHolder,
  DocumentChargeSheetsFormViewModel,
  SysUtils,
  Classes,
  DB;

type

  TDocumentChargeSheetsChangesInfoDTOMapper = class

    protected

      function MapDocumentChargeSheetsInfoDTOFrom(
        DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel
      ): TDocumentChargeSheetsInfoDTO; virtual;
      
      function MapAddedDocumentChargeSheetsInfoDTOFrom(
        DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel
      ): TDocumentChargeSheetsInfoDTO; virtual;

      function MapChangedDocumentChargeSheetsInfoDTOFrom(
        DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel
      ): TDocumentChargeSheetsInfoDTO; virtual;

      function MapRemovedDocumentChargeSheetsInfoDTOFrom(
        DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel
      ): TDocumentChargeSheetsInfoDTO; virtual;

    public

      function MapDocumentChargeSheetsChangesInfoDTOFrom(
        DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel
      ): TDocumentChargeSheetsChangesInfoDTO; virtual;
      
  end;
  
implementation

uses DocumentChargeSheetSetHolder;

{ TDocumentChargeSheetsChangesInfoDTOMapper }

function TDocumentChargeSheetsChangesInfoDTOMapper.
  MapDocumentChargeSheetsChangesInfoDTOFrom(
    DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel
  ): TDocumentChargeSheetsChangesInfoDTO;
begin

  Result := TDocumentChargeSheetsChangesInfoDTO.Create;

  try

    Result.AddedDocumentChargeSheetsInfoDTO :=
      MapAddedDocumentChargeSheetsInfoDTOFrom(
        DocumentChargeSheetsFormViewModel
      );

    Result.ChangedDocumentChargeSheetsInfoDTO :=
      MapChangedDocumentChargeSheetsInfoDTOFrom(
        DocumentChargeSheetsFormViewModel
      );

    Result.RemovedDocumentChargeSheetsInfoDTO :=
      MapRemovedDocumentChargeSheetsInfoDTOFrom(
        DocumentChargeSheetsFormViewModel
      );

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentChargeSheetsChangesInfoDTOMapper.
  MapAddedDocumentChargeSheetsInfoDTOFrom(
    DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel
  ): TDocumentChargeSheetsInfoDTO;
begin

  DocumentChargeSheetsFormViewModel.DocumentChargeSetHolder.RevealAddedRecords;

  Result :=
    MapDocumentChargeSheetsInfoDTOFrom(DocumentChargeSheetsFormViewModel);
    
end;

function TDocumentChargeSheetsChangesInfoDTOMapper.
  MapChangedDocumentChargeSheetsInfoDTOFrom(
    DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel
  ): TDocumentChargeSheetsInfoDTO;
begin

  DocumentChargeSheetsFormViewModel.DocumentChargeSetHolder.RevealChangedRecords;

  Result :=
    MapDocumentChargeSheetsInfoDTOFrom(DocumentChargeSheetsFormViewModel);

end;

function TDocumentChargeSheetsChangesInfoDTOMapper.
  MapRemovedDocumentChargeSheetsInfoDTOFrom(
    DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel
  ): TDocumentChargeSheetsInfoDTO;
begin

  DocumentChargeSheetsFormViewModel.DocumentChargeSetHolder.RevealRemovedRecords;

  Result :=
    MapDocumentChargeSheetsInfoDTOFrom(DocumentChargeSheetsFormViewModel);
    
end;

function TDocumentChargeSheetsChangesInfoDTOMapper.
  MapDocumentChargeSheetsInfoDTOFrom(
    DocumentChargeSheetsFormViewModel: TDocumentChargeSheetsFormViewModel
  ): TDocumentChargeSheetsInfoDTO;
var
    DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
begin

  Result := TDocumentChargeSheetsInfoDTO.Create;

  try

    with
      DocumentChargeSheetsFormViewModel,
      DocumentChargeSheetsFormViewModel.DocumentChargeSheetSetHolder
    do begin

      First;

      while not Eof do begin

        DocumentChargeSheetInfoDTO :=
          TDocumentChargeSheetInfoDTOClass(
            DocumentChargeKindDto.ChargeInfoDTOClass.ChargeSheetInfoDTOClass
          ).Create;

        Result.Add(DocumentChargeSheetInfoDTO);

        DocumentChargeSheetInfoDTO.Id := IdFieldValue;
        DocumentChargeSheetInfoDTO.KindId := KindIdFieldValue;
        DocumentChargeSheetInfoDTO.KindName := KindNameFieldValue;
        DocumentChargeSheetInfoDTO.TopLevelChargeSheetId := TopLevelChargeSheetIdFieldValue;
        DocumentChargeSheetInfoDTO.IsForAcquaitance := IsForAcquaitanceFieldValue;
        DocumentChargeSheetInfoDTO.PerformerInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;
        DocumentChargeSheetInfoDTO.PerformerInfoDTO.FullName := PerformerFullNameFieldValue;
        DocumentChargeSheetInfoDTO.PerformerInfoDTO.Speciality := PerformerSpecialityFieldValue;
        DocumentChargeSheetInfoDTO.PerformerInfoDTO.Id := PerformerIdFieldValue;

        DocumentChargeSheetInfoDTO.PerformerInfoDTO.DepartmentInfoDTO := TDepartmentInfoDTO.Create;
                                                                                    
        DocumentChargeSheetInfoDTO.PerformerInfoDTO.DepartmentInfoDTO.Name := PerformerDepartmentNameFieldValue;
        DocumentChargeSheetInfoDTO.PerformerResponse := PerformerCommentFieldValue;
        DocumentChargeSheetInfoDTO.PerformingDateTime := PerformingDateTimeFieldValue;
        DocumentChargeSheetInfoDTO.DocumentId := DocumentIdFieldValue;
        DocumentChargeSheetInfoDTO.ChargeText := ChargeTextFieldValue;
        DocumentChargeSheetInfoDTO.PerformerInfoDTO.IsForeign := IsPerformerForeignFieldValue;

        DocumentChargeSheetInfoDTO.IssuerInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;

        DocumentChargeSheetInfoDTO.IssuerInfoDTO.Id := IssuerIdFieldValue;
        DocumentChargeSheetInfoDTO.IssuerInfoDTO.FullName := IssuerNameFieldValue;
        DocumentChargeSheetInfoDTO.IssuingDateTime := IssuingDateTimeFieldValue;
        
        Next;

      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

end.
