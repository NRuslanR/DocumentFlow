unit DocumentChargeSheetsInfoDTOFromDataSetMapper;

interface

uses

  DocumentChargeSheetsInfoDTO,
  DocumentChargeSheetsInfoHolder,
  DocumentFlowEmployeeInfoDTO,
  DepartmentInfoDTO,
  SysUtils,
  VariantListUnit,
  Disposable;

type

  TDocumentChargeSheetsInfoDTOFromDataSetMapper =
    class (TInterfacedObject, IDisposable)

      protected

        function CreateDocumentChargeSheetsInfoDTOInstance: TDocumentChargeSheetsInfoDTO; virtual;
        function CreateDocumentChargeSheetInfoDTOInstance: TDocumentChargeSheetInfoDTO; virtual;

      protected

        function MapDocumentChargeSheetInfoDTOFrom(
          DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
        ): TDocumentChargeSheetInfoDTO;
        
      public

        function MapDocumentChargeSheetsInfoDTOFrom(
          DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
        ): TDocumentChargeSheetsInfoDTO;

    end;
    
implementation

uses

  Variants, AbstractDataSetHolder;
  
{ TDocumentChargeSheetsInfoDTOFromDataSetMapper }

function TDocumentChargeSheetsInfoDTOFromDataSetMapper
  .MapDocumentChargeSheetsInfoDTOFrom(
    DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
  ): TDocumentChargeSheetsInfoDTO;

var
    HandledDocumentChargeSheetIds: TVariantList;
    DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
begin

  HandledDocumentChargeSheetIds := TVariantList.Create;

  try

    Result := CreateDocumentChargeSheetsInfoDTOInstance;

    try

      with DocumentChargeSheetsInfoHolder do begin

        First;

        while not Eof do begin

          if not VarIsNull(DocumentChargeSheetIdFieldValue) and
             not HandledDocumentChargeSheetIds.Contains(
                    DocumentChargeSheetIdFieldValue
             )
          then begin

            DocumentChargeSheetInfoDTO :=
              MapDocumentChargeSheetInfoDTOFrom(DocumentChargeSheetsInfoHolder);

            Result.Add(DocumentChargeSheetInfoDTO);

            HandledDocumentChargeSheetIds.Add(DocumentChargeSheetIdFieldValue);
            
          end;

          Next;
          
        end;

      end;

    except

      on e: Exception do begin

        FreeAndNil(Result);
        raise;

      end;

    end;

  finally

    FreeAndNil(HandledDocumentChargeSheetIds);

  end;

end;

function TDocumentChargeSheetsInfoDTOFromDataSetMapper
  .MapDocumentChargeSheetInfoDTOFrom(
    DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
  ): TDocumentChargeSheetInfoDTO;
