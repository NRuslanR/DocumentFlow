unit LoodsmanDocumentUploadingInfoFormViewModelMapper;

interface

uses

  LoodsmanDocumentUploadingStatus,
  LoodsmanDocumentUploadingInfo,
  LoodsmanDocumentUploadingInfoFormViewModel,
  SysUtils,
  Classes;

type

  TLoodsmanDocumentUploadingInfoFormViewModelMapper = class

    private

      function CompileStatusNameByStatus(
        const Status: TLoodsmanDocumentUploadingStatus
      ): String;

      function MapStatusNames(StatusInfo: TLoodsmanDocumentUploadingStatusInfo): TStrings;

    public

      function MapLoodsmanDocumentUploadingInfoFormViewModel(
        LoodsmanDocumentUploadingInfo: TLoodsmanDocumentUploadingInfo
      ): TLoodsmanDocumentUploadingInfoFormViewModel;
      
  end;
  
implementation

uses

  AuxiliaryStringFunctions;
  
{ TLoodsmanDocumentUploadingInfoFormViewModelMapper }

function TLoodsmanDocumentUploadingInfoFormViewModelMapper
  .CompileStatusNameByStatus(
    const Status: TLoodsmanDocumentUploadingStatus
  ): String;
begin

  Result := TLoodsmanDocumentUploadingStatusNames.GetNameByStatus(Status);
  
end;

function TLoodsmanDocumentUploadingInfoFormViewModelMapper
  .MapLoodsmanDocumentUploadingInfoFormViewModel(
    LoodsmanDocumentUploadingInfo: TLoodsmanDocumentUploadingInfo
  ): TLoodsmanDocumentUploadingInfoFormViewModel;
begin

  Result := TLoodsmanDocumentUploadingInfoFormViewModel.Create;

  if LoodsmanDocumentUploadingInfo.IsEmpty then Exit;

  with LoodsmanDocumentUploadingInfo do begin

    Result.StatusNames := MapStatusNames(StatusInfo);
    Result.StatusName := CompileStatusNameByStatus(StatusInfo.Status);
    Result.StatusDateTime := StatusInfo.StatusDateTime;
    Result.ErrorMessage := StatusInfo.ErrorMessage;
    Result.IsAccessible := not IsEmpty;

    if Assigned(StatusInfo.StatusInitiatorDTO) then
      Result.StatusInitiatorFullName := StatusInfo.StatusInitiatorDTO.FullName;

    with Result.UploadingControlToolsInfoViewModel do begin

      UploadingToolVisible := AccessRights.UploadingAllowed;

      if UploadingToolVisible then begin

        UploadingToolActive := AccessRights.UploadingAllowed;
        UploadingToolCaption := 'Выгрузить в Лоцман';

      end;

      CancellationToolVisible := AccessRights.CancellationAllowed;

      if CancellationToolVisible then begin

        CancellationToolActive := AccessRights.CancellationAllowed;
        CancellationToolCaption := 'Отменить выгрузку в Лоцман';

      end;

    end;

  end;

end;

function TLoodsmanDocumentUploadingInfoFormViewModelMapper
  .MapStatusNames(
    StatusInfo: TLoodsmanDocumentUploadingStatusInfo
  ): TStrings;
begin

  Result := TLoodsmanDocumentUploadingStatusNames.GetStatusNames;

end;

end.
