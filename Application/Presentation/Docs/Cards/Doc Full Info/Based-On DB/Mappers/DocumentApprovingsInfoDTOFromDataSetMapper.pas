unit DocumentApprovingsInfoDTOFromDataSetMapper;

interface

uses

  Disposable,
  DocumentFullInfoDTO,
  DepartmentInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  VariantListUnit,
  SysUtils,
  DocumentApprovingsInfoHolder;

type

  TDocumentApprovingsInfoDTOFromDataSetMapper =
    class (TInterfacedObject, IDisposable)

      public

        function CreateDocumentApprovingsInfoDTOInstance: TDocumentApprovingsInfoDTO; virtual;
        function CreateDocumentApprovingInfoDTOInstance: TDocumentApprovingInfoDTO; virtual;

      public

        function MapDocumentApprovingInfoDTOFrom(
          DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder
        ): TDocumentApprovingInfoDTO;

        function MapDocumentFormalApproverInfoDTOFrom(
          DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder
        ): TDocumentFlowEmployeeInfoDTO;

        function MapDocumentActualApproverInfoDTOFrom(
          DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder
        ): TDocumentFlowEmployeeInfoDTO;

      public

        function MapDocumentApprovingsInfoDTOFrom(
          DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder
        ): TDocumentApprovingsInfoDTO;
        
    end;

implementation

uses

  Variants;

{ TDocumentApprovingsInfoDTOFromDataSetMapper }

function TDocumentApprovingsInfoDTOFromDataSetMapper
  .MapDocumentApprovingsInfoDTOFrom(
    DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder
  ): TDocumentApprovingsInfoDTO;

var
    DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;
    HandledDocumentApprovingIds: TVariantList;
begin

  HandledDocumentApprovingIds := TVariantList.Create;

  try

    Result := CreateDocumentApprovingsInfoDTOInstance;
    
    try

      with DocumentApprovingsInfoHolder do begin

        First;

        while not Eof do begin

          if not VarIsNull(DocumentApprovingIdFieldValue) and
             VarIsNull(DocumentApprovingCycleNumberFieldValue) and
             not HandledDocumentApprovingIds.Contains(DocumentApprovingIdFieldValue)

          then begin

            DocumentApprovingInfoDTO :=
              MapDocumentApprovingInfoDTOFrom(DocumentApprovingsInfoHolder);

            Result.Add(DocumentApprovingInfoDTO);

            HandledDocumentApprovingIds.Add(DocumentApprovingInfoDTO.Id);
            
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

    FreeAndNil(HandledDocumentApprovingIds);
    
  end;

end;

function TDocumentApprovingsInfoDTOFromDataSetMapper.MapDocumentApprovingInfoDTOFrom(
  DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder): TDocumentApprovingInfoDTO;
begin

  Result := CreateDocumentApprovingInfoDTOInstance;

  try

    with DocumentApprovingsInfoHolder do begin

      Result.Id := DocumentApprovingIdFieldValue;
      Result.PerformingDateTime := DocumentApprovingPerformingDateTimeFieldValue;
      Result.SetPerformingResultFromDomain(DocumentApprovingPerformingResultIdFieldValue);
      Result.PerformingResultName := DocumentApprovingPerformingResultFieldValue;
      Result.Note := DocumentApprovingNoteFieldValue;
      Result.IsViewedByApprover := DocumentApprovingIsLookedByApproverFieldValue;
      Result.IsAccessible := DocumentApprovingIsAccessibleFieldValue;

      Result.ApproverInfoDTO :=
        MapDocumentFormalApproverInfoDTOFrom(DocumentApprovingsInfoHolder);

      Result.ActuallyPerformedEmployeeInfoDTO :=
        MapDocumentActualApproverInfoDTOFrom(DocumentApprovingsInfoHolder);

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;

    end;

  end;

end;

function TDocumentApprovingsInfoDTOFromDataSetMapper.MapDocumentActualApproverInfoDTOFrom(
  DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder): TDocumentFlowEmployeeInfoDTO;
begin

  Result := TDocumentFlowEmployeeInfoDTO.Create;

  try

    with DocumentApprovingsInfoHolder do begin

      Result.Id := DocumentActualApproverIdFieldValue;
      Result.LeaderId := DocumentActualApproverLeaderIdFieldValue;
      Result.IsForeign := DocumentActualApproverIsForeignFieldValue;
      Result.FullName := DocumentActualApproverNameFieldValue;
      Result.Speciality := DocumentActualApproverSpecialityFieldValue;

      Result.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

      Result.DepartmentInfoDTO.Id := DocumentActualApproverDepartmentIdFieldValue;
      Result.DepartmentInfoDTO.Code := DocumentActualApproverDepartmentCodeFieldValue;
      Result.DepartmentInfoDTO.Name := DocumentActualApproverDepartmentNameFieldValue;
  
    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;

end;

function TDocumentApprovingsInfoDTOFromDataSetMapper.MapDocumentFormalApproverInfoDTOFrom(
  DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder): TDocumentFlowEmployeeInfoDTO;
begin

  Result := TDocumentFlowEmployeeInfoDTO.Create;

  try

    with DocumentApprovingsInfoHolder do begin

      Result.Id := DocumentApproverIdFieldValue;
      Result.LeaderId := DocumentApproverLeaderIdFieldValue;
      Result.IsForeign := DocumentApproverIsForeignFieldValue;
      Result.FullName := DocumentApproverNameFieldValue;
      Result.Speciality := DocumentApproverSpecialityFieldValue;

      Result.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

      Result.DepartmentInfoDTO.Id := DocumentApproverDepartmentIdFieldValue;
      Result.DepartmentInfoDTO.Code := DocumentApproverDepartmentCodeFieldValue;
      Result.DepartmentInfoDTO.Name := DocumentApproverDepartmentNameFieldValue;
  
    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;
  
end;

function TDocumentApprovingsInfoDTOFromDataSetMapper.CreateDocumentApprovingInfoDTOInstance: TDocumentApprovingInfoDTO;
begin

  Result := TDocumentApprovingInfoDTO.Create;

end;

function TDocumentApprovingsInfoDTOFromDataSetMapper.CreateDocumentApprovingsInfoDTOInstance: TDocumentApprovingsInfoDTO;
begin

  Result := TDocumentApprovingsInfoDTO.Create;
  
end;

end.

