unit StandardLoodsmanDocumentUploadingStatusChangingEnsurer;

interface

uses

  LoodsmanDocumentUploadingStatusChangingEnsurer,
  LoodsmanDocumentUploadingInfo,
  LoodsmanDocumentUploadingStatus,
  Hashes,
  SysUtils,
  Classes;

type

  TStandardLoodsmanDocumentUploadingStatusChangingEnsurer =
    class (TInterfacedObject, ILoodsmanDocumentUploadingStatusChangingEnsurer)

      private
      
        type

          TStatusTransitionInfo = class

            public

              SourceStatus: TLoodsmanDocumentUploadingStatus;
              TargetStatus: TLoodsmanDocumentUploadingStatus;

              TransitionAllowed: Boolean;
              ErrorMessage: String;

              constructor Create(
                const SourceStatus: TLoodsmanDocumentUploadingStatus;
                const TargetStatus: TLoodsmanDocumentUploadingStatus;
                const TransitionAllowed: Boolean;
                const ErrorMessage: String
              );

          end;

      private

        FForbiddenUploadingStatusTransitions: TObjectHash;

        function CreateUploadingStatusTransitionInfo(
          const CurrentStatus: TLoodsmanDocumentUploadingStatus;
          const NewStatus: TLoodsmanDocumentUploadingStatus;
          const TransitionAllowed: Boolean;
          const ErrorMessage: String = ''
        ): TStatusTransitionInfo;
        
        procedure CreateForbiddenUploadingStatusTransitions;
        
        function GetUploadingStatusTransitionInfo(
          const SourceStatus: TLoodsmanDocumentUploadingStatus;
          const TargetStatus: TLoodsmanDocumentUploadingStatus
        ): TStatusTransitionInfo;

        procedure RaiseExceptionIfStatusTransitionForbidden(
          StatusTransitionInfo: TStatusTransitionInfo
        );
        
      public

        constructor Create;
        
        procedure EnsureDocumentUploadingStatusChangingAllowed(
          UploadingInfo: TLoodsmanDocumentUploadingInfo;
          const NewStatus: TLoodsmanDocumentUploadingStatus
        );

    end;

implementation

uses

  VariantFunctions,
  StrUtils;
  
{ TStandardLoodsmanDocumentUploadingStatusChangingEnsurer }

constructor TStandardLoodsmanDocumentUploadingStatusChangingEnsurer.Create;
begin

  inherited Create;

  CreateForbiddenUploadingStatusTransitions;
  
end;

procedure TStandardLoodsmanDocumentUploadingStatusChangingEnsurer
  .CreateForbiddenUploadingStatusTransitions;

  function CreateStatusTransitionTargets(
    const SourceStatus: TLoodsmanDocumentUploadingStatus
  ): TObjectHash;
  begin

    Result := TObjectHash.Create;

    case SourceStatus of
    
      usUploading, usCanceling:
      begin

        Result[
          TLoodsmanDocumentUploadingStatusNames.UPLOADING_REQUESTED_STATUS_NAME
          
        ] := 
          CreateUploadingStatusTransitionInfo(
            VarIfThen(SourceStatus = usUploading, usUploading, usCanceling),
            usUploadingRequested, 
            False
          );

        Result[
          TLoodsmanDocumentUploadingStatusNames.CANCELATION_REQUESTED_STATUS_NAME

        ] := 
          CreateUploadingStatusTransitionInfo(
            VarIfThen(SourceStatus = usUploading, usUploading, usCanceling),
            usCancelationRequested,
            False
          );
        
      end;
      
      usNotUploaded, usUploaded, usCanceled: 
      begin

        Result[
          TLoodsmanDocumentUploadingStatusNames.CANCELATION_REQUESTED_STATUS_NAME
          
        ] := 
          CreateUploadingStatusTransitionInfo(
            VarIfThen(
              SourceStatus = usNotUploaded,
              usNotUploaded,
              VarIfThen(
                SourceStatus = usUploaded,
                usUploaded,
                usCanceled
              )
            ), 
            usCancelationRequested,
            False
          )
        
      end;
      
    end;
    
  end;
  
var
    StatusTransitionInfo: TStatusTransitionInfo;
    TransitionTargets: TObjectHash;
