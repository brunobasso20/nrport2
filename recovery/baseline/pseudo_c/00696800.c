/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00696800 */

char * FUN_00696800(int param_1)

{
  if (param_1 < 1) {
    if (param_1 == 0) {
      return s_WS_Success_0075a458;
    }
    if (param_1 < -0x9cf) {
      if (param_1 == -0x9d0) {
        return s_WS_RoutingServG2_ClientNotMuted_0075ad80;
      }
      if (param_1 < -0xa27) {
        if (param_1 == -0xa28) {
          return s_WS_ProfileServ_ProfileDoesNotExi_0075b320;
        }
        if (param_1 < -0xaf1) {
          if (param_1 == -0xaf2) {
            return s_WS_DBProxyServ_NoModule_0075b5d0;
          }
          switch(param_1) {
          case -2999:
            return s_WS_DBProxyServ_GameSpecificError_0075b5e8;
          case -0xb57:
            return s_WS_DBProxyServ_GameSpecificWarri_0075b60c;
          case -0xb54:
            return s_WS_DBProxyServ_GameSpecificError_0075b640;
          case -0xb02:
            return s_WS_DBProxyServ_PerCDKeyCheckRequ_0075b668;
          case -0xb01:
            return s_WS_DBProxyServ_DataAlreadyExists_0075b690;
          case -0xb00:
            return s_WS_DBProxyServ_ValidNotLatest_0075b6b4;
          case -0xaff:
            return s_WS_DBProxyServ_OutOfDateNoUpdate_0075b6d4;
          case -0xafe:
            return s_WS_DBProxyServ_OutOfDate_0075b6f8;
          case -0xafd:
            return s_WS_DBProxyServ_ItemHasDependenci_0075b714;
          case -0xafc:
            return s_WS_DBProxyServ_AgeNotOldEnough_0075b738;
          case -0xafb:
            return s_WS_DBProxyServ_InvalidPassword_0075b758;
          case -0xafa:
            return s_WS_DBProxyServ_AccountCreateDisa_0075b778;
          case -0xaf9:
            return s_WS_DBProxyServ_EMailPasswordDupl_0075b7a0;
          case -0xaf8:
            return s_WS_DBProxyServ_KeyNotUsed_0075b7c8;
          case -0xaf7:
            return s_WS_DBProxyServ_InvalidCDKey_0075b7e4;
          case -0xaf6:
            return s_WS_DBProxyServ_UserDoesNotExist_0075b800;
          case -0xaf5:
            return s_WS_DBProxyServ_KeyInUse_0075b820;
          case -0xaf4:
            return s_WS_DBProxyServ_InvalidUserName_0075b838;
          case -0xaf3:
            return s_WS_DBProxyServ_UserExists_0075b858;
          }
        }
        else {
          switch(param_1) {
          case -0xaf1:
            return s_WS_DBProxyServ_NoData_0075b344;
          case -0xaf0:
            return s_WS_DBProxyServ_DBError_0075b35c;
          case -0xa39:
            return s_WS_ProfileServ_RemoveNewsLetters_0075b374;
          case -0xa38:
            return s_WS_ProfileServ_NoNewslettersProv_0075b39c;
          case -0xa37:
            return s_WS_ProfileServ_TooManyNewsletter_0075b3c4;
          case -0xa36:
            return s_WS_ProfileServ_UnfoundNewsletter_0075b3e8;
          case -0xa35:
            return s_WS_ProfileServ_OtherError_0075b410;
          case -0xa34:
            return s_WS_ProfileServ_AccountCreationDi_0075b42c;
          case -0xa33:
            return s_WS_ProfileServ_InvalidWONUserNam_0075b454;
          case -0xa32:
            return s_WS_ProfileServ_DatabaseError_0075b478;
          case -0xa31:
            return s_WS_ProfileServ_WONUserAlreadyExi_0075b498;
          case -0xa30:
            return s_WS_ProfileServ_BadWONUserPasswor_0075b4bc;
          case -0xa2f:
            return s_WS_ProfileServ_PartySourceEntryE_0075b4e0;
          case -0xa2e:
            return s_WS_ProfileServ_NewsletterEntryEx_0075b508;
          case -0xa2d:
            return s_WS_ProfileServ_EmailAlreadyUsed_0075b530;
          case -0xa2c:
            return s_WS_ProfileServ_PartySeqAlreadySe_0075b550;
          case -0xa2b:
            return s_WS_ProfileServ_CountryNotFound_0075b574;
          case -0xa2a:
            return s_WS_ProfileServ_AgeRangeNotFound_0075b594;
          case -0xa29:
            return s_WS_ProfileServ_UserNotFound_0075b5b4;
          }
        }
      }
      else {
        switch(param_1) {
        case -0x9f8:
          return s_WS_RoutingServG2_JoinCanceled_0075ada0;
        case -0x9f7:
          return s_WS_RoutingServG2_GroupNameExceed_0075adc0;
        case -0x9f6:
          return s_WS_RoutingServG2_TooManyRecipien_0075adec;
        case -0x9f5:
          return s_WS_RoutingServG2_TooManyMembersh_0075ae10;
        case -0x9f4:
          return s_WS_RoutingServG2_Throttled_0075ae34;
        case -0x9f3:
          return s_WS_RoutingServG2_SubscriptionDoe_0075ae50;
        case -0x9f2:
          return s_WS_RoutingServG2_SubscriptionDoe_0075ae7c;
        case -0x9f1:
          return s_WS_RoutingServG2_SubscriptionAlr_0075aea8;
        case -0x9f0:
          return s_WS_RoutingServG2_ShutdownTimerDo_0075aed4;
        case -0x9ef:
          return s_WS_RoutingServG2_ShutdownTimerAl_0075af00;
        case -0x9ee:
          return s_WS_RoutingServG2_ServerFull_0075af2c;
        case -0x9ed:
          return s_WS_RoutingServG2_Pending_0075af48;
        case -0x9ec:
          return s_WS_RoutingServG2_OffsetTooLarge_0075af64;
        case -0x9eb:
          return s_WS_RoutingServG2_ObserversNotAll_0075af84;
        case -0x9ea:
          return s_WS_RoutingServG2_ObjectDoesNotEx_0075afac;
        case -0x9e9:
          return s_WS_RoutingServG2_NoUsernameInCer_0075afd0;
        case -0x9e8:
          return s_WS_RoutingServG2_NoPendingJoin_0075affc;
        case -0x9e7:
          return s_WS_RoutingServG2_MustBeVisible_0075b01c;
        case -0x9e6:
          return s_WS_RoutingServG2_MustBeSelf_0075b03c;
        case -0x9e4:
          return s_WS_RoutingServG2_MustBeModerator_0075b058;
        case -0x9e3:
          return s_WS_RoutingServG2_MustBeClient_0075b07c;
        case -0x9e2:
          return s_WS_RoutingServG2_MustBeCaptainOr_0075b09c;
        case -0x9e1:
          return s_WS_RoutingServG2_MustBeCaptain_0075b0c8;
        case -0x9e0:
          return s_WS_RoutingServG2_MustBeAuthentic_0075b0e8;
        case -0x9df:
          return s_WS_RoutingServG2_MustBeAdmin_0075b110;
        case -0x9de:
          return s_WS_RoutingServG2_LoginTypeNotSup_0075b130;
        case -0x9dd:
          return s_WS_RoutingServG2_InvalidWONUserI_0075b158;
        case -0x9dc:
          return s_WS_RoutingServG2_InvalidPassword_0075b17c;
        case -0x9db:
          return s_WS_RoutingServG2_InvalidContentT_0075b1a0;
        case -0x9da:
          return s_WS_RoutingServG2_GuestNamesReser_0075b1c4;
        case -0x9d9:
          return s_WS_RoutingServG2_GroupFull_0075b1e8;
        case -0x9d8:
          return s_WS_RoutingServG2_GroupDoesNotExi_0075b204;
        case -0x9d7:
          return s_WS_RoutingServG2_GroupDeleted_0075b228;
        case -0x9d6:
          return s_WS_RoutingServG2_GroupClosed_0075b248;
        case -0x9d5:
          return s_WS_RoutingServG2_GroupAlreadyExi_0075b268;
        case -0x9d4:
          return s_WS_RoutingServG2_GroupAlreadyCla_0075b28c;
        case -0x9d3:
          return s_WS_RoutingServG2_DuplicateDataOb_0075b2b4;
        case -0x9d2:
          return s_WS_RoutingServG2_ConnectFailure_0075b2dc;
        case -0x9d1:
          return s_WS_RoutingServG2_ClientNotPermit_0075b2fc;
        }
      }
    }
    else if (param_1 < -0x76d) {
      if (param_1 == -0x76e) {
        return s_WS_EventServ_InvalidDataType_0075ab9c;
      }
      switch(param_1) {
      case -0x9cf:
        return s_WS_RoutingServG2_ClientNotInvite_0075abbc;
      case -0x9ce:
        return s_WS_RoutingServG2_ClientNotInGrou_0075abe0;
      case -0x9cd:
        return s_WS_RoutingServG2_ClientNotBanned_0075ac04;
      case -0x9cc:
        return s_WS_RoutingServG2_ClientDoesNotEx_0075ac28;
      case -0x9cb:
        return s_WS_RoutingServG2_ClientBanned_0075ac4c;
      case -0x9ca:
        return s_WS_RoutingServG2_ClientAlreadyRe_0075ac6c;
      case -0x9c9:
        return s_WS_RoutingServG2_ClientAlreadyMu_0075ac98;
      case -0x9c8:
        return s_WS_RoutingServG2_ClientAlreadyIn_0075acbc;
      case -0x9c7:
        return s_WS_RoutingServG2_ClientAlreadyEx_0075ace4;
      case -0x9c6:
        return s_WS_RoutingServG2_ClientAlreadyBa_0075ad0c;
      case -0x9c5:
        return s_WS_RoutingServG2_CaptainRejected_0075ad34;
      case -0x9c4:
        return s_WS_RoutingServG2_BlankNamesNotAl_0075ad58;
      }
    }
    else if (param_1 < -0x4ba) {
      if (param_1 == -0x4bb) {
        return s_WS_DirServ_InvalidKey_0075a7f0;
      }
      if (param_1 < -0x5dd) {
        if (param_1 == -0x5de) {
          return s_WS_AuthServ_CDKeyBanned_0075a9d8;
        }
        if (param_1 < -0x5e5) {
          if (param_1 == -0x5e6) {
            return s_WS_AuthServ_InvalidCDKey_0075aaa4;
          }
          if (param_1 < -0x5e9) {
            if (param_1 == -0x5ea) {
              return s_WS_AuthServ_KeyNotActive_0075ab10;
            }
            if (param_1 < -0x76a) {
              if (param_1 == -0x76b) {
                return s_WS_EventServ_FailureStart_0075ab44;
              }
              if (param_1 == -0x76d) {
                return s_WS_EventServ_InvalidDateTime_0075ab60;
              }
              if (param_1 == -0x76c) {
                return s_WS_EventServ_BufferingError_0075ab80;
              }
            }
            else if (param_1 == -0x5eb) {
              return s_WS_AuthServ_KeyExpired_0075ab2c;
            }
          }
          else {
            if (param_1 == -0x5e9) {
              return s_WS_AuthServ_SetCUDError_0075aac0;
            }
            if (param_1 == -0x5e8) {
              return s_WS_AuthServ_UserSeqInUse_0075aad8;
            }
            if (param_1 == -0x5e7) {
              return s_WS_AuthServ_NotInCommunity_0075aaf4;
            }
          }
        }
        else {
          switch(param_1) {
          case -0x5e5:
            return s_WS_AuthServ_BadCommunity_0075a9f0;
          case -0x5e4:
            return s_WS_AuthServ_InvalidUserName_0075aa0c;
          case -0x5e3:
            return s_WS_AuthServ_BadPassword_0075aa28;
          case -0x5e2:
            return s_WS_AuthServ_UserNotFound_0075aa40;
          case -0x5e1:
            return s_WS_AuthServ_UserExists_0075aa5c;
          case -0x5e0:
            return s_WS_AuthServ_CRCFailed_0075aa74;
          case -0x5df:
            return s_WS_AuthServ_CDKeyInUse_0075aa8c;
          }
        }
      }
      else if (param_1 < -0x4c2) {
        if (param_1 == -0x4c3) {
          return s_WS_DirServ_PermissionExists_0075a8d0;
        }
        if (param_1 < -0x4c6) {
          if (param_1 == -0x4c7) {
            return s_WS_DirServ_MultiGetPartialFailur_0075a93c;
          }
          if (param_1 < -0x5da) {
            if (param_1 == -0x5db) {
              return s_WS_AuthServ_FailureStart_0075a988;
            }
            if (param_1 == -0x5dd) {
              return s_WS_AuthServ_BadCDKey_0075a9a4;
            }
            if (param_1 == -0x5dc) {
              return s_WS_AuthServ_BadPubKeyBlock_0075a9bc;
            }
          }
          else if (param_1 == -0x4c8) {
            return s_WS_DirServ_MultiGetFailedAllRequ_0075a960;
          }
        }
        else {
          if (param_1 == -0x4c6) {
            return s_WS_DirServ_NoACLs_0075a8ec;
          }
          if (param_1 == -0x4c5) {
            return s_WS_DirServ_MaxPermissions_0075a900;
          }
          if (param_1 == -0x4c4) {
            return s_WS_DirServ_PermissionNotFound_0075a91c;
          }
        }
      }
      else {
        switch(param_1) {
        case -0x4c2:
          return s_WS_DirServ_InvalidACLType_0075a808;
        case -0x4c1:
          return s_WS_DirServ_DataObjectNotFound_0075a824;
        case -0x4c0:
          return s_WS_DirServ_DataObjectExists_0075a844;
        case -0x4bf:
          return s_WS_DirServ_NoDataObjects_0075a860;
        case -0x4be:
          return s_WS_DirServ_InvalidDataObject_0075a87c;
        case -0x4bd:
          return s_WS_DirServ_InvalidLifespan_0075a89c;
        case -0x4bc:
          return s_WS_DirServ_InvalidMode_0075a8b8;
        }
      }
    }
    else if (param_1 < -0x13) {
      if (param_1 == -0x14) {
        return s_WS_CommServ_StatusCommon_BannedA_0075a68c;
      }
      switch(param_1) {
      case -0x4ba:
        return s_WS_DirServ_InvalidGetFlags_0075a6b4;
      case -0x4b9:
        return s_WS_DirServ_InvalidPath_0075a6d0;
      case -0x4b8:
        return s_WS_DirServ_BadDataOffset_0075a6e8;
      case -0x4b7:
        return s_WS_DirServ_MaxDataObjects_0075a704;
      case -0x4b6:
        return s_WS_DirServ_EntityTooLarge_0075a720;
      case -0x4b5:
        return s_WS_DirServ_AlreadyConnected_0075a73c;
      case -0x4b4:
        return s_WS_DirServ_DirIsFull_0075a758;
      case -0x4b3:
        return s_WS_DirServ_ServiceExists_0075a770;
      case -0x4b2:
        return s_WS_DirServ_DirExists_0075a78c;
      case -0x4b1:
        return s_WS_DirServ_ServiceNotFound_0075a7a4;
      case -0x4b0:
        return s_WS_DirServ_DirNotFound_0075a7c0;
      case -0x4af:
        return s_WS_DirServ_FailureStart_0075a7d8;
      }
    }
    else {
      switch(param_1) {
      case -0x13:
        return s_WS_CommServ_ExpiredPeerCertifica_0075a464;
      case -0x12:
        return s_WS_CommServ_BadPeerCertificate_0075a488;
      case -0x11:
        return s_WS_CommServ_BehindFirewall_0075a4a8;
      case -0x10:
        return s_WS_CommServ_InvalidMessage_0075a4c4;
      case -0xf:
        return s_WS_CommServ_InvalidSequenceNumbe_0075a4e0;
      case -0xe:
        return s_WS_CommServ_InvalidSessionId_0075a504;
      case -0xd:
        return s_WS_CommServ_DecryptionFailed_0075a524;
      case -0xc:
        return s_WS_CommServ_NotSupported_0075a544;
      case -0xb:
        return s_WS_CommServ_TimedOut_0075a560;
      case -10:
        return s_WS_CommServ_NoPortAvailable_0075a578;
      case -9:
        return s_WS_CommServ_ResourcesLow_0075a594;
      case -8:
        return s_WS_CommServ_NotAuthorized_0075a5b0;
      case -7:
        return s_WS_CommServ_SessionNotFound_0075a5cc;
      case -6:
        return s_WS_CommServ_MessageExceedsMax_0075a5e8;
      case -5:
        return s_WS_CommServ_AlreadyExists_0075a608;
      case -4:
        return s_WS_CommServ_InvalidParameters_0075a624;
      case -3:
        return s_WS_CommServ_NotAllowed_0075a644;
      case -2:
        return s_WS_CommServ_NotAvailable_0075a65c;
      case -1:
        return s_WS_CommServ_Failure_0075a678;
      }
    }
  }
  else if (param_1 < 0x186c1) {
    if (param_1 == 0x186c0) {
      return s_WS_PeerAuthClient_CompleteDecryp_00759d5c;
    }
    if (param_1 < 0x2755) {
      if (param_1 == 0x2754) {
        return s_WS_WSAEUSERS_0075a190;
      }
      switch(param_1) {
      case 0x2714:
        return s_WS_WSAEINTR_0075a44c;
      case 0x2719:
        return s_WS_WSAEBADF_0075a440;
      case 0x271d:
        return s_WS_WSAEACCES_0075a430;
      case 0x271e:
        return s_WS_WSAEFAULT_0075a420;
      case 0x2726:
        return s_WS_WSAEINVAL_0075a410;
      case 0x2728:
        return s_WS_WSAEMFILE_0075a400;
      case 0x2733:
        return s_WS_WSAEWOULDBLOCK_0075a3ec;
      case 0x2734:
        return s_WS_WSAEINPROGRESS_0075a3d8;
      case 0x2735:
        return s_WS_WSAEALREADY_0075a3c8;
      case 0x2736:
        return s_WS_WSAENOTSOCK_0075a3b8;
      case 0x2737:
        return s_WS_WSAEDESTADDRREQ_0075a3a4;
      case 0x2738:
        return s_WS_WSAEMSGSIZE_0075a394;
      case 0x2739:
        return s_WS_WSAEPROTOTYPE_0075a380;
      case 0x273a:
        return s_WS_WSAENOPROTOOPT_0075a36c;
      case 0x273b:
        return s_WS_WSAEPROTONOSUPPORT_0075a354;
      case 0x273c:
        return s_WS_WSAESOCKTNOSUPPORT_0075a33c;
      case 0x273d:
        return s_WS_WSAEOPNOTSUPP_0075a328;
      case 0x273e:
        return s_WS_WSAEPFNOSUPPORT_0075a314;
      case 0x273f:
        return s_WS_WSAEAFNOSUPPORT_0075a300;
      case 0x2740:
        return s_WS_WSAEADDRINUSE_0075a2ec;
      case 0x2741:
        return s_WS_WSAEADDRNOTAVAIL_0075a2d8;
      case 0x2742:
        return s_WS_WSAENETDOWN_0075a2c8;
      case 0x2743:
        return s_WS_WSAENETUNREACH_0075a2b4;
      case 0x2744:
        return s_WS_WSAENETRESET_0075a2a4;
      case 0x2745:
        return s_WS_WSAECONNABORTED_0075a290;
      case 0x2746:
        return s_WS_WSAECONNRESET_0075a27c;
      case 0x2747:
        return s_WS_WSAENOBUFS_0075a26c;
      case 0x2748:
        return s_WS_WSAEISCONN_0075a25c;
      case 0x2749:
        return s_WS_WSAENOTCONN_0075a24c;
      case 0x274a:
        return s_WS_WSAESHUTDOWN_0075a23c;
      case 0x274b:
        return s_WS_WSAETOOMANYREFS_0075a228;
      case 0x274c:
        return s_WS_WSAETIMEDOUT_0075a218;
      case 0x274d:
        return s_WS_WSAECONNREFUSED_0075a204;
      case 0x274e:
        return s_WS_WSAELOOP_0075a1f8;
      case 0x274f:
        return s_WS_WSAENAMETOOLONG_0075a1e4;
      case 0x2750:
        return s_WS_WSAEHOSTDOWN_0075a1d4;
      case 0x2751:
        return s_WS_WSAEHOSTUNREACH_0075a1c0;
      case 0x2752:
        return s_WS_WSAENOTEMPTY_0075a1b0;
      case 0x2753:
        return s_WS_WSAEPROCLIM_0075a1a0;
      }
    }
    else if (param_1 < 0x186ad) {
      if (param_1 == 0x186ac) {
        return s_WS_MessageUnpackFailure_0075a014;
      }
      if (param_1 < 0x186a3) {
        if (param_1 == 0x186a2) {
          return s_WS_Killed_0075a0e8;
        }
        if (param_1 < 0x276d) {
          if (param_1 == 0x276c) {
            return s_WS_WSAVERNOTSUPPORTED_0075a134;
          }
          switch(param_1) {
          case 0x2755:
            return s_WS_WSAEDQUOT_0075a180;
          case 0x2756:
            return s_WS_WSAESTALE_0075a170;
          case 0x2757:
            return s_WS_WSAEREMOTE_0075a160;
          case 0x276b:
            return s_WS_WSASYSNOTREADY_0075a14c;
          }
        }
        else if (param_1 < 0x186a1) {
          if (param_1 == 100000) {
            return s_WS_Pending_0075a100;
          }
          if (param_1 == 0x276d) {
            return s_WS_WSANOTINITIALISED_0075a10c;
          }
          if (param_1 == 0x2775) {
            return s_WS_WSAEDISCON_0075a124;
          }
        }
        else if (param_1 == 0x186a1) {
          return s_WS_TimedOut_0075a0f4;
        }
      }
      else {
        switch(param_1) {
        case 0x186a3:
          return s_WS_Incomplete_0075a0d8;
        case 0x186a4:
          return s_WS_None_0075a0d0;
        case 0x186a5:
          return s_WS_AwaitingCompletion_0075a0b8;
        case 0x186a6:
          return s_WS_InvalidMessage_0075a0a4;
        case 0x186a7:
          return s_WS_FailedToOpenFile_0075a090;
        case 0x186a8:
          return s_WS_FailedToWriteToFile_0075a078;
        case 0x186a9:
          return s_WS_BlockMode_NotSupported_0075a05c;
        case 0x186aa:
          return s_WS_AsyncMode_NotSupported_0075a040;
        case 0x186ab:
          return s_WS_InvalidPublicKey_0075a02c;
        }
      }
    }
    else {
      switch(param_1) {
      case 0x186ad:
        return s_WS_AuthRequired_0075a004;
      case 0x186ae:
        return s_WS_InvalidAddress_00759ff0;
      case 0x186af:
        return s_WS_NoReply_00759fe4;
      case 0x186b0:
        return s_WS_NoInternetConnection_00759fcc;
      case 0x186b1:
        return s_WS_AsyncSocket_InvalidSocket_00759fac;
      case 0x186b2:
        return s_WS_AsyncSocket_PartialSendTo_00759f8c;
      case 0x186b3:
        return s_WS_AsyncSocket_StreamNotAllowed_00759f6c;
      case 0x186b4:
        return s_WS_AsyncSocket_DatagramNotAllowe_00759f48;
      case 0x186b5:
        return s_WS_AsyncSocket_Shutdown_00759f30;
      case 0x186b6:
        return s_WS_AsyncSocket_ConnectFailed_00759f10;
      case 0x186b7:
        return s_WS_SocketOp_InvalidSocket_00759ef4;
      case 0x186b8:
        return s_WS_RecvMsg_InvalidLengthFieldSiz_00759ed0;
      case 0x186b9:
        return s_WS_RecvMsg_InvalidMessageLength_00759eb0;
      case 0x186ba:
        return s_WS_PeerAuthClient_Challenge1Decr_00759e84;
      case 0x186bb:
        return s_WS_PeerAuthClient_Challenge1Inva_00759e54;
      case 0x186bc:
        return s_WS_PeerAuthClient_Challenge1Inva_00759e24;
      case 0x186bd:
        return s_WS_PeerAuthClient_Challenge1Cert_00759dec;
      case 0x186be:
        return s_WS_PeerAuthClient_Challenge1Cert_00759db4;
      case 0x186bf:
        return s_WS_PeerAuthClient_Challenge2Encr_00759d88;
      }
    }
  }
  else {
    switch(param_1) {
    case 0x186c1:
      return s_WS_PeerAuthClient_CompleteInvali_00759d30;
    case 0x186c2:
      return s_WS_PeerAuthClient_CompleteInvali_00759d04;
    case 0x186c3:
      return s_WS_PeerAuthClient_InvalidService_00759cdc;
    case 0x186c4:
      return s_WS_PeerAuthClient_UnexpectedChal_00759cb4;
    case 0x186c5:
      return s_WS_PeerAuthClient_InvalidMessage_00759c90;
    case 0x186c6:
      return s_WS_PeerAuthClient_MsgUnpackFailu_00759c6c;
    case 0x186c7:
      return s_WS_PeerAuthServer_NotStarted_00759c4c;
    case 0x186c8:
      return s_WS_PeerAuthServer_InvalidService_00759c24;
    case 0x186c9:
      return s_WS_PeerAuthServer_UnexpectedRequ_00759c00;
    case 0x186ca:
      return s_WS_PeerAuthServer_UnexpectedChal_00759bd8;
    case 0x186cb:
      return s_WS_PeerAuthServer_InvalidMessage_00759bb4;
    case 0x186cc:
      return s_WS_PeerAuthServer_MsgUnpackFailu_00759b90;
    case 0x186cd:
      return s_WS_PeerAuthServer_InvalidAuthMod_00759b6c;
    case 0x186ce:
      return s_WS_PeerAuthServer_InvalidEncrypt_00759b44;
    case 0x186cf:
      return s_WS_PeerAuthServer_InvalidClientC_00759b18;
    case 0x186d0:
      return s_WS_PeerAuthServer_ExpiredClientC_00759aec;
    case 0x186d1:
      return s_WS_PeerAuthServer_FailedToVerify_00759ab8;
    case 0x186d2:
      return s_WS_PeerAuthServer_FailedToEncryp_00759a84;
    case 0x186d3:
      return s_WS_PeerAuthServer_FailedToDecryp_00759a54;
    case 0x186d4:
      return s_WS_PeerAuthServer_InvalidSecretA_00759a30;
    case 0x186d5:
      return s_WS_PeerAuthServer_InvalidSecretB_00759a0c;
    case 0x186d6:
      return s_WS_PeerAuth_GetCertFailure_007599f0;
    case 0x186d7:
      return s_WS_ServerReq_FailedAllServers_007599d0;
    case 0x186d8:
      return s_WS_ServerReq_NoServersSpecified_007599b0;
    case 0x186d9:
      return s_WS_ServerReq_NeedAuthContext_00759990;
    case 0x186da:
      return s_WS_ServerReq_TryNextServer_00759974;
    case 0x186db:
      return s_WS_ServerReq_Send_00759960;
    case 0x186dc:
      return s_WS_ServerReq_Recv_0075994c;
    case 0x186dd:
      return s_WS_ServerReq_ExitCommunicationLo_00759928;
    case 0x186de:
      return s_WS_ServerReq_SessionExpired_0075990c;
    case 0x186df:
      return s_WS_ServerReq_GetCertFailure_007598f0;
    case 0x186e0:
      return s_WS_ServerReq_InvalidReplyHeader_007598d0;
    case 0x186e1:
      return s_WS_ServerReq_UnpackFailure_007598b4;
    case 0x186e2:
      return s_WS_GetCert_PubKeyEncryptFailure_00759894;
    case 0x186e3:
      return s_WS_GetCert_InvalidPubKeyReply_00759874;
    case 0x186e4:
      return s_WS_GetCert_InvalidLoginReply_00759854;
    case 0x186e5:
      return s_WS_GetCert_UnableToFindHashFile_00759834;
    case 0x186e6:
      return s_WS_GetCert_UnexpectedLoginChalle_00759810;
    case 0x186e7:
      return s_WS_GetCert_NeedVerifierKey_007597f4;
    case 0x186e8:
      return s_WS_GetCert_FailedToVerifyPubKeyB_007597cc;
    case 0x186e9:
      return s_WS_GetCert_InvalidCertificate_007597ac;
    case 0x186ea:
      return s_WS_GetCert_InvalidPubKeyBlock_0075978c;
    case 0x186eb:
      return s_WS_GetCert_DecryptFailure_00759770;
    case 0x186ec:
      return s_WS_GetCert_InvalidPrivateKey_00759750;
    case 0x186ed:
      return s_WS_GetCert_InvalidSecretConfirm_00759730;
    case 0x186ee:
      return s_WS_GetCert_MissingCertificate_00759710;
    case 0x186ef:
      return s_WS_AuthData_SetCertificateUnpack_007596e8;
    case 0x186f0:
      return s_WS_AuthData_SetPubKeyBlockUnpack_007596c0;
    case 0x186f1:
      return s_WS_AuthData_SetCertificateVerify_00759698;
    case 0x186f2:
      return s_WS_AuthData_SetPrivateKeyFailed_00759678;
    case 0x186f3:
      return s_WS_AuthSession_EncryptFailure_00759658;
    case 0x186f4:
      return s_WS_AuthSession_DecryptSessionIdM_00759630;
    case 0x186f5:
      return s_WS_AuthSession_DecryptFailure_00759610;
    case 0x186f6:
      return s_WS_AuthSession_DecryptBadLen_007595f0;
    case 0x186f7:
      return s_WS_AuthSession_DecryptInvalidSeq_007595c4;
    case 0x186f8:
      return s_WS_AuthSession_DecryptUnpackFail_007595a0;
    case 0x186f9:
      return s_WS_ServerConnection_RecvNotAllow_00759570;
    case 0x186fa:
      return s_WS_FTP_InvalidResponse_00759558;
    case 0x186fb:
      return s_WS_FTP_StatusError_00759544;
    case 0x186fc:
      return s_WS_FTP_InvalidPasvResponse_00759528;
    case 0x186fd:
      return s_WS_HTTP_InvalidHeader_00759510;
    case 0x186fe:
      return s_WS_HTTP_StatusError_007594fc;
    case 0x186ff:
      return s_WS_HTTP_InvalidRedirect_007594e4;
    case 0x18700:
      return s_WS_HTTP_TooManyRedirects_007594c8;
    case 0x18701:
      return s_WS_HTTP_Redirected_007594b4;
    case 0x18702:
      return s_WS_HTTP_SendSuccess_007594a0;
    case 0x18703:
      return s_WS_GetMOTD_SysNotFound_00759488;
    case 0x18704:
      return s_WS_GetMOTD_GameNotFound_00759470;
    case 0x18705:
      return s_WS_BaseMsgRequest_NoRequest_00759454;
    case 0x18706:
      return s_WS_BaseMsgRequest_UnpackFailure_00759434;
    case 0x18707:
      return s_WS_BaseMsgRequest_BadHeaderType_00759414;
    case 0x18708:
      return s_WS_RoutingOp_ReplyUnpackFailure_007593f4;
    case 0x18709:
      return s_WS_RoutingOp_DontWantReply_007593d8;
    case 0x1870a:
      return s_WS_RoutingOp_NeedMoreReplies_007593b8;
    case 0x1870b:
      return s_WS_GameSpySupport_UnhandledError_00759394;
    case 0x1870c:
      return s_WS_GameSpySupport_WinSockError_00759374;
    case 0x1870d:
      return s_WS_GameSpySupport_BindError_00759358;
    case 0x1870e:
      return s_WS_GameSpySupport_DNSError_0075933c;
    case 0x1870f:
      return s_WS_GameSpySupport_ConnError_00759320;
    }
  }
  if ((param_1 < -0xb53) && (-3000 < param_1)) {
    FUN_006c4f81(&DAT_00f9d1a0,s_DBProxyServ_GameSpecificError_d_00759300,param_1);
    return &DAT_00f9d1a0;
  }
  FUN_006c4f81(&DAT_00f9d1a0,&DAT_0071e860,param_1);
  return &DAT_00f9d1a0;
}


