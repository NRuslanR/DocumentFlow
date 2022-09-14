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
  DocumentChargesFormViewModelUnit,
  SysUtils,
  Classes,
  DB;

type

  TDocumentChargeSheetsChangesInfoDTOMapper = class

    protected

      function MapDocumentChargeSheetsInfoDTOFrom(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargeSheetsInfoDTO; virtual;
      
      function MapAddedDocumentChargeSheetsInfoDTOFrom(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargeSheetsInfoDTO; virtual;

      function MapChangedDocumentChargeSheetsInfoDTOFrom(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargeSheetsInfoDTO; virtual;

      function MapRemovedDocumentChargeSheetsInfoDTOFrom(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargeSheetsInfoDTO; virtual;

    public

      function MapDocumentChargeSheetsChangesInfoDTOFrom(
        DocumentChargesFormViewModel: TDocumentChargesFormViewModel
      ): TDocumentChargeSheetsChangesInfoDTO; virtual;
      
  end;
  
implementation

{ TDocumentChargeSheetsChangesInfoDTOMapper }

function TDocumentChargeSheetsChangesInfoDTOMapper.
  MapDocumentChargeSheetsChangesInfoDTOFrom(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargeSheetsChangesInfoDTO;
begin

  Result := TDocumentChargeSheetsChangesInfoDTO.Create;

  try

    Result.AddedDocumentChargeSheetsInfoDTO :=
      MapAddedDocumentChargeSheetsInfoDTOFrom(
        DocumentChargesFormViewModel
      );

    Result.ChangedDocumentChargeSheetsInfoDTO :=
      MapChangedDocumentChargeSheetsInfoDTOFrom(
        DocumentChargesFormViewModel
      );

    Result.RemovedDocumentChargeSheetsInfoDTO :=
      MapRemovedDocumentChargeSheetsInfoDTOFrom(
        DocumentChargesFormViewModel
      );

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentChargeSheetsChangesInfoDTOMapper.
  MapAddedDocumentChargeSheetsInfoDTOFrom(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargeSheetsInfoDTO;
begin

  DocumentChargesFormViewModel.
    DocumentChargeSetHolder.
      RevealAddedChargeRecords;

  Result :=
    MapDocumentChargeSheetsInfoDTOFrom(DocumentChargesFormViewModel);
    
end;

function TDocumentChargeSheetsChangesInfoDTOMapper.
  MapChangedDocumentChargeSheetsInfoDTOFrom(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargeSheetsInfoDTO;
begin

  DocumentChargesFormViewModel.
    DocumentChargeSetHolder.
      RevealChangedChargeRecords;

  Result :=
    MapDocumentChargeSheetsInfoDTOFrom(DocumentChargesFormViewModel);

end;

function TDocumentChargeSheetsChangesInfoDTOMapper.
  MapRemovedDocumentChargeSheetsInfoDTOFrom(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargeSheetsInfoDTO;
begin

  DocumentChargesFormViewModel.
    DocumentChargeSetHolder.
      RevealRemovedChargeRecords;

  Result :=
    MapDocumentChargeSheetsInfoDTOFrom(DocumentChargesFormViewModel);
    
end;

function TDocumentChargeSheetsChangesInfoDTOMapper.
  MapDocumentChargeSheetsInfoDTOFrom(
    DocumentChargesFormViewModel: TDocumentChargesFormViewModel
  ): TDocumentChargeSheetsInfoDTO;
var DocumentChargesDataSetHolder: TDocumentChargeSetHolder;
    DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
begin

  DocumentChargesDataSetHolder :=
    DocumentChargesFormViewModel.DocumentChargeSetHolder;

  Result := TDocumentChargeSheetsInfoDTO.Create;

  try

    DocumentChargesDataSetHolder.First;

    with
      DocumentChargesFormViewModel,
      DocumentChargesFormViewModel.DocumentChargeSetHolder
    do begin
    
      while not DocumentChargesDataSetHolder.Eof do
      begin

        { conditional refactor: см. TDocumentChargesFormViewModel }
        
        DocumentChargeSheetInfoDTO :=
          TDocumentChargeSheetInfoDTOClass(
            DocumentChargeKindDto.ChargeInfoDTOClass.ChargeSheetInfoDTOClass
          ).Create;

        Result.Add(DocumentChargeSheetInfoDTO);

        DocumentChargeSheetInfoDTO.Id := IdFieldValue;
        DocumentChargeSheetInfoDTO.KindId := ChargeKindIdFieldValue;
        DocumentChargeSheetInfoDTO.KindName := ChargeKindNameFieldValue;
        DocumentChargeSheetInfoDTO.TopLevelChargeSheetId := TopLevelChargeIdFieldValue;
        DocumentChargeSheetInfoDTO.IsForAcquaitance := IsChargeForAcquaitanceFieldValue;
        DocumentChargeSheetInfoDTO.PerformerInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;
        DocumentChargeSheetInfoDTO.PerformerInfoDTO.FullName := ReceiverFullNameFieldValue;
        DocumentChargeSheetInfoDTO.PerformerInfoDTO.Speciality := ReceiverSpecialityFieldValue;
        DocumentChargeSheetInfoDTO.PerformerInfoDTO.Id := ReceiverIdFieldValue;

        DocumentChargeSheetInfoDTO.PerformerInfoDTO.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

        DocumentChargeSheetInfoDTO.PerformerInfoDTO.DepartmentInfoDTO.Name := ReceiverDepartmentNameFieldValue;
        DocumentChargeSheetInfoDTO.PerformerResponse := ReceiverCommentFieldValue;
        DocumentChargeSheetInfoDTO.PerformingDateTime := ReceiverPerformingDateTimeFieldValue;
        DocumentChargeSheetInfoDTO.DocumentId := ReceiverDocumentIdFieldValue;
        DocumentChargeSheetInfoDTO.ChargeText := ChargeTextFieldValue;
        DocumentChargeSheetInfoDTO.PerformerInfoDTO.LeaderId := ReceiverLeaderIdFieldValue;
        DocumentChargeSheetInfoDTO.PerformerInfoDTO.IsForeign := IsReceiverForeignFieldValue;
        DocumentChargeSheetInfoDTO.SenderEmployeeInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;
        DocumentChargeSheetInfoDTO.SenderEmployeeInfoDTO.Id := ChargeSheetSenderEmployeeIdFieldValue;
        DocumentChargeSheetInfoDTO.SenderEmployeeInfoDTO.FullName := ChargeSheetSenderEmployeeNameFieldValue;
        DocumentChargeSheetInfoDTO.IssuingDateTime := ChargeSheetIssuingDateTimeFieldValue;
        
        DocumentChargesDataSetHolder.Next;

      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;


end.