begin

  Result := CreateDocumentChargeSheetInfoDTOInstance;

  try

    with DocumentChargeSheetsInfoHolder do begin

      Result.Id := DocumentChargeSheetIdFieldValue;
      Result.KindId := DocumentChargeSheetKindIdFieldValue;
      Result.KindName := DocumentChargeSheetKindNameFieldValue;
      Result.ServiceKindName := DocumentChargeSheetServiceKindNameFieldName;
      Result.TopLevelChargeSheetId := TopLevelChargeSheetIdFieldValue;
      Result.DocumentId := ChargeSheetDocumentIdFieldValue;
      Result.ChargeText := DocumentChargeSheetTextFieldValue;
      Result.PerformerResponse := DocumentChargeSheetResponseFieldValue;
      Result.TimeFrameStart := DocumentChargeSheetPeriodStartFieldValue;
      Result.TimeFrameDeadline := DocumentChargeSheetPeriodEndFieldValue;
      Result.IssuingDateTime := DocumentChargeSheetIssuingDateTimeFieldValue;
      Result.PerformingDateTime := DocumentChargeSheetPerformingDateTimeFieldValue;
      Result.ViewingDateByPerformer := DocumentChargeSheetViewingDateByPerformerFieldValue;
      Result.IsForAcquaitance := DocumentChargeSheetIsForAcquaitanceFieldValue;
      
      Result.PerformerInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;
      Result.PerformerInfoDTO.Id := DocumentChargeSheetPerformerIdFieldValue;
      Result.PerformerInfoDTO.LeaderId := DocumentChargeSheetPerformerLeaderIdFieldValue;
      Result.PerformerInfoDTO.RoleId := DocumentChargeSheetPerformerRoleIdFieldValue;
      Result.PerformerInfoDTO.IsForeign := DocumentChargeSheetPerformerIsForeignFieldValue;
      Result.PerformerInfoDTO.FullName := DocumentChargeSheetPerformerNameFieldValue;
      Result.PerformerInfoDTO.Speciality := DocumentChargeSheetPerformerSpecialityFieldValue;

      Result.PerformerInfoDTO.DepartmentInfoDTO := TDepartmentInfoDTO.Create;
      Result.PerformerInfoDTO.DepartmentInfoDTO.Id := DocumentChargeSheetPerformerDepartmentIdFieldValue;
      Result.PerformerInfoDTO.DepartmentInfoDTO.Code := DocumentChargeSheetPerformerDepartmentCodeFieldValue;
      Result.PerformerInfoDTO.DepartmentInfoDTO.Name := DocumentChargeSheetPerformerDepartmentNameFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;
      Result.ActuallyPerformedEmployeeInfoDTO.Id := DocumentChargeSheetActualPerformerIdFieldValue;
      Result.ActuallyPerformedEmployeeInfoDTO.LeaderId := DocumentChargeSheetActualPerformerLeaderIdFieldValue;
      Result.ActuallyPerformedEmployeeInfoDTO.IsForeign := DocumentChargeSheetActualPerformerIsForeignFieldValue;
      Result.ActuallyPerformedEmployeeInfoDTO.FullName := DocumentChargeSheetActualPerformerNameFieldValue;
      Result.ActuallyPerformedEmployeeInfoDTO.Speciality := DocumentChargeSheetActualPerformerSpecialityFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO.DepartmentInfoDTO := TDepartmentInfoDTO.Create;
      Result.ActuallyPerformedEmployeeInfoDTO.DepartmentInfoDTO.Id := DocumentChargeSheetActualPerformerDepartmentIdFieldValue;
      Result.ActuallyPerformedEmployeeInfoDTO.DepartmentInfoDTO.Code := DocumentChargeSheetActualPerformerDepartmentCodeFieldValue;
      Result.ActuallyPerformedEmployeeInfoDTO.DepartmentInfoDTO.Name := DocumentChargeSheetActualPerformerDepartmentNameFieldValue;

      Result.SenderEmployeeInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;
      Result.SenderEmployeeInfoDTO.Id := DocumentChargeSheetSenderIdFieldValue;
      Result.SenderEmployeeInfoDTO.FullName := DocumentChargeSheetSenderNameFieldValue;
      Result.SenderEmployeeInfoDTO.Speciality := DocumentChargeSheetSenderSpecialityFieldValue;

      Result.SenderEmployeeInfoDTO.DepartmentInfoDTO := TDepartmentInfoDTO.Create;
      Result.SenderEmployeeInfoDTO.DepartmentInfoDTO.Id := DocumentChargeSheetSenderDepartmentIdFieldValue;
      Result.SenderEmployeeInfoDTO.LeaderId := DocumentChargeSheetSenderLeaderIdFieldValue;
      Result.SenderEmployeeInfoDTO.IsForeign := DocumentChargeSheetSenderIsForeignFieldValue;
      Result.SenderEmployeeInfoDTO.DepartmentInfoDTO.Code := DocumentChargeSheetSenderDepartmentCodeFieldValue;
      Result.SenderEmployeeInfoDTO.DepartmentInfoDTO.Name := DocumentChargeSheetSenderDepartmentNameFieldValue;

      {
        refactor(DocumentChargeSheetsInfoDTOFromDataSetMapper, 1):
        remove after refactor(DocumentPerformingInfoQueryBuilder, 1)
      }
      with Result.AccessRights do begin

        ViewingAllowed := GetDataSetFieldValue('can_charge_sheet_view', Null);
        ChargeSectionAccessible := GetDataSetFieldValue('has_charge_section_access', Null);
        ResponseSectionAccessible := GetDataSetFieldValue('has_response_section_access', Null);
        RemovingAllowed := GetDataSetFieldValue('can_charge_sheet_remove', Null);
        PerformingAllowed := GetDataSetFieldValue('can_charge_sheet_perform', Null);
        
      end;
      
    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;
  
end;

function TDocumentChargeSheetsInfoDTOFromDataSetMapper.
  CreateDocumentChargeSheetInfoDTOInstance: TDocumentChargeSheetInfoDTO;
begin

  Result := TDocumentChargeSheetInfoDTO.Create;

end;

function TDocumentChargeSheetsInfoDTOFromDataSetMapper.
  CreateDocumentChargeSheetsInfoDTOInstance: TDocumentChargeSheetsInfoDTO;
begin

  Result := TDocumentChargeSheetsInfoDTO.Create;

end;

end.
