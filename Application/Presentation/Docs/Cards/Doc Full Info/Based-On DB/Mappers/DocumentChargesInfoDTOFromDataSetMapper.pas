unit DocumentChargesInfoDTOFromDataSetMapper;

interface

uses

  DocumentChargeSheetsInfoDTO,
  DocumentChargesInfoHolder,
  DocumentFlowEmployeeInfoDTO,
  DepartmentInfoDTO,
  VariantListUnit,
  SysUtils,
  Disposable;

type

  TDocumentChargesInfoDTOFromDataSetMapper = class (TInterfacedObject, IDisposable)

    protected

      function CreateDocumentChargesInfoDTOInstance: TDocumentChargesInfoDTO; virtual;
      function CreateDocumentChargeInfoDTOInstance: TDocumentChargeInfoDTO; virtual;

    public

    function MapDocumentChargeInfoDTOFrom(DocumentChargesInfoHolder: TDocumentChargesInfoHolder): TDocumentChargeInfoDTO;
    function MapDocumentChargesInfoDTOFrom(DocumentChargesInfoHolder: TDocumentChargesInfoHolder): TDocumentChargesInfoDTO;

  end;

implementation

uses

  Variants;

{ TDocumentChargesInfoDTOFromDataSetMapper }

function TDocumentChargesInfoDTOFromDataSetMapper
  .MapDocumentChargesInfoDTOFrom(
    DocumentChargesInfoHolder: TDocumentChargesInfoHolder
  ): TDocumentChargesInfoDTO;

var
    HandledDocumentChargeIds: TVariantList;
    DocumentChargeInfoDTO: TDocumentChargeInfoDTO;
begin

  HandledDocumentChargeIds := TVariantList.Create;

  try

    Result := CreateDocumentChargesInfoDTOInstance;

    try

      with DocumentChargesInfoHolder do begin

        First;

        while not Eof do begin

          if
              not VarIsNull(IdFieldValue) and
              not HandledDocumentChargeIds.Contains(IdFieldValue)
          then begin

            DocumentChargeInfoDTO :=
              MapDocumentChargeInfoDTOFrom(DocumentChargesInfoHolder);

            Result.Add(DocumentChargeInfoDTO);

            HandledDocumentChargeIds.Add(IdFieldValue);

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

    FreeAndNil(HandledDocumentChargeIds);

  end;

end;

function TDocumentChargesInfoDTOFromDataSetMapper.CreateDocumentChargesInfoDTOInstance: TDocumentChargesInfoDTO;
begin

  Result := TDocumentChargesInfoDTO.Create;

end;

function TDocumentChargesInfoDTOFromDataSetMapper.MapDocumentChargeInfoDTOFrom(
  DocumentChargesInfoHolder: TDocumentChargesInfoHolder): TDocumentChargeInfoDTO;
begin

  Result := CreateDocumentChargeInfoDTOInstance;

  try

    with DocumentChargesInfoHolder do begin

      Result.Id := IdFieldValue;
      Result.KindId := KindIdFieldValue;
      Result.KindName := KindNameFieldValue;
      Result.ServiceKindName := ServiceKindNameFieldValue;
      Result.ChargeText := ChargeTextFieldValue;
      Result.PerformerResponse := ResponseFieldValue;
      Result.TimeFrameStart := TimeFrameStartFieldValue;
      Result.TimeFrameDeadline := TimeFrameDeadlineFieldValue;
      Result.PerformingDateTime := PerformingDateTimeFieldValue;
      Result.IsForAcquaitance := IsForAcquaitanceFieldValue;

      Result.PerformerInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;

      Result.PerformerInfoDTO.Id := PerformerIdFieldValue;
      Result.PerformerInfoDTO.IsForeign := PerformerIsForeignFieldValue;
      Result.PerformerInfoDTO.FullName := PerformerNameFieldValue;
      Result.PerformerInfoDTO.Speciality := PerformerSpecialityFieldValue;

      Result.PerformerInfoDTO.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

      Result.PerformerInfoDTO.DepartmentInfoDTO.Id :=
        PerformerDepartmentIdFieldValue;

      Result.PerformerInfoDTO.DepartmentInfoDTO.Code :=
        PerformerDepartmentCodeFieldValue;

      Result.PerformerInfoDTO.DepartmentInfoDTO.Name :=
        PerformerDepartmentNameFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;

      Result.ActuallyPerformedEmployeeInfoDTO.Id :=
        ActualPerformerIdFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO.FullName :=
        ActualPerformerNameFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO.Speciality :=
        ActualPerformerSpecialityFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO.DepartmentInfoDTO :=
        TDepartmentInfoDTO.Create;

      Result.ActuallyPerformedEmployeeInfoDTO.DepartmentInfoDTO.Id :=
        ActualPerformerDepartmentIdFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO.DepartmentInfoDTO.Code :=
        ActualPerformerDepartmentCodeFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO.DepartmentInfoDTO.Name :=
        ActualPerformerDepartmentNameFieldValue;

    end;

  except

      FreeAndNil(Result);

      Raise;

  end;

end;

function TDocumentChargesInfoDTOFromDataSetMapper.CreateDocumentChargeInfoDTOInstance: TDocumentChargeInfoDTO;
begin

  Result := TDocumentChargeInfoDTO.Create;
  
end;

end.