begin

  FForbiddenUploadingStatusTransitions := TObjectHash.Create;

  try
  
    FForbiddenUploadingStatusTransitions[
      TLoodsmanDocumentUploadingStatusNames.NOT_UPLOADED_STATUS_NAME
      
    ] := CreateStatusTransitionTargets(usNotUploaded);

    FForbiddenUploadingStatusTransitions[
      TLoodsmanDocumentUploadingStatusNames.UPLOADING_STATUS_NAME
      
    ] := CreateStatusTransitionTargets(usUploading);

    FForbiddenUploadingStatusTransitions[
      TLoodsmanDocumentUploadingStatusNames.CANCELING_STATUS_NAME

    ] := CreateStatusTransitionTargets(usCanceling);

    FForbiddenUploadingStatusTransitions[
      TLoodsmanDocumentUploadingStatusNames.CANCELED_STATUS_NAME

    ] := CreateStatusTransitionTargets(usCanceled);

    FForbiddenUploadingStatusTransitions[
      TLoodsmanDocumentUploadingStatusNames.UPLOADED_STATUS_NAME

    ] := CreateStatusTransitionTargets(usUploaded);
    
  except

    FreeAndNil(FForbiddenUploadingStatusTransitions);

  end;

end;

function TStandardLoodsmanDocumentUploadingStatusChangingEnsurer.CreateUploadingStatusTransitionInfo(
  const CurrentStatus, NewStatus: TLoodsmanDocumentUploadingStatus;
  const TransitionAllowed: Boolean;
  const ErrorMessage: String = ''
): TStatusTransitionInfo;
var
    TargetErrorMessage: String;
begin

  TargetErrorMessage := 
    IfThen(
      not TransitionAllowed,
      IfThen(
        Trim(ErrorMessage) = '',
        Format(
          'Недопустимый перевод документа из статуса "%s" в статус "%s"',
          [
            TLoodsmanDocumentUploadingStatusNames.GetNameByStatus(CurrentStatus),
            TLoodsmanDocumentUploadingStatusNames.GetNameByStatus(NewStatus)
          ]
        ),
        ErrorMessage
      ),
      ''
    );
  
  Result := 
    TStatusTransitionInfo.Create(
      CurrentStatus,
      NewStatus,
      TransitionAllowed,
      TargetErrorMessage
    );
  
end;

procedure TStandardLoodsmanDocumentUploadingStatusChangingEnsurer
  .EnsureDocumentUploadingStatusChangingAllowed(
    UploadingInfo: TLoodsmanDocumentUploadingInfo;
    const NewStatus: TLoodsmanDocumentUploadingStatus
  );
var
    StatusTransitionInfo: TStatusTransitionInfo;
begin

  StatusTransitionInfo :=
    GetUploadingStatusTransitionInfo(UploadingInfo.StatusInfo.Status, NewStatus);

  RaiseExceptionIfStatusTransitionForbidden(StatusTransitionInfo);
  
end;

function TStandardLoodsmanDocumentUploadingStatusChangingEnsurer
  .GetUploadingStatusTransitionInfo(
    const SourceStatus,
    TargetStatus: TLoodsmanDocumentUploadingStatus
  ): TStatusTransitionInfo;
var
    SourceStatusName, TargetStatusName: String;
    TransitionTargets: TObjectHash;
begin

  SourceStatusName := 
    TLoodsmanDocumentUploadingStatusNames.GetNameByStatus(SourceStatus);
  
  if not FForbiddenUploadingStatusTransitions.Exists(SourceStatusName) then begin

    Result := nil;
    Exit;
    
  end;

  TransitionTargets := TObjectHash(FForbiddenUploadingStatusTransitions[SourceStatusName]);

  TargetStatusName := 
    TLoodsmanDocumentUploadingStatusNames.GetNameByStatus(TargetStatus);

  if not TransitionTargets.Exists(TargetStatusName) then begin
  
    Result := nil;
    Exit;
    
  end;

  Result := TStatusTransitionInfo(TransitionTargets[TargetStatusName]);
  
end;

procedure TStandardLoodsmanDocumentUploadingStatusChangingEnsurer.RaiseExceptionIfStatusTransitionForbidden(
  StatusTransitionInfo: TStatusTransitionInfo);
begin

  if not Assigned(StatusTransitionInfo) then Exit;

  if not StatusTransitionInfo.TransitionAllowed then begin

    Raise TLoodsmanDocumentUploadingStatusChangingEnsurerException.Create(
      StatusTransitionInfo.ErrorMessage
    );

  end;

end;

{ TStandardLoodsmanDocumentUploadingStatusChangingEnsurer.TStatusTransitionInfo }

constructor TStandardLoodsmanDocumentUploadingStatusChangingEnsurer.TStatusTransitionInfo.Create(
  const SourceStatus: TLoodsmanDocumentUploadingStatus;
  const TargetStatus: TLoodsmanDocumentUploadingStatus;
  const TransitionAllowed: Boolean; 
  const ErrorMessage: String
);
begin

  inherited Create;

  Self.SourceStatus := SourceStatus;
  Self.TargetStatus := TargetStatus;
  Self.TransitionAllowed := TransitionAllowed;
  Self.ErrorMessage := ErrorMessage;

end;

end.
